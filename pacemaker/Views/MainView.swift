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
  
  @State private var goal: String = ""
  
  @State private var response: GoalPlan?
  @State private var selectedGoal: GoalPlanResponse?
  
  @State private var goalLevel: Int = 0
  @State private var selectedIndex: Int = 0
  @State private var isLoading: Bool = false
  
  @State private var currentPage: Int = 0
  
  private let client = FoundationModelClient(instruction: instruction)
  
  init() {}
  
  init(
    previewGoal: String,
    previewResponse: GoalPlan?,
    previewSelectedGoal: GoalPlanResponse? = nil,
    previewGoalLevel: Int,
    previewIsLoading: Bool = false,
  ) {
    _goal = State(initialValue: previewGoal)
    _response = State(initialValue: previewResponse)
    _selectedGoal = State(initialValue: previewSelectedGoal)
    _goalLevel = State(initialValue: previewGoalLevel)
    _isLoading = State(initialValue: previewIsLoading)
  }
  
  var body: some View {
    NavigationStack{
      VStack(spacing: 0) {
        if isLoading {
          VStack(spacing: 12) {
            Spacer ()
            ProgressView()
            Text("목표를 작은 단계로 나누고 있어요...")
              .font(.subheadline)
              .foregroundStyle(.secondary)
            Spacer ()
          }
          .padding(.top, 20)
        }
        if goalLevel > 0 {
          if let subgoals = response?.subgoals,
             !subgoals.isEmpty,
             subgoals.indices.contains(goalLevel - 1) {
            Carousel(
              pageCount: subgoals.count,
              visibleEdgeSpace: 10,
              spacing: 10,
              currentIndex: $currentPage
            ) { index in
              GoalCard(
                subgoal: subgoals[index],
                disabled: index >= goalLevel
              ) {
                if index < goalLevel {
                  selectedGoal = subgoals[index]
                }
              }
            }
            
            Spacer()
            
            SproutView(
              level: goalLevel,
              onTap: {
              }
            )
          }
        } else {
          Spacer()
        }
        //        if goalLevel <= 0 {
        //          Text("목표 설정하기")
        //            .font(.title)
        //          Text("아래의 상자에 목표를 적고 버튼을 눌러주세요")
        //            .padding(.bottom, 40)
        //        }
        
        VStack {
          if goalLevel > 0 {
            Text(goal)
              .bold()
              .foregroundStyle(.white)
              .font(.title2)
              .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))
          } else {
            InputField(isLoading: isLoading, generateGoals: generateGoals, goal: $goal)
          }
        }
        .padding(.vertical, 20)
        .background(.brown)
        
      }.navigationDestination(item: $selectedGoal) { goal in
        SubGoalView(subGoal: goal, onComplete:{
          goalLevel = goal.id + 1;
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
      
      withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
        goalLevel = 1;
      }
    case .failure:
      goalLevel = 0
    }
  }
}

#Preview("초기 입력 상태") {
  MainView(

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

  )
}


