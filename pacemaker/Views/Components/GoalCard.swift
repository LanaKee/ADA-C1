//
//  GoalCard.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

struct GoalCard: View {
  @Environment(\.colorScheme) private var colorScheme
  @State var subgoal: GoalPlanResponse
  let onTap: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Rectangle()
        .fill(.accent)
        .frame(width: 3)
        .clipShape(Capsule())
      
      VStack(alignment: .leading, spacing: 6) {
        Text("\(subgoal.id) \(subgoal.goal)")
          .font(.headline)
          .padding(.bottom, 5)
        
        VStack(alignment: .leading, spacing: 4) {
          ForEach(subgoal.tasks, id: \.self) { task in
            Text(task)
              .font(.caption)
          }
        }
      }
      .padding(.leading, 10)
      Spacer()
      Image(systemName:"chevron.right")
        .resizable()
        .frame(width: 5, height: 10)
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(colorScheme == ColorScheme.light ? .gray.opacity(0.07) : .gray.opacity(0.3))
    .cornerRadius(20)
    .shadow(radius: 10)
    .padding(.horizontal, 20)
    .onTapGesture {TapGesture in
      onTap()
    }
  }
}

#Preview {
  GoalCard(
    subgoal: GoalPlanResponse(
      id: 1,
      goal: "Learn SwiftUI",
      tasks: ["Read SwiftUI documentation", "Create a simple SwiftUI app"]
    ),
    onTap: {}
  )
}
