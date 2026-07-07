import Foundation

struct Pour: Identifiable, Codable, Equatable {
    let id: UUID
    var dateCreated: Date
    var title: String
    var mixRatio: String
    var moldType: String
    var cureStart: Date
    var notes: String

    init(id: UUID = UUID(), dateCreated: Date = Date(), title: String = "", mixRatio: String = "", moldType: String = "", cureStart: Date = Date(), notes: String = "") {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.mixRatio = mixRatio
        self.moldType = moldType
        self.cureStart = cureStart
        self.notes = notes
    }
}
