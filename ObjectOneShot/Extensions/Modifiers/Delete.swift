//
//  Delete.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/11.
//

import SwiftUI

struct Delete: ViewModifier {
    
    let isTask: Bool
    let action: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var startPos: CGPoint = .zero
    @State var isSwipping = true
    @State var contentWidth: CGFloat = UIScreen.main.bounds.width

    func body(content: Content) -> some View {
        if !isTask {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("red_error"))
                    .padding(.leading, 50)
                    .overlay {
                        HStack {
                            Spacer()
                            Button {
                                delete()
                            } label: {
                                Image("deleteButton")
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                content
                    .offset(x: offset.width)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            if self.isSwipping {
                                self.startPos = gesture.location
                                self.isSwipping.toggle()
                            }
                        }
                        .onEnded { gesture in
                            let xDist =  abs(gesture.location.x - self.startPos.x)
                            let yDist =  abs(gesture.location.y - self.startPos.y)
                            // left swipe
                            if self.startPos.x > gesture.location.x && yDist < xDist {
                                self.offset.width = -52
                            }
                            // right swipe
                            else if self.startPos.x < gesture.location.x && yDist < xDist {
                                self.offset = .zero
                            }
                        }
                    )
                    .animation(.spring(), value: offset)
            }
        } else {
            content
                .gesture(DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            offset.width = gesture.translation.width
                        }
                    })
        }
    }
    
    private func delete() {
        offset.width = -contentWidth
        action()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

}
