//
//  KeyResult.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

enum KeyResultState {
    case beforeStart
    case inProgress
    case completed
}

struct KeyResult: Identifiable, Hashable {
    static func == (lhs: KeyResult, rhs: KeyResult) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var dummy = KeyResult(title: "", completionState: .beforeStart, tasks: [])
    
    let id = UUID().uuidString
    var title: String
    var completionState: KeyResultState
    var tasks: [Task]
    var progressPercentage: Int = 0
    var progressValue: Double = 0
    
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
    }
    
    mutating func setProgressPercentage() {
        if self.tasks.count == 0 {
            self.progressPercentage = 0
        } else {
            self.progressPercentage = Int((Double(tasks.filter { $0.isCompleted == true}.count) / Double(tasks.count)) * 100)
        }
    }
    
}
