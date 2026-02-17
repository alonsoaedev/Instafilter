//
//  ContentView.swift
//  Instafilter
//
//  Created by Alonso Acosta on 12/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let example: Image = Image(.example)
        
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
            Label("Spread the word about Swift!", systemImage: "swift")
        }
        
        ShareLink(
            item: example,
            preview: SharePreview("Boston", image: example),
        ) {
            Label("Click to share", systemImage: "airplane")
        }
    }
}

#Preview {
    ContentView()
}
