//
//  Task.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

struct Task: Identifiable, Hashable, Codable {
    static var dummy = Task(title: "")
    
    let id = UUID().uuidString
    var isCompleted = false
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(title, forKey: .title)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case isCompleted
        case title
    }
    
}
