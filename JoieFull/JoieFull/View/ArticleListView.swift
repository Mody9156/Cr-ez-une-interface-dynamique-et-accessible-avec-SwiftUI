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
        NavigationStack {
            ScrollView {
                    LazyHStack(spacing: 10) {
                        ForEach(articleListViewModel.articleCatalog,id: \.name) { article  in
                            if article.category == "TOPS" {
                                Section{
                                    AsyncImage(url: URL(string: article.picture.url)).scaledToFit().cornerRadius(10)
                                        
                                }
                                        
                                 
                                }
                        }
                    }
            }
        }
        }

}

