//
//  OpenDocumentRestoration.swift
//  Text Viewer
//

import Cocoa

/// Restores file-backed document windows across launches. The app is sandboxed,
/// so persisted security-scoped bookmarks are required; plain paths would not
/// retain the user's Open-panel access after relaunch.
@MainActor
enum OpenDocumentRestoration {
    private static let defaultsKey = "TextViewer.openFileBookmarks"
    private static var didAttemptRestore = false
    private static var isRestoring = false
    private static var pendingRestoreCount = 0
    private static var unresolvedBookmarks: [Data] = []
    private static var startedAccessURLs = Set<URL>()
    private static var restoreFailures: [String] = []

    /// Reopens the files saved by the previous session and returns how many
    /// were eligible to reopen. Missing volumes/files are retained for a
    /// later launch instead of being discarded.
    @discardableResult
    static func restoreOpenFiles() -> Int {
        guard !didAttemptRestore else { return 0 }
        didAttemptRestore = true

        let bookmarks = UserDefaults.standard.array(forKey: defaultsKey) as? [Data] ?? []
        var seen = Set<URL>()
        var restorable: [(url: URL, bookmark: Data)] = []

        for bookmark in bookmarks {
            var isStale = false
            guard let url = try? URL(
                resolvingBookmarkData: bookmark,
                options: [.withSecurityScope, .withoutUI],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            ) else {
                unresolvedBookmarks.append(bookmark)
                continue
            }

            let fileURL = url.standardizedFileURL
            guard seen.insert(fileURL).inserted else { continue }
            if startedAccessURLs.insert(fileURL).inserted {
                _ = fileURL.startAccessingSecurityScopedResource()
            }

            guard !fileURL.isExistingDirectory,
                  FileManager.default.fileExists(atPath: fileURL.path) else {
                unresolvedBookmarks.append(bookmark)
                continue
            }
            restorable.append((fileURL, bookmark))
        }

        guard !restorable.isEmpty else {
            persistOpenFiles()
            return 0
        }

        isRestoring = true
        pendingRestoreCount = restorable.count
        for entry in restorable {
            NSDocumentController.shared.openDocument(
                withContentsOf: entry.url,
                display: true
            ) { document, _, error in
                if let error {
                    unresolvedBookmarks.append(entry.bookmark)
                    restoreFailures.append("\(entry.url.path): \(error.localizedDescription)")
                } else if let document, document.windowControllers.isEmpty {
                    document.makeWindowControllers()
                    document.showWindows()
                }

                pendingRestoreCount -= 1
                guard pendingRestoreCount == 0 else { return }
                isRestoring = false
                persistOpenFiles()
                presentRestoreFailuresIfNeeded()
            }
        }
        return restorable.count
    }

    /// Saves currently open, file-backed windows (including minimized and
    /// inactive tab windows). During asynchronous restoration, wait for the
    /// whole batch so an early callback cannot overwrite later bookmarks.
    /// A closing controller is explicitly excluded because AppKit may not yet
    /// have removed its NSDocument from the controller's live document list.
    static func persistOpenFiles(excluding closingController: DocumentWindowController? = nil) {
        guard !isRestoring else { return }

        let controllers = NSDocumentController.shared.documents
            .flatMap(\.windowControllers)
            .compactMap { $0 as? DocumentWindowController }
        var seen = Set<URL>()
        let urls = controllers.compactMap { controller -> URL? in
            guard controller !== closingController else { return nil }
            guard let url = controller.currentFileURL,
                  !url.isExistingDirectory else { return nil }
            let fileURL = DocumentWindowController.fileURLWithoutFragment(url).standardizedFileURL
            return seen.insert(fileURL).inserted ? fileURL : nil
        }

        let bookmarks = urls.compactMap(makeBookmark(for:)) + unresolvedBookmarks
        UserDefaults.standard.set(bookmarks, forKey: defaultsKey)
    }

    private static func makeBookmark(for url: URL) -> Data? {
        (try? url.bookmarkData(options: .withSecurityScope,
                               includingResourceValuesForKeys: nil,
                               relativeTo: nil))
            ?? (try? url.bookmarkData(options: [],
                                      includingResourceValuesForKeys: nil,
                                      relativeTo: nil))
    }

    private static func presentRestoreFailuresIfNeeded() {
        guard !restoreFailures.isEmpty else { return }
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Some files could not be restored",
                                              comment: "Open document restoration error")
        alert.informativeText = restoreFailures.joined(separator: "\n")
        alert.alertStyle = .warning
        if let window = NSApp.keyWindow {
            alert.beginSheetModal(for: window)
        } else {
            alert.runModal()
        }
        restoreFailures.removeAll()
    }
}
