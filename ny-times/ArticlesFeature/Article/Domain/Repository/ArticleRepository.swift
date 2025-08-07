//
//  ArticleRepository.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

protocol ArticleRepository {
    func mostPopular(_ criteria: FetchCriteria) async throws -> [Article]
}

struct FetchCriteria: Equatable {
    var type: PopularArticleType
    var period: String
}
