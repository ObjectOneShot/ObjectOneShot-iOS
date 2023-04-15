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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
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
                    Spacer()
                    Button {
                        isPresentingTips = true
                    } label: {
                        Image("questionMark_white")
                    }
                    .padding(.trailing, 25)
                }
            }
            
            HStack {
                Text("Objective를 설정해 주세요")
                    .font(.pretendard(.semiBold, size: 18))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                Spacer()
                Button {
                    
                } label: {
                    Image("cloud_download")
                        .frame(width: 24, height: 16)
                        .padding(.horizontal, 24)
                }
            }
            Divider()
                .foregroundColor(Color("grey_300"))
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            // Objectives 카드 뷰
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.objectives) { objective in
                        // 클릭하면 ObjectiveDetailView로 전환
                        NavigationLink(destination: ObjectiveDetailView(objectiveID: objective.id)
                            .environmentObject(self.viewModel)) {
                                ObjectiveCardView(objectiveID: objective.id)
                                    .padding(.bottom, 10)
                                    .onDelete(isTask: false) {
                                        viewModel.deleteObjectiveByID(of: objective.id)
                                        viewModel.saveObjectivesToUserDefaults()
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
        }
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
