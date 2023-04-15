//
//  showNewTaskView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct TaskEditView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @Binding var isAddingTask: Bool
    @State private var title = ""
    
    let isLast: Bool
    let task : Task
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.newEditingKeyResult.tasks[index].isCompleted.toggle()
                    } else {
                        print("ERROR : no task matching taskID : TaskEditView")
                    }
                    viewModel.newEditingKeyResult.setProgress()
                } label: {
                    if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                        if viewModel.newEditingKeyResult.tasks[index].isCompleted {
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
                // task title
                ZStack {
                    TextField("", text: $title, prompt: Text("내용을 입력해주세요").font(.pretendard(.medium, size: 16)).foregroundColor(Color("grey_500")))
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(Color("grey_900"))
                        .onChange(of: title) { _ in
                            if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                                viewModel.newEditingKeyResult.tasks[index].title = title
                            } else {
                                print("ERROR : no task matching taskID : TaskEditView")
                            }
                        }
                    if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                        if viewModel.newEditingKeyResult.tasks[index].isCompleted {
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("grey_900"))
                                .padding(.trailing, 24)
                        }
                    }
                }
                Spacer()
                if isLast && !isAddingTask {
                    Button {
                        if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                            // title 비어있지 않고 task 갯수 5 미만일 때만 task 추가 작업 진행
                            if !viewModel.newEditingKeyResult.tasks[index].title.isEmpty {
                                if viewModel.newEditingKeyResult.tasks.count < 5 {
                                    isAddingTask = true
                                }
                            }
                        } else {
                            print("ERROR : no task matching taskID : TaskEditView")
                        }
                    } label : {
                        Image("plus")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color("grey_900"))
                    }
                }
            }
            .padding(.leading, 19)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("grey_900"))
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
        }
        .onAppear {
            if let index = viewModel.newEditingKeyResult.tasks.firstIndex(where: { $0.id == task.id }) {
                title = viewModel.newEditingKeyResult.tasks[index].title
            } else {
                print("ERROR : no task matching taskID : TaskEditView")
            }
        }
    }
}

struct showNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(isAddingTask: .constant(true), isLast: true, task: Task.dummy)            .environmentObject(OKRViewModel())
    }
}
