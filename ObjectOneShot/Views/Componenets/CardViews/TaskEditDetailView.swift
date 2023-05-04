//
//  TaskEditDetailView.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/30.
//

import SwiftUI

struct TaskEditDetailView: View {
    @EnvironmentObject var viewModel: OKRViewModel
    
    let task: Task
    let keyResultIndex: Int
    var isShowingCompletedObjective: Bool
    
    @State private var isCompleted = false
    @State private var title = ""
    @State private var isFocused = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                checkBox()
                    .padding(.trailing, 11)
                    .padding(.top, 2)
                    .padding(.bottom, 12)
                taskTitle()
                    .padding(.top, 2)
                    .padding(.bottom, 12)
                // 제목 수정중이고 task 2개 이상이면 x 표시하기
                if isFocused {
                    if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count > 1 {
                        showXMarkButton()
                            .padding(.bottom, 6)
                    }
                } else {
                // task가 5개 미만이고 제목 수정중이지 않고 마지막 task이면 + 표시하기
                    if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count < 5 {
                        if viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) == viewModel.currentObjective.keyResults[keyResultIndex].tasks.count - 1 {
                            showPlusButton()
                                .padding(.bottom, 6)
                        }
                    }
                }
            }
            .padding(.leading, 19)
            .padding(.trailing, 6)
            underLine()
                .padding(.horizontal, 8)
        }
        .background(Color("grey_50"))
        .onAppear {
            if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                self.title = viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title
                self.isCompleted = viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted
            } else {
                print("ERROR : no matching task found by taskID: TaskDetailView.swift")
            }
        }
    }
    
    // 태스크 체크박스
    @ViewBuilder
    func checkBox() -> some View {
        Button {
            endTextEditing()
            // 제목이 비어있지 않다면 isCompleted 상태 변경
            if !title.isEmpty {
                isCompleted.toggle()
            }
        } label: {
            if let task = viewModel.currentObjective.keyResults[keyResultIndex].tasks.first(where: { $0.id == task.id }) {
                if task.isCompleted {
                    Image("checkMark.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                } else {
                    Image("square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                }
            }
        }
        .disabled(isShowingCompletedObjective)
        .onChange(of: isCompleted) { newValue in
            if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted = isCompleted
            }
            // key result 프로그레스도 반영
            viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
            viewModel.currentObjective.setProgress()
        }
    }
    
    // 태스크 제목
    @ViewBuilder
    func taskTitle() -> some View {
        ZStack {
            TextField("", text: $title, onEditingChanged: { editing in
                if editing {
                    isFocused = true
                } else {
                    isFocused = false
                    if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title = self.title
                        print(viewModel.currentObjective.keyResults[keyResultIndex])
                    } else {
                        print("ERROR : no matching task found by taskID: TaskDetailView.swift")
                    }
                }
            })
            .disabled(isCompleted || isShowingCompletedObjective)
            .font(.pretendard(.medium, size: 16))
            .strikethrough(isCompleted)
            .foregroundColor(Color("grey_900"))
            .background {
                // 플레이스홀더
                if title.isEmpty {
                    HStack {
                        Text("내용을 입력해주세요")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundColor(Color("grey_500"))
                        Spacer()
                    }
                }
            }
            .onReceive(title.publisher.collect()) {
                if $0.count > Constants.characterLengthLimit {
                    self.title = String($0.prefix(Constants.characterLengthLimit))
                }
            }
        }
    }
    
    // x버튼
    @ViewBuilder
    func showXMarkButton() -> some View {
        Button {
            // x 터치하면 task 삭제 및 key Result progress 업데이트
            endTextEditing()
            viewModel.deleteTaskWhenTappedXmark(keyResultIndex: keyResultIndex, taskID: task.id)
            viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
            viewModel.currentObjective.setProgress()
        } label: {
            Image("xMark")
                .renderingMode(.template)
                .frame(width: 28, height: 28)
                .foregroundColor(Color("grey_900"))
        }
    }
    
    // +버튼
    @ViewBuilder
    func showPlusButton() -> some View {
        Button {
            // 빈 task 추가
            // 여기서 로직 잘 짜야겠다....
            endTextEditing()
            viewModel.currentObjective.keyResults[keyResultIndex].tasks.append(Task(title: ""))
            dump(viewModel.currentObjective.keyResults[keyResultIndex])
        } label: {
            Image("plus")
                .renderingMode(.template)
                .frame(width: 28, height: 28)
                .foregroundColor(Color("grey_900"))
        }
        .disabled(isShowingCompletedObjective)
    }
    
    // 언더라인
    @ViewBuilder
    func underLine() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_900"))
    }
}

struct TaskEditDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditDetailView(task: Task.dummy, keyResultIndex: 0, isShowingCompletedObjective: false)
            .environmentObject(OKRViewModel())
    }
}
