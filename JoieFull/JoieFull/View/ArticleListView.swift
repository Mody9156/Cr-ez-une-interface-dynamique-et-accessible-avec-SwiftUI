import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    
                    Section(header:Text("Hauts")) {
                        ScrollView(.horizontal){//Show TOPS
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "TOPS")
                                }
                                
                            }
                        }
                        
                    }.padding()
                    
                    Section(header:Text("Bas")) {
                        ScrollView(.horizontal){//Show BOTTOMS
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "BOTTOMS")
                                }
                                
                            }
                        }
                    }.padding()
                    
                    Section(header:Text("Sacs").font(.title).fontWeight(.bold).foregroundColor(.black).multilineTextAlignment(.leading)) {
                        
                        ScrollView(.horizontal){//Show ACCESSORIES
                            
                            LazyHStack {
                                ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                    ArticleView(article: article,category: "ACCESSORIES")
                                }
                                
                            }
                        }
                    }.padding()
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
            AsyncImage(url: URL(string: article.picture.url)) { image in
                image
                    .resizable()
                    
            } placeholder: {
                ProgressView()
            }
            .frame(width: 198, height: 198).cornerRadius(10)
        }
        
        
    }
}
