//
//  APIConstants.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

struct APIConstants {
    static let baseURL = "https://api.nytimes.com/svc/mostpopular/v2"
    static let apiKey = "k71edZcqEzTBWlc2lQfBwM96FUMjN9V3"
    static let secret = "d20rOYbAgAPHrDw3"
    
    struct Endpoints {
        static let mostViewed = "/mostviewed"
        static let mostShared = "/mostshared"
        static let mostEmailed = "/mostemailed"
        
        struct Sections {
            static let allSections = "all-sections"
            static let arts = "arts"
            static let business = "business"
            static let politics = "politics"
            static let technology = "technology"
            static let sports = "sports"
        }
        
        struct TimePeriods {
            static let oneDay = "1"
            static let sevenDays = "7"
            static let thirtyDays = "30"
        }
    }
}
