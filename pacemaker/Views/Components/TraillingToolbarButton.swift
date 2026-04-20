//
//  TraillingToolbarButton.swift
//  Sylva
//
//  Created by Lanakee on 4/20/26.
//

import SwiftUI

struct TraillingToolbarButton: ToolbarContent {
  let displayPhase: GoalDisplayPhaseEnum
  @Binding var selectedAssistant: AIAssistantEnum
  let toggle: () -> Void
  
  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if displayPhase == .input {
        Menu {
          Picker("AI Assistant", selection: $selectedAssistant) {
            ForEach(AIAssistantEnum.allCases, id: \.self) { assistant in
              Label(assistant.title, systemImage: assistant.icon)
                .tag(assistant)
            }
          }
        } label: {
          Label("설정", systemImage: "ellipsis")
        }
      } else if displayPhase == .list || displayPhase == .carousel {
        Button {
          toggle()
        } label: {
          if displayPhase == .list {
            Label("캐러셀 보기", systemImage: "text.rectangle")
          } else if displayPhase == .carousel {
            Label("리스트 보기", systemImage: "list.bullet")
          }
        }
      }
    }
  }
}
