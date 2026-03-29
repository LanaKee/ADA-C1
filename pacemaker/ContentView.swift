//
//  ContentView.swift
//  pacemaker
//
//  Created by Lanakee on 3/20/26.
//

import SwiftUI
import SwiftData
import FoundationModels

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  
  @State private var goal: String = ""
  
  @State private var response: GoalPlan?
  @State private var selectedGoal: GoalPlanResponse?
  
  @State private var goalLevel: Int = 0
  @State private var isLoading: Bool = false
  @State private var showGoalCard: Bool = false
  
  
  private let client = FoundationModelClient(instruction: instruction)
  
  var body: some View {
    NavigationStack{
      VStack(spacing: 0) {
        if showGoalCard {
          if let subgoals = response?.subgoals,
             subgoals.indices.contains(goalLevel - 1) {
            
            let selected = subgoals[goalLevel - 1]
            
            GoalCard(subgoal: selected) {
              selectedGoal = selected
            }
          }
        }
        Spacer()
        if goalLevel > 0 {
          SproutView(
            level: goalLevel,
            onTap: {
              withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                showGoalCard.toggle()
              }
            }
          )
        }
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
          goalLevel+=1
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
