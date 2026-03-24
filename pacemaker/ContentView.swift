//
//  ContentView.swift
//  pacemaker
//
//  Created by Lanakee on 3/20/26.
//

import SwiftUI
import SwiftData
import FoundationModels
import Playgrounds

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var goal: String = ""
    @State private var output: String = ""
    private let instruction = """
        You are a consultant with 20 years of experience.
        Take the user’s goal and break it down into multiple smaller goals.

        Conditions:
            1. Each goal must be achievable within one week.
            2. Each goal must consist of specific, actionable tasks.
            3. The goals should be structured to progressively advance step by step.
            4. The result must be presented as a numbered list.
            5. Always response with Korean
        """

    var body: some View {
        Spacer()
        Text("PaceMaker")
            .font(.largeTitle)
        
        Text("이루고 싶은걸 적어주세요")
            .font(.headline)
            .foregroundStyle(.gray)
        
        HStack(spacing: 8) {
            TextField("애플에 입사하기?", text: $goal)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            Button{
                Task {
                    output = await splitGoals(goal: goal)
                }
            } label: {
                Image(systemName: "arrow.up")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10 ))
            }
            .disabled(goal.isEmpty)
        }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
        ScrollView {
            Text(output.isEmpty ? "아직 결과가 없습니다." : output)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        Spacer()
    }
    
    private func splitGoals(goal: String) async -> String {
        do {
            let session = LanguageModelSession(instructions: instruction)
            let response = try await session.respond(to: "\(goal)을/를 이루기 위해 필요한 작은 목표들을 알려주세요")
            return response.content
        } catch LanguageModelSession.GenerationError.guardrailViolation {
            return "애플 가드레일에 의해 응답이 차단되었습니다"
        } catch {
            return "에러 발생: \(error)"
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
