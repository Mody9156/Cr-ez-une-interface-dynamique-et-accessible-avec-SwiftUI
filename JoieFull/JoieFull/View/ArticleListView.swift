import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal){
                
                LazyHStack {
                    ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                            ArticleView(article: article)
                    }
                
            }
        }
    }
    }
}

struct ArticleView: View {
    var article: ArticleCatalog
    
    var body: some View {
        // Vérifie si l'article appartient aux catégories "TOPS" ou "BOTTOMS"
        if article.category == "TOPS" {
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
