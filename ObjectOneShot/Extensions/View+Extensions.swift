//
//  View+Extensions.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/08.
//

import SwiftUI

extension View {
    
    // 텍스트 입력 중 다른 곳을 터치하면 키보드가 내려가도록 하는 함수
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func onDelete(isTask: Bool, perform action: @escaping () -> Void) -> some View {
        self.modifier(Delete(isTask: isTask, action: action))
    }
    
    func sync(_ published: Binding<[KeyResult]>, with binding: Binding<[KeyResult]>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
