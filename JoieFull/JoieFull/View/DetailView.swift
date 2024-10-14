//
//  DetailView.swift
//  JoieFull
//
//  Created by KEITA on 13/10/2024.
//

import SwiftUI

struct DetailView: View {
    let articleCatalog: [ArticleCatalog]
    @State private var comment: String = ""
    
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
                        Section {
                            VStack {
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text(article.name).font(.system(size: 14))
                                            .fontWeight(.semibold)
                                            .lineSpacing(2.71)
                                            .multilineTextAlignment(.leading)
                                        Text("\(article.price, format: .number.rounded(increment: 10.0))€").font(.system(size: 14))
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
                                Text(article.picture.description)
                                    .font(.custom("SF Pro", size: 14))
                                    .fontWeight(.regular)
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.leading).padding(.leading).padding(.trailing)
                                
                            }
                        }
                        Section{
                            VStack(alignment: .leading) {
                                HStack {
                                    Image("UserPicture")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width:50)
                                    
                                    HStack {
                                        ImageSystemName(order: 1)
                                        ImageSystemName(order: 2)
                                        ImageSystemName(order: 3)
                                        ImageSystemName(order: 4)
                                        ImageSystemName(order: 5)
                                    }
                                    Spacer()
                                }
                            }
                            ZStack (alignment: .topLeading){
                                Rectangle().frame(width:361,height:117).background(.white).foregroundColor(.white).border(.gray,width:1).cornerRadius(10)
                                TextField("Partagez ici vos impressions sur cette pièce",
                                          text: $comment
                                )
                            }
                        }.padding()
                    }
                    
                }
            }
        }
    }
}

struct ImageSystemName : View {
    @State var foregroundColor : Color = .gray
    @State var showRightColor: Bool = false
    @State var start : String = "star"
    var order : Int
    
    var body: some View {
        
        Button {
            
            showRightColor.toggle()
            
            
            if showRightColor {
                foregroundColor = .yellow
                start = "star.fill"
                
            }else{
                foregroundColor = .gray
                start = "star"
            }
            
            for _ in 1...5 {
                print("\(order)")
                
            }
            
        } label: {
            Image(systemName: start).foregroundColor(foregroundColor)
        }
        
    }
    
}



