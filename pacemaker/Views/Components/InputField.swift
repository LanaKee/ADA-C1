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
        .font(.title.bold())
    } icon: {
      Image("seed")
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
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
    .glassEffect(.regular, in: .rect(cornerRadius: 16))
    
    .padding(.horizontal, 20)
  }
}

/**
 * @deprecated
*/
struct groundInputField: View {
  let isLoading: Bool
  let generateGoals: () async -> Void
  @Binding var goal: String
  
  @FocusState private var isTextFieldFocused: Bool
  
  var body: some View {
      HStack(spacing: 10) {
          TextField("이루고 싶은 목표를 간략하게 입력해주세요", text: $goal)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
              .foregroundColor(.white)
              .disabled(isLoading)
              .focused($isTextFieldFocused)

          Button {
              Task {
                  isTextFieldFocused = false
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

#Preview("목표씨앗") {
  InputField(
    icon: "checkmark",
    isLoading: false,
    generateGoals: {},
    goal: .init(get: { "Hello" }, set: { _ in }))
  InputField(
    icon: "arrow.up",
    isLoading: false,
    generateGoals: {},
    goal: .init(get: { "Hello" }, set: { _ in }))
  InputField(
    icon: "list.bullet.below.rectangle",
    isLoading: false,
    generateGoals: {},
    goal: .init(get: { "Hello" }, set: { _ in }))
}

#Preview("땅 인풋필드") {
  groundInputField(
        isLoading: false,
        generateGoals: { },
        goal: .init(get: { "Hello" }, set: { _ in })
    )
}
