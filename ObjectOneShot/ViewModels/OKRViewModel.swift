//
//  OKRViewModel.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import Foundation

final class OKRViewModel: ObservableObject {
    
    @Published var keyResultState: KeyResultState = .all
    @Published var currentObjective: Objective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
    @Published var newEditingKeyResult: KeyResult = KeyResult(title: "", completionState: .inProgress, tasks: [Task(title: "")])
    @Published var newEditingTask: Task = Task(title: "")
    @Published var objectives: [Objective] = []
    @Published var deletingObjectiveID: String = ""
    
    init() {
        loadObjectivesFromUserDefaults()
    }
    
    // MARK: - CRUD
    func addNewObjective(_ newObjective: Objective) {
        objectives.append(newObjective)
    }
    
    func deleteObjectiveByID(of id: String) {
        objectives = objectives.filter { $0.id != id }
    }
    
    func deleteTaskWhenTappedXmark(keyResultIndex: Int, taskID: String) {
        self.currentObjective.keyResults[keyResultIndex].tasks = self.currentObjective.keyResults[keyResultIndex].tasks.filter { $0.id != taskID }
    }
    
    // MARK: - others
    // yy-mm-dd 형식으로 Date 변경
    func getStringDate(of date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func isOutDated(endDate: Date) -> Bool {
        if endDate.compare(Date()) == .orderedAscending {
            let isSameDay = Calendar.current.isDate(Date(), equalTo: endDate, toGranularity: .day)
            if isSameDay {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func getDday(endDate: Date) -> Int {
        let today = Date()
        let calendar = Calendar.current
        let dDay = calendar.dateComponents([.day], from: today, to: endDate)
        return dDay.day!
    }
    
    // 새로 작성중인 Key Result에 Task 추가하기
    func addNewTaskToNewKeyResult() {
        self.newEditingKeyResult.tasks.append(self.newEditingTask)
    }
    
    // MARK: - UserDefault 설정
    func serializeObjectives() -> Data? {
        do {
            let data = try JSONEncoder().encode(objectives)
            return data
        } catch {
            print("Error encoding objectives: \(error)")
            return nil
        }
    }
    
    func deserializeObjectives(from data: Data) -> [Objective]? {
        do {
            let objectives = try JSONDecoder().decode([Objective].self, from: data)
            return objectives
        } catch {
            print("Error decoding objectives: \(error)")
            return nil
        }
    }
    
    func saveObjectivesToUserDefaults() {
        if let serializedData = serializeObjectives() {
            UserDefaults.standard.set(serializedData, forKey: "objectives")
        }
    }
    
    func loadObjectivesFromUserDefaults() {
        if let serializedData = UserDefaults.standard.data(forKey: "objectives") {
            if let objectives = deserializeObjectives(from: serializedData) {
                self.objectives = objectives
            }
        }
    }

}
