import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Pour] = []
    @Published var isPro: Bool = false

    static let freeLimit = 12

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("batchpour_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = [
            Pour(title: "Pour title 1", mixRatio: "Mix ratio 1", moldType: "Mold type 1", cureStart: Date().addingTimeInterval(-0 * 86400), notes: "Notes 1"),
            Pour(title: "Pour title 2", mixRatio: "Mix ratio 2", moldType: "Mold type 2", cureStart: Date().addingTimeInterval(-1 * 86400), notes: "Notes 2"),
            Pour(title: "Pour title 3", mixRatio: "Mix ratio 3", moldType: "Mold type 3", cureStart: Date().addingTimeInterval(-2 * 86400), notes: "Notes 3")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Pour) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Pour) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Pour) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Pour].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
