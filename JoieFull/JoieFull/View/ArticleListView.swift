import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading){
                    
                    Section(header:Text("Hauts")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .lineSpacing(4.25)
                        .multilineTextAlignment(.leading)) {
                            
                            ScrollView(.horizontal){//Show TOPS
                                
                                LazyHStack {
                                                                    
                                    ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                        ArticleView(article: article,category: "TOPS")
                                    }
                                    
                                }
                            }
                            
                        }.padding(.leading)
                        .padding(.trailing)
                    
                    Section(header:Text("Bas").font(.system(size: 22))
                        .fontWeight(.semibold)
                        .lineSpacing(4.25)
                        .multilineTextAlignment(.leading)) {
                            
                            ScrollView(.horizontal){//Show BOTTOMS
                                
                                LazyHStack {
                                    ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                        ArticleView(article: article,category: "BOTTOMS")
                                    }
                                    
                                }
                            }
                        }.padding(.leading)
                        .padding(.trailing)
                    
                    Section(header:Text("Sacs").font(.system(size: 22))
                        .fontWeight(.semibold)
                        .lineSpacing(4.25)
                        .multilineTextAlignment(.leading)) {
                            
                            ScrollView(.horizontal){//Show ACCESSORIES
                                
                                LazyHStack {
                                    ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                        ArticleView(article: article,category: "ACCESSORIES")
                                    }
                                    
                                }
                            }
                        }.padding(.leading)
                        .padding(.trailing)
                }.onAppear{
                    Task{
                        try? await articleListViewModel.loadArticles()

                    }
                    
                }
            }
        }
    }
}

struct ArticleView: View {
    var article: ArticleCatalog
    var category : String = ""
    var body: some View {
        
        if article.category == category {
            
            VStack {
                
                NavigationLink {
                    DetailView(articleCatalog: [article])
                } label: {
                    ZStack(alignment: .bottomTrailing){
                        
                        AsyncImage(url: URL(string: article.picture.url)) { image in
                            image
                                .resizable()
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 198, height: 297).cornerRadius(20)
                        
                        LikeView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30).padding()
                        
                        
                    }
                }
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(article.name)
                            .font(.system(size: 14))
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
                }
            }
        }
        
    }
}



struct LikeView :View {
    var article: ArticleCatalog
    var width : Double
    var height : Double
    var widthFrame : Double
    var heightFrame : Double
    var body: some View {
        
        HStack{
            ZStack {
                
                Capsule()
                    .fill(.white)
                    .frame(width: widthFrame, height: heightFrame)
                HStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: width, height: height)
                        .foregroundColor(.black)
                      
                    
                    if let likes = article.likes {
                        Text("\(likes)")
                        .foregroundColor(.black)
                        
                    }
                }
                
            }
            
            
        }
        
        
    }
}
