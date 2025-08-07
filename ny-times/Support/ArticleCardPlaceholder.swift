//
//  ArticleCardPlaceholder.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//

import SwiftUI

struct ArticleCardPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 12) {
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 14)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 180, height: 14)
                    .shimmer()
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 10)
                        .shimmer()
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 22)
                        .shimmer()
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }
}
