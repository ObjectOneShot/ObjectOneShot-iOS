//
//  WideAddButtonView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

struct WideAddButtonView: View {
    var body: some View {
        Image(systemName: "plus")
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
}

struct WideAddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        WideAddButtonView()
    }
}
