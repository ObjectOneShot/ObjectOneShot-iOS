//
//  KeyResultsHeaderView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct KeyResultsHeaderView: View {
    
    @EnvironmentObject var viewModel: OKRViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Key Results 설정해 주세요")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundColor(Color("title_black"))
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 9, trailing: 0))
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("grey_300"))
                .padding(.horizontal, 16)
            HStack {
                Spacer()
                Button {
                    viewModel.keyResultState = .all
                    setIsExpandedToFalse()
                } label : {
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .if(viewModel.keyResultState == .all) { view in
                                view
                                    .foregroundColor(Color("point_1"))
                            }
                            .if(viewModel.keyResultState != .all) { view in
                                view
                                    .foregroundColor(.white)
                            }
                        Text("전체")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundColor(Color("grey_900"))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 19)
                    .background(Color("grey_200"))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                }
                Spacer()
                Button {
                    viewModel.keyResultState = .inProgress
                    setIsExpandedToFalse()
                } label: {
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .if(viewModel.keyResultState == .inProgress) { view in
                                view
                                    .foregroundColor(Color("point_2"))
                            }
                            .if(viewModel.keyResultState != .inProgress) { view in
                                view
                                    .foregroundColor(.white)
                            }
                        Text("진행")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundColor(Color("grey_900"))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 19)
                    .background(Color("grey_200"))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                Spacer()
                Button {
                    viewModel.keyResultState = .completed
                    setIsExpandedToFalse()
                } label: {
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .if(viewModel.keyResultState == .completed) { view in
                                view
                                    .foregroundColor(Color("point_3"))
                            }
                            .if(viewModel.keyResultState != .completed) { view in
                                view
                                    .foregroundColor(.white)
                            }
                        Text("완료")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundColor(Color("grey_900"))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 19)
                    .background(Color("grey_200"))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                Spacer()
            }
            .padding(.vertical, 9)
        }
    }
    
    func setIsExpandedToFalse() {
        for i in 0..<viewModel.currentObjective.keyResults.count {
            viewModel.currentObjective.keyResults[i].isExpanded = false
        }
    }
}

struct KeyResultsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultsHeaderView()
            .environmentObject(OKRViewModel())
    }
}
