//
//  Task.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import Foundation

struct Task: Identifiable, Hashable {
    static var dummy = Task(title: "")
    
    let id = UUID().uuidString
    var isCompleted = false
    var title: String
}
