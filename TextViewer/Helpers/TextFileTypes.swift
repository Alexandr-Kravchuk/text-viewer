import Foundation
import UniformTypeIdentifiers

nonisolated enum TextFileTypes {
    static let extensions: Set<String> = [
        "txt", "text", "log", "out", "conf", "cfg", "ini", "env",
        "csv", "tsv", "json", "xml", "yaml", "yml", "toml",
        "md", "markdown", "mdown", "mkd", "mdwn", "mdx",
        "swift", "py", "js", "jsx", "ts", "tsx", "css", "scss",
        "html", "htm", "sh", "zsh", "bash", "sql", "rb", "go",
        "rs", "java", "kt", "c", "h", "cpp", "hpp", "cs", "php",
        "properties", "gradle", "makefile", "dockerfile"
    ]

    static let openPanelTypes: [UTType] = extensions
        .sorted()
        .compactMap { UTType(filenameExtension: $0) }
}

nonisolated enum TextFileDecoder {
    static func decode(_ data: Data) -> String? {
        [
            String.Encoding.utf8,
            .utf16,
            .utf16LittleEndian,
            .utf16BigEndian,
            .utf32,
            .utf32LittleEndian,
            .utf32BigEndian,
            .isoLatin1,
            .windowsCP1252
        ].lazy.compactMap { String(data: data, encoding: $0) }.first
    }
}
