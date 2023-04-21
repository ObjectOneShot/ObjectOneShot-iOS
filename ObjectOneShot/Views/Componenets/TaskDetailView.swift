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
    @State private var isFocused = false
    @State private var isCompleted = false
    @Binding var isEditingNewTask: Bool
    @Binding var progressValue: Double
    @Binding var progressPercentage: Int
   
    let keyResultIndex: Int
    let task: Task
    var isLast: Bool
    var isShowingCompletedObjective: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                checkBox()
                taskTitle()
                Spacer()
                // 만약 focus 되었고 표시할 task가 2개 이상이면 x 표시하기
                if isFocused {
                    if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count > 1 {
                        Button {
                            // 버튼 터치하면 task 삭제
                            viewModel.currentObjective.keyResults[keyResultIndex].tasks = viewModel.currentObjective.keyResults[keyResultIndex].tasks.filter { $0.id != viewModel.currentObjective.keyResults[keyResultIndex].tasks[viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id })!].id }
                            viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
                        } label: {
                            Image("xMark")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(Color("grey_900"))
                        }
                        .padding(.trailing, 22)
                    }
                }
                
                // 만약 마지막 task이고 새로운 task 추가중이지 않다면 + 버튼 추가, task 추가 가능하도록 하기
                // + focus중이 아닐 때만 추가!
                if isLast && !isEditingNewTask && !isFocused {
                    Button {
                        // task 추가 및 task가 5개 이하라면 다음 task 추가 칸 보이기!
                        isEditingNewTask = true
                    } label: {
                        Image("plus")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color("grey_900"))
                    }
                    .disabled(isShowingCompletedObjective)
                    .padding(.trailing, 22)
                }
            }
            .padding(.leading, 19)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("grey_900"))
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
        }
        
        .background(Color("grey_50"))
        .onAppear {
            if let taskTitle = viewModel.currentObjective.keyResults[keyResultIndex].tasks.first(where: {$0.id == task.id})?.title {
                self.title = taskTitle
            } else {
                print("ERROR : no matching tasks found by taskID : TaskDetailView.swift")
            }
            
            if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                self.isCompleted = viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted
            }
        }
    }
    
    @ViewBuilder
    func checkBox() -> some View {
        Button {
            self.isCompleted.toggle()
        } label: {
            if let task = viewModel.currentObjective.keyResults[keyResultIndex].tasks.first(where: { $0.id == task.id }) {
                if task.isCompleted {
                    Image("checkMark.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                } else {
                    Image("square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                }
            }
        }
        .disabled(isShowingCompletedObjective)
        .onChange(of: isCompleted) { newValue in
            if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted = isCompleted
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
        }
    }
    
    @ViewBuilder
    func taskTitle() -> some View {
        ZStack {
            // 태스크 내용
            TextField("", text: $title, onEditingChanged: { editing in
                // 수정 중인지 아닌지
                if editing {
                    self.isFocused = true
                } else {
                    if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title = self.title
                    } else {
                        print("ERROR : no matching task found by taskID: TaskDetailView.swift")
                    }
                    self.isFocused = false
                }
            })
            .disabled(isCompleted || isShowingCompletedObjective)
            .font(.pretendard(.medium, size: 16))
            .strikethrough(isCompleted)
            .foregroundColor(Color("grey_900"))
            .background {
                // 플레이스홀더
                if title.isEmpty {
                    HStack {
                        Text("내용을 입력해주세요")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundColor(Color("grey_500"))
                        Spacer()
                    }
                }
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
