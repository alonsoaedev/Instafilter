//
//  ContentView.swift
//  Instafilter
//
//  Created by Alonso Acosta on 12/02/26.
//

import StoreKit
import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Button("Leave a review") {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
