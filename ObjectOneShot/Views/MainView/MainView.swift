//
//  MainView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var coordinator: Coordinator
    @EnvironmentObject var viewModel: OKRViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("목표 한방")
                .font(.system(size: 25, weight: .bold))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray)
                .padding(1)
            HStack {
                Text("Objective를 설정해 주세요")
                    .font(.system(size:20, weight: .bold))
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                Spacer()
            }
            Divider()
            // Objectives 카드 뷰
            ScrollView {
                ForEach(viewModel.objectives) { objective in
                    // 클릭하면 ObjectiveDetailView로 전환
                    NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id)
                        .environmentObject(self.viewModel)) {
                            ObjectiveCardView(objectiveID: objective.id)
                                .onDelete(isTask: false) {
                                    viewModel.deleteObjectiveByID(of: objective.id)
                                }
                    }
                    .foregroundColor(.black)
                }
            }
            Spacer()
            // Objective 추가 뷰
            Button {
                coordinator.show(AddObjectiveView.self)
            } label: {
                WideAddButtonView()
                    .tint(.black)
            }
            .navigationDestination(for: String.self) { id in
                if id == String(describing: AddObjectiveView.self) {
                    AddObjectiveView()
                        .environmentObject(self.viewModel)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(coordinator: Coordinator())
            .environmentObject(OKRViewModel())
    }
}
