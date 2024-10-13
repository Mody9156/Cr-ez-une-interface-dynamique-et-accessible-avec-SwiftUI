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
                Text(article.name).foregroundColor(.black)
                
                AsyncImage(url: URL(string: article.picture.url)) { image in
                    image
                        .resizable()
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 198, height: 297).cornerRadius(20)
                
            }
        }
       
    }
}

