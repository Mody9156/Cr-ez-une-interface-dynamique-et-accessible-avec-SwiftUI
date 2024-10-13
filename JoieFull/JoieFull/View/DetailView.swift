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
        ScrollView {
            VStack (alignment: .leading){
                ForEach(articleCatalog) { article in
                    
                    ZStack(alignment: .bottomTrailing){
                        
                        ZStack (alignment: .topTrailing){
                            
                            
                            AsyncImage(url: URL(string: article.picture.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .padding()
                                
                                
                            } placeholder: {
                                ProgressView()
                        }
                            ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!) {
                                Label("", image: "Share")
                            }.padding([.top, .trailing], 30)
                        }
                         
                            LikeView(article: article,width:
                                        20.92,height: 20.92,widthFrame: 90,heightFrame: 40).padding([.bottom, .trailing], 30)
                     
                    }
                    VStack {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(article.name).font(.system(size: 28))
                                    .fontWeight(.semibold)
                                    .lineSpacing(2.71)
                                    .multilineTextAlignment(.leading)
                                Text("\(article.price, format: .number.rounded(increment: 10.0))€").font(.system(size: 28))
                                    .fontWeight(.regular).lineSpacing(2.71)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                HStack {
                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                    if let article = article.likes {
                                        
                                        Text("\(article)")
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                            .lineSpacing(2.71)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                
                                Text("\(article.original_price, format: .number.rounded(increment: 10.0))€").strikethrough().font(.system(size: 14))
                                    .fontWeight(.regular)
                                    .lineSpacing(2.71)
                                    .multilineTextAlignment(.leading).foregroundColor(.gray)
                                
                            }
                        }.padding()
                       
                    }
                       
                }
            }
        }
    }
}
