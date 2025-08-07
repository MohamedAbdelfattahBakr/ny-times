//
//  Article.swift
//  ny-times
//
//  Created by Mohamed Bakr on 07/08/2025.
//

import Foundation

struct Article: Codable, Identifiable {
    let uri: String
    let url: String
    let id: Int
    let assetId: Int
    let source: String
    let publishedDate: String
    let updated: String
    let section: String
    let subsection: String
    let nytdsection: String
    let adxKeywords: String
    let column: String?
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let media: [Media]
    let etaId: Int
    
    enum CodingKeys: String, CodingKey {
        case uri, url, id, source, title, abstract, byline, type, section, subsection, nytdsection, column, media
        case assetId = "asset_id"
        case publishedDate = "published_date"
        case updated
        case adxKeywords = "adx_keywords"
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case etaId = "eta_id"
    }
    
    var thumbnailURL: String? {
        return media.first?.mediaMetadata?.first?.url
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: publishedDate) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return publishedDate
    }
}

// MARK: - Article helpers for unit test
extension Article: Equatable {
    public static func == (lhs: Article, rhs: Article) -> Bool { lhs.id == rhs.id }
}

extension Article {
    static func stub(
        id: Int = 0,
        title: String = "Stub Title",
        abstract: String = "Stub Abstract",
        section: String = "Tech",
        date: String = "2025-08-07"
    ) -> Self {
        Article(
            uri: "nyt://article/\(id)",
            url: "https://example.com/article\(id)",
            id: id,
            assetId: id,
            source: "NYTimes",
            publishedDate: date,
            updated: date,
            section: section,
            subsection: "",
            nytdsection: section,
            adxKeywords: "",
            column: nil,
            byline: "By Stub",
            type: "Article",
            title: title,
            abstract: abstract,
            desFacet: [],
            orgFacet: [],
            perFacet: [],
            geoFacet: [],
            media: [],
            etaId: 0
        )
    }
}
