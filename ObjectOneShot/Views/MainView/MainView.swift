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
            ScrollView {
                ForEach(viewModel.objectives) { objective in
                    NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id)
                        .environmentObject(OKRViewModel.shared)) {
                            ObjectiveCardView(objectiveID: objective.id)
                                .onDelete(isTask: false) {
                                    viewModel.deleteObjectiveByID(of: objective.id)
                                }
                    }
                    .foregroundColor(.black)
                }
            }
            Spacer()
            Button {
                coordinator.show(AddObjective.self)
            } label: {
                WideAddButtonView()
                    .tint(.black)
            }
            .navigationDestination(for: String.self) { id in
                if id == String(describing: AddObjective.self) {
                    AddObjective()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(coordinator: Coordinator())
            .environmentObject(OKRViewModel.shared)
    }
}
