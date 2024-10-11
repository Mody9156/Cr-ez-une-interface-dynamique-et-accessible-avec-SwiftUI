import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading){
                    
                    Section(header:Text("Hauts").font(.title).fontWeight(.medium).foregroundColor(.black).multilineTextAlignment(.leading)) {
                        ScrollView(.horizontal){//Show TOPS
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "TOPS")
                                }
                                
                            }
                        }
                        
                    }.padding(.leading)
                        .padding(.trailing)
                    
                    Section(header:Text("Bas").font(.title).fontWeight(.medium).foregroundColor(.black).multilineTextAlignment(.leading)) {
                        ScrollView(.horizontal){//Show BOTTOMS
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "BOTTOMS")
                                }
                                
                            }
                        }
                    }.padding(.leading)
                        .padding(.trailing)
                    
                    Section(header:Text("Sacs").font(.title).fontWeight(.medium).foregroundColor(.black).multilineTextAlignment(.leading)) {
                        
                        ScrollView(.horizontal){//Show ACCESSORIES
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "ACCESSORIES")
                                }
                                
                            }
                        }
                    }.padding(.leading)
                    .padding(.trailing)
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
                AsyncImage(url: URL(string: article.picture.url)) { image in
                    image
                    .resizable()
                    
                } placeholder: {
                    ProgressView()
                }
            .frame(width: 198, height: 198).cornerRadius(20)
                
                HStack {
                    VStack {
                        Text(article.name)
                        Text("\(article.price)€")
                    }
                    Spacer()
                    Image(systemName: "star.fill")
                    Text("\(article.likes)")
                }
            }
        }
        
        
    }
}
