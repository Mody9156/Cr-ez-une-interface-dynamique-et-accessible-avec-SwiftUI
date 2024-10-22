import SwiftUI
struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @State var presentArticles: Bool = false
    @State var selectedArticle: ArticleCatalog? = nil
    @State  var addInFavoris : Bool = false
    @Environment (\.horizontalSizeClass) private var horizontalSizeClass
    var articleCatalog : ArticleCatalog
    @State var addNewFavoris : Bool = false
    var isDeviceLandscapeMode : Bool{
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView(showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        
                        ArticlesFinder( sectionName: "Hauts", categoryName: "TOPS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder( sectionName: "Bas", categoryName: "BOTTOMS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder( sectionName: "Sacs", categoryName: "ACCESSORIES", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                    }
                    
                    if isDeviceLandscapeMode {
                        if let article =  selectedArticle {
                            DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                            
                        }
                        
                    }
                    
                }.onAppear {
                    Task {
                        
                        try? await articleListViewModel.loadArticles()
                    }
                }
            }
        }
    }
}

struct ShowCategories: View {
    var article: ArticleCatalog
    var category : String = ""
    @Binding var presentArticles : Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog? // Utilisation de l'article sélectionné
    @Binding var addInFavoris : Bool
    @Environment (\.horizontalSizeClass) private var horizontalSizeClass
    var isDeviceLandscapeMode : Bool{
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        
        if article.category == category {
            
            if isDeviceLandscapeMode {
                
                ExtractionDeviceLandscapeMode(presentArticles: $presentArticles, article: article, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                
            }else{
                VStack {
                    
                    NavigationLink {
                        
                        DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                        
                    } label: {
                        ZStack(alignment: .bottomTrailing){
                            
                            AsyncImage(url: URL(string: article.picture.url)) { image in
                                image
                                    .resizable()
                                
                                    .scaledToFit()
                                    .frame(width: 198, height: 198)
                                    .cornerRadius(20)
                                
                            } placeholder: {
                                ProgressView()
                            }
                           
                            
                            LikesView(article: article, articleListViewModel: articleListViewModel)
                                .padding()
                        }
                        
                    }.accessibilityLabel(Text("You select \(article.name)")).navigationTitle( "Home").navigationBarTitleDisplayMode(.inline)
                    
                    
                    InfoExtract(article: article, articleListViewModel: articleListViewModel)
                    
                }
                
            }
            
        }
        
    }
}



struct ExtractionDeviceLandscapeMode : View{
    @Binding var presentArticles : Bool
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?  // Suivre l'article sélectionné
    @Binding var addInFavoris : Bool
    var body: some View {
        VStack {
            VStack {
                Button {
                    selectedArticle = (selectedArticle == article) ? nil : article
                } label: {
                    ZStack(alignment: .bottomTrailing){
                        
                        AsyncImage(url: URL(string: article.picture.url)) { image in
                            image
                                .resizable()
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 198, height: 297)
                        .cornerRadius(20)
                        
                        LikesView(article: article, articleListViewModel: articleListViewModel)
                            .padding()
                    }.border(presentArticles ? .blue : .clear, width:3)
                    
                    
                    
                }
            }.accessibilityLabel(Text("You select \(article.name)"))
            
            InfoExtract(article: article, articleListViewModel: articleListViewModel)
        }
    }
}

struct LikesView :View {
    var article: ArticleCatalog
    var width : Double = 14.01
    var height : Double = 12.01
    var widthFrame : Double = 60
    var heightFrame : Double = 30
    @StateObject var articleListViewModel : ArticleListViewModel
    var body: some View {
        
        HStack{
            ZStack {
                
                Capsule()
                    .fill(.white)
                    .frame(width: widthFrame, height: heightFrame)
                
                HStack{
                    Image(systemName: articleListViewModel.isFavoris(article: article) ? "heart.fill":"heart")
                        .resizable()
                        .frame(width: width, height: height)
                        .foregroundColor(articleListViewModel.isFavoris(article: article) ? .yellow : .black)
                    
                    if let likes = article.likes {
                        
                        
                        Text("\(articleListViewModel.isFavoris(article: article) ? ( likes + 1) :  likes)")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct InfoExtract: View {
    var article: ArticleCatalog
    @StateObject var articleListViewModel : ArticleListViewModel
    
    var body: some View {
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
                    
                    Text("\(Double(articleListViewModel.grade), format: .number.rounded(increment: 0.1))")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .lineSpacing(2.71)
                        .multilineTextAlignment(.leading)
                    
                }
                
                
                Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                    .strikethrough()
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .lineSpacing(2.71)
                    .multilineTextAlignment(.leading).foregroundColor(.gray)
            }
        }
    }
}

struct ArticlesFinder: View {
    var sectionName : String
    var categoryName : String
    @Binding var presentArticles : Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?  // Gère l'article sélectionné
    @Binding var addInFavoris : Bool
    var body: some View {
        VStack(alignment: .leading) {
            Section(header:Text(sectionName)
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .lineSpacing(4.25)
                .multilineTextAlignment(.leading)) {
                    
                    ScrollView(.horizontal){
                        
                        HStack {
                            
                            ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                ShowCategories(article: article,category: categoryName, presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
                            }
                            
                        }
                    }
                    
                }.padding(.leading)
                .padding(.trailing)
            
        }
    }
}
