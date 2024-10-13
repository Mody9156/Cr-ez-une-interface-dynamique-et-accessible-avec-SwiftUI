//
//  DetailView.swift
//  JoieFull
//
//  Created by KEITA on 13/10/2024.
//

import SwiftUI

struct DetailView: View {
    let articleCatalog: [ArticleCatalog]
    var body: some View {
        VStack {
            ForEach(articleCatalog) { article in
                ZStack(alignment: .bottomTrailing){
                    
                    AsyncImage(url: URL(string: article.picture.url)) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    LikeView(article: article).padding()
                    
                    
                }

            }
        }
       
    }
}

