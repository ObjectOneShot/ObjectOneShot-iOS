//
//  KeyResultDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/09.
//

import SwiftUI

struct KeyResultDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State var isExpanded = false
    
    @State var keyResultTitle = ""
    @State var progressValue: Double = 0.0
    @State var progressPercentage = 0
    
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
                    }
            })
                // 펼치면 Task들 보이기
                if isExpanded {
                showTasks()
            }
        }
        .onAppear {
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                self.keyResultTitle = viewModel.currentObjective.keyResults[index].title
                self.progressValue = viewModel.currentObjective.keyResults[index].progressValue
                self.progressPercentage = viewModel.currentObjective.keyResults[index].progressPercentage
            } else {
                print("ERROR : no keyResult matching id : KeyResultDetailView")
            }
        }
        .onChange(of: progressValue) { newValue in
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                if newValue == 0 {
                    viewModel.currentObjective.keyResults[index].completionState = .beforeStart
                } else if newValue == 1 {
                    viewModel.currentObjective.keyResults[index].completionState = .completed
                } else {
                    viewModel.currentObjective.keyResults[index].completionState = .inProgress
                }
            } else {
                print("ERROR : no keyResult matching id : KeyResultDetailView")
            }
            viewModel.currentObjective.setProgress()
        }
    }
    
    @ViewBuilder
    func showTasks() -> some View {
        // currentKeyResult의 tasks 보여주기
        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
            ForEach(viewModel.currentObjective.keyResults[index].tasks, id: \.id) { task in
                TaskDetailView(progressValue: $progressValue, progressPercentage: $progressPercentage, keyResultIndex: index, task: task, isLast: viewModel.currentObjective.keyResults[index].tasks.count - 1 == viewModel.currentObjective.keyResults[index].tasks.firstIndex(where: { $0.id == task.id }))
                // Task가 두 개 이상일 때만 삭제 가능
                    .if(viewModel.currentObjective.keyResults[index].tasks.count > 1) { view in
                        view
                            .onDelete(isTask: true) {
                                viewModel.currentObjective.keyResults[index].tasks = viewModel.currentObjective.keyResults[index].tasks.filter { $0.id != viewModel.currentObjective.keyResults[index].tasks[viewModel.currentObjective.keyResults[index].tasks.firstIndex(where: { $0.id == task.id })!].id } }
                    }
            }
        }
    }
}

struct KeyResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultDetailView(keyResultID: KeyResult.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
