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
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @State private var isPresentingTips: Bool = false
    @State private var isShowingCompletedObjectives = false
    @State private var isShowingObjectiveDeleteAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                mainTitle()
                showObjectives()
            }
            
            if isShowingObjectiveDeleteAlert {
                CustomAlert(alertState: .deletingObjective, objectiveID: viewModel.deletingObjectiveID, isShowingObjectiveDeleteAlert: $isShowingObjectiveDeleteAlert)
            }
        }
    }
    
    @ViewBuilder
    func mainTitle() -> some View {
        HStack {
            Spacer()
            Image("mainTitle")
                .padding(.vertical, 12)
            Spacer()
        }
        .background(Color("titleBackground"))
        .padding(.top, 1)
        .overlay {
            HStack {
                if isShowingCompletedObjectives {
                    Button {
                      isShowingCompletedObjectives = false
                    } label: {
                        Image("chevron.left.white")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                    }
                    .padding(.leading, 25)
                }
                Spacer()
                Button {
                    isPresentingTips = true
                } label: {
                    Image("questionMark_white")
                }
                .padding(.trailing, 25)
            }
        }
    }
    
    @ViewBuilder
    func showObjectives() -> some View {
        HStack {
            if isShowingCompletedObjectives {
                Text("보관된 목표를 확인해주세요")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundColor(Color("grey_900"))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            } else {
                Text("Objective를 설정해 주세요")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundColor(Color("grey_900"))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            Spacer()
            if !isShowingCompletedObjectives {
                Button {
                    isShowingCompletedObjectives = true
                } label: {
                    Image("cloud_download")
                        .frame(width: 24, height: 16)
                        .padding(.horizontal, 24)
                }
            }
        }
        Divider()
            .foregroundColor(Color("grey_300"))
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
        // Objectives 카드 뷰
        ScrollView {
            VStack(spacing: 0) {
                // 완료된 objectives 보여주기
                if isShowingCompletedObjectives {
                    ForEach(viewModel.objectives.filter{ $0.progressValue == 1}) { objective in
                        // 클릭하면 ObjectiveDetailView로 전환
                        NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id)
                            .environmentObject(self.viewModel)) {
                                ObjectiveCardView(objectiveID: objective.id, isShowingObjectiveDeleteAlert: $isShowingObjectiveDeleteAlert)
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                    }
                } else {
                    // 완료하지 않은 objectives 보여주기
                    ForEach(viewModel.objectives.filter{ $0.progressValue != 1 }) { objective in
                        // 클릭하면 ObjectiveDetailView로 전환
                        NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id)
                            .environmentObject(self.viewModel)) {
                                ObjectiveCardView(objectiveID: objective.id, isShowingObjectiveDeleteAlert: $isShowingObjectiveDeleteAlert)
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        Spacer()
        // Objective 추가 뷰
        Button {
            coordinator.show(AddObjectiveView.self)
        } label: {
            Image("mainButton_add")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal, 16)
        .navigationDestination(for: String.self) { id in
            if id == String(describing: AddObjectiveView.self) {
                AddObjectiveView()
                    .environmentObject(self.viewModel)
            }
        }
        .background(Color("background"))
        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingView(isFirstLaunching: $isFirstLaunching)
        }
        .fullScreenCover(isPresented: $isPresentingTips) {
            UseTipsView(isPresenting: $isPresentingTips)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(coordinator: Coordinator())
            .environmentObject(OKRViewModel())
    }
}
