//
//  showNewTaskView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct TaskEditView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State var title = ""
    
    let task : Task
    var isLast: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if let index = viewModel.newKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.newKeyResult.tasks[index].isCompleted.toggle()
                    } else {
                        print("ERROR : no task matching taskID : TaskEditView")
                    }
                    viewModel.newKeyResult.setProgress()
                } label: {
                    if let index = viewModel.newKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                        if viewModel.newKeyResult.tasks[index].isCompleted {
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.black)
                        }
                    }
                }
                TextField("", text: $title)
                    .onChange(of: title) { _ in
                        if let index = viewModel.newKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.newKeyResult.tasks[index].title = title
                        } else {
                            print("ERROR : no task matching taskID : TaskEditView")
                        }
                    }
                Spacer()
                if isLast && !viewModel.isAddingTask {
                    Button {
                        if let index = viewModel.newKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                            // title 비어있지 않고 task 갯수 5 미만일 때만 task 추가 작업 진행
                            if !viewModel.newKeyResult.tasks[index].title.isEmpty {
                                if viewModel.newKeyResult.tasks.count < 5 {
                                    viewModel.isAddingTask = true
                                }
                            }
                        } else {
                            print("ERROR : no task matching taskID : TaskEditView")
                        }
                    } label : {
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
            if let index = viewModel.newKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                title = viewModel.newKeyResult.tasks[index].title
            } else {
                print("ERROR : no task matching taskID : TaskEditView")
            }
        }
    }
}

struct showNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(task: Task(title: ""), isLast: true)
            .environmentObject(OKRViewModel.shared)
    }
}
