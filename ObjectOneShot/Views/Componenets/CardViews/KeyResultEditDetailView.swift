//
//  KeyResultEditDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/30.
//

import SwiftUI
import Combine

struct KeyResultEditDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State private var isExpanded = false
    @State private var keyResultTitle = ""
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage = 0
    @State var doShake = false
    
    let keyResultID: String
    var isShowingCompletedObjective: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            showKeyResultTitle()
            // 펼치기 true면 task들 펼쳐서 보여주기
            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                if viewModel.currentObjective.keyResults[index].isExpanded {
                    showTasks()
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
                self.keyResultTitle = viewModel.currentObjective.keyResults[index].title
                self.isExpanded = viewModel.currentObjective.keyResults[index].isExpanded
                self.progressValue = viewModel.currentObjective.keyResults[index].progressValue
                self.progressPercentage = viewModel.currentObjective.keyResults[index].progressPercentage
            }
        }
    }
    
    @ViewBuilder
    func showKeyResultTitle() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ZStack {
                    TextField("", text: $keyResultTitle, onEditingChanged: { editing in
                        if !editing {
                            if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                                viewModel.currentObjective.keyResults[index].title = keyResultTitle
                            } else {
                                print("ERROR : no keyResult matching id : KeyResultDetailView")
                            }
                        }
                    })
                    .disabled(isShowingCompletedObjective)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .background {
                        if keyResultTitle.isEmpty {
                            HStack {
                                Text("단계별 계획을 입력해주세요")
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
                    endTextEditing()
                    isExpanded.toggle()
                    if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
                        viewModel.currentObjective.keyResults[index].isExpanded = isExpanded
                    }
                } label: {
                    if isExpanded {
                        Image("chevron.down")
                            .frame(width: 24, height: 24)
                            .rotationEffect(Angle(degrees: 180))
                    } else {
                        Image("chevron.down")
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(EdgeInsets(top: 15, leading: 8, bottom: 7, trailing: 10))
        }
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_900"))
            .padding(.horizontal, 8)
        HStack(spacing: 8) {
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
        .padding(.vertical, 12)
        .padding(.leading, 8)
        .padding(.trailing, 11)
    }
    
    @ViewBuilder
    func showTasks() -> some View {
        // currentKeyResult의 tasks 보여주기
        if let index = viewModel.currentObjective.keyResults.firstIndex(where: { $0.id == keyResultID }) {
            ForEach(viewModel.currentObjective.keyResults[index].tasks, id: \.id) { task in
                TaskEditDetailView(task: task, keyResultIndex: index, isShowingCompletedObjective: isShowingCompletedObjective)
                    .padding(.bottom, 10)
            }
        }
    }
    
}

struct KeyResultEditDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultEditDetailView(keyResultID: KeyResult.dummy.id, isShowingCompletedObjective: false)
            .environmentObject(OKRViewModel())
    }
}
