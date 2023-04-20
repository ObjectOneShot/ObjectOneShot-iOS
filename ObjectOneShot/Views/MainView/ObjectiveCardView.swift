//
//  ObjectiveCardView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct ObjectiveCardView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    let objectiveID: String
    
    @Binding var isShowingObjectiveDeleteAlert: Bool
    @State var objectiveTitle = ""
    @State var objectiveEndDate = Date()
    @State var firstKeyReulstTitle = ""
    @State var secondKeyReusltTitle = ""
    @State var progressValue: Double = 0.0
    @State var progressPercentage = 0
    @State var isCompleted = false
    @State var isOutdated = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            objectiveCardHeader()
            // keyResult 보여주기
            if !firstKeyReulstTitle.isEmpty {
                showRecentKeyResults()
            }
            // divider
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("grey_200"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            progressBar()
        }
        .background(Color("grey_50"))
        .border(Color("grey_200"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onDelete(){
            isShowingObjectiveDeleteAlert = true
            viewModel.deletingObjectiveID = objectiveID
        }
        .padding(.horizontal, 16)
        .shadow(radius: 1)
        .onAppear {
            
            
            if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                
                self.objectiveTitle = currentObjective.title
                self.objectiveEndDate = currentObjective.endDate
                self.progressValue = currentObjective.progressValue
                self.progressPercentage = currentObjective.progressPercentage
                self.isCompleted = currentObjective.isCompleted
                self.isOutdated = currentObjective.isOutdated
                
                if currentObjective.keyResults.count > 0 {
                    self.firstKeyReulstTitle = currentObjective.keyResults[0].title
                } else {
                    self.firstKeyReulstTitle = ""
                    self.secondKeyReusltTitle = ""
                }
                
                if currentObjective.keyResults.count > 1 {
                    self.secondKeyReusltTitle = currentObjective.keyResults[1].title
                } else {
                    self.secondKeyReusltTitle = ""
                }
                
            } else {
                print("ERROR : no objective found matching id : \(objectiveID) in ObjectiveDetailCard")
            }
        }
    }
    
    @ViewBuilder
    func objectiveCardHeader() -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(objectiveTitle)
                .font(.pretendard(.medium, size: 16))
                .foregroundColor(Color("grey_900"))
            Spacer()
            if isCompleted {
                Text("달성")
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("red_error"))
            } else {
                if viewModel.isOutDated(endDate: objectiveEndDate) {
                    Text("미달성")
                        .font(.pretendard(.semiBold, size: 10))
                        .foregroundColor(Color("title_black"))
                } else {
                    Text("D-\(viewModel.getDday(endDate: objectiveEndDate))")
                        .font(.pretendard(.semiBold, size: 10))
                        .foregroundColor(Color("red_error"))
                }
            }
            Text(" / \(viewModel.getStringDate(of: objectiveEndDate))")
                .font(.pretendard(.semiBold, size: 10))
                .foregroundColor(Color("grey_600"))
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 16))
    }
    
    @ViewBuilder
    func progressBar() -> some View {
        HStack {
            CustomProgressBar(value: $progressValue, backgroundColor: Color("grey_200"), isOutdated: $isOutdated)
                .frame(height: 16)
            
            Text("\(progressPercentage)%")
                .font(.pretendard(.medium, size: 14))
                .foregroundColor(Color("progress_percentage"))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    func showRecentKeyResults() -> some View {
        VStack(spacing: 6) {
            HStack {
                Rectangle()
                    .frame(width: 1.2, height: 14)
                Text(firstKeyReulstTitle)
                Spacer()
            }
            if !secondKeyReusltTitle.isEmpty {
                HStack {
                    Rectangle()
                        .frame(width: 1.2, height: 14)
                    Text(secondKeyReusltTitle)
                    Spacer()
                }
            }
        }
        .font(.pretendard(.thin, size: 12))
        .foregroundColor(Color("grey_900"))
        .padding(8)
        .background(Color("taskBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

struct ObjectiveCardView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveCardView(objectiveID: Objective.dummy.id, isShowingObjectiveDeleteAlert: .constant(false))
            .environmentObject(OKRViewModel())
    }
}
