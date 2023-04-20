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
    @State private var isObjectiveCompleted = false
    @State private var isObjectiveOutdated = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                mainTitle()
                showObjectives()
            }
            
            if isObjectiveOutdated {
                CustomAlert(alertState: .outdatedObjective, objectiveID: "", isShowingAlert: $isObjectiveOutdated, isSaveButtonTapped: .constant(false), isObjectiveCompleted: .constant(false))
            }
            else if isShowingObjectiveDeleteAlert {
                CustomAlert(alertState: .deletingObjective, objectiveID: viewModel.deletingObjectiveID, isShowingAlert: $isShowingObjectiveDeleteAlert, isSaveButtonTapped: .constant(false), isObjectiveCompleted: .constant(false))
            } else if isObjectiveCompleted {
                CustomAlert(alertState: .completedObjective, objectiveID: "", isShowingAlert: $isObjectiveCompleted, isSaveButtonTapped: .constant(false), isObjectiveCompleted: .constant(false))
            }
        }
        .onAppear {
            isShowingCompletedObjectives = false
            viewModel.keyResultState = .beforeStart
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
                // 완료되었거나 기한이 지난 objectives 보여주기
                if isShowingCompletedObjectives {
                    ForEach(viewModel.objectives.filter{ $0.isCompleted == true || $0.isOutdated == true }) { objective in
                        // 클릭하면 ObjectiveDetailView로 전환
                        NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id, isObjectiveCompleted: $isObjectiveCompleted)
                            .environmentObject(self.viewModel)) {
                                ObjectiveCardView(objectiveID: objective.id, isShowingObjectiveDeleteAlert: $isShowingObjectiveDeleteAlert)
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            // 보관된 objectives는 인터랙션 불가
                            .allowsHitTesting(false)
                            
                    }
                } else {
                    // 완료하지 않았고 D-day가 지나지 않은 objectives 보여주기
                    ForEach(viewModel.objectives.filter{ $0.isCompleted == false && $0.isOutdated == false }) { objective in
                        // 클릭하면 ObjectiveDetailView로 전환
                        NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id, isObjectiveCompleted: $isObjectiveCompleted)
                            .environmentObject(self.viewModel)) {
                                ObjectiveCardView(objectiveID: objective.id, isShowingObjectiveDeleteAlert: $isShowingObjectiveDeleteAlert)
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                if viewModel.isOutDated(endDate: objective.endDate) {
                                    // 카드 보여질 때 마다 outdated 검사
                                    if let objectiveIndex = viewModel.objectives.firstIndex(where: { $0.id == objective.id }) {
                                        viewModel.objectives[objectiveIndex].isOutdated = true
                                        viewModel.saveObjectivesToUserDefaults()
                                    }
                                    isObjectiveOutdated = true
                                    dump(objective)
                                }
                            }
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
