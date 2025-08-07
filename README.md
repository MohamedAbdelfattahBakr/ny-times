# 📰 ArticlesFeature – NY Times iOS App

A modular SwiftUI implementation for listing and reading New York Times articles.
This feature is designed for scalability, MVVM layering, and a clean user experience.

---

##  Features

- Scrollable, responsive article list
- Time segment (1 Day, 7 Days, 30 Days) and article type filters
- Sort & filter using modal sheets with clean UI
- Detail view with smooth transition using `matchedGeometryEffect`
- Graceful error handling and loading states using shimmer loading
- Organized with `Domain`, `Presentation`, `Repository`, `ViewModels`, and `Support`
                                    

---
 ## 📁 Module Structure

                                        ArticlesFeature/
                                        ├── Article/
                                        │   ├── Domain/
                                        │   │   ├── Model/
                                        │   │   │   ├── Article.swift
                                        │   │   │   ├── Media.swift
                                        │   │   │   ├── NYTimesResponse.swift
                                        │   │   │   └── SortOption.swift
                                        │   │   ├── Repository/
                                        │   │   │   └── ArticleRepository.swift
                                        │   │   └── UseCases/
                                        │
                                        │   ├── Presentation/
                                        │   │   ├── ArticleCardView.swift
                                        │   │   ├── ArticleDetailView.swift
                                        │   │   ├── ArticleListView.swift
                                        │   │   └── ViewModels/
                                        │   │       └── ArticleListViewModel.swift
                                        │
                                        ├── Constants/
                                        │   └── APIConstants.swift
                                        │
                                        ├── Data/
                                        │   └── Services/
                                        │       ├── NetworkError.swift
                                        │       ├── NYTimesService.swift
                                        │       └── NYTimesURLBuilder.swift
                                        │
                                        ├── Extensions/
                                        │   └── Animation+Extensions.swift
                                        │
                                        ├── Resources/
                                        │   └── Assets.xcassets
                                        │
                                        ├── Support/
                                        │   ├── ArticleCardPlaceholder.swift
                                        │   ├── ScrollOffsetKey.swift
                                        │   └── ShimmerViewModifier.swift
