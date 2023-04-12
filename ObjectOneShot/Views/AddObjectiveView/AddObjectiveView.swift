//
//  AddObjective.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct AddObjective: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State var objectiveTitle: String = ""
    @State var objectiveStartDate = Date()
    @State var objectiveEndDate = Date()
    @State var objectiveProgressValue = 0.0
    @State var objectiveProgressPercentage = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            // Header
            HStack {
                backButton()
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Text("Objective 설정")
                    .font(.system(size:20, weight: .bold))
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            // objective detail 뷰
            ObjectiveDetailCard(title: $objectiveTitle, startDate: $objectiveStartDate, endDate: $objectiveEndDate, progressValue: $objectiveProgressValue, progressPercentage: $objectiveProgressPercentage)
                .onChange(of: viewModel.currentObjective.progressValue) { newValue in
                    self.objectiveProgressValue = newValue
                }
                .onChange(of: viewModel.currentObjective.progressPercentage) { newValue in
                    self.objectiveProgressPercentage = newValue
                }
            // KeyReulst 헤더 뷰
            KeyResultsHeaderView()
            // Key Result 추가 뷰
            ScrollView {
                VStack {
                    ForEach(viewModel.currentObjective.keyResults, id: \.self) { keyResult in
                        KeyResultDetailView(keyResult: keyResult)
                    }
                }
                Spacer()
                if viewModel.isAddingKeyResult {
                    KeyResultEditView()
                        .padding(.horizontal, 5)
                        .padding(.top, 10)
                    
                    Button {
                        // 작성된 key result를 newKeyResults에 저장
                        // 다만 텍스트필드가 모두 채워져 있어야 함
                        // task도 하나 이상 있어야 함
                        if !viewModel.newKeyResult.title.isEmpty {
                            viewModel.isAddingKeyResult = false
                            viewModel.currentObjective.keyResults.append(viewModel.newKeyResult)
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
                        viewModel.isAddingKeyResult = true
                        viewModel.newKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [Task(title: "")])
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
            }
            
            Spacer()
            addObjectButton()   /* TODO : 키보드랑 같이 위로 올라오지 않도록 수정 */
        }
        .onAppear {
            let currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
            viewModel.currentObjective = currentObjective
            
            self.objectiveTitle = currentObjective.title
            self.objectiveStartDate = currentObjective.startDate
            self.objectiveEndDate = currentObjective.endDate
            self.objectiveProgressValue = currentObjective.progressValue
            self.objectiveProgressPercentage = currentObjective.progressPercentage
        }
        .onDisappear {
            viewModel.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [])
            viewModel.newKeyResult = KeyResult(title: "", completionState: .beforeStart, tasks: [])
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
            self.presentationMode.wrappedValue.dismiss()
        } label : {
            HStack{
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
        }
    }
    
    @ViewBuilder
    func addObjectButton() -> some View {
        Button {
            // 모든 텍스트필드가 작성되어 있다면 뷰모델에게 목표 등록 일시키기
            if !viewModel.currentObjective.title.isEmpty {
                viewModel.addNewObjective(viewModel.currentObjective)
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("목표 등록하기")
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.gray)
    }
}

struct AddObjective_Previews: PreviewProvider {
    static var previews: some View {
        AddObjective()
            .environmentObject(OKRViewModel.shared)
    }
}
