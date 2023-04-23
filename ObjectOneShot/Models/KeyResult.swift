//
//  KeyResult.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

enum KeyResultState: String, Codable {
    case beforeStart
    case inProgress
    case completed
}

struct KeyResult: Identifiable, Hashable, Codable {
    static func == (lhs: KeyResult, rhs: KeyResult) -> Bool {
        if lhs.id == rhs.id {
            if lhs.title != rhs.title {
                return false
            }
            if lhs.tasks.count != rhs.tasks.count {
                return false
            }
            for i in 0..<lhs.tasks.count {
                if lhs.tasks[i] != rhs.tasks[i] {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var dummy = KeyResult(title: "", completionState: .beforeStart, tasks: [])
    
    let id = UUID().uuidString
    var isExpanded = false
    var title: String
    var completionState: KeyResultState
    var tasks: [Task]
    var progressPercentage: Int = 0
    var progressValue: Double = 0
    
    init(title: String, completionState: KeyResultState, tasks: [Task]) {
        self.title = title
        self.completionState = completionState
        self.tasks = tasks
        setProgress()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isExpanded = try container.decode(Bool.self, forKey: .isExpanded)
        title = try container.decode(String.self, forKey: .title)
        completionState = try container.decode(KeyResultState.self, forKey: .completionState)
        tasks = try container.decode([Task].self, forKey: .tasks)
        progressPercentage = try container.decode(Int.self, forKey: .progressPercentage)
        progressValue = try container.decode(Double.self, forKey: .progressValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isExpanded, forKey: .isExpanded)
        try container.encode(title, forKey: .title)
        try container.encode(completionState, forKey: .completionState)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(progressPercentage, forKey: .progressPercentage)
        try container.encode(progressValue, forKey: .progressValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case isExpanded
        case title
        case completionState
        case tasks
        case progressPercentage
        case progressValue
    }
    
    mutating func setProgress() {
        setProgressValue()
        setProgressPercentage()
    }
    
    mutating func setProgressValue() {
        if self.tasks.count == 0 {
            self.progressValue = 0
        } else {
            self.progressValue = Double(Double(tasks.filter { $0.isCompleted == true }.count) / Double(tasks.count))
        }
        
        if self.progressValue == 0 {
            self.completionState = .beforeStart
        } else if self.progressValue == 1 {
            self.completionState = .completed
        } else {
            self.completionState = .inProgress
        }
    }
    
    mutating func setProgressPercentage() {
        if self.tasks.count == 0 {
            self.progressPercentage = 0
        } else {
            self.progressPercentage = Int((Double(tasks.filter { $0.isCompleted == true}.count) / Double(tasks.count)) * 100)
        }
    }
    
}
