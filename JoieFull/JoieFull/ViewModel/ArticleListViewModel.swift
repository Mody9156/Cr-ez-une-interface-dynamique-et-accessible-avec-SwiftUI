//
//  ArticleListViewModel.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

class ArticleListViewModel : ObservableObject {
//    @Published var articleCatalog : [ArticleCatalog] = Service().load("clothes.json")
    let catalogProduct : CatalogProduct
    @Published var articleCatalog : [ArticleCatalog] = []

    init(catalogProduct: CatalogProduct)    {
        self.catalogProduct = catalogProduct
    }
    
    enum ArticleListViewModelError : Error{
        case loadArticlesError
    }
    
    func loadArticles() async throws -> [ArticleCatalog]{
        
        do{
          let articles = try await catalogProduct.loadArticlesFromURL()
            print("Félicitation la fonction loadArticles est passée ")
            DispatchQueue.main.async {
               self.articleCatalog = articles
                        }
            print("\(articles)")
            return articles
        }catch{
            print("error de la fonction loadArticles ")

            throw ArticleListViewModelError.loadArticlesError
        }
    }
    
    func useLoadArticles() async throws {
        try await loadArticles()
    }
    
}
