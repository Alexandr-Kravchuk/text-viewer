import AppKit
import Synchronization

@MainActor
final class TextDocument: NSDocument {
    private nonisolated let textStorage = Mutex("")

    var text: String {
        textStorage.withLock { $0 }
    }

    override init() {
        super.init()
        hasUndoManager = false
    }

    override class var autosavesInPlace: Bool {
        false
    }

    override var isDocumentEdited: Bool {
        false
    }

    override func makeWindowControllers() {
        let controller = TextDocumentWindowController()
        addWindowController(controller)
        controller.display(text: text, fileURL: fileURL)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        try read(from: Data(contentsOf: url), ofType: typeName)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        guard let decodedText = Self.decode(data) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        textStorage.withLock { $0 = decodedText }
    }

    override func data(ofType typeName: String) throws -> Data {
        throw CocoaError(.fileWriteNoPermission)
    }

    override func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(save(_:)),
             #selector(saveAs(_:)),
             #selector(saveTo(_:)),
             #selector(revertToSaved(_:)):
            false
        default:
            super.validateUserInterfaceItem(item)
        }
    }

    private nonisolated static func decode(_ data: Data) -> String? {
        [
            .utf8,
            .utf16,
            .utf16LittleEndian,
            .utf16BigEndian,
            .utf32,
            .utf32LittleEndian,
            .utf32BigEndian,
        ].lazy.compactMap { String(data: data, encoding: $0) }.first
    }
}
