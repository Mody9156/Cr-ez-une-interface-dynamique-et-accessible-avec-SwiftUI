//
//  ArticleListViewModel.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

class ArticleListViewModel: ObservableObject {
    let catalogProduct: CatalogProduct
    @Published var articleCatalog: [ArticleCatalog] = []
    @Published var favoriteArticles: Set<Int> = []
    @Published var grade: Int = 4

    init(catalogProduct: CatalogProduct) {
        self.catalogProduct = catalogProduct
    }

    enum ArticleListViewModelError: Error {
        case loadArticlesError
    }

    @MainActor
    @discardableResult
    func loadArticles() async throws -> [ArticleCatalog] {
        do {
            let articles = try await catalogProduct.loadArticlesFromURL()
            DispatchQueue.main.async {
                self.articleCatalog = articles
            }
            return articles
        } catch {
            throw ArticleListViewModelError.loadArticlesError
        }
    }

    func reloadArticles() async throws {
        try await loadArticles()
    }

    func toggleFavoris(article: ArticleCatalog) {
        if favoriteArticles.contains(article.id) {
            favoriteArticles.remove(article.id)
        } else {
            favoriteArticles.insert(article.id)
        }
    }

    func isFavoris(article: ArticleCatalog) -> Bool {
        return favoriteArticles.contains(article.id)
    }
}
