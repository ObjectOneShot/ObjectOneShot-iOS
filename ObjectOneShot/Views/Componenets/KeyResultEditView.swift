//
//  KeyResultEditView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct KeyResultEditView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @Binding var isAddingKeyResult: Bool
    @State var keyResultTitle: String = ""
    @State var taskTitle: String = ""
    @State var isAddingTask: Bool = true
    
    var body: some View {
        VStack(spacing: 10) {
            // KeyResult 헤더
            VStack {
                HStack {
                    TextField("Key Results를 입력해 주세요", text: $keyResultTitle)
                        .padding(.leading, 5)
                    Button {
                        // keyResultEditing 종료
                        viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
                        self.isAddingKeyResult = false
                    } label: {
                        Image(systemName: "xmark")
                            .padding(.trailing, 5)
                            .tint(.black)
                    }
                    .onChange(of: keyResultTitle) { newValue in
                        viewModel.newEditingKeyResult.title = newValue
                    }
                    .onChange(of: viewModel.newEditingKeyResult.title) { newValue in
                        keyResultTitle = newValue
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(5)
                HStack {
                    ProgressView(value: viewModel.newEditingKeyResult.progressValue)
                    Text("\(viewModel.newEditingKeyResult.progressPercentage)%")
                }
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 10)
            
            // 배열이 비어있지 않을 때만 showNewTasks
            if !viewModel.newEditingKeyResult.tasks.isEmpty {
                showNewTasks()
            }
            // 태스크 추가 중이고 태스크 갯수가 5개 미만이면 editNewTask 보이기
            if isAddingTask && viewModel.newEditingKeyResult.tasks.count != 5 {
                editNewTask()
            }
        }
        .onAppear {
            viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
        }
        
    }
    
    @ViewBuilder
    func showNewTasks() -> some View {
        ForEach(viewModel.newEditingKeyResult.tasks, id: \.self) { task in
            if let taskIndex = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                if taskIndex == viewModel.newEditingKeyResult.tasks.count - 1 {
                    TaskEditView(isAddingTask: $isAddingTask, isLast: true, task: task)
                        .if(viewModel.newEditingKeyResult.tasks.count > 1) { view in
                            view
                                .onDelete(isTask: true) {
                                    viewModel.newEditingKeyResult.tasks = viewModel.newEditingKeyResult.tasks.filter { $0.id != task.id }
                                    viewModel.newEditingKeyResult.setProgress()
                                }
                        }
                } else {
                    TaskEditView(isAddingTask: $isAddingTask, isLast: false, task: task)
                        .if(viewModel.newEditingKeyResult.tasks.count > 1) { view in
                            view
                                .onDelete(isTask: true) {
                                    viewModel.newEditingKeyResult.tasks = viewModel.newEditingKeyResult.tasks.filter { $0.id != task.id }
                                    viewModel.newEditingKeyResult.setProgress()
                                }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func editNewTask() -> some View {
        VStack {
            HStack {
                Image(systemName: "square")
                TextField("", text: $taskTitle)
                Button {
                    // 새로운 태스크의 텍스트필드 비어있지 않다면 new Key Result에 추가
                    if !taskTitle.isEmpty {
                        // 5개까지만 추가 가능
                        if viewModel.newEditingKeyResult.tasks.count < 5 {
                            viewModel.newEditingKeyResult.tasks.append(Task(title: taskTitle))
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
            Rectangle()
                .frame(height:1)
                .padding(.horizontal)
        }
    }
    
    struct KeyResultEditView_Previews: PreviewProvider {
        static var previews: some View {
            KeyResultEditView(isAddingKeyResult: .constant(true))
                .environmentObject(OKRViewModel())
        }
    }
}
