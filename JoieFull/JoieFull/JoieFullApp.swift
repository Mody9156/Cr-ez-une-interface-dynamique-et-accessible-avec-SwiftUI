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
            ArticleListView(articleListViewModel: ArticleListViewModel(catalogProduct: CatalogProduct()), articleCatalog: ArticleCatalog(id: 33, picture: URLBuilder(url: "", description: ""), name: "", category: "", price: 22.33, original_price: 22.22))
        }
    }
}
