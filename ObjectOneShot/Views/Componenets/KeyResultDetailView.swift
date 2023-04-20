//
//  KeyResultDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/09.
//

import SwiftUI

struct KeyResultDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State private var isExpanded = false
    @State private var isEditingNewTask = false
    @State private var isEditingTaskFocused = false
    
    @State private var keyResultTitle = ""
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage = 0
    @State private var taskTitle = ""
    
    let keyResultID: String
    
    var body: some View {
        VStack(spacing: 0) {
            // KeyResult title
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TextField("", text: $keyResultTitle, prompt: Text("Key Results를 입력해 주세요").font(.pretendard(.medium, size: 16)).foregroundColor(Color("grey_500")))
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundColor(Color("grey_900"))
                        .onChange(of: keyResultTitle) { _ in
                            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                                viewModel.currentObjective.keyResults[index].title = keyResultTitle
                            } else {
                                print("ERROR : no keyResult matching id : KeyResultDetailView")
                            }
                        }
                    Spacer()
                    Button {
                        isExpanded.toggle()
                    } label: {
                        if isExpanded {
                            Image("chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 7.47)
                                .rotationEffect(Angle(degrees: 180))
                        } else {
                            Image("chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 7.47)
                        }
                    }
                }
                .padding(EdgeInsets(top: 14, leading: 8, bottom: 7, trailing: 14))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("grey_900"))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
                HStack {
                    CustomProgressBar(value: $progressValue, backgroundColor: Color("grey_300"), isOutdated: .constant(false))
                    Text("\(progressPercentage)%")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundColor(Color("title_black"))
                }
                .frame(height: 19.85)
                .padding(.horizontal, 8)
            }
            .padding(.bottom, 20)
            
                // 펼치면 Task들 보이기
            if isExpanded {
                showTasks()
                // task가 5개를 채우지 못했고
                if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                    if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                        // + 버튼 눌러 새로운 task 추가중일 때 editNewTask 보이기
                        if isEditingNewTask {
                            editNewTask()
                        }
                    }
                }
            }
        }
        
        .background(Color("grey_50"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("grey_300"))
        )
        .if(!isExpanded, transform: { view in
            view
                .onDelete() {
                    viewModel.currentObjective.keyResults =  viewModel.currentObjective.keyResults.filter { $0.id != keyResultID }
                    viewModel.currentObjective.setProgress()
                }
        })
        .onAppear {
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                self.keyResultTitle = viewModel.currentObjective.keyResults[index].title
                self.progressValue = viewModel.currentObjective.keyResults[index].progressValue
                self.progressPercentage = viewModel.currentObjective.keyResults[index].progressPercentage
                self.isExpanded = viewModel.currentObjective.keyResults[index].isExpanded
                
                if viewModel.currentObjective.keyResults[index].tasks.isEmpty {
                    self.isEditingNewTask = true
                }
            } else {
                print("ERROR : no keyResult matching id : KeyResultDetailView")
            }
        }
        .onChange(of: progressValue) { newValue in
            viewModel.currentObjective.setProgress()
        }
    }
    
    @ViewBuilder
    func showTasks() -> some View {
        // currentKeyResult의 tasks 보여주기
        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
            ForEach(viewModel.currentObjective.keyResults[index].tasks, id: \.id) { task in
                TaskDetailView(isEditingNewTask: $isEditingNewTask, progressValue: $progressValue, progressPercentage: $progressPercentage, keyResultIndex: index, task: task, isLast: viewModel.currentObjective.keyResults[index].tasks.count - 1 == viewModel.currentObjective.keyResults[index].tasks.firstIndex(where: { $0.id == task.id }))
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
                            if taskTitle.isEmpty {
                                if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                                    // 만약 taskTitle 비어있고 task가 하나도 없다면 isEditingNewTask true로 유지
                                    if viewModel.currentObjective.keyResults[index].tasks.isEmpty {
                                        isEditingNewTask = true
                                    } else {
                                        isEditingNewTask = false
                                    }
                                }
                            } else {
                                if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                                    if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                                        viewModel.currentObjective.keyResults[index].tasks.append(Task(title: taskTitle))
                                        taskTitle = ""
                                    }
                                }
                            }
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
                        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                            if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                                viewModel.currentObjective.keyResults[index].tasks.append(Task(title: taskTitle))
                                taskTitle = ""
                            }
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
}

struct KeyResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultDetailView(keyResultID: KeyResult.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
