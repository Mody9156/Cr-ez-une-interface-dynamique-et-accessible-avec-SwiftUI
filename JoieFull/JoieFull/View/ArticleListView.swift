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
        VStack{
            ScrollView {
            ForEach(articleListViewModel.articleCatalog,id: \.name) { article  in
               
                    if article.category == "TOPS" {
                        VStack(alignment: .top){
                            AsyncImage(url: URL(string: article.picture.url))
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                            
                        }
                    }
                }
            }
        }
        
        
        
    }
}

