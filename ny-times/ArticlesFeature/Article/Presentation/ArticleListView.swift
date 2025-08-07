//
//  ArticleListView.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import SwiftUI

struct ArticleListView: View {
    @EnvironmentObject var viewModel: ArticleListViewModel
    @State private var selectedArticle: Article?
    @State private var selectedCardFrame: CGRect = .zero
    @Namespace private var cardNamespace
    
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    appHeader
                    searchBar
                    timePeriodSegment
                    sortFilterButton
                    
                    if viewModel.isLoading && viewModel.articles.isEmpty {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(errorMessage)
                    } else {
                        articlesList
                    }
                }
                .refreshable {
                    viewModel.refresh()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showingSortSheet) {
            sortSheet
        }
        .sheet(isPresented: $viewModel.showingFilterSheet) {
            filterSheet
        }
        .overlay(
            Group {
                if let article = selectedArticle {
                    ArticleDetailView(
                        article: article,
                        namespace: cardNamespace,
                        onDismiss: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedArticle = nil
                            }
                        }
                    )
                    .zIndex(1)
                }
            }
        )
    }
    
    private var appHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Articles")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button {
                    viewModel.refresh()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                        .animation(Animation.repeatWhile(viewModel.isLoading), value: viewModel.isLoading)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16))
            
            TextField("Search articles...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var timePeriodSegment: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Picker("Time Period", selection: Binding(
                    get: { viewModel.selectedTimePeriod },
                    set: { viewModel.selectedTimePeriod = $0 }
                )) {
                    Text("1 Day").tag("1")
                    Text("7 Days").tag("7")
                    Text("30 Days").tag("30")
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.systemBackground))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    
    private var sortFilterButton: some View {
        HStack {
            Text(viewModel.selectedSortOption.rawValue)
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Spacer()
            
            Button {
                viewModel.showingSortSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 16, weight: .medium))
                    Text("Filter")
                        .font(.subheadline)
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var articlesList: some View {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredArticles) { article in
                    ArticleCardView(
                        article: article,
                        namespace: cardNamespace,
                        isSelected: selectedArticle?.id == article.id
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedArticle = article
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Color.clear.frame(height: 20)
            }
            .padding(.vertical, 12)
    }
    
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<6) { _ in
                    ArticleCardPlaceholder()
                        .padding(.horizontal, 16)
                }
                Color.clear.frame(height: 20)
            }
            .padding(.top, 12)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                viewModel.retry()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var sortSheet: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Sort Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sort By")
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                        
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button {
                                viewModel.selectedSortOption = option
                            } label: {
                                HStack {
                                    Image(systemName: option.icon)
                                        .foregroundColor(.blue)
                                        .frame(width: 24)
                                    
                                    Text(option.rawValue)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if viewModel.selectedSortOption == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                            .bold()
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    viewModel.selectedSortOption == option
                                    ? Color.blue.opacity(0.1)
                                    : Color.clear
                                )
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Article Type")
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(PopularArticleType.allCases, id: \.self) { type in
                                articleTypeFilterButton(for: type)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Button {
                        viewModel.showingSortSheet = false
                    } label: {
                        Text("Apply")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.blue, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.showingSortSheet = false
                    }
                }
            }
        }
        .presentationDetents([.height(600)])
    }
    
    private func articleTypeFilterButton(for type: PopularArticleType) -> some View {
        let isSelected = viewModel.selectedArticleType == type
        
        return Button {
            viewModel.selectedArticleType = type
        } label: {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 20)
                
                Text(type.rawValue)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                isSelected ? Color.blue : Color(.systemGray6),
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
    }
    
    private var filterSheet: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    articleTypeSection
                    dayPeriodSection
                    
                    applyFiltersButton
                }
                .padding(20)
            }
            .navigationTitle("Filter Articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        viewModel.showingFilterSheet = false
                    }
                }
            }
        }
        .presentationDetents([.height(600)])
    }
    
    private var articleTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Article Type")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(PopularArticleType.allCases, id: \.self) { type in
                    articleTypeButton(for: type)
                }
            }
        }
    }
    
    private func articleTypeButton(for type: PopularArticleType) -> some View {
        let isSelected = viewModel.selectedArticleType == type
        
        return Button {
            viewModel.selectedArticleType = type
        } label: {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 24)
                
                Text(type.rawValue)
                    .font(.body.bold())
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(12)
            .background(
                isSelected ? Color.blue : Color.clear,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
    }
    
    private var dayPeriodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text("Time Period")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 12) {
                ForEach(dayPeriodOptions, id: \.period) { option in
                    dayPeriodButton(for: option)
                }
            }
        }
    }
    
    private var dayPeriodOptions: [(period: String, title: String, subtitle: String)] {
        [
            (APIConstants.Endpoints.TimePeriods.oneDay, "1 Day", "Latest"),
            (APIConstants.Endpoints.TimePeriods.sevenDays, "7 Days", "This Week"),
            (APIConstants.Endpoints.TimePeriods.thirtyDays, "30 Days", "This Month")
        ]
    }
    
    private func dayPeriodButton(for option: (period: String, title: String, subtitle: String)) -> some View {
        let isSelected = viewModel.selectedTimePeriod == option.period
        
        return Button {
            viewModel.selectedTimePeriod = option.period
        } label: {
            VStack(spacing: 4) {
                Text(option.title)
                    .font(.headline.bold())
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(option.subtitle)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                isSelected ? Color.purple : Color.clear,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.purple : Color.purple.opacity(0.5), lineWidth: 2)
            )
        }
    }
    
    private var applyFiltersButton: some View {
        Button {
            viewModel.updateFilters(
                type: viewModel.selectedArticleType,
                section: viewModel.selectedSection,
                timePeriod: viewModel.selectedTimePeriod
            )
            viewModel.showingFilterSheet = false
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Apply Filters")
            }
            .font(.headline.bold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
        .padding(.horizontal, 20)
    }
}

