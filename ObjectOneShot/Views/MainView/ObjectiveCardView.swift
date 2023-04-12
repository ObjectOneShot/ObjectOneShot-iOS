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
    
    @State var objectiveTitle = ""
    @State var objectiveEndDate = Date()
    @State var firstKeyReulstTitle = ""
    @State var secondKeyReusltTitle = ""
    @State var progressValue: Double = 0.0
    @State var progressPercentage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("목표 : \(objectiveTitle)")
                    .padding(.horizontal)
                Spacer()
                Text("마감일 : \(viewModel.getStringDate(of: objectiveEndDate))")
                    .font(.system(size:12))
                    .padding(.horizontal)
            }
            if !firstKeyReulstTitle.isEmpty {
                showRecentKeyResults()
            }
            Rectangle()
                .frame(height: 1)
                .padding(.horizontal)
            HStack {
                ProgressView(value: progressValue)
                Text("\(progressPercentage)%")
            }
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .onAppear {
            if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                
                self.objectiveTitle = currentObjective.title
                self.objectiveEndDate = currentObjective.endDate
                self.progressValue = currentObjective.progressValue
                self.progressPercentage = currentObjective.progressPercentage
               
                if currentObjective.keyResults.count > 0 {
                    self.firstKeyReulstTitle = currentObjective.keyResults[0].title
                }
                
                if currentObjective.keyResults.count > 1 {
                    self.secondKeyReusltTitle = currentObjective.keyResults[1].title
                }
                
            } else {
                print("ERROR : no objective found matching id : \(objectiveID) in ObjectiveDetailCard")
            }
        }
    }
    
    @ViewBuilder
    func showRecentKeyResults() -> some View {
        VStack {
            HStack {
                Text("|")
                    .foregroundColor(.gray)
                Text(firstKeyReulstTitle)
                Spacer()
            }
            if !secondKeyReusltTitle.isEmpty {
                HStack {
                    Text("|")
                        .foregroundColor(.gray)
                    Text(secondKeyReusltTitle)
                    Spacer()
                }
            }
        }
        .padding()
        .background(.pink)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct ObjectiveCardView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveCardView(objectiveID: Objective.dummy.id)
            .environmentObject(OKRViewModel.shared)
    }
}
