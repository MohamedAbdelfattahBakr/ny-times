//
//  Article.swift
//  ny-times
//
//  Created by Mohamed Bakr on 07/08/2025.
//

import UIKit

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
