//
//  ArticleListViewModel.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

class ArticleListViewModel : ObservableObject {
    @Published var articles : [ArticleCatalog] = Service().load("clothes")
    
    
}
