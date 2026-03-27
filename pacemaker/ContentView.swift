import SwiftUI
import SwiftData
import FoundationModels

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @Query private var items: [Item]
  
  @State private var goal: String = ""
  @State private var output: String = ""
  
  @State private var response: GoalPlan?
  @State private var isGoalSet: Bool = false
  @State private var isLoading: Bool = false
  @State private var showGoalCard: Bool = false
  
  @State private var grow: Bool = false
  
  private var client: FoundationModelClient {
    FoundationModelClient(instruction: instruction)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if showGoalCard {
        if let subgoals = response?.subgoals, let first = subgoals.first {
          HStack(alignment: .top, spacing: 12) {
            Rectangle()
              .fill(.accent)
              .frame(width: 3)
              .clipShape(Capsule())
            
            VStack(alignment: .leading, spacing: 6) {
              Text("1. \(first.goal)")
                .font(.headline)
                .padding(.bottom, 5)
              
              VStack(alignment: .leading, spacing: 4) {
                ForEach(first.tasks, id: \.self) { task in
                  Text(task)
                    .font(.caption)
                }
              }
            }
            .padding(.leading, 10)
          }
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .background(colorScheme == ColorScheme.light ? .gray.opacity(0.07) : .gray.opacity(0.3))
          .cornerRadius(20)
          .shadow(radius: 10)
          .padding(.horizontal, 20)
        }
      }
      
      Spacer()
      if isGoalSet {
        SproutView(
          onTap: {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
              showGoalCard.toggle()
            }
          }
        )
      }
      VStack {
        if isGoalSet {
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
      output = plan.subgoals.first?.goal ?? ""
      
      withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
        isGoalSet = true
      }
    case .failure:
      isGoalSet = false
    }
  }
}

struct GoalView: View {
  let goal: GoalPlanResponse
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(goal.goal)
        .font(.title2)
        .bold()
      
      ForEach(goal.tasks, id: \.self) { task in
        Text("• \(task)")
      }
    }
    .padding()
    .navigationTitle("세부 목표")
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
