//
//  ArticleListViewModel.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

class ArticleListViewModel: ObservableObject {
    // Propriétés
    let catalogProduct: CatalogProduct
    @Published var articleCatalog: [ArticleCatalog] = []
    @Published var favoriteArticles: Set<Int> = []
    @Published var grade: Int = 4

    // Initialiseur
    init(catalogProduct: CatalogProduct) {
        self.catalogProduct = catalogProduct
    }

    // Enumération des erreurs possibles pour ArticleListViewModel
    enum ArticleListViewModelError: Error {
        case loadArticlesError
    }

    // Charge les articles de manière asynchrone
    @MainActor
    @discardableResult
    func loadArticles() async throws -> [ArticleCatalog] {
        
    
        do {
            let articles = try await catalogProduct.loadArticlesFromURL()
            
                self.articleCatalog = articles
            return articles
        } catch {
            throw ArticleListViewModelError.loadArticlesError
        }
    }

    // Recharge les articles en appelant la méthode loadArticles()
    func reloadArticles() async throws {
        try await loadArticles()
    }

    // Gère l'ajout/suppression d'un article dans les favoris
    func toggleFavoris(article: ArticleCatalog) {
        if favoriteArticles.contains(article.id) {
            favoriteArticles.remove(article.id)
        } else {
            favoriteArticles.insert(article.id)
        }
    }

    // Vérifie si un article est dans les favoris
    func isFavoris(article: ArticleCatalog) -> Bool {
        return favoriteArticles.contains(article.id)
    }
}
