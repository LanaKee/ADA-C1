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
  @StateObject private var viewModel = MainViewModel()
  var isInitialList: Bool {
    if case .initialList = viewModel.displayPhase { return true }
      return false
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
                viewModel.isLoading = false
                await viewModel.generateGoals()
                viewModel.displayPhase = .loading
              }
            )
            Spacer()
          case .loading:
            Loading(message: "목표를 작은 단계로 나누고 있어요...")
            
          case .initialList,  .list:
            Text("WIP")
            if let subgoals = viewModel.response?.subgoals, !subgoals.isEmpty {
              ListView(
                subgoals: viewModel.subgoals,
                goalLevel: viewModel.goalLevel,
                showStartButton: isInitialList,
                selectedGoal: $viewModel.selectedGoal,
                displayPhase:$viewModel.displayPhase,
              )
            }

          case .carousel:
            Text("WIP")
            // CarouselPhaseView(breakdown: breakdown, level: level, ...)
          case .final:
            Text("WIP")
            // FinalPhaseView(...)
          }
        } else {
          BonsaiView()
        }
        Image("img_ground")
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: 100)
      }
      .ignoresSafeArea(edges: .bottom)
      .background(.sky)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            viewModel.toggleBonsaiView()
          } label: {
            Label("기록", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
          }
        }
        if case .input = viewModel.displayPhase {
          ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
              Picker("AI Assistant", selection: $viewModel.selectedAssistant) {
                ForEach(AIAssistantEnum.allCases, id: \.self) { assistant in
                  Label(assistant.title, systemImage: assistant.icon)
                    .tag(assistant)
                }
              }
            } label: {
              Label("설정", systemImage: "ellipsis")
            }
          }
        }
      }
    }
  }
  
  //  @Environment(\.colorScheme) var colorScheme
  //
  //
  //  var body: some View {
  //    NavigationStack {
  //      VStack(spacing: 0) {
  //        if isLoading && displayPhase != .list && displayPhase != .initialList {
  //          Loading(message: "목표를 작은 단계로 나누고 있어요...")
  //        }
  //        if displayPhase != .input {
  //          Text(goal)
  //            .font(.memom(.largeTitle))
  //            .foregroundStyle(.primary)
  //            .padding(.top, 16)
  //        }
  //
  //        switch displayPhase {
  //        case .input:
  //          if !isLoading {
  //            Spacer()
  //            InputView(
  //              selectedModel: selectedAssistant,
  //              goal: $goal
  //            )
  //            Spacer()
  //          }
  //
  //
  //        case .initialList, .list:
  //          if let subgoals = response?.subgoals, !subgoals.isEmpty {
  //            ListView(
  //              subgoals: subgoals,
  //              goalLevel: goalLevel,
  //              showStartButton: displayPhase == .initialList,
  //              selectedGoal: $selectedGoal,
  //              displayPhase: $displayPhase
  //            )
  //          }
  //
  //        case .carousel:
  //          if let subgoals = response?.subgoals,
  //             !subgoals.isEmpty,
  //             subgoals.indices.contains(goalLevel - 1) {
  //            Carousel(
  //              pageCount: subgoals.count,
  //              visibleEdgeSpace: 10,
  //              spacing: 10,
  //              content:  { index in
  //                GoalCard(
  //                  subgoal: subgoals[index],
  //                  disabled: false, // index >= goalLevel,
  //                  onTap:{selectedGoal = subgoals[index]},
  //                  status: goalLevel > subgoals[index].id ? .completed : .normal
  //                )
  //              }, currentIndex: $currentPage)
  //            .padding(.top, 10)
  //
  //            Spacer()
  //
  //            Tree(
  //              level: goalLevel,
  //              onTap: {
  //              }
  //            )
  //          }
  //
  //        case .final:
  //          Text("축하합니다 목표를 완료하셨어요!")
  //            .font(.memom(.subheadline))
  //            .foregroundStyle(.secondary)
  //            .padding(.top, 4)
  //          Spacer()
  //          Tree(level: 5) {
  //            trigger += 1
  //          }.onAppear {
  //            trigger += 1
  //          }
  //          .confettiCannon(trigger: $trigger)
  //        }
  //        Image("img_ground")
  //          .resizable()
  //          .frame(maxWidth: .infinity, maxHeight: 100)
  //
  //      }
  //      .ignoresSafeArea(edges: .bottom)
  //      .background(.sky)
  //      .navigationDestination(item: $selectedGoal) { goal in
  //        SubGoalView(
  //          subGoal: goal,
  //          allSubgoals: response?.subgoals ?? [],
  //          goalLevel: goalLevel,
  //          onComplete: {
  //            goalLevel = goal.id + 1
  //            currentPage = goal.id
  //            if (goalLevel > 5) {
  //              displayPhase = .final
  //            }
  //          }
  //        )
  //      }
  //        }
  //      }
  //    }
  //  }
}

#Preview {
  MainView()
}
