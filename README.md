# 📰 ArticlesFeature – NY Times iOS App

A modular SwiftUI implementation for listing and reading New York Times articles.
This feature is designed for **scalability**, **MVVM layering**, and a **clean user experience**.

---

## 🚀 Features

- 📱 Scrollable, responsive article list
- ⏱ Time segment filters (1 Day, 7 Days, 30 Days)
- 🔍 Sort & filter options via modal sheets
- ✨ Detail view with `matchedGeometryEffect` transition
- 💡 Graceful error handling and shimmer loading states
- 🧱 Modular architecture with clean separation of concerns

---
## 🛠️ Getting Started
                                        
### ✅ Prerequisites

- Xcode 15 or later
- iOS 17+
- Swift 5.9+
---

## 🔁 Clone and Run

```bash
git clone --branch main https://github.com/MohamedAbdelfattahBakr/ny-times
cd ny-times

## 📁 Module Structure
                                        
ArticlesFeature/
├── Article/
│ ├── Domain/
│ │ ├── Model/
│ │ │ ├── Article.swift
│ │ │ ├── Media.swift
│ │ │ ├── NYTimesResponse.swift
│ │ │ └── SortOption.swift
│ │ ├── Repository/
│ │ │ └── ArticleRepository.swift
│ │ └── UseCases/
│
│ ├── Presentation/
│ │ ├── ArticleCardView.swift
│ │ ├── ArticleDetailView.swift
│ │ ├── ArticleListView.swift
│ │ └── ViewModels/
│ │ └── ArticleListViewModel.swift
│
├── Constants/
│ └── APIConstants.swift
│
├── Data/
│ └── Services/
│ ├── NetworkError.swift
│ ├── NYTimesService.swift
│ └── NYTimesURLBuilder.swift
│
├── Extensions/
│ └── Animation+Extensions.swift
│
├── Resources/
│ └── Assets.xcassets
│
├── Support/
│ ├── ArticleCardPlaceholder.swift
│ ├── ScrollOffsetKey.swift
│ └── ShimmerViewModifier.swift
