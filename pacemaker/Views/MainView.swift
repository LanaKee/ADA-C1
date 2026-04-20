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
  
  var tesNumt: Int = 0
  
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
                await viewModel.generateGoals()
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
                .padding(.top, 16)
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

              Tree(
                level: viewModel.goalLevel,
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
              viewModel.confettiTrigger += 1
            }.onAppear {
              viewModel.confettiTrigger += 1
            }
            .confettiCannon(trigger: $viewModel.confettiTrigger)
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
        RecordToolbarButton{
          viewModel.toggleBonsaiView()
        }
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

#Preview {
  MainView()
}
