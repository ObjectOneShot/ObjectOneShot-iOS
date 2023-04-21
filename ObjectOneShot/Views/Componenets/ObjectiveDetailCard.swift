//
//  ObjectiveDetailCard.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/09.
//

import SwiftUI

struct ObjectiveDetailCard: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    let objectiveID: String
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage: Int = 0
    var isShowingCompletedObjective: Bool = false
    
    var body: some View {
        VStack(spacing: 8){
            HStack(alignment: .center) {
                Text("목표")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                VStack(alignment: .center, spacing: 0) {
                    TextField("", text: $title, prompt: Text("목표를 입력해주세요").font(.pretendard(.regular, size: 14)).foregroundColor(Color("grey_500")))
                        .disabled(isShowingCompletedObjective)
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color("grey_900"))
                        .frame(height: 29)
                        .padding(.top, 7)
                        .padding(.horizontal, 12)
                        .onChange(of: title) { _ in
                            viewModel.currentObjective.title = title
                        }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("grey_900"))
                        .padding(.bottom, 8)
                        .padding(.horizontal, 12)
                }
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
            }
            HStack(alignment: .center) {
                Text("기간")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                HStack {
                    DatePicker("", selection: $startDate, in: ...endDate, displayedComponents: .date)
                        .disabled(isShowingCompletedObjective)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko-KR"))
                        .scaleEffect(0.9)
                        .onChange(of: startDate) { _ in
                            viewModel.currentObjective.startDate = startDate
                        }
                    Text("~")
                        .font(.pretendard(.regular, size: 14))
                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .disabled(isShowingCompletedObjective)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko-KR"))
                        .scaleEffect(0.9)
                        .onChange(of: endDate) { newValue in
                            viewModel.currentObjective.endDate = endDate
                        }
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
                
            }
            HStack {
                Text("달성")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                HStack {
                    CustomProgressBar(value: $progressValue, backgroundColor: Color("grey_300"), isOutdated: .constant(false))
                        .padding(.vertical, 12)
                        .onChange(of: viewModel.currentObjective.progressValue) { newValue in
                            progressValue = viewModel.currentObjective.progressValue
                        }
                    Text("\(progressPercentage)%")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundColor(Color("title_black"))
                        .padding(.vertical, 12)
                        .onChange(of: viewModel.currentObjective.progressPercentage) { newValue in
                            progressPercentage = viewModel.currentObjective.progressPercentage
                        }
                }
                .padding(.horizontal, 10)
                .frame(height: 44)
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8.5)
        .background(Color("grey_100"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .onAppear {
            if let currentObjective = viewModel.objectives.first(where: { $0.id == objectiveID }) {
                self.title = currentObjective.title
                self.startDate = currentObjective.startDate
                self.endDate = currentObjective.endDate
                self.progressValue = currentObjective.progressValue
                self.progressPercentage = currentObjective.progressPercentage
            }
        }
    }
}

struct ObjectiveDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveDetailCard(objectiveID: Objective.dummy.id)
            .environmentObject(OKRViewModel())
    }
}
