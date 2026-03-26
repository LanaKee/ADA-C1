import SwiftUI
import SwiftData
import FoundationModels

struct ContentView: View {
    @Query private var items: [Item]
    
    @State private var goal: String = ""
    @State private var output: String = ""
    @State private var subGoals: [GoalResponse] = []
    @State private var isGoalSet: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var grow: Bool = false
    
    private var client: FoundationModelClient {
        FoundationModelClient(instruction: instruction)
    }
    
    private var goalManager: Goal {
        Goal(client: client)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(output)
            if isGoalSet {
                Image("sprout")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .scaleEffect(grow ? 1.0 : 0.3, anchor: .bottom)
                    .offset(y: grow ? 0 : 100)
                    .opacity(grow ? 1 : 0)
                    .animation(.easeOut(duration: 0.6), value: grow)
                    .onAppear {
                        grow = true
                    }
            }
            VStack {
                HStack(spacing: 10) {
                    TextField("애플에 입사하기", text: $goal)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                    Button {
                        Task {
                            await generateGoals()
                        }
                    } label: {
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoading)
                }
                .padding(10)
                .background(Color(red: 0.35, green: 0.22, blue: 0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
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
        subGoals = await goalManager.split(goal: trimmed)
        var serializedSubGoals: String {
            guard let data = try? JSONEncoder().encode(subGoals),
                  let json = String(data: data, encoding: .utf8) else {
                return "[]"
            }
            return json
        }
        output = serializedSubGoals
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isGoalSet = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}


