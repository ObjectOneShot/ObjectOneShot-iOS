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
    var isShowingCompletedObjective: Bool = false
    
    @State private var isCompleted = false
    @State private var title = ""
    @State private var isFocused = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                checkBox()
                taskTitle()
                // 제목 수정중이고 task 2개 이상이면 x 표시하기
                if isFocused {
                    if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count > 1 {
                        showXMarkButton()
                    }
                } else {
                // task가 5개 미만이고 제목 수정중이지 않고 마지막 task이면 + 표시하기
                    if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count < 5 {
                        if viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) == viewModel.currentObjective.keyResults[keyResultIndex].tasks.count - 1 {
                            showPlusButton()
                        }
                    }
                }
            }
            .padding(.leading, 19)
            underLine()
        }
        .background(Color("grey_50"))
    }
    
    // 태스크 체크박스
    @ViewBuilder
    func checkBox() -> some View {
        Button {
            self.isCompleted.toggle()
            // 실제 데이터에도 반영
            if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].isCompleted = isCompleted
            }
            // key result 프로그레스도 반영
            viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
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
    }
    
    // 태스크 제목
    @ViewBuilder
    func taskTitle() -> some View {
        ZStack {
            TextField("", text: $title, onEditingChanged: { editing in
                if editing {
                    isFocused = true
                } else {
                    // 커서 아웃될 때 마다 title 저장
                    isFocused = false
                    if let index = viewModel.currentObjective.keyResults[keyResultIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                        // 만약 내용이 빈 채로 커서 아웃된다면 task가 2개 이상 남아있다면 해당 task 삭제
                        if title.isEmpty {
                            if viewModel.currentObjective.keyResults[keyResultIndex].tasks.count > 1 {
                                viewModel.currentObjective.keyResults[keyResultIndex].tasks.remove(at: index)
                            } else {
                                // 아니면 그냥 빈 내용 그대로 저장
                                viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title = self.title
                            }
                        } else {
                            // 내용 비어있지 않으면 해당하는 task에 내용 저장
                            viewModel.currentObjective.keyResults[keyResultIndex].tasks[index].title = self.title
                        }
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
            viewModel.deleteTaskWhenTappedXmark(keyResultIndex: keyResultIndex, taskID: task.id)
            viewModel.currentObjective.keyResults[keyResultIndex].setProgress()
        } label: {
            Image("xMark")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(Color("grey_900"))
        }
        .padding(.trailing, 13)
    }
    
    // +버튼
    @ViewBuilder
    func showPlusButton() -> some View {
        Button {
            // 빈 task 추가
            viewModel.currentObjective.keyResults[keyResultIndex].tasks.append(Task(title: ""))
        } label: {
            Image("plus")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(Color("grey_900"))
        }
        .disabled(isShowingCompletedObjective)
        .padding(.trailing, 13)
    }
    
    // 언더라인
    @ViewBuilder
    func underLine() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color("grey_900"))
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
    }
}

struct TaskEditDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditDetailView(task: Task.dummy, keyResultIndex: 0)
            .environmentObject(OKRViewModel())
    }
}
