//
//  MainView.swift
//  pacemaker
//
//  Created by Lanakee on 3/30/26.
//

import SwiftUI
import SwiftData
import FoundationModels

struct MainView: View {
  @Environment(\.colorScheme) var colorScheme
  @FocusState private var isFocused
  
  @State private var goal: String = ""
  
  @State private var response: GoalPlan?
  @State private var selectedGoal: GoalPlanResponse?
  
  @State private var goalLevel: Int = 0
  @State private var currentPage: Int = 0
  @State private var selectedIndex: Int = 0
  
  @State private var isLoading: Bool = false
  @State private var displayPhase: GoalDisplayPhase = .input
  
  private let client = FoundationModelClient(instruction: instruction)
  
  init() {}
  
  init(
    previewGoal: String,
    previewResponse: GoalPlan?,
    previewSelectedGoal: GoalPlanResponse? = nil,
    previewGoalLevel: Int,
    previewIsLoading: Bool = false,
    previewDisplayPhase: GoalDisplayPhase = .input
  ) {
    _goal = State(initialValue: previewGoal)
    _response = State(initialValue: previewResponse)
    _selectedGoal = State(initialValue: previewSelectedGoal)
    _goalLevel = State(initialValue: previewGoalLevel)
    _isLoading = State(initialValue: previewIsLoading)
    _displayPhase = State(initialValue: previewDisplayPhase)
  }
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if isLoading && displayPhase != .listPreview {
          Loading(message: "목표를 작은 단계로 나누고 있어요...")
        }
        
        switch displayPhase {
        case .input:
          if !isLoading {
            Spacer()
            InputField(
              icon: "arrow.up",
              isLoading: isLoading,
              generateGoals: generateGoals,
              goal: $goal,
            )
            Spacer()
          }
          
          
        case .listPreview:
          if let subgoals = response?.subgoals, !subgoals.isEmpty {
            Text("미션")
              .font(.memom)
              .foregroundStyle(.white)
            Text("목표를 이루기 위해 5단계로 쪼개봤어요")
              .padding(.bottom, 16)
            ScrollView {
              VStack(spacing: 12) {
                ForEach(subgoals, id: \.id) { subgoal in
                  GoalCard(
                    subgoal: subgoal,
                    disabled: false,
                    onTap: {selectedGoal = subgoal},
                    status: .normal
                  )
                  .padding(.horizontal, 16)
                }
              }
              .padding(.vertical, 20)
              Button {
                displayPhase = .carousel
              } label: {
                Label("다음단계로", systemImage: "arrow.right")
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 14)
              }
              .buttonStyle(.glassProminent)
              .padding(.horizontal, 16)
              .padding(.bottom, 20)
            }
          }
          
        case .carousel:
          if let subgoals = response?.subgoals,
             !subgoals.isEmpty,
             subgoals.indices.contains(goalLevel - 1) {
            Carousel(
              pageCount: subgoals.count,
              visibleEdgeSpace: 10,
              spacing: 10,
              content:  { index in
                GoalCard(
                  subgoal: subgoals[index],
                  disabled: false, // index >= goalLevel,
                  onTap:{
                    if index < goalLevel {
                    selectedGoal = subgoals[index]
                  }}
                  ,status: .normal
                )
              }, currentIndex: $currentPage)
            .padding(.top, 10)
            
            Spacer()
            
            SproutView(
              level: goalLevel,
              onTap: {
              }
            )
          }
        }
        VStack {
          
          Text(goalLevel > 0  ? goal : "")
            .bold()
            .foregroundStyle(.white)
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .center)
          
        }
        .padding(.vertical, 20)
        .background(.brown)
      }
      .background(
        LinearGradient(
          colors: [
            Color(red: 0.40, green: 0.70, blue: 0.95),
            Color(red: 0.53, green: 0.81, blue: 0.98),
            Color(red: 0.72, green: 0.90, blue: 1.0),
            Color(red: 0.88, green: 0.96, blue: 1.0)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .navigationDestination(item: $selectedGoal) { goal in
        SubGoalView(subGoal: goal, onComplete: {
          goalLevel = goal.id + 1
          currentPage = goal.id
        })
      }
    }
  }
  
  private func generateGoals() async {
    let trimmed = goal.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let result = await client.getResponse(prompt: trimmed)
    switch result {
    case .success(let plan):
      response = plan
      goalLevel = 1
      currentPage = 0
      
      withAnimation(.easeInOut(duration: 0.3)) {
        displayPhase = .listPreview
      }
      
    case .failure:
      goalLevel = 0
      displayPhase = .input
    }
  }
}

#Preview("초기 입력 상태") {
  MainView(
    
  )
}

#Preview("프리뷰 표시 상태") {
  let mockSubgoals = [
    GoalPlanResponse(
      id: 1,
      goal: "포트폴리오 주제 정하기",
      description: "어떤 프로젝트를 만들지 정한다."
    ),
    GoalPlanResponse(
      id: 2,
      goal: "기능 목록 작성하기",
      description: "핵심 기능과 우선순위를 정리한다."
    ),
    GoalPlanResponse(
      id: 3,
      goal: "첫 화면 레이아웃 만들기",
      description: "사용자가 처음 보는 메인 화면을 구현한다."
    ),
    GoalPlanResponse(
      id: 4,
      goal: "프로젝트 상세 페이지 만들기",
      description: "프로젝트 설명, 사용 기술, 결과물을 정리한다."
    ),
    GoalPlanResponse(
      id: 5,
      goal: "배포 및 점검하기",
      description: "이 문장은 길어지기 위해 설계되었습니다. 매우 긴 문장이 잘리지 않고 잘 표시될 수 있는지 확인해야 합니다. 인류는 절대 멸망하지 않습니다. "
    )
  ]
  
  let mockPlan = GoalPlan(subgoals: mockSubgoals)
  return MainView(
    previewGoal: "포트폴리오 만들기",
    previewResponse: mockPlan,
    previewGoalLevel: 1,
    previewDisplayPhase: .listPreview
  )
}


#Preview("캐러셀 표시 상태") {
  let mockSubgoals = [
    GoalPlanResponse(
      id: 1,
      goal: "포트폴리오 주제 정하기",
      description: "어떤 프로젝트를 만들지 정한다."
    ),
    GoalPlanResponse(
      id: 2,
      goal: "기능 목록 작성하기",
      description: "핵심 기능과 우선순위를 정리한다."
    ),
    GoalPlanResponse(
      id: 3,
      goal: "첫 화면 레이아웃 만들기",
      description: "사용자가 처음 보는 메인 화면을 구현한다."
    ),
    GoalPlanResponse(
      id: 4,
      goal: "프로젝트 상세 페이지 만들기",
      description: "프로젝트 설명, 사용 기술, 결과물을 정리한다."
    ),
    GoalPlanResponse(
      id: 5,
      goal: "배포 및 점검하기",
      description: "이 문장은 길어지기 위해 설계되었습니다. 매우 긴 문장이 잘리지 않고 잘 표시될 수 있는지 확인해야 합니다. 인류는 절대 멸망하지 않습니다. "
    )
  ]
  
  let mockPlan = GoalPlan(subgoals: mockSubgoals)
  return MainView(
    previewGoal: "포트폴리오 만들기",
    previewResponse: mockPlan,
    previewGoalLevel: 1,
    previewDisplayPhase: .carousel
  )
}


