//
//  ArticleDetailView.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    let namespace: Namespace.ID
    let onDismiss: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var showContent = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(isDragging ? max(0.1, 0.6 - dragOffset.height / 500) : 0.6)
                    .ignoresSafeArea(.all)
                    .animation(.easeInOut(duration: 0.3), value: isDragging)
                    .onTapGesture {
                        dismissView()
                    }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                GeometryReader { imageGeometry in
                                    AsyncImage(url: URL(string: article.thumbnailURL ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .offset(y: scrollOffset * 0.5)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.4)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .overlay {
                                                VStack(spacing: 12) {
                                                    Image(systemName: "photo.fill")
                                                        .font(.system(size: 48))
                                                        .foregroundColor(.gray.opacity(0.5))
                                                    
                                                    Text("NY Times")
                                                        .font(.title3.bold())
                                                        .foregroundColor(.gray.opacity(0.7))
                                                }
                                            }
                                    }
                                }
                                .frame(height: 400)
                                .clipped()
                                .matchedGeometryEffect(
                                    id: "image-\(article.id)",
                                    in: namespace,
                                    properties: .frame,
                                    anchor: .center
                                )
                                
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.clear,
                                        Color.black.opacity(0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: dismissView) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title)
                                                .foregroundStyle(.white, .black.opacity(0.6))
                                                .background(
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                        .shadow(radius: 2)
                                                )
                                        }
                                        .padding(.trailing, 20)
                                        .padding(.top, 20)
                                    }
                                    Spacer()
                                }
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3).delay(0.2), value: showContent)
                                
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text(article.section.uppercased())
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(.ultraThinMaterial)
                                                    .shadow(radius: 4)
                                            )
                                            .matchedGeometryEffect(
                                                id: "badge-\(article.id)",
                                                in: namespace,
                                                properties: .position
                                            )
                                        Spacer()
                                    }
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 24) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(article.byline)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                            .matchedGeometryEffect(
                                                id: "metadata-\(article.id)",
                                                in: namespace,
                                                properties: .position
                                            )
                                        
                                        Text(article.formattedDate)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock")
                                            .font(.caption)
                                        Text("5 min read")
                                            .font(.caption.bold())
                                    }
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color(.systemGray6))
                                    )
                                    .opacity(showContent ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.3).delay(0.4), value: showContent)
                                }
                                
                                Text(article.title)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.4).delay(0.1), value: showContent)
                                
                                Text(article.abstract)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(8)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.4).delay(0.2), value: showContent)
                                
                                
                                if showContent && !article.desFacet.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 8) {
                                            ForEach(Array(article.desFacet.prefix(5)), id: \.self) { tag in
                                                Text(tag)
                                                    .font(.caption.bold())
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        Capsule()
                                                            .fill(Color(.systemGray5))
                                                    )
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        .padding(.horizontal, 24)
                                    }
                                    .padding(.horizontal, -24)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.4).delay(0.3), value: showContent)
                                }
                                
                                if showContent {
                                    Divider()
                                        .padding(.vertical, 8)
                                        .opacity(showContent ? 1 : 0)
                                        .animation(.easeOut(duration: 0.4).delay(0.4), value: showContent)
                                    
                                    VStack(spacing: 16) {
                                        Link(destination: URL(string: article.url)!) {
                                            HStack {
                                                Image(systemName: "safari")
                                                    .font(.headline)
                                                
                                                Text("Read Full Article")
                                                    .font(.headline.bold())
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.up.right")
                                                    .font(.headline)
                                            }
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(
                                                LinearGradient(
                                                    colors: [.blue, .purple],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                in: RoundedRectangle(cornerRadius: 16)
                                            )
                                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                        }
                                        
                                        HStack(spacing: 12) {
                                            ShareLink(item: URL(string: article.url)!) {
                                                HStack {
                                                    Image(systemName: "square.and.arrow.up")
                                                    Text("Share")
                                                        .font(.subheadline.bold())
                                                }
                                                .foregroundColor(.primary)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 14)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(.regularMaterial)
                                                        .shadow(color: .black.opacity(0.1), radius: 2)
                                                )
                                            }
                                        }
                                    }
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 30)
                                    .animation(.easeOut(duration: 0.4).delay(0.5), value: showContent)
                                }
                                
                                Color.clear.frame(height: 100)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .matchedGeometryEffect(
                                        id: "card-\(article.id)",
                                        in: namespace,
                                        properties: .frame
                                    )
                            )
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .statusBarHidden()
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showContent = true
            }
        }
        .onDisappear {
            showContent = false
        }
    }
    
    private func dismissView() {
        withAnimation(.interpolatingSpring(stiffness: 400, damping: 35)) {
            showContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            onDismiss()
        }
    }
}
