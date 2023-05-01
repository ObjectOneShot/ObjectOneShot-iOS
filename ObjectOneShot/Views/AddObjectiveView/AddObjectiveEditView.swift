//
//  AddObjectiveEditView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/05/01.
//

import SwiftUI

struct AddObjectiveEditView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    @State private var isPresentingTips = false
    @State private var isPresentingSaveAlert = false
    @State private var isSaveButtonTapped = false
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var progressValue: Double = 0.0
    @State private var progressPercentage: Int = 0
    
    var isShowingCompletedObjective: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                objectiveDetailHeader()
                ScrollView {
                    objectiveDetailCard()
                        .padding(.top, 8)
                    keyResultHeader()
                    VStack(spacing: 0) {
                        keyResultDetails()
                        // 완료된 objective detail을 보는 것이 아니라면
                        if !isShowingCompletedObjective {
                            // key result 추가 버튼 보이기
                            keyResultAddButton()
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal, 16)
                    .background {
                        Color("primary_10")
                    }
                }
                Spacer()
                    .frame(height: 45)
                    .padding(.bottom, 1)
            }
            VStack {
                Spacer()
                addObjectiveButton()
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            viewModel.currentObjective = Objective(title: "", startDate: Date(), endDate: Date(), keyResults: [KeyResult(title: "", completionState: .inProgress, tasks: [Task(title: "")])])
            viewModel.keyResultState = .all
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .background {
            Color("background")
        }
        .fullScreenCover(isPresented: $isPresentingTips) {
            UsageTipsView(isPresenting: $isPresentingTips)
        }
        .navigationBarHidden(true)
    }
    
    // objective 헤더
    @ViewBuilder
    func objectiveDetailHeader() -> some View {
        HStack(spacing: 0) {
            backButton()
                .padding(.trailing, 16)
            Text("Objective를 설정해 주세요")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("title_black"))
                .padding(.vertical, 12)
            Spacer()
            Button {
                endTextEditing()
                isPresentingTips = true
            } label: {
                Image("questionMark.black")
            }
            .padding(.trailing, 26)
        }
        .padding(.leading, 18)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_300"))
            .padding(.horizontal, 16)
    }
    
    // 뒤로가기 버튼
    @ViewBuilder
    func backButton() -> some View {
        Button {
            endTextEditing()
            self.presentationMode.wrappedValue.dismiss()
        } label : {
            HStack{
                Image("chevron.left.black")
                    .frame(width: 20, height: 20)
            }
        }
        .onChange(of: isSaveButtonTapped) { newValue in
            if newValue {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    // objective 디테일 카드 뷰
    @ViewBuilder
    func objectiveDetailCard() -> some View {
        VStack(spacing: 8){
            HStack(alignment: .center) {
                Text("목표")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                VStack(alignment: .center, spacing: 0) {
                    TextField("", text: $title, prompt: Text("목표를 입력해주세요").font(.pretendard(.regular, size: 14)).foregroundColor(Color("grey_500")))
                        .disabled(isShowingCompletedObjective)
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color("grey_900"))
                        .frame(height: 29)
                        .padding(.top, 7)
                        .padding(.horizontal, 12)
                        .onChange(of: title) { _ in
                            viewModel.currentObjective.title = title
                        }
                        .onReceive(title.publisher.collect()) {
                            if $0.count > Constants.characterLengthLimit {
                                self.title = String($0.prefix(Constants.characterLengthLimit))
                            }
                        }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("grey_900"))
                        .padding(.bottom, 8)
                        .padding(.horizontal, 12)
                }
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
            }
            HStack(alignment: .center) {
                Text("기간")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .disabled(isShowingCompletedObjective)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko-KR"))
                        .scaleEffect(0.9)
                        .onChange(of: startDate) { _ in
                            viewModel.currentObjective.startDate = startDate
                        }
                    Text("~")
                        .font(.pretendard(.regular, size: 14))
                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .disabled(isShowingCompletedObjective)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko-KR"))
                        .scaleEffect(0.9)
                        .onChange(of: endDate) { newValue in
                            viewModel.currentObjective.endDate = endDate
                        }
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
                
            }
            HStack {
                Text("달성")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("grey_900"))
                    .frame(width: 64, height: 44)
                    .background(Color("grey_50"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("grey_300"))
                    )
                HStack {
                    CustomProgressBar(value: $progressValue, backgroundColor: Color("grey_300"), isOutdated: .constant(false))
                        .padding(.vertical, 12)
                        .onChange(of: viewModel.currentObjective.progressValue) { newValue in
                            progressValue = viewModel.currentObjective.progressValue
                        }
                    Text("\(progressPercentage)%")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundColor(Color("title_black"))
                        .padding(.vertical, 12)
                        .onChange(of: viewModel.currentObjective.progressPercentage) { newValue in
                            progressPercentage = viewModel.currentObjective.progressPercentage
                        }
                }
                .padding(.horizontal, 10)
                .frame(height: 44)
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("grey_300"))
                )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8.5)
        .background(Color("grey_100"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
    
    // key result 헤더 뷰
    @ViewBuilder
    func keyResultHeader() -> some View {
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
                    endTextEditing()
                    viewModel.keyResultState = .all
                    for i in 0..<viewModel.currentObjective.keyResults.count {
                        viewModel.currentObjective.keyResults[i].isExpanded = false
                    }
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
                    endTextEditing()
                    viewModel.keyResultState = .inProgress
                    for i in 0..<viewModel.currentObjective.keyResults.count {
                        viewModel.currentObjective.keyResults[i].isExpanded = false
                    }
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
                    endTextEditing()
                    viewModel.keyResultState = .completed
                    for i in 0..<viewModel.currentObjective.keyResults.count {
                        viewModel.currentObjective.keyResults[i].isExpanded = false
                    }
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
    
    // currnet objectie의 key results 보이기
    @ViewBuilder
    func keyResultDetails() -> some View {
        switch viewModel.keyResultState {
        case .all:
            if !viewModel.currentObjective.keyResults.isEmpty {
                ForEach(viewModel.currentObjective.keyResults, id: \.self) { keyResult in
                    KeyResultEditDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjective)
                        .padding(.top, 10)
                }
            } else if isShowingCompletedObjective {
                Color("primary_10")
            }
        case .inProgress:
            if !viewModel.currentObjective.keyResults.filter({ $0.completionState == .inProgress }).isEmpty {
                ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .inProgress }, id: \.self) { keyResult in
                    KeyResultEditDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjective)
                        .padding(.top, 10)
                }
            } else if isShowingCompletedObjective {
                Color("primary_10")
            }
        case .completed:
            if !viewModel.currentObjective.keyResults.filter({ $0.completionState == .completed }).isEmpty {
                ForEach(viewModel.currentObjective.keyResults.filter { $0.completionState == .completed }, id: \.self) { keyResult in
                    KeyResultEditDetailView(keyResultID: keyResult.id, isShowingCompletedObjective: isShowingCompletedObjective)
                        .padding(.top, 10)
                }
            } else if isShowingCompletedObjective {
                Color("primary_10")
            }
        }
    }
    
    @ViewBuilder
    func keyResultAddButton() -> some View {
        Button {
            endTextEditing()
            viewModel.currentObjective.keyResults.append(KeyResult(isExpanded: true, title: "", completionState: .inProgress, tasks: [Task(title: "")]))
        } label: {
            Text("Key Result 추가")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(Color("titleForeground"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("primaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    func addObjectiveButton() -> some View {
        Button {
            endTextEditing()
            // 목표 제목 작성했으면 목표 등록하기
            if !viewModel.currentObjective.title.isEmpty  {
                viewModel.addNewObjective(viewModel.currentObjective)
                self.presentationMode.wrappedValue.dismiss()
                viewModel.saveObjectivesToUserDefaults()
            }
        } label: {
            Text("목표 등록하기")
                .font(.pretendard(.bold, size: 20))
                .foregroundColor(Color("titleForeground"))
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .if(viewModel.currentObjective.title.isEmpty) { view in
            view
                .background(Color("titleBackground_40"))
        }
        .if(!viewModel.currentObjective.title.isEmpty) { view in
            view
                .background(Color("titleBackground"))
        }
        .padding(.bottom, 1)
    }
}

struct AddObjectiveEditView_Previews: PreviewProvider {
    static var previews: some View {
        AddObjectiveEditView()
            .environmentObject(OKRViewModel())
    }
}
