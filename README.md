# **목표한방 - OKR 기반 목표 관리 앱**

## 앱스토어 링크

[<img src="https://user-images.githubusercontent.com/22342277/230514542-e8c39751-7a96-4ffd-9175-91b24feb8849.png" height=50>](https://apps.apple.com/us/app/목표한방-okr-기반-관리-앱/id6447925542?ign-itscg=30200&ign-itsct=apps_box_link)

## 주요 기능

| 온보딩 | 목표 등록 | 목표 삭제 |
| - | - | - |
| <img src="https://github.com/ObjectOneShot/iOS-ObjectOneShot/assets/22342277/7a191f75-0272-49e7-a4df-9736dbe44271" width="300"> | <img src="https://github.com/ObjectOneShot/iOS-ObjectOneShot/assets/22342277/6b619967-e623-4b50-af3d-d2b6f5fc7d3d" width="300"> | <img src="https://github.com/ObjectOneShot/iOS-ObjectOneShot/assets/22342277/997a06b4-cbd6-4732-bf16-badfc8234663" width="300"> |

</br>

## **프로젝트 소개**

스프린터 해커톤 과정에서 나온 아이디어를 기반으로 시작한 OKR 기반 목표 관리 앱 프로젝트 입니다.  
장기 목표를 세우고, 세부 계획과 할 일을 기록하고 달성할 수 있습니다.  
프로그레스 바를 통한 달성률의 시각적인 확인이 가능합니다.

## **개발 환경 및 라이브러리**

* Xcode 14
* SwiftUI

## **폴더 구조**

```
📦ObjectOneShot
 ┣ 📂Apps
 ┃ ┣ 📜Launch Screen.storyboard
 ┃ ┗ 📜ObjectOneShotApp.swift
 ┣ 📂Extensions
 ┃ ┣ 📂Modifiers
 ┃ ┃ ┣ 📜Delete.swift
 ┃ ┃ ┗ 📜ShakeEffect.swift
 ┃ ┗ 📜View+Extensions.swift
 ┣ 📂Models
 ┃ ┣ 📜KeyResult.swift
 ┃ ┣ 📜Objective.swift
 ┃ ┗ 📜Task.swift
 ┣ 📂Preview Content
 ┃ ┗ 📂Preview Assets.xcassets
 ┃ ┃ ┗ 📜Contents.json
 ┣ 📂Resources
 ┣ 📂Utilities
 ┃ ┣ 📂ObjectOneShot.xcdatamodeld
 ┃ ┃ ┣ 📂ObjectOneShot.xcdatamodel
 ┃ ┃ ┃ ┗ 📜contents
 ┃ ┃ ┗ 📜.xccurrentversion
 ┃ ┣ 📜Constants.swift
 ┃ ┣ 📜Coordinator.swift
 ┃ ┣ 📜EmptyButtonStyle.swift
 ┃ ┗ 📜RoundedCorner.swift
 ┣ 📂ViewModels
 ┃ ┗ 📜OKRViewModel.swift
 ┣ 📂Views
 ┃ ┣ 📂AddObjectiveView
 ┃ ┃ ┗ 📜AddObjectiveEditView.swift
 ┃ ┣ 📂Componenets
 ┃ ┃ ┣ 📂CardViews
 ┃ ┃ ┃ ┣ 📜KeyResultEditDetailView.swift
 ┃ ┃ ┃ ┣ 📜ObjectiveCardView.swift
 ┃ ┃ ┃ ┣ 📜ObjectiveDetailCard.swift
 ┃ ┃ ┃ ┗ 📜TaskEditDetailView.swift
 ┃ ┃ ┣ 📂CustomAlert
 ┃ ┃ ┃ ┗ 📜CustomAlert.swift
 ┃ ┃ ┗ 📂CustomProgressbar
 ┃ ┃ ┃ ┗ 📜CustomProgressBar.swift
 ┃ ┣ 📂MainView
 ┃ ┃ ┗ 📜MainView.swift
 ┃ ┣ 📂ObjectiveDetailView
 ┃ ┃ ┗ 📜ObjectiveEditDetailView.swift
 ┃ ┣ 📂Onboarding
 ┃ ┃ ┗ 📜OnboardingView.swift
 ┃ ┣ 📂UsageTipsView
 ┃ ┃ ┗ 📜UsageTipsView.swift
 ┃ ┗ 📜.DS_Store
 ┣ 📜GoogleService-Info.plist
 ┗ 📜Info.plist
```

## **Commit Convention**

커밋 컨벤션은 Udacity Git Commit Message Style Guide 를 따릅니다.

* feat: A new feature
* fix: A bug fix
* docs: Changes to documentation
* style: Formatting, missing semi colons, etc; no code change
* refactor: Refactoring production code
* test: Adding tests, refactoring test; no production code change
* chore: Updating build tasks, package manager configs, etc; no production code change
