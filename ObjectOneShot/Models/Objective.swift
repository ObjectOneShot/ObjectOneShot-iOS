//
//  Objective.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

struct Objective: Identifiable, Hashable, Codable {
    static func == (lhs: Objective, rhs: Objective) -> Bool {
        if lhs.id == rhs.id {
            if lhs.title != rhs.title {
                return false
            }
            if lhs.startDate != rhs.startDate {
                return false
            }
            if lhs.endDate != rhs.endDate {
                return false
            }
            if lhs.keyResults.count != rhs.keyResults.count {
               return false
            }
            for i in 0..<lhs.keyResults.count {
                if lhs.keyResults[i] != rhs.keyResults[i] {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    static var dummy = Objective(title: "감사 일기 쓰기", startDate: Date(), endDate: Date(), keyResults: [KeyResult(title: "하이요", completionState: .beforeStart, tasks: []), KeyResult(title: "하이요", completionState: .beforeStart, tasks: [])])
    
    let id = UUID().uuidString
    var title: String
    var startDate: Date
    var endDate: Date
    var keyResults: [KeyResult]
    var progressPercentage: Int = 0
    var progressValue: Double = 0
    var isOutdated: Bool = false
    var isCompleted: Bool = false
    
    init(title: String, startDate: Date, endDate: Date, keyResults: [KeyResult]) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.keyResults = keyResults
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        self.keyResults = try container.decode([KeyResult].self, forKey: .keyResults)
        self.isOutdated = try container.decode(Bool.self, forKey: .isOutdated)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        setProgress()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(keyResults, forKey: .keyResults)
        try container.encode(isOutdated, forKey: .isOutdated)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case startDate
        case endDate
        case keyResults
        case isOutdated
        case isCompleted
    }
    
    mutating func setProgress() {
        setProgressValue()
        setProgressPercentage()
        if self.progressValue == 1 {
            isCompleted = true
        } else {
            isCompleted = false
        }
    }
    
    mutating func setProgressValue() {
        if keyResults.count == 0  {
            self.progressPercentage = 0
        } else {
            self.progressValue = Double(keyResults.filter { $0.completionState == .completed }.count) / Double(keyResults.count)
        }
    }
    
    mutating func setProgressPercentage() {
        if keyResults.count == 0  {
            self.progressPercentage = 0
        } else {
            self.progressPercentage = Int((Double(keyResults.filter { $0.completionState == .completed }.count) / Double(keyResults.count)) * 100)
        }
    }
}
