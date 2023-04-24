//
//  AddObjective.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct AddObjectiveView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    @Namespace var bottomID
    
    @State private var isAddingKeyResult = true
    @State private var isPresentingTips: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                addObjectiveHeader()
                ScrollViewReader { proxy in
                    ScrollView {
                        // objective detail 뷰
                        ObjectiveDetailCard(objectiveID: "")
                        // KeyReulst 헤더 뷰
                        KeyResultsHeaderView()
                        // Key Result 추가 뷰
                        VStack(spacing: 0) {
                            showKeyResultDetails()
                            // keyResult를 추가 중이면 KeyResultEditView 보이기 및 버튼 종류 변경
                            if self.isAddingKeyResult  {
                                KeyResultEditView(isAddingKeyResult: $isAddingKeyResult)
                                keyResultSaveButton()
                            } else {
                                keyResultAddButton(proxy: proxy)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .background(Color("primary_10"))
                        .id(bottomID)
                    }
                }
            }
            VStack {
                Spacer()
                addObjectButton()
            }
            .ignoresSafeArea(.keyboard)
        }
        .background(Color("background"))
        .onAppear {
            // objective 추가에 사용할 viewModel.currentObjective 초기화
            let currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
            viewModel.currentObjective = currentObjective
        }
        .onDisappear {
            viewModel.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
            viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .fullScreenCover(isPresented: $isPresentingTips) {
            UseTipsView(isPresenting: $isPresentingTips)
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func backButton() -> some View {
        Button {
            /*
             TODO : 사용자의 내용작성 정도에 따라 값을 저장하지 않고 나가겠냐는 팝업창 띄워주기
             */
            self.presentationMode.wrappedValue.dismiss()
        } label : {
            Image("chevron.left.black")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
        }
    }
    
    @ViewBuilder
    func addObjectButton() -> some View {
        Button {
            // 모든 텍스트필드가 작성되어 있고 현재 keyResult 수정 중이 아니라면 뷰모델에게 목표 등록 일시키기
            if !viewModel.currentObjective.title.isEmpty && !isAddingKeyResult {
                viewModel.addNewObjective(viewModel.currentObjective)
                self.presentationMode.wrappedValue.dismiss()
                viewModel.saveObjectivesToUserDefaults()
            }
        } label: {
            Text("목표 등록하기")
                .font(.pretendard(.bold, size: 20))
                .foregroundColor(Color("titleForeground"))
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .if(viewModel.currentObjective.title.isEmpty || isAddingKeyResult) { view in
            view
                .background(Color("titleBackground_40"))
        }
        .if(!viewModel.currentObjective.title.isEmpty && !isAddingKeyResult) { view in
            view
                .background(Color("titleBackground"))
        }
        .padding(.bottom, 1)
    }
    
    @ViewBuilder
    func addObjectiveHeader() -> some View {
        HStack(spacing: 0) {
            backButton()
                .padding(.trailing, 16)
            Text("Objective를 설정해 주세요")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("title_black"))
                .padding(.vertical, 12)
            Spacer()
            Button {
                /* TODO : 사용법 화면 링크 */
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
            ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .beforeStart }, id: \.self) { keyResult in
                KeyResultDetailView(keyResultID: keyResult.id)
                    .padding(.bottom, 10)
            }
        case .inProgress:
            ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .inProgress }, id: \.self) { keyResult in
                KeyResultDetailView(keyResultID: keyResult.id)
                    .padding(.bottom, 10)
            }
        case .completed:
            ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .completed }, id: \.self) { keyResult in
                KeyResultDetailView(keyResultID: keyResult.id)
                    .padding(.bottom, 10)
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
                viewModel.currentObjective.setProgress()
            }
        } label: {
            Text("Key Result 저장")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("titleForeground"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .if(viewModel.newEditingKeyResult.title.isEmpty || viewModel.newEditingKeyResult.tasks.isEmpty) { view in
                    view
                        .background(Color("primaryColor_50"))
                }
                .if(!viewModel.newEditingKeyResult.title.isEmpty && !viewModel.newEditingKeyResult.tasks.isEmpty) { view in
                    view
                        .background(Color("primaryColor"))
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    func keyResultAddButton(proxy: ScrollViewProxy) -> some View {
        Button {
            // editing 시작
            self.isAddingKeyResult = true
            viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
            proxy.scrollTo(bottomID)
        } label: {
            Text("Key Result 추가")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("titleForeground"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("primaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.bottom, 10)
    }
}

struct AddObjective_Previews: PreviewProvider {
    static var previews: some View {
        AddObjectiveView()
            .environmentObject(OKRViewModel())
    }
}
