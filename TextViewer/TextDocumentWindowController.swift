import AppKit

@MainActor
final class TextDocumentWindowController: NSWindowController {
    private let textViewController = TextViewController()

    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 960, height: 640),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Text Viewer"
        window.minSize = NSSize(width: 360, height: 240)
        window.center()
        window.contentViewController = textViewController
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(text: String, fileURL: URL?) {
        window?.title = fileURL?.lastPathComponent ?? "Text Viewer"
        textViewController.display(text)
    }
}
