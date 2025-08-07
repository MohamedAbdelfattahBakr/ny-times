//
//  NYTimesResponse.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

struct NYTimesResponse: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright, results
        case numResults = "num_results"
    }
}
