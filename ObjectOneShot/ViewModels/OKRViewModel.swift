//
//  OKRViewModel.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import Foundation

final class OKRViewModel: ObservableObject {
    @Published var keyResultState: KeyResultState = .beforeStart
    
    @Published var currentObjective: Objective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
    @Published var newEditingKeyResult: KeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
    @Published var newEditingTask: Task = Task(title: "")
    
    @Published var objectives: [Objective] = [
        Objective(title: "감사 일기 쓰기", startDate: Date(), endDate: Date(), keyResults: [
            KeyResult(title: "책상에 앉아 생각하기", completionState: .beforeStart, tasks: [
                Task(title: "task1"),
                Task(title: "task2")]),
            KeyResult(title: "하루에 있었던 일 기록하기", completionState: .beforeStart, tasks: [
                Task(title: "task1"),
                Task(title: "task2")]),
            KeyResult(title: "뭐든해보기~", completionState: .beforeStart, tasks: [
                Task(title: "task1"),
                Task(title: "task2")])
        ]),
//        Objective(title: "목표 제목 1", startDate: Date(), endDate: Date(), keyResults: [
//            KeyResult(title: "KeyResult1", completionState: .beforeStart, tasks: [
//                Task(title: "task1"),
//                Task(title: "task2")])
//        ]),
    ]
    
    // MARK: - CRUD
    func addNewObjective(_ newObjective: Objective) {
        objectives.append(newObjective)
    }
    
    func fetchObjectiveFromID(of id: String) -> Objective {
        objectives.filter { $0.id == id }[0]
    }
    
    // TODO : objective update 만들기
    func updateObjectiveFromID(of id: String) {
        
    }
    
    func deleteObjectiveByID(of id: String) {
        objectives = objectives.filter { $0.id != id }
    }
    
    // MARK: - others
    
    func getObjectiveIndexFromID(of id: String) -> Int {
        if let objectiveIndex = objectives.firstIndex(where: { $0.id == id }) {
            return objectiveIndex
        } else {
            return -1
        }
    }
    
    // yy-mm-dd 형식으로 Date 변경
    func getStringDate(of date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    // 새로 작성중인 Key Result에 Task 추가하기
    func addNewTaskToNewKeyResult() {
        self.newEditingKeyResult.tasks.append(self.newEditingTask)
    }
    
    func reInitiateNewObjective() {
        self.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
    }
    
    func reInitiateNewKeyResult() {
        self.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
    }
    
    // 새로운 태스크 새로운 객체로 재할당
    func reInitiateNewTask() {
        self.newEditingTask = Task(title: "")
    }
    
    // Key Result 수정이 끝났는지
    func isEndedEditingKeyResult() -> Bool {
        if !newEditingKeyResult.title.isEmpty, !newEditingTask.title.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    // 새로운 objective 추가를 취소했을 때(뷰 이동) 임시 값 모두 초기화
    func reInitializeNewValues() {
        reInitiateNewObjective()
        reInitiateNewKeyResult()
        reInitiateNewTask()
    }
    
    // 새로 작성하는 objective의 모든 텍스트필드들이 작성되어 있는지 확인하기
    func isReadyToAddNewObjective() -> Bool {
        if currentObjective.title.isEmpty || newEditingKeyResult.title.isEmpty {
            return false
        } else {
            return true
        }
    }
}
