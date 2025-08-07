//
//  ArticleListViewModel.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//

import SwiftUI

@MainActor
final class ArticleListViewModel: ObservableObject {
    
    @Published private(set) var articles: [Article] = []
    @Published private(set) var filteredArticles: [Article] = []
    @Published private(set) var isLoading  = false
    @Published private(set) var errorMessage: String?
    
    // MARK: – User-editable filters / search
    @Published var searchText = "" { didSet { applySearch() } }
    @Published var selectedSortOption = SortOption.date { didSet { applySearch() } }
    
    @Published var selectedArticleType = PopularArticleType.mostViewed { didSet { refresh() } }
    @Published var selectedSection = APIConstants.Endpoints.Sections.allSections { didSet { refresh() } }
    @Published var selectedTimePeriod = APIConstants.Endpoints.TimePeriods.sevenDays { didSet { refresh() } }
    
    // MARK: – Sheet flags
    @Published var showingSortSheet   = false
    @Published var showingFilterSheet = false
    
    // MARK: – Private
    private let fetchUseCase: FetchArticlesUseCase
    private var fetchTask: Task<Void, Never>?
    
    // MARK: – Init
    init(repo: ArticleRepository = NYTimesService()) {
        self.fetchUseCase = .init(repository: repo)
        refresh()
    }
    
    func refresh() {
        fetchTask?.cancel()
        fetchTask = Task { await fetch() }
    }
    
    func retry() {
        refresh()
    }
    
    func updateFilters(type: PopularArticleType,
                       section: String,
                       timePeriod: String) {
        selectedArticleType = type
        selectedSection     = section
        selectedTimePeriod  = timePeriod
    }
    
    // MARK: – Networking
    private func fetch() async {
        isLoading = true
        errorMessage = nil
        
        let criteria = FetchCriteria(
            type:   selectedArticleType,
            period: selectedTimePeriod
        )
        do {
            articles = try await fetchUseCase.execute(with: criteria)
            applySearch()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func applySearch() {
        let base = searchText.isEmpty
        ? articles
        : articles.filter {
            $0.title   .localizedCaseInsensitiveContains(searchText) ||
            $0.abstract.localizedCaseInsensitiveContains(searchText) ||
            $0.section .localizedCaseInsensitiveContains(searchText)
        }
        
        filteredArticles = sort(base, by: selectedSortOption)
    }
    
    private func sort(_ list: [Article], by option: SortOption) -> [Article] {
        switch option {
        case .date: return list.sorted { $0.publishedDate > $1.publishedDate }
        case .title: return list.sorted { $0.title < $1.title }
        case .section: return list.sorted { $0.section < $1.section }
        }
    }
}
