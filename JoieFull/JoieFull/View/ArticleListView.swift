import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @State var presentArticles: Bool = false
    @State var selectedArticle: ArticleCatalog? = nil
    @State var addInFavoris: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var articleCatalog: ArticleCatalog
    @State var addNewFavoris: Bool = false
    @State private var searchText = ""
    
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView(showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        // Les différentes sections d'articles
                        ArticlesFinder(sectionName: "Hauts", categoryName: "TOPS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder(sectionName: "Bas", categoryName: "BOTTOMS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder(sectionName: "Sacs", categoryName: "ACCESSORIES", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                    }
                    
                    // Affichage du détail si l'appareil est en mode paysage
                    if isDeviceLandscapeMode, let article = selectedArticle {
                        DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                        
                    }
                }
                .onAppear {
                    Task {
                        try? await articleListViewModel.loadArticles()
                    }
                }
            }.background(isDeviceLandscapeMode ? Color("Background") : Color.white)
                .searchable(text: $searchText, prompt: "Rechercher un article")
        }
        
    }
}

// Extraction pour l'affichage des catégories d'articles
struct ShowCategories: View {
    var article: ArticleCatalog
    var category: String = ""
    @Binding var presentArticles: Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?
    @Binding var addInFavoris: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        if article.category == category {
            
            if isDeviceLandscapeMode {
                ExtractionDeviceLandscapeMode(presentArticles: $presentArticles, article: article, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                
                
            } else {
                VStack {
                    NavigationLink {
                        DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: article.picture.url)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 198, height: 198)
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            LikesView(article: article, articleListViewModel: articleListViewModel)
                                .padding()
                        }
                    }
                    .accessibilityLabel(Text("Vous avez sélectionné \(article.name)"))
                    
                    
                    InfoExtract(article: article, articleListViewModel: articleListViewModel, presentArticles: $presentArticles, selectedArticle: $selectedArticle)
                }
            }
        }
    }
}

// Mode paysage
struct ExtractionDeviceLandscapeMode: View {
    @Binding var presentArticles: Bool
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?
    @Binding var addInFavoris: Bool
    @State private var scale: CGFloat = 1.0 // Échelle de l'image
    @State private var lastScale: CGFloat = 1.0 // Dernière échelle appliquée
    
    func toggleBackground(id:Int){
        var array : [Int] = []
        for index in 1...id {
            array.append(index)
            
            print("index:\(String(describing: array.last))")
        }
    }
    
    var body: some View {
        
        VStack {
            Button {
                selectedArticle = (selectedArticle == article) ? nil : article
                if let selectedArticleId = selectedArticle {
                    print("selectedArticle=\(selectedArticleId.id)")
                    toggleBackground(id: selectedArticleId.id)
                }
                
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: article.picture.url)) { image in
                        image
                            .resizable()
                            .frame(width: 221.52, height: 254.47)
                            .cornerRadius(20)
                        
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                    LikesView(article: article, articleListViewModel: articleListViewModel)
                        .padding()
                }
                .overlay(
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedArticle?.id == article.id  ? Color("Cyan") : .clear, lineWidth: 3)
                    
                )
                
                
            }
            .accessibilityLabel(Text("Vous avez sélectionné \(article.name)"))
            
            InfoExtract(article: article, articleListViewModel: articleListViewModel, presentArticles: $presentArticles, selectedArticle: $selectedArticle)
        }
    }
}

// Vue pour les likes
struct LikesView: View {
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    var width: Double = 14.01
    var height: Double = 12.01
    var widthFrame: Double = 60
    var heightFrame: Double = 30
    
    var body: some View {
        HStack {
            ZStack {
                Capsule()
                    .fill(.white)
                    .frame(width: widthFrame, height: heightFrame)
                
                HStack {
                    Image(systemName: articleListViewModel.isFavoris(article: article) ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: width, height: height)
                        .foregroundColor(articleListViewModel.isFavoris(article: article) ? .yellow : .black)
                    
                    if let likes = article.likes {
                        Text("\(articleListViewModel.isFavoris(article: article) ? (likes + 1) : likes)")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

// Vue d'informations sur l'article
struct InfoExtract: View {
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var presentArticles : Bool
    @Binding var selectedArticle: ArticleCatalog?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(article.name)
                    .font(.custom("SF Pro", size: 18))
                    .fontWeight(.medium)
                    .lineSpacing(2.71)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : .black)
                
                Text("\(article.price, format: .number.rounded(increment: 10.0))€")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .lineSpacing(2.71)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : .black)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("AccentColor"))
                    
                    Text("\(Double(articleListViewModel.grade), format: .number.rounded(increment: 0.1))")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .lineSpacing(2.71)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(selectedArticle?.id == article.id  ? Color("Cyan") : .black)
                }
                
                Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                    .strikethrough()
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .lineSpacing(2.71)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : .black)
                    .opacity(selectedArticle?.id == article.id ? 1 : 0.7)
            }
        }
    }
}

// Vue pour trouver les articles dans chaque section
struct ArticlesFinder: View {
    var sectionName: String
    var categoryName: String
    @Binding var presentArticles: Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?
    @Binding var searchText: String
    @Binding var addInFavoris: Bool
    
    var searchResults: [ArticleCatalog] {
        if searchText.isEmpty {
            return articleListViewModel.articleCatalog
        } else {
            
            return articleListViewModel.articleCatalog.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Section(header: Text(searchText.isEmpty ? sectionName : "")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .lineSpacing(4.25)
                .multilineTextAlignment(.leading)) {
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(searchResults.sorted(by: {$0.name<$1.name}), id: \.name) { article in
                                ShowCategories(article: article, category: categoryName, presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                            }
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleListView(articleListViewModel: ArticleListViewModel(catalogProduct: CatalogProduct()), presentArticles: true, selectedArticle: ArticleCatalog(id: 3, picture: URLBuilder(url: "", description: ""), name: "", category: "", price: 33.33, original_price: 22), addInFavoris: true, articleCatalog: ArticleCatalog(id: 2, picture: URLBuilder(url: "", description: ""), name: "", category: "", likes: 3, price: 3.3, original_price: 33.3), addNewFavoris: true)
//    }
//}
