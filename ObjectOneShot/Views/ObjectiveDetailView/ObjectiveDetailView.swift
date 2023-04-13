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
    
    @State var objectiveTitle: String = ""
    @State var objectiveStartDate = Date()
    @State var objectiveEndDate = Date()
    @State var objectiveProgressValue = 0.0
    @State var objectiveProgressPercentage = 0
    @State var currentKeyResults: [KeyResult] = []
    
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
            ObjectiveDetailCard()
            KeyResultsHeaderView()
            ScrollView {
                VStack {
                    ForEach(currentKeyResults, id: \.self) { keyResult in
                        KeyResultDetailView(keyResult: keyResult)
                            .sync($currentKeyResults, with: $viewModel.currentObjective.keyResults)
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                viewModel.currentObjective = currentObjective
                
                self.objectiveTitle = currentObjective.title
                self.objectiveStartDate = currentObjective.startDate
                self.objectiveEndDate = currentObjective.endDate
                self.objectiveProgressValue = currentObjective.progressValue
                self.objectiveProgressPercentage = currentObjective.progressPercentage
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
