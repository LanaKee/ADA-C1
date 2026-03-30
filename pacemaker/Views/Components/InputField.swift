//
//  InputField.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//
import SwiftUI
import UIKit

struct InputField: View {
    let isLoading: Bool
    let generateGoals: () async -> Void
    @Binding var goal: String
    
    var body: some View {
        HStack(spacing: 10) {
            TextField("아카데미 6기에 지원하기", text: $goal)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .foregroundColor(.white)
                .disabled(isLoading)
            Button {
                Task {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
}

#Preview {
    InputField(
        isLoading: false,
        generateGoals: { },
        goal: .init(get: { "Hello" }, set: { _ in })
    )
}


