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
    @State private var isFocused = false
    
    let isLast: Bool
    let task : Task
    
    var body: some View {
        VStack {
            HStack {
                checkBox()
                taskTitle()
                Spacer()
                // 만약 focus 되었고 표시할 task가 2개 이상이면 x 표시하기
                if isFocused {
                    if viewModel.newEditingKeyResult.tasks.count > 1 {
                        Button {
                            // 버튼 터치하면 task 삭제
                            viewModel.newEditingKeyResult.tasks = viewModel.newEditingKeyResult.tasks.filter { $0.id != task.id }
                            viewModel.newEditingKeyResult.setProgress()
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
                
                if isLast && !isAddingTask && !isFocused {
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
    
    @ViewBuilder
    func checkBox() -> some View {
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
                    self.isFocused = false
                }
            })
            .font(.pretendard(.medium, size: 16))
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
    }
}

struct showNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(isAddingTask: .constant(true), isLast: true, task: Task.dummy)            .environmentObject(OKRViewModel())
    }
}
