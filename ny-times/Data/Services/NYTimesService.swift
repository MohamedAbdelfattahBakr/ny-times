//
//  NYTimesService.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation
import OSLog

final class NYTimesService: ArticleRepository {

    // MARK: – Private
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let log = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "NYTimesService",
        category:  "network"
    )

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: – ArticleRepository
    func mostPopular(_ crt: FetchCriteria) async throws -> [Article] {
        guard let url = NYTimesURLBuilder.buildURL(
            endpoint: crt.type.endpoint,
            period: crt.period
        ) else {
            throw NetworkError.invalidURL
        }

        log.debug("🔗 Requesting \(url, privacy: .public)")

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let payload = try decoder.decode(NYTimesResponse.self, from: data)
        return payload.results
    }
}
