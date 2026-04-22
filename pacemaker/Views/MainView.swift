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
    let trimmed = viewModel.goalInput.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    
    viewModel.isLoading = true
    defer { viewModel.isLoading = false }
    
    if viewModel.selectedAssistant == .appleIntelligence {
      let result = await client.getResponse(prompt: trimmed)
      switch result {
      case .success(let plan):
        let newGoal = GoalModel(goal: viewModel.goalInput, goals: plan)
        context.insert(newGoal)
        viewModel.setNewGoal(newGoal)
        
      case .failure:
        viewModel.displayPhase = .input
      }
    } else if viewModel.selectedAssistant == .gemini {
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
        
        let geminiresponse = try await model.generateContent("사용자 입력: \(trimmed)")
        guard let text = geminiresponse.text else { return }
        let breakdown = try parseGoalBreakDown(from: text)
        let newGoal = GoalModel(
          goal: viewModel.goalInput,
          goals: GoalBreakDown(subgoals: breakdown.subgoals)
        )
        context.insert(newGoal)
        viewModel.setNewGoal(newGoal)
        
      } catch {
        print("gemini fail \(error)")
        viewModel.displayPhase = .input
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
              goal: $viewModel.goalInput,
              isLoading: $viewModel.isLoading,
              selectedAssistant: viewModel.selectedAssistant,
              onSubmit: {
                await generateGoals()
              }
            )
            Spacer()
          case .loading:
            Loading(message: "목표를 작은 단계로 나누고 있어요...")
            
          case .initialList,  .list:
            if !viewModel.subgoals.isEmpty {
              Text(viewModel.goal)
                .font(.memom(.title))
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
              .font(.memom(.title))
              .foregroundStyle(.primary)
            if !viewModel.subgoals.isEmpty {
              Carousel(
                pageCount: viewModel.subgoals.count,
                visibleEdgeSpace: 10,
                spacing: 10,
                content:  { index in
                  GoalCard(
                    subgoal: viewModel.subgoals[index],
                    disabled: false,
                    onTap:{viewModel.selectedGoal = viewModel.subgoals[index]},
                    status: viewModel.goalLevel > viewModel.subgoals[index].id ? .completed : .normal
                  )
                }, currentIndex: $viewModel.currentPage)
              .padding(.top, 10)
              
              Spacer()
            }
          case .final:
            Text(viewModel.goal)
              .font(.memom(.title))
              .foregroundStyle(.primary)
            Text("축하합니다 목표를 완료하셨어요!")
              .font(.memom(.subheadline))
              .foregroundStyle(.secondary)
              .padding(.top, 4)
            Spacer()
            Button {
              viewModel.completeGoal()
            } label : {
              Text("새로운 목표 설정하기")
                .padding(10)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .bold()
            }
            .buttonStyle(.borderedProminent)
            .tint(.accent)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
          }
        } else {
          BonsaiView {
            viewModel.load(from: savedGoals)
          }
        }
        VStack(spacing: 20) {
          ZStack(alignment: .bottom) {
            Image("img_ground")
              .resizable()
              .frame(maxWidth: .infinity, maxHeight: 100)
            
            if viewModel.mainViewState != .bonsai {
              
              if viewModel.displayPhase == .carousel {
                Tree(
                  level: viewModel.goalLevel,
                  onTap: { }
                )
              } else if viewModel.displayPhase == .final {
                Tree(level: 10) {
                  viewModel.confettiTrigger += 1
                }.onAppear {
                  viewModel.confettiTrigger += 1
                }
                .confettiCannon(trigger: $viewModel.confettiTrigger)
              }
            }
          }
        }
      }
      .onAppear {
        viewModel.load(from: savedGoals)
      }
      .ignoresSafeArea(edges: .bottom)
      .background(.sky)
      .navigationDestination(item: $viewModel.selectedGoal) { goal in
        SubGoalView(
          subGoal: goal,
          allSubgoals: viewModel.subgoals,
          goalLevel: viewModel.goalLevel,
          onComplete: {
            viewModel.completeMileStone()
          },
          onSkip: {
            viewModel.skipMileStone(to: goal)
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
