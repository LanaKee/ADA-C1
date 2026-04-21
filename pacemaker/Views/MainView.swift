//
//  MainView.swift
//  pacemaker
//
//  Created by Lanakee on 3/30/26.
//

import SwiftUI
import SwiftData
import Combine
import ConfettiSwiftUI
import FoundationModels
import FirebaseAI
import FirebaseAILogic

struct MainView: View {
  @Environment(\.modelContext) var context
  @Query var savedGoals: [GoalModel]
  @StateObject private var viewModel = MainViewModel()
  
  private let client = GoalBreakDowner(instruction: instruction)
  var isInitialList: Bool {
    if case .initialList = viewModel.displayPhase { return true }
    return false
  }
  
  func generateGoals() async -> Void {
    viewModel.displayPhase = .loading
    let trimmed = viewModel.goal.trimmingCharacters(in: .whitespacesAndNewlines)
    if viewModel.selectedAssistant == .appleIntelligence {
      guard !trimmed.isEmpty else { return }
      
      viewModel.isLoading = true
      defer { viewModel.isLoading = false }
      
      let result = await client.getResponse(prompt: trimmed)
      switch result {
      case .success(let plan):
        viewModel.response = plan
        let newGoal = GoalModel(goal: viewModel.goal, goals: plan)
        context.insert(newGoal)
        viewModel.displayPhase = .initialList

      case .failure:
        viewModel.displayPhase = .input
      }
    } else if viewModel.selectedAssistant == .gemini {
      viewModel.isLoading = true
      do {
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        let model = ai.generativeModel(
          modelName: "gemini-2.5-flash-lite",
          generationConfig : GenerationConfig(
            responseMIMEType: "application/json",
            responseSchema: geminiSchema
          ),
          systemInstruction: ModelContent(role: "system", parts: instruction)
        )
        
        defer { viewModel.isLoading = false }
        
        let geminiresponse = try await model.generateContent("사용자 입력: \(trimmed)")
        guard let text = geminiresponse.text else {
          return
        }
        viewModel.response = try parseGoalBreakDown(from: text)
        viewModel.displayPhase = .initialList
        let newGoal = GoalModel(goal: viewModel.goal, goals: GoalBreakDown(subgoals: viewModel.response?.subgoals ?? []))
        context.insert(newGoal)
        
      } catch {
        print("gemini fail \(error)")
      }
    }
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        if (viewModel.mainViewState == .main) {
          switch viewModel.displayPhase {
          case .input:
            Spacer()
            InputView(
              goal: $viewModel.goal,
              isLoading: $viewModel.isLoading,
              selectedAssistant: viewModel.selectedAssistant,
              onSubmit: {
                await generateGoals()
                viewModel.goalLevel = 1
                
              }
            )
            Spacer()
          case .loading:
            Loading(message: "목표를 작은 단계로 나누고 있어요...")
            
          case .initialList,  .list:
            if let subgoals = viewModel.response?.subgoals, !subgoals.isEmpty {
              Text(viewModel.goal)
                .font(.memom(.largeTitle))
                .foregroundStyle(.primary)

              ListView(
                subgoals: viewModel.subgoals,
                goalLevel: viewModel.goalLevel,
                showStartButton: isInitialList,
                selectedGoal: $viewModel.selectedGoal,
                onTap: {
                  viewModel.displayPhase = .carousel
                }
              )
            }
            
          case .carousel:
            Text(viewModel.goal)
                .font(.memom(.largeTitle))
                .foregroundStyle(.primary)
            if let subgoals = viewModel.response?.subgoals,
               !subgoals.isEmpty {
              Carousel(
                pageCount: subgoals.count,
                visibleEdgeSpace: 10,
                spacing: 10,
                content:  { index in
                  GoalCard(
                    subgoal: viewModel.subgoals[index],
                    disabled: false,
                    onTap:{viewModel.selectedGoal = subgoals[index]},
                    status: viewModel.goalLevel > subgoals[index].id ? .completed : .normal
                  )
                }, currentIndex: $viewModel.currentPage)
              .padding(.top, 10)

              Spacer()
            }
          case .final:
            Text("축하합니다 목표를 완료하셨어요!")
              .font(.memom(.subheadline))
              .foregroundStyle(.secondary)
              .padding(.top, 4)
            Spacer()
            Tree(level: 5) {
              viewModel.confettiTrigger += 1
            }.onAppear {
              viewModel.confettiTrigger += 1
            }
            .confettiCannon(trigger: $viewModel.confettiTrigger)
          }
        } else {
          BonsaiView()
        }
        VStack(spacing: 20) {
          ZStack(alignment: .bottom) {
            Image("img_ground")
              .resizable()
              .frame(maxWidth: .infinity, maxHeight: 100)
            
            Tree(
              level: viewModel.goalLevel,
              onTap: { }
            )
          }
        }
      }
      .onAppear {
        if !savedGoals.isEmpty {
          if let index = savedGoals.firstIndex(where: { $0.state == .active }) {
            viewModel.goal = savedGoals[index].goal
            viewModel.response = savedGoals[index].goalBreakdown
            viewModel.goalLevel = savedGoals[index].goalLevel
            viewModel.displayPhase = .carousel
          } else {
            viewModel.displayPhase = .input
          }
        } else {
          viewModel.displayPhase = .input
        }
      }
      .ignoresSafeArea(edges: .bottom)
      .background(.sky)
      .navigationDestination(item: $viewModel.selectedGoal) { goal in
        SubGoalView(
          subGoal: goal,
          allSubgoals: viewModel.response?.subgoals ?? [],
          goalLevel: viewModel.goalLevel,
          onComplete: {
            viewModel.goalLevel = viewModel.goalLevel + 1
            viewModel.currentPage = viewModel.goalLevel
          }
        )
      }
      .toolbar {
        RecordToolbarButton{
          viewModel.toggleBonsaiView()
        }
        if viewModel.mainViewState != .bonsai {
          TraillingToolbarButton(
            displayPhase: viewModel.displayPhase,
            selectedAssistant: $viewModel.selectedAssistant,
            toggle: {
              viewModel.toggleViewMode()
            }
          )
        }
      }
    }
  }
}

#Preview {
  MainView()
}

