//
//  ObjectiveDetailCard.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/09.
//

import SwiftUI

struct ObjectiveDetailCard: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    @Binding var title: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var progressValue: Double
    @Binding var progressPercentage: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("목표")
                    .frame(width: 60, height: 40)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("", text: $title)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onChange(of: title) { _ in
                        viewModel.currentObjective.title = title
                    }
            }
            HStack(alignment: .center) {
                Text("목표일")
                    .frame(width: 60, height: 40)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: startDate) { _ in
                            viewModel.currentObjective.startDate = startDate
                        }
                    Text("~")
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: endDate) { newValue in
                            viewModel.currentObjective.endDate = endDate
                        }
                    Spacer()
                }
                .frame(height: 40)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            HStack {
                Text("진행률")
                    .frame(width: 60, height: 40)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack {
                    ProgressView(value: progressValue)
                    Text("\(progressPercentage)%")
                }
                .frame(height: 40)
                .padding(.horizontal)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(10)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(10)
    }
}

struct ObjectiveDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveDetailCard(title: .constant(""), startDate: .constant(Date()), endDate: .constant(Date()), progressValue: .constant(0), progressPercentage: .constant(0))
    }
}
