//
//  ContentView.swift
//  pacemaker
//
//  Created by Lanakee on 3/20/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var goal: String = ""
    // @FocusState private var goalFieldIsFocused: Bool = false

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

            Button(action: addItem) {
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

        Spacer()
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
