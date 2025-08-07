//
//  ArticleCardView.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import SwiftUI

struct ArticleCardView: View {
    let article: Article
    let namespace: Namespace.ID
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: article.thumbnailURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.gray.opacity(0.5))
                                    
                                    Text("NY Times")
                                        .font(.caption.bold())
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                            }
                    }
                    .frame(height: 200)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                    .matchedGeometryEffect(
                        id: "image-\(article.id)",
                        in: namespace,
                        properties: .frame,
                        anchor: .center
                    )
                    
                    Text(article.section.uppercased())
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .shadow(radius: 2)
                        )
                        .padding(16)
                        .matchedGeometryEffect(
                            id: "badge-\(article.id)",
                            in: namespace,
                            properties: .position
                        )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(article.title)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Text(article.abstract)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(article.byline)
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Text(article.formattedDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .matchedGeometryEffect(
                            id: "metadata-\(article.id)",
                            in: namespace,
                            properties: .position
                        )
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("Read")
                                .font(.caption.bold())
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: Capsule()
                        )
                    }
                }
                .padding(20)
            }
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(
                        color: .black.opacity(isPressed ? 0.05 : 0.1),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
                    .matchedGeometryEffect(
                        id: "card-\(article.id)",
                        in: namespace,
                        properties: .frame
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isSelected ? 0.1 : 1)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = false
                    }
                }
        )
    }
}
