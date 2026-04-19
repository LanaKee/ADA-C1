//
//  MainView.swift
//  pacemaker
//
//  Created by Lanakee on 3/30/26.
//

import SwiftUI
import Combine
import ConfettiSwiftUI
import FoundationModels

struct MainView: View {
  @Environment(\.colorScheme) var colorScheme
  
  @State private var goal: String = ""
  
  @State private var response: GoalBreakDown?
  @State private var selectedGoal: SubGoal?
  
  @State private var goalLevel: Int = 0
  @State private var currentPage: Int = 0
  @State private var selectedIndex: Int = 0
  
  @State private var isLoading: Bool = false
  @State private var displayPhase: GoalDisplayPhaseEnum = .input
  
  @State private var trigger: Int = 0
  @State private var selectedAssistant: AIAssistantEnum = .appleIntelligence
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if isLoading && displayPhase != .list && displayPhase != .initialList {
          Loading(message: "목표를 작은 단계로 나누고 있어요...")
        }
        if displayPhase != .input {
          Text(goal)
            .font(.memom(.largeTitle))
            .foregroundStyle(.primary)
            .padding(.top, 16)
        }
        
        switch displayPhase {
        case .input:
          if !isLoading {
            Spacer()
            InputView(
              selectedModel: selectedAssistant,
              goal: $goal
            )
            Spacer()
          }
          
          
        case .initialList, .list:
          if let subgoals = response?.subgoals, !subgoals.isEmpty {
            ListView(
              subgoals: subgoals,
              goalLevel: goalLevel,
              showStartButton: displayPhase == .initialList,
              selectedGoal: $selectedGoal,
              displayPhase: $displayPhase
            )
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
                  onTap:{selectedGoal = subgoals[index]},
                  status: goalLevel > subgoals[index].id ? .completed : .normal
                )
              }, currentIndex: $currentPage)
            .padding(.top, 10)
            
            Spacer()
            
            Tree(
              level: goalLevel,
              onTap: {
              }
            )
          }
          
        case .final:
          Text("축하합니다 목표를 완료하셨어요!")
            .font(.memom(.subheadline))
            .foregroundStyle(.secondary)
            .padding(.top, 4)
          Spacer()
          Tree(level: 5) {
            trigger += 1
          }.onAppear {
            trigger += 1
          }
          .confettiCannon(trigger: $trigger)
        }
        Image("img_ground")
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: 100)
        
      }
      .ignoresSafeArea(edges: .bottom)
      .background(.sky)
      .navigationDestination(item: $selectedGoal) { goal in
        SubGoalView(
          subGoal: goal,
          allSubgoals: response?.subgoals ?? [],
          goalLevel: goalLevel,
          onComplete: {
            goalLevel = goal.id + 1
            currentPage = goal.id
            if (goalLevel > 5) {
              displayPhase = .final
            }
          }
        )
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("기록",
                 systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                 action: {}
          )
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker("AI Assistant", selection: $selectedAssistant) {
                    ForEach(AIAssistantEnum.allCases) { assistant in
                        Label(assistant.title, systemImage: assistant.icon)
                            .tag(assistant)
                    }
                }
            } label: {
                Label("설정", systemImage: "ellipsis")
            }
        }
        if displayPhase == .carousel || displayPhase == .list {
          ToolbarItem(placement: .topBarLeading) {
            Button("Mode Change", systemImage: displayPhase == .carousel ? "list.bullet": "text.rectangle") {
              withAnimation(.easeInOut(duration: 0.3)) {
                switch displayPhase {
                case .carousel:
                  displayPhase = .list
                case .list:
                  displayPhase = .carousel
                default:
                  break
                }
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  MainView()
}
