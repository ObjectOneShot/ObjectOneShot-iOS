//
//  CustomAlert.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/17.
//

import SwiftUI

enum AlertState {
    case deletingObjective
    case savingChanges
}

struct CustomAlert: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    let alertState: AlertState
    let objectiveID: String
    
    @Binding var isShowingAlert: Bool
    @Binding var isSaveButtonTapped: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            
            // objective 삭제의 경우
            if alertState == .deletingObjective {
                Image("alert.deleteObjective")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 140)
                    .overlay {
                        VStack {
                            Spacer()
                            HStack(spacing: 16) {
                                Button {
                                    // 취소하기
                                    isShowingAlert = false
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 102, height: 36)
                                        .opacity(0)
                                }
                                
                                Button {
                                    // 삭제하기
                                    viewModel.deleteObjectiveByID(of: objectiveID)
                                    isShowingAlert = false
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 102, height: 36)
                                        .opacity(0)
                                }
                            }
                            Spacer()
                                .frame(height: 20.71)
                        }
                    }
            }
            
            if alertState == .savingChanges {
                Image("alert.saveObjective")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 278, height: 122)
                    .overlay {
                        VStack {
                            Spacer()
                            HStack(spacing: 16) {
                                Button {
                                    // 취소하기
                                    isShowingAlert = false
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 102, height: 36)
                                        .opacity(0)
                                }
                                
                                Button {
                                    // 저장하기
                                    isSaveButtonTapped = true
                                    viewModel.objectives[viewModel.objectives.firstIndex(where: { $0.id == objectiveID })!] = viewModel.currentObjective
                                    viewModel.saveObjectivesToUserDefaults()
                                    isShowingAlert = false
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 102, height: 36)
                                        .opacity(0)
                                }
                            }
                            Spacer()
                                .frame(height: 24)
                        }
                    }
            }
        }
    }
}

//struct CustomAlert_Previews: PreviewProvider {
////    static var previews: some View {
////        CustomAlert(alertState: .deletingObjective, objectiveID: Objective.dummy.id, isShowingAlert: .constant(true), presentationdMode: .constant(false))
////    }
//}
