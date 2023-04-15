//
//  OnboardingView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/15.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    @Binding var isFirstLaunching: Bool
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex){
                firstOnboarding()
                    .tag(0)
                secondOnboarding()
                    .tag(1)
                thirdOnboarding()
                    .tag(2)
                fourthOnboarding()
                    .tag(3)
                fifthOnboarding()
                    .tag(4)
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
                    Circle()
                        .frame(width: 10, height: 10)
                        .if(currentIndex == 4) {
                            $0.foregroundColor(Color("primaryColor"))
                        }
                        .if(currentIndex != 4) {
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
                        isFirstLaunching = false
                    } label: {
                        Image("onboarding.skip")
                            .padding(.bottom, 14)
                    }
                } else {
                    Button {
                        isFirstLaunching = false
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
    }
    
    @ViewBuilder
    func firstOnboarding() -> some View {
        VStack(spacing: 0) {
            Image("onboarding.first.description")
                .padding(.top, 85)
            Image("onboarding.first")
                .resizable()
                .scaledToFit()
                .padding(.top, 41)
        }
    }
    
    @ViewBuilder
    func secondOnboarding() -> some View {
        VStack(spacing: 0) {
            Image("onboarding.second.description")
                .padding(.top, 85)
            Image("onboarding.second")
                .resizable()
                .scaledToFit()
                .padding(.top, 41)
                .shadow(radius: 1)
        }
    }
    
    @ViewBuilder
    func thirdOnboarding() -> some View {
        VStack(spacing: 0) {
            Image("onboarding.third.description")
                .padding(.top, 85)
            Image("onboarding.third")
                .resizable()
                .scaledToFit()
                .padding(.top, 41)
        }
    }
    
    @ViewBuilder
    func fourthOnboarding() -> some View {
        VStack(spacing: 0) {
            Image("onboarding.fourth.description")
                .padding(.top, 85)
            Image("onboarding.fourth")
                .resizable()
                .scaledToFit()
                .padding(.top, 41)
        }
    }
    
    @ViewBuilder
    func fifthOnboarding() -> some View {
        VStack(spacing: 0) {
            Image("onboarding.fifth.description")
                .padding(.top, 85)
            Image("onboarding.fifth")
                .resizable()
                .scaledToFit()
                .padding(.top, 41)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isFirstLaunching: .constant(true))
    }
}
