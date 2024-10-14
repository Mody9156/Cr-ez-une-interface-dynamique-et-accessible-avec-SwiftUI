//
//  JoieFullApp.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import SwiftUI

@main
struct JoieFullApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            ArticleListView(articleListViewModel: ArticleListViewModel(catalogProduct: CatalogProduct()), articleCatalog: [ArticleCatalog(id: 2, picture: URLBuilder(url: "", description: ""), name: "", category: "", likes: 2, price: 33, original_price: 33)])
        }
    }
}
