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
        VStack {
            HStack {
                Text("Key Results 설정하기")
                    .font(.system(size:20, weight: .bold))
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            HStack {
                Button {
                    viewModel.keyResultState = .beforeStart
                } label : {
                    Text("진행전")
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .tint(.black)
                }
                Button {
                    viewModel.keyResultState = .inProgress
                } label: {
                    Text("진행중")
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .tint(.white)
                }
                Button {
                    viewModel.keyResultState = .completed
                } label: {
                    Text("완료")
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .tint(.black)
                }
            }
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(.gray)
        }
    }
}

struct KeyResultsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        KeyResultsHeaderView()
    }
}
