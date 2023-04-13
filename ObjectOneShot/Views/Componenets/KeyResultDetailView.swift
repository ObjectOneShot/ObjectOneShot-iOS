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
    
    @State private var keyResultTitle = ""
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage = 0
    @State private var taskTitle = ""
    
    let keyResultID: String
    
    var body: some View {
        VStack(spacing: 10) {
            // KeyResult title
            VStack {
                HStack {
                    TextField("", text: $keyResultTitle)
                        .padding(.leading, 5)
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
                        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                            viewModel.currentObjective.keyResults[index].isExpanded.toggle()
                        }
                    } label: {
                        if isExpanded {
                            Image(systemName: "chevron.up")
                                .padding(.trailing, 5)
                                .tint(.black)
                        } else {
                            Image(systemName: "chevron.down")
                                .padding(.trailing, 5)
                                .tint(.black)
                        }
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(5)
                HStack {
                    ProgressView(value: progressValue)
                    Text("\(progressPercentage)%")
                }
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 10)
            .if(!isExpanded, transform: { view in
                view
                    .onDelete(isTask: false) {
                        viewModel.currentObjective.keyResults =  viewModel.currentObjective.keyResults.filter { $0.id != keyResultID }
                        viewModel.currentObjective.setProgress()
                    }
            })
                // 펼치면 Task들 보이기
            if isExpanded {
                showTasks()
                
                // task가 5개를 채우지 못했을 경우에만 editTask 보이기
                if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                    if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                        if isEditingNewTask {
                            editNewTask()
                        }
                    }
                }
            }
        }
        .onAppear {
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                self.keyResultTitle = viewModel.currentObjective.keyResults[index].title
                self.progressValue = viewModel.currentObjective.keyResults[index].progressValue
                self.progressPercentage = viewModel.currentObjective.keyResults[index].progressPercentage
                self.isExpanded = viewModel.currentObjective.keyResults[index].isExpanded
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
                // Task가 두 개 이상일 때만 삭제 가능
                    .if(viewModel.currentObjective.keyResults[index].tasks.count > 1) { view in
                        view
                            .onDelete(isTask: true) {
                                viewModel.currentObjective.keyResults[index].tasks = viewModel.currentObjective.keyResults[index].tasks.filter { $0.id != viewModel.currentObjective.keyResults[index].tasks[viewModel.currentObjective.keyResults[index].tasks.firstIndex(where: { $0.id == task.id })!].id }
                                viewModel.currentObjective.keyResults[index].setProgress()
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
                        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                            if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                                viewModel.currentObjective.keyResults[index].tasks.append(Task(title: taskTitle))
                                taskTitle = ""
                            }
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
}

struct KeyResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultDetailView(keyResultID: KeyResult.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
