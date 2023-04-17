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
    
    let objectiveID: String
    @State private var isAddingKeyResult = false
    @State private var isPresentingTips = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 0) {
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
            ObjectiveDetailCard(objectiveID: objectiveID)
            KeyResultsHeaderView()
            ScrollView {
                VStack(spacing: 0) {
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
                    // keyResult를 추가 중이면 KeyResultEditView 보이기 및 버튼 종류 변경
                    if self.isAddingKeyResult {
                        KeyResultEditView(isAddingKeyResult: $isAddingKeyResult)
                        
                        Button {
                            // 작성된 key result를 newKeyResults에 저장
                            // 다만 텍스트필드가 모두 채워져 있어야 함
                            // task도 하나 이상 있어야 함
                            if !viewModel.newEditingKeyResult.title.isEmpty {
                                self.isAddingKeyResult = false
                                
                                viewModel.currentObjective.keyResults.append(viewModel.newEditingKeyResult)
                                if viewModel.newEditingKeyResult.completionState == .beforeStart {
                                    viewModel.keyResultState = .beforeStart
                                } else if viewModel.newEditingKeyResult.completionState == .inProgress {
                                    viewModel.keyResultState = .inProgress
                                } else {
                                    viewModel.keyResultState = .completed
                                }
                            }
                        } label: {
                            Text("Key Result 저장")
                                .font(.pretendard(.semiBold, size: 18))
                                .foregroundColor(Color("titleForeground"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .if(viewModel.newEditingKeyResult.title.isEmpty) { view in
                                    view
                                        .background(Color("primaryColor_50"))
                                }
                                .if(!viewModel.newEditingKeyResult.title.isEmpty) { view in
                                    view
                                        .background(Color("primaryColor"))
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.vertical, 10)

                    } else {
                        Button {
                            // editing 시작
                            self.isAddingKeyResult = true
                            viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
                        } label: {
                            Text("Key Result 추가")
                                .font(.pretendard(.semiBold, size: 18))
                                .foregroundColor(Color("titleForeground"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color("primaryColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.vertical, 10)

                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .background(Color("primary_10"))
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
        }
        .onDisappear {
            viewModel.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .background(Color("background"))
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
            viewModel.objectives[viewModel.objectives.firstIndex(where: { $0.id == objectiveID })!] = viewModel.currentObjective
            self.presentationMode.wrappedValue.dismiss()
            viewModel.saveObjectivesToUserDefaults()
        } label : {
            HStack{
                Image("chevron.left.black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 14)
            }
        }
    }
}

struct ObjectiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveDetailView(objectiveID: Objective.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
