import Foundation
import AppKit

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

enum Arguments {
    static let ayah = "-ayah"
    static let editions = "-editions"
    static let noArabic = "-no-arabic"
}

// MARK: - Models
struct Ayah: Codable {
    let numberInSurah: Int
    let text: String
}

struct Response: Codable {
    let ayas: [Ayah]
    
    enum Keys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let ayah = try? container.decode(Ayah.self, forKey: .data) {
            self.ayas = [ayah]
        } else {
            self.ayas = try container.decode([Ayah].self, forKey: .data)
        }
    }
}

let pasteboard = NSPasteboard.general
pasteboard.clearContents()

// MARK: - Arguments
let args = CommandLine.arguments
guard let ayaIndex = args.index(of: Arguments.ayah), let numbers = args[safe: ayaIndex + 1] else {
    print("❌ You should pass aya number in the next format: -ayah 1:1")
    exit(1)
}

let noArabicText = args.contains(Arguments.noArabic)
var edition: String?
if let editionsIndex = args.index(of: Arguments.editions), let rawEdition = args[safe: editionsIndex + 1] {
    edition = rawEdition
}

func copyToClipboard(ayah: Ayah, add: Bool) {
    var text = ayah.text
    if add, let existingString = pasteboard.string(forType: .string) {
        text = existingString + "\n\n" + text
    }
    pasteboard.setString(text, forType: .string)
}

func parse() {
    var rawUrl = "https://api.alquran.cloud/ayah/\(numbers)"
    if let edition = edition {
        if noArabicText {
            rawUrl.append("/editions/")
        } else {
            rawUrl.append("/editions/quran-uthmani,")
        }
        rawUrl.append("\(edition)")
    }
    
    let url = URL(string: rawUrl)!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        defer {
            print("Copied Ayah \(numbers) to the clipboard. ✅")
            exit(0)
        }
        
        guard let json = data, error == nil else {
            print("❌ ", error!.localizedDescription)
            exit(1)
        }
        
        let response = try! JSONDecoder().decode(Response.self, from: json)
        for (index, aya) in response.ayas.enumerated() {
            copyToClipboard(ayah: aya, add: index > 0)
        }
    }
    task.resume()
}

parse()
RunLoop.current.run()
