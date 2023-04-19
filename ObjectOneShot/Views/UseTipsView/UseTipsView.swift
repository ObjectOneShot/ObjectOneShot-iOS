//
//  UseTips.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/15.
//

import SwiftUI

struct UseTipsView: View {
    @State private var currentIndex = 0
    @Binding var isPresenting: Bool
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex){
                firstTip()
                    .tag(0)
                secondTip()
                    .tag(1)
                thirdTip()
                    .tag(2)
                fourthTip()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            VStack {
                HStack(spacing: 16) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .if(currentIndex == 0) {
                            $0.foregroundColor(Color("primaryColor"))
                        }
                        .if(currentIndex != 0) {
                            $0.foregroundColor(Color("grey_200"))
                        }
                    Circle()
                        .frame(width: 10, height: 10)
                        .if(currentIndex == 1) {
                            $0.foregroundColor(Color("primaryColor"))
                        }
                        .if(currentIndex != 1) {
                            $0.foregroundColor(Color("grey_200"))
                        }
                    Circle()
                        .frame(width: 10, height: 10)
                        .if(currentIndex == 2) {
                            $0.foregroundColor(Color("primaryColor"))
                        }
                        .if(currentIndex != 2) {
                            $0.foregroundColor(Color("grey_200"))
                        }
                    Circle()
                        .frame(width: 10, height: 10)
                        .if(currentIndex == 3) {
                            $0.foregroundColor(Color("primaryColor"))
                        }
                        .if(currentIndex != 3) {
                            $0.foregroundColor(Color("grey_200"))
                        }
                }
                .padding(.top, 29)
                Spacer()
            }
            VStack {
                Spacer()
                if currentIndex != 4 {
                    Button {
                        isPresenting = false
                    } label: {
                        Image("onboarding.skip")
                            .padding(.bottom, 14)
                    }
                } else {
                    Button {
                        isPresenting = false
                    } label: {
                        Text("목표 달성하기")
                            .font(.pretendard(.bold, size: 20))
                            .foregroundColor(Color("titleForeground"))
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color("titleBackground"))
                    .padding(.bottom, 1)
                }
            }
        }
        .background(Color("background"))
    }
    
    @ViewBuilder
    func firstTip() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Image("tips.first.description")
                    .padding(.top, 85)
                Image("tips.first")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 41)
            }
            VStack {
                HStack {
                    Image("tips.logo")
                        .padding(.leading, 27)
                        .padding(.top, 45)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func secondTip() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Image("tips.second.description")
                    .padding(.top, 85)
                Image("tips.second")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 41)
                    .shadow(radius: 1)
            }
            VStack {
                HStack {
                    Image("tips.logo")
                        .padding(.leading, 27)
                        .padding(.top, 45)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func thirdTip() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Image("tips.third.description")
                    .padding(.top, 85)
                Image("tips.third")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 41)
            }
            VStack {
                HStack {
                    Image("tips.logo")
                        .padding(.leading, 27)
                        .padding(.top, 45)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func fourthTip() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Image("tips.fourth.description")
                    .padding(.top, 85)
                Image("tips.fourth.caution")
                    .padding(.top, 16)
                Image("tips.fourth")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 11)
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                Image("tips.archive")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 107, height: 107)
                            }
                            .padding(.top, 25)
                            Spacer()
                        }
                    }
            }
            VStack {
                HStack {
                    Image("tips.logo")
                        .padding(.leading, 27)
                        .padding(.top, 45)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct UseTipsView_Previews: PreviewProvider {
    static var previews: some View {
        UseTipsView(isPresenting: .constant(true))
    }
}
