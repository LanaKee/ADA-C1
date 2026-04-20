//
//  GoalModel.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//

import Foundation
import SwiftData

enum GoalModelState: Codable {
  case active
  case finished
  case givenUp
}

@Model
class GoalModel {
  @Attribute(.unique) var id: UUID
  var state: GoalModelState
  var goal: String
  var goalLevel: Int
  
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
}
