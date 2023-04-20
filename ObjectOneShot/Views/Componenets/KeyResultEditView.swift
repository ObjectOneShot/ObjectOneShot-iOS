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
    @State var isEditingNewTask = true
    @State var isEditingTaskFocused = false
    
    var body: some View {
        VStack(spacing: 0) {
            // KeyResult 헤더
            VStack(spacing: 0) {
                HStack {
                    TextField("", text: $keyResultTitle, prompt: Text("Key Results를 입력해 주세요").font(.pretendard(.medium, size: 16)).foregroundColor(Color("grey_500")))
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundColor(Color("grey_900"))
                        
                    Button {
                        // keyResultEditing 종료
                        viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
                        self.isAddingKeyResult = false
                    } label: {
                        Image("xMark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                    }
                    .onChange(of: keyResultTitle) { newValue in
                        viewModel.newEditingKeyResult.title = newValue
                    }
                    .onChange(of: viewModel.newEditingKeyResult.title) { newValue in
                        keyResultTitle = newValue
                    }
                }
                .padding(EdgeInsets(top: 14, leading: 8, bottom: 7, trailing: 14))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("grey_900"))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
                HStack(spacing: 9) {
                    CustomProgressBar(value: $viewModel.newEditingKeyResult.progressValue, backgroundColor: Color("grey_300"), isOutdated: .constant(false))
                    Text("\(viewModel.newEditingKeyResult.progressPercentage)%")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundColor(Color("title_black"))
                }
                .frame(height: 19.85)
                .padding(.horizontal, 8)
            }
            .padding(.bottom, 20)
            // 배열이 비어있지 않을 때만 showNewTasks
            if !viewModel.newEditingKeyResult.tasks.isEmpty {
                showNewTasks()
            }
            // 태스크 추가 중이고 태스크 갯수가 5개 미만이면 editNewTask 보이기
            if isAddingTask && viewModel.newEditingKeyResult.tasks.count != 5 {
                editNewTask()
            }
        }
        .background(Color("grey_50"))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("grey_300"))
        )
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
                } else {
                    TaskEditView(isAddingTask: $isAddingTask, isLast: false, task: task)
                }
            }
        }
    }
    
    @ViewBuilder
    func editNewTask() -> some View {
        VStack(spacing: 0) {
            HStack {
                Image("square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                ZStack {
                    // 태스크 내용
                    TextField("", text: $taskTitle, onEditingChanged: { editing in
                        // 수정 중인지 아닌지
                        if editing {
                            self.isEditingTaskFocused = true
                        } else {
                            self.isEditingTaskFocused = false
                        }
                    })
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .background {
                        // 플레이스홀더
                        if taskTitle.isEmpty {
                            HStack {
                                Text("내용을 입력해주세요")
                                    .font(.pretendard(.medium, size: 16))
                                    .foregroundColor(Color("grey_500"))
                                Spacer()
                            }
                        }
                    }
                }
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
                    if taskTitle.isEmpty {
                        Image("plus")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color("grey_500"))
                    } else {
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
            .padding(.trailing, 13)
            .padding(.bottom, 11)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("grey_900"))
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
        }
    }
    
    struct KeyResultEditView_Previews: PreviewProvider {
        static var previews: some View {
            KeyResultEditView(isAddingKeyResult: .constant(true))
                .environmentObject(OKRViewModel())
        }
    }
}
