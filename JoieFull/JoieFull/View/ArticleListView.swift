//
//  ArticleListView.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyHStack(spacing: 10) {
                    ForEach(articleListViewModel.articleCatalog, id: \.name){ article in
                        ArticleView(article: article)
                    }
                    .navigationTitle("Articles")
                    .padding()
                }
            }
        }
    }
}

struct ArticleView: View {
     var article : ArticleCatalog
    var body: some View {
       
            if article.category == "TOPS" || article.category == "BOTTOMS" {
                VStack {
                    AsyncImage(url: URL(string: article.picture.url)) { image in
                        image
                            .resizable()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                }
                .padding()
        
        }
    }
}
