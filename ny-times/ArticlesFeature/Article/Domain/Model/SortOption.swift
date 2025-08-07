//
//  SortOption.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import Foundation

enum SortOption: String, CaseIterable {
    case date = "Date"
    case title = "Title"
    case section = "Section"
    
    var icon: String {
        switch self {
        case .date:
            return "clock.fill"
        case .title:
            return "textformat.abc"
        case .section:
            return "folder.fill"
        }
    }
}

enum PopularArticleType: String, CaseIterable {
    case mostViewed = "Most Viewed"
    case mostShared = "Most Shared"
    case mostEmailed = "Most Emailed"
    
    var icon: String {
        switch self {
        case .mostViewed:  return "eye.fill"
        case .mostShared:  return "square.and.arrow.up.fill"
        case .mostEmailed: return "envelope.fill"
            
        }
    }
    
    var endpoint: String {
        switch self {
        case .mostViewed: return "viewed"
        case .mostShared: return "shared"
        case .mostEmailed: return "emailed"
            
        }
    }
}
