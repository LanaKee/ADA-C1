//
//  MainViewModel.swift
//  Sylva
//
//  Created by Lanakee on 4/17/26.
//

import SwiftUI
import SwiftData
import Combine
import Foundation

@MainActor
class MainViewModel: ObservableObject {
  @Published var currentGoal: GoalModel?

  @Published var goalInput: String = ""

  @Published var selectedGoal: SubGoal?
  @Published var currentPage: Int = 1
  @Published var isLoading: Bool = false

  @Published var displayPhase: GoalDisplayPhaseEnum = .input
  @Published var mainViewState: mainViewEnum = .main
  @Published var confettiTrigger: Int = 1
  @Published var selectedAssistant: AIAssistantEnum = .appleIntelligence

  var goal: String {
    currentGoal?.goal ?? ""
  }

  var subgoals: [SubGoal] {
    currentGoal?.goalBreakdown.subgoals ?? []
  }

  var goalLevel: Int {
    currentGoal?.goalLevel ?? 1
  }

  var isComplete: Bool {
    goalLevel > 5
  }

  var showCarouselListToggle: Bool {
    if case .list = displayPhase { return true }
    if case .carousel = displayPhase { return true }
    return false
  }

  func load(from savedGoals: [GoalModel]) {
    if let activeGoal = savedGoals.first(where: { $0.state == .active }) {
      currentGoal = activeGoal
      goalInput = activeGoal.goal
      currentPage = activeGoal.goalLevel-1
      if activeGoal.goalLevel > 5 {
        displayPhase = .final
      } else {
        displayPhase = .carousel
      }
    } else {
      currentGoal = nil
      displayPhase = .input
    }
  }

  func setNewGoal(_ goalModel: GoalModel) {
    currentGoal = goalModel
    displayPhase = .initialList
    currentPage = 0
  }

  func completeGoal() {
    guard let currentGoal else { return }
    currentGoal.goalLevel += 1
    currentPage = currentGoal.goalLevel-1

    objectWillChange.send()

    if isComplete {
      displayPhase = .final
    }
  }

  func toggleViewMode() {
    guard currentGoal != nil else { return }
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

  func toggleBonsaiView() {
    withAnimation(.easeInOut(duration: 0.3)) {
      switch mainViewState {
      case .main:
        mainViewState = .bonsai
      case .bonsai:
        mainViewState = .main
      }
    }
  }

  func firework() {
    confettiTrigger += 1
  }
}
