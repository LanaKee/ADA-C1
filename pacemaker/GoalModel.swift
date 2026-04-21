//
//  GoalModel.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//

import Foundation
import SwiftData

enum GoalModelState: Equatable & Codable {
  case active
  case finished
  case givenUp
}

@Model
class GoalModel {
  @Attribute(.unique) var id: UUID
  var state: GoalModelState
  var goal: String
  var goalLevel: Int = 1
  
  var goalBreakdown: GoalBreakDown
  
  var createdAt: Date
  var finishedAt: Date?
  
  init(goal: String, goals: GoalBreakDown) {
    self.id = UUID()
    self.goalLevel = 1
    self.state = .active
    
    self.goal = goal
    self.goalBreakdown = goals
    
    self.createdAt = Date()
    self.finishedAt = nil
  }
  
//  init(model: GoalModel, goalLevel: Int) {
//    self.id = model.id
//    self.state = model.state
//    self.goal = model.goal
//    self.goalBreakdown = model.goalBreakdown
//    self.createdAt = model.createdAt
//    self.finishedAt = model.finishedAt
//    
//    self.goalLevel = goalLevel
//  }
//  
//  init(model: GoalModel, goalState: GoalModelState) {
//    self.id = model.id
//    self.goal = model.goal
//    self.goalLevel = model.goalLevel
//    self.goalBreakdown = model.goalBreakdown
//    self.createdAt = model.createdAt
//    
//    self.state = goalState
//    self.finishedAt = Date()
//  }
}
