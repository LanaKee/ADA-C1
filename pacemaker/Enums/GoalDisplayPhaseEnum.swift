//
//  GoalDisplayPhaseEnum.swift
//  pacemaker
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

enum GoalDisplayPhaseEnum {
    case input
    case loading
    case initialList(GoalBreakDown)
    case list(GoalBreakDown)
    case carousel(GoalBreakDown, level: Int)
    case final
}

enum mainViewEnum {
  case main
  case bonsai
}
