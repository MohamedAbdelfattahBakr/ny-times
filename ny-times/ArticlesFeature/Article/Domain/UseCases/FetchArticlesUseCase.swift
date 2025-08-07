//
//  FetchArticlesUseCase.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

struct FetchArticlesUseCase {
    private let repo: ArticleRepository
    init(repository: ArticleRepository) { self.repo = repository }

    func execute(with criteria: FetchCriteria) async throws -> [Article] {
        try await repo.mostPopular(criteria)
    }
}
