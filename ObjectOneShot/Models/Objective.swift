//
//  Objective.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

struct Objective: Identifiable, Hashable {
    static func == (lhs: Objective, rhs: Objective) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var dummy = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
    
    let id = UUID().uuidString
    var title: String
    var startDate: Date
    var endDate: Date
    var keyResults: [KeyResult]
    var progressPercentage: Int = 0
    var progressValue: Double = 0
    
    mutating func setProgress() {
        setProgressValue()
        setProgressPercentage()
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
