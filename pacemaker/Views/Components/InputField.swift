//
//  InputField.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import SwiftUI


struct InputField: View {
  let icon: String
  let isLoading: Bool
  let generateGoals: () async -> Void
  @Binding var goal: String
  
  @FocusState private var isFocused: Bool
  
  var body: some View {
    Label {
      Text("목표 씨앗 만들기")
        .font(.memom(.title))
      
    } icon: {
      Image("ico_seed")
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50)
    }.padding(10)
    HStack(spacing: 10) {
      TextField("이루고 싶은 목표를 간략하게 입력해주세요", text: $goal)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .disabled(isLoading)
        .focused($isFocused)
      
      Button {
        Task {
          isFocused = false
          await generateGoals()
        }
      } label: {
        Group {
          if isLoading {
            ProgressView()
              .tint(.white)
              .frame(width: 20, height: 20)
          } else {
            Image(systemName: icon)
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.white)
          }
        }
        .frame(width: 36, height: 36)
        .background(.accent)
        .clipShape(RoundedRectangle(cornerRadius: 12))

      }
      .disabled(isLoading)
    }
    .padding(10)
    .background(.white)
    .cornerRadius(16)
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 0.5)))
    .padding(.horizontal, 20)
  }
}

#Preview("목표씨앗") {
  VStack {
    Spacer()
    InputField(
      icon: "arrow.up",
      isLoading: false,
      generateGoals: {},
      goal: .init(get: { "Hello" }, set: { _ in }))
    Spacer()
  }.background(.sky)
}
