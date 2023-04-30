//
//  KeyResultEditDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/30.
//

import SwiftUI

struct KeyResultEditDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State private var isExpanded = false
    @State private var keyResultTitle = ""
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage = 0
    
    let keyResultID: String
    var isShowingCompletedObjective: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            showKeyResultTitle()
                .padding(.bottom, 20)
            
            if isExpanded {
                showTasks()
                // task가 5개를 채우지 못했고
                if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                    if viewModel.currentObjective.keyResults[index].tasks.count < 5 {
                        // + 버튼 눌러 새로운 task 추가중일 때 editNewTask 보이기
//                        if isEditingNewTask {
//                            editNewTask()
//                        }
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
        .if(!isExpanded && !isShowingCompletedObjective){ view in
            view
                .onDelete() {
                    viewModel.currentObjective.keyResults =  viewModel.currentObjective.keyResults.filter { $0.id != keyResultID }
                    viewModel.currentObjective.setProgress()
                }
        }
        .onAppear {
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                self.isExpanded = viewModel.currentObjective.keyResults[index].isExpanded
            }
        }
    }
    
    @ViewBuilder
    func showKeyResultTitle() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ZStack {
                    TextField("", text: $keyResultTitle) { editing in
                        if editing {
                            
                        } else {
                            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                                viewModel.currentObjective.keyResults[index].title = keyResultTitle
                            } else {
                                print("ERROR : no keyResult matching id : KeyResultDetailView")
                            }
                        }
                    }
                    .disabled(isShowingCompletedObjective)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .background {
                        if keyResultTitle.isEmpty {
                            HStack {
                                Text("Key Result 입력")
                                    .font(.pretendard(.medium, size: 16))
                                    .foregroundColor(Color("grey_500"))
                                Spacer()
                            }
                        }
                    }
                    .onReceive(keyResultTitle.publisher.collect()) {
                        if $0.count > Constants.characterLengthLimit {
                            self.keyResultTitle = String($0.prefix(Constants.characterLengthLimit))
                        }
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
        }
        .padding(EdgeInsets(top: 14, leading: 8, bottom: 7, trailing: 14))
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_900"))
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        HStack {
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
            CustomProgressBar(value: $progressValue, backgroundColor: Color("grey_300"), isOutdated: .constant(false))
                    .sync($progressValue, with: $viewModel.currentObjective.keyResults[index].progressValue)
            Text("\(progressPercentage)%")
                .font(.pretendard(.medium, size: 14))
                .foregroundColor(Color("title_black"))
                .sync($progressPercentage, with: $viewModel.currentObjective.keyResults[index].progressPercentage)
            }
        }
        .frame(height: 19.85)
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    func showTasks() -> some View {
        // currentKeyResult의 tasks 보여주기
        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
            ForEach(viewModel.currentObjective.keyResults[index].tasks, id: \.id) { task in
                TaskEditDetailView(task: task, keyResultIndex: index)
            }
        }
    }
        
}

struct KeyResultEditDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultEditDetailView(keyResultID: KeyResult.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
