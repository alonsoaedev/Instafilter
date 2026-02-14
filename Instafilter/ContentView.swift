//
//  ContentView.swift
//  Instafilter
//
//  Created by Alonso Acosta on 12/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any snippets yet")
        } actions: {
            Button("Create snippet") {
                //
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
