//
//  ObjectiveDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

// using viewmodel's currentObjective to handle objective data
struct ObjectiveDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    @Namespace var bottomID
    
    let objectiveID: String
    @Binding var isObjectiveCompleted: Bool
    @State private var isAddingKeyResult = false
    @State private var isPresentingTips = false
    @State private var isPresentingSaveAlert = false
    @State private var isSaveButtonTapped = false
    var isShowingCompletedObjectives: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // objective Detail Header
                objectiveDetailHeader()
                ScrollViewReader { proxy in
                    ScrollView {
                        ObjectiveDetailCard(objectiveID: objectiveID, isShowingCompletedObjective: isShowingCompletedObjectives)
                        KeyResultsHeaderView()
                        VStack(spacing: 0) {
                            showKeyResultDetails()
                            // 완료된 objective detail을 보이는 것이 아니고
                            // keyResult를 추가 중이면 KeyResultEditView 보이기 및 버튼 종류 변경
                            if !isShowingCompletedObjectives {
                                if self.isAddingKeyResult {
                                    KeyResultEditView(isAddingKeyResult: $isAddingKeyResult)
                                    keyResultSaveButton()
                                } else {
                                    keyResultAddButton(proxy: proxy)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .background(Color("primary_10"))
                        .id(bottomID)
                    }
                }
            }
            
            if isPresentingSaveAlert {
                CustomAlert(alertState: .savingChanges, objectiveID: objectiveID, isShowingAlert: $isPresentingSaveAlert, isSaveButtonTapped: $isSaveButtonTapped, isObjectiveCompleted: $isObjectiveCompleted)
            }
        }
        .onAppear {
            // 선택된 objective 가져오기
            if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                viewModel.currentObjective = currentObjective
                for index in viewModel.currentObjective.keyResults.indices {
                    viewModel.currentObjective.keyResults[index].isExpanded = false
                }
            } else {
                print("ERROR : no objective found matching id : \(objectiveID) in ObjectiveDetailCard")
            }
            if isShowingCompletedObjectives {
                viewModel.keyResultState = .completed
            } else {
                viewModel.keyResultState = .beforeStart
            }
        }
        .onDisappear {
            viewModel.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .onChange(of: viewModel.currentObjective.progressValue, perform: { newValue in
            if !isShowingCompletedObjectives {
                if viewModel.currentObjective.progressValue == 1 {
                    isObjectiveCompleted = true
                } else {
                    isObjectiveCompleted = false
                }
            }
        })
        .background(Color("background"))
        .fullScreenCover(isPresented: $isPresentingTips) {
            UseTipsView(isPresenting: $isPresentingTips)
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func objectiveDetailHeader() -> some View {
        HStack(spacing: 0) {
            backButton()
                .padding(.trailing, 16)
            Text("Objective를 설정해 주세요")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("title_black"))
                .padding(.vertical, 12)
            Spacer()
            Button {
                isPresentingTips = true
            } label: {
                Image("questionMark.black")
            }
            .padding(.trailing, 26)
        }
        .padding(.leading, 24)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_300"))
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
    }
    
    @ViewBuilder
    func showKeyResultDetails() -> some View {
        switch viewModel.keyResultState {
        case .beforeStart:
            if !viewModel.currentObjective.keyResults.filter({ $0.completionState == .beforeStart }).isEmpty {
                ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .beforeStart }, id: \.self) { keyResult in
                    KeyResultDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjectives)
                        .padding(.bottom, 10)
                }
            } else if isShowingCompletedObjectives {
                Color("primary_10")
            }
        case .inProgress:
            if !viewModel.currentObjective.keyResults.filter({ $0.completionState == .inProgress }).isEmpty {
                ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .inProgress }, id: \.self) { keyResult in
                    KeyResultDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjectives)
                        .padding(.bottom, 10)
                }
            } else if isShowingCompletedObjectives {
                Color("primary_10")
            }
        case .completed:
            if !viewModel.currentObjective.keyResults.filter({ $0.completionState == .completed }).isEmpty {
                ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .completed }, id: \.self) { keyResult in
                    KeyResultDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjectives)
                        .padding(.bottom, 10)
                }
            } else if isShowingCompletedObjectives {
                Color("primary_10")
            }
        }
    }
    
    @ViewBuilder
    func keyResultSaveButton() -> some View {
        Button {
            // 작성된 key result를 newKeyResults에 저장
            // 다만 텍스트필드가 모두 채워져 있어야 함
            // task도 하나 이상 있어야 함
            if !viewModel.newEditingKeyResult.title.isEmpty && !viewModel.newEditingKeyResult.tasks.isEmpty {
                self.isAddingKeyResult = false
                
                viewModel.currentObjective.keyResults.append(viewModel.newEditingKeyResult)
                if viewModel.newEditingKeyResult.completionState == .beforeStart {
                    viewModel.keyResultState = .beforeStart
                } else if viewModel.newEditingKeyResult.completionState == .inProgress {
                    viewModel.keyResultState = .inProgress
                } else {
                    viewModel.keyResultState = .completed
                }
                
                viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
            }
        } label: {
            Text("Key Result 저장")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("titleForeground"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .if(viewModel.newEditingKeyResult.title.isEmpty || viewModel.newEditingKeyResult.tasks.isEmpty ) { view in
                    view
                        .background(Color("primaryColor_50"))
                }
                .if(!viewModel.newEditingKeyResult.title.isEmpty && !viewModel.newEditingKeyResult.tasks.isEmpty ) { view in
                    view
                        .background(Color("primaryColor"))
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func keyResultAddButton(proxy : ScrollViewProxy) -> some View {
        Button {
            // editing 시작
            self.isAddingKeyResult = true
            viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
            withAnimation {
                proxy.scrollTo(bottomID)
            }
        } label: {
            Text("Key Result 추가")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("titleForeground"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("primaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        //.padding(.vertical, 10)
    }
    
    @ViewBuilder
    func backButton() -> some View {
        Button {
            /*
             TODO : 값을 변경했을 때만 값을 저장하지 않고 나가겠냐는 팝업창 띄워주기
             */
            if !isShowingCompletedObjectives {
                if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                    // 데이터 변경 없음
                    if currentObjective == viewModel.currentObjective {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        isPresentingSaveAlert = true
                    }
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        } label : {
            HStack{
                Image("chevron.left.black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 14)
            }
        }
        .onChange(of: isSaveButtonTapped) { newValue in
            if newValue {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ObjectiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveDetailView(objectiveID: Objective.dummy.id, isObjectiveCompleted: .constant(false))
            .environmentObject(OKRViewModel())
    }
}
