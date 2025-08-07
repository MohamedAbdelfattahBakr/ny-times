//
//  NYTimesURLBuilder.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

enum NYTimesURLBuilder {
    static func buildURL(
        endpoint: String,
        period: String
    ) -> URL? {
        let base = APIConstants.baseURL
        let full = "\(base)/\(endpoint)/\(period).json"

        var comps = URLComponents(string: full)
        comps?.queryItems = [URLQueryItem(name: "api-key", value: APIConstants.apiKey)]
        return comps?.url
    }
}
