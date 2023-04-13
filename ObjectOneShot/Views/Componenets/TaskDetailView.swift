//
//  TaskDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct TaskDetailView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State var title = ""
    @Binding var isEditingNewTask: Bool
    @Binding var progressValue: Double
    @Binding var progressPercentage: Int
    
    let keyResultIndex: Int
    let task: Task
    var isLast: Bool
    
    var body: some View {
        VStack {
            HStack {
                // isCompleted 체크박스
                Button {
                    if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted.toggle()
                    } else {
                        print("ERROR : no matching task found by taskID : TaskDetailView.swift")
                    }
                    viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
                    if viewModel.currentObjective.keyResults[keyResultIndex].completionState == .beforeStart {
                        viewModel.keyResultState = .beforeStart
                    } else if viewModel.currentObjective.keyResults[keyResultIndex].completionState == .inProgress {
                        viewModel.keyResultState = .inProgress
                    } else {
                        viewModel.keyResultState = .completed
                    }
                    viewModel.currentObjective.keyResults[keyResultIndex].isExpanded = true
                    
                    progressValue = viewModel.currentObjective.keyResults[keyResultIndex].progressValue
                    progressPercentage = viewModel.currentObjective.keyResults[keyResultIndex].progressPercentage
                } label: {
                    if let task = viewModel.currentObjective.keyResults[keyResultIndex].tasks.first(where: { $0.id == task.id }) {
                        if task.isCompleted {
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                // task title
                TextField("", text: $title)
                    .onChange(of: title) { _ in
                        if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title = self.title
                        } else {
                            print("ERROR : no matching task found by taskID: TaskDetailView.swift")
                        }
                    }
                Spacer()
                
                // 만약 마지막 task이고 새로운 task 추가중이지 않다면 + 버튼 추가, task 추가 가능하도록 하기
                if isLast && !isEditingNewTask {
                    Button {
                        // task 추가 및 task가 5개 이하라면 다음 task 추가 칸 보이기!
                        isEditingNewTask = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 3)
            Rectangle()
                .frame(height:1)
                .padding(.horizontal)
        }
        .onAppear {
            if let taskTitle = viewModel.currentObjective.keyResults[keyResultIndex].tasks.first(where: {$0.id == task.id})?.title {
                self.title = taskTitle
            } else {
                print("ERROR : no matching tasks found by taskID : TaskDetailView.swift")
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(isEditingNewTask: .constant(false), progressValue: .constant(0.0), progressPercentage: .constant(0), keyResultIndex: 0, task: Task(title: ""), isLast: true)
            .environmentObject(OKRViewModel())
    }
}
