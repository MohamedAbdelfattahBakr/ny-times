//
//  ny_timesApp.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//

import SwiftUI

@main
struct ny_timesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
// 4️⃣  ContentView – works exactly like your old one
// ────────────────────────────────────────────────────────────────

struct ContentView: View {
    @StateObject private var viewModel = ArticleListViewModel()

    var body: some View {
        NavigationView {
            ArticleListView()                       // your existing UI
                .environmentObject(viewModel)       // nothing else changes
        }
        .navigationViewStyle(.stack)
    }
}
