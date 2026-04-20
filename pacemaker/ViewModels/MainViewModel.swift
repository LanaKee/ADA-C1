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
  @Published var goal: String = ""
  @Published var response: GoalBreakDown?
  @Published var selectedGoal: SubGoal?
  
  @Published var goalLevel: Int = 0
  @Published var currentPage: Int = 0
  
  @Published var isLoading: Bool = false
  @Published var displayPhase: GoalDisplayPhaseEnum = .input
  @Published var mainViewState: mainViewEnum = .main
  
  @Published var confettiTrigger: Int = 0
  @Published var selectedAssistant: AIAssistantEnum = .appleIntelligence
  
  var subgoals: [SubGoal] {
    response?.subgoals ?? []
  }
  
  var isComplete: Bool {
    goalLevel > 5
  }
  
  var showCarouselListToggle: Bool {
    if case .list = displayPhase { return true }
    if case .carousel = displayPhase { return true }
    return false
  }
  
  func completeSubgoal(_ subgoal: SubGoal) {
    goalLevel = subgoal.id + 1
    currentPage = subgoal.id
    if isComplete {
      displayPhase = .final
    }
  }
  
  func toggleViewMode() {
    guard response != nil else { return }
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
  
  func toggleBonsaiView () {
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

