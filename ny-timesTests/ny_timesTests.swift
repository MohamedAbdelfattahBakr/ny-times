//
//  ny_timesTests.swift
//  ny-timesTests
//
//  Created by Unit-Test Bot on 07/08/2025.
//

import Foundation
import Testing
@testable import ny_times

// MARK: - Mock repository
final class MockArticleRepository: ArticleRepository {
    var capturedCriteria: FetchCriteria?
    var result: [Article]  = []
    var error: Error?

    func mostPopular(_ criteria: FetchCriteria) async throws -> [Article] {
        capturedCriteria = criteria
        if let error { throw error }
        return result
    }
}

// MARK: - Use-case tests
struct FetchArticlesUseCaseTests {

    @Test
    func execute_returnsData_andForwardsCriteria() async throws {
        let repo = MockArticleRepository()
        let sample: [Article] = [.stub(id: 1), .stub(id: 2)]
        repo.result = sample
        let criteria = FetchCriteria(type: .mostViewed, period: "1")
        let useCase = FetchArticlesUseCase(repository: repo)

        let output = try await useCase.execute(with: criteria)

        #expect(repo.capturedCriteria == criteria)
        #expect(output.count == 2)
    }

    @Test
    func execute_propagatesRepositoryError() async throws {
        let repo = MockArticleRepository()
        repo.error = URLError(.badServerResponse)
        let useCase = FetchArticlesUseCase(repository: repo)

        do {
            _ = try await useCase.execute(with: .init(type: .mostViewed, period: "1"))
            #expect(false, "Expected error but got success")
        } catch {
            #expect(true)
        }
    }
}

// MARK: - View-model tests
struct ArticleListViewModelTests {

    /// Helper that instantiates the VM with a mocked repo,
    /// waits briefly for the async `fetch()` to finish,
    /// and returns the ready-to-use instance.
    @MainActor
    private func makeViewModel(returning articles: [Article]) async -> ArticleListViewModel {
        let mock = MockArticleRepository()
        mock.result = articles
        let viewModel = ArticleListViewModel(repo: mock)

        // Allow fetch() to complete
        try? await Task.sleep(nanoseconds: 50_000_000)
        return viewModel
    }

    @Test
    func refresh_populatesArticles_andFilteredArticles() async throws {
        // GIVEN
        let sample: [Article] = [.stub(id: 1), .stub(id: 2)]
        let vm = await makeViewModel(returning: sample)

        // THEN
        let articles = await vm.articles
        let filtered = await vm.filteredArticles
        let error = await vm.errorMessage
        let loading = await vm.isLoading

        #expect(articles == sample)
        #expect(filtered == sample)
        #expect(error == nil)
        #expect(loading == false)
    }


    @Test
    func searchText_filtersResults() async throws {
        let sample: [Article] = [
            .stub(id: 1, title: "Test News"),
            .stub(id: 2, title: "Football Highlights")
        ]
        
        let vm = await makeViewModel(returning: sample)

        await MainActor.run {
            vm.searchText = "apple"
        }

        let count = await vm.filteredArticles.count
        let firstTitle = await vm.filteredArticles.first?.title

        #expect(count == 1)
        #expect(firstTitle == "Apple News")
    }

    @Test
    func sortOption_titleSortsAlphabetically() async throws {
        let sample: [Article] = [
            .stub(id: 1, title: "Zebra Story"),
            .stub(id: 2, title: "Alpha Story")
        ]
        
        let vm = await makeViewModel(returning: sample)

        await MainActor.run {
            vm.selectedSortOption = .title
        }

        let firstTitle = await vm.filteredArticles.first?.title
        #expect(firstTitle == "Test Text")
    }
}
