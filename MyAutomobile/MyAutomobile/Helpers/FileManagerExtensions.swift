import Foundation

extension FileManager {
    private static var documentsDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func write(
        data: Data,
        to url: URL = documentsDirectoryURL,
        fileName: String
    ) throws {
        let writeURL = url.appendingPathComponent(fileName)
        try data.write(to: writeURL, options: [.atomicWrite, .completeFileProtection])
    }
    
    static func readData(
        from url: URL = documentsDirectoryURL,
        fileName: String
    ) throws -> Data {
        let readURL = url.appendingPathComponent(fileName)
        return try Data(contentsOf: readURL)
    }
    
    static func deleteFile(
        from url: URL = documentsDirectoryURL,
        fileName: String
    ) throws {
        let fileURL = url.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File deleted successfully: \(fileURL)")
        } catch {
            throw error
        }
    }
}
