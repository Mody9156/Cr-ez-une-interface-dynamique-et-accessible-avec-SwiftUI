//
//  ArticleListViewModel.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

class ArticleListViewModel : ObservableObject {
    @Published var articleCatalog : [ArticleCatalog] = Service().load("clothes.json")
    
    
}
