import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                Section(header:Text("Hauts")) {
                    ScrollView(.horizontal){//Show TOPS
                        
                        LazyHStack {
                            ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                ArticleView(article: article,category: "TOPS")
                            }
                            
                        }
                    }
                    
                }
                Section(header:Text("Bas")) {
                    ScrollView(.horizontal){//Show BOTTOMS
                        
                        LazyHStack {
                            ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                ArticleView(article: article,category: "BOTTOMS")
                            }
                            
                        }
                    }
                }
                Section(header:Text("Sacs")) {
                    
                    ScrollView(.horizontal){//Show ACCESSORIES
                        
                        LazyHStack {
                            ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                ArticleView(article: article,category: "ACCESSORIES")
                            }
                            
                        }
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
            AsyncImage(url: URL(string: article.picture.url)) { image in
                image
                    .resizable()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
        }
        
        
    }
}
