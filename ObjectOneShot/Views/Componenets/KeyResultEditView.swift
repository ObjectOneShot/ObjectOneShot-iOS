//
//  KeyResultEditView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct KeyResultEditView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State var keyResultTitle: String = ""
    @State var taskTitle: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            // KeyResult 헤더
            VStack {
                HStack {
                    TextField("Key Results를 입력해 주세요", text: $keyResultTitle)
                        .padding(.leading, 5)
                    Button {
                        viewModel.newKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
                        viewModel.isAddingKeyResult = false
                    } label: {
                        Image(systemName: "xmark")
                            .padding(.trailing, 5)
                            .tint(.black)
                    }
                    .onChange(of: keyResultTitle) { newValue in
                        viewModel.newKeyResult.title = newValue
                    }
                    .onChange(of: viewModel.newKeyResult.title) { newValue in
                        keyResultTitle = newValue
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(5)
                HStack {
                    ProgressView(value: viewModel.newKeyResult.progressValue)
                    Text("\(viewModel.newKeyResult.progressPercentage)%")
                }
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 10)
            
            // 배열이 비어있지 않을 때만 showNewTasks
            if !viewModel.newKeyResult.tasks.isEmpty {
                showNewTasks()
            }
            if viewModel.isAddingTask {
                editNewTask()
            }
        }
        
    }
    
    @ViewBuilder
    func showNewTasks() -> some View {
        ForEach(viewModel.newKeyResult.tasks, id: \.self) { task in
            TaskEditView(task: task, isLast: true)
                .onDelete(isTask: true) {
                    viewModel.newKeyResult.tasks = viewModel.newKeyResult.tasks.filter { $0.id == task.id }
                }
        }
    }
    
    @ViewBuilder
    func editNewTask() -> some View {
        if viewModel.newKeyResult.tasks.count != 5 {
            VStack {
                HStack {
                    Image(systemName: "square")
                    TextField("", text: $taskTitle)
                        .textFieldStyle(.plain)
                    Button {
                        // 새로운 태스크의 텍스트필드 비어있지 않다면 new Key Result에 추가
                        if !taskTitle.isEmpty {
                            // 5개까지만 추가 가능
                            if viewModel.newKeyResult.tasks.count < 5 {
                                viewModel.addNewTaskToNewKeyResult()
                                taskTitle = ""
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 3)
                .onChange(of: taskTitle) { newValue in
                    viewModel.newTask.title = taskTitle
                }
                .onChange(of: viewModel.newTask.title) { newValue in
                    taskTitle = newValue
                }
                Rectangle()
                    .frame(height:1)
                    .padding(.horizontal)
            }
        }
    }
}

struct KeyResultEditView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultEditView()
            .environmentObject(OKRViewModel.shared)
    }
}
