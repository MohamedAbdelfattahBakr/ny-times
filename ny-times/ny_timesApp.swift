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

struct ContentView: View {
    @StateObject private var viewModel = ArticleListViewModel()

    var body: some View {
        NavigationView {
            ArticleListView()
                .environmentObject(viewModel)
        }
        .navigationViewStyle(.stack)
    }
}
