//
//  SproutView.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import SwiftUI

struct SproutView: View {
    @State private var grow: Bool = false
    let onTap: () -> Void

    var body: some View {
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
            .onTapGesture {apGesture in
              onTap()
            }
    }
}

#Preview {
    SproutView(
      onTap: { }
    )
}
