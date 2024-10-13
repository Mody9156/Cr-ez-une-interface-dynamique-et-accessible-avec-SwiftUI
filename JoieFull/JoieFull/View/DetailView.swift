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
                    
                    Image(systemName: "Share")
                    
                    AsyncImage(url: URL(string: article.picture.url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding()
                        
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    LikeView(article: article,width:
                                20.92,height: 20.92,widthFrame: 90,heightFrame: 40).padding([.bottom, .trailing], 30)
                    
                    
                }
                
            }
        }
        
    }
}

