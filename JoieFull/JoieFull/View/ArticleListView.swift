//
//  ArticleListView.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel : ArticleListViewModel
    
    var body: some View {
        
        ForEach(articleListViewModel.articleCatalog,id: \.name) { article  in 
            Text(article.name)
        }
      
        
    }
}

