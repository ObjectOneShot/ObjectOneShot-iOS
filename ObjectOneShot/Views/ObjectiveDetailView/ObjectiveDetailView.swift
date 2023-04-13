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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                backButton()
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Text("Objective 설정")
                    .font(.system(size:20, weight: .bold))
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            ObjectiveDetailCard(objectiveID: objectiveID)
            KeyResultsHeaderView()
            ScrollView {
                switch viewModel.keyResultState {
                case .beforeStart:
                    VStack {
                        ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .beforeStart }, id: \.self) { keyResult in
                            KeyResultDetailView(keyResultID: keyResult.id)
                        }
                    }
                case .inProgress:
                    VStack {
                        ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .inProgress }, id: \.self) { keyResult in
                            KeyResultDetailView(keyResultID: keyResult.id)
                        }
                    }
                case .completed:
                    VStack {
                        ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .completed }, id: \.self) { keyResult in
                            KeyResultDetailView(keyResultID: keyResult.id)
                        }
                    }
                }
                // keyResult를 추가 중이면 KeyResultEditView 보이기 및 버튼 종류 변경
                if self.isAddingKeyResult {
                    KeyResultEditView(isAddingKeyResult: $isAddingKeyResult)
                        .padding(.horizontal, 5)
                        .padding(.top, 10)
                    
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
                            .tint(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                } else {
                    Button {
                        // editing 시작
                        self.isAddingKeyResult = true
                        viewModel.newEditingKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
                    } label: {
                        Text("Key Result 추가")
                            .tint(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                }
                Spacer()
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
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
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
