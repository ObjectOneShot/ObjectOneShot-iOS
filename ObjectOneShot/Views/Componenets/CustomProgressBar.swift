//
//  CustomProgressView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/14.
//

import SwiftUI


struct CustomProgressBar: View {
    @Binding var value: Double
    var backgroundColor: Color
    @Binding var isOutdated: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(backgroundColor)
                
                if !isOutdated {
                    Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .if(value <= 0.33) { view in
                            view
                                .foregroundColor(Color("point_1"))
                        }
                        .if(value > 0.33 && value <= 0.66) { view in
                            view
                                .foregroundColor(Color("point_2"))
                        }
                        .if(value > 0.66) { view in
                            view
                                .foregroundColor(Color("point_3"))
                        }
                        .animation(.linear, value: value)
                } else {
                    Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor(Color("grey_400"))
                        .animation(.linear, value: value)
                }
            }
            .cornerRadius(45.0)
        }
    }
}

struct CustomProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressBar(value: .constant(0.3), backgroundColor: Color("grey_200"), isOutdated: .constant(false))
    }
}
