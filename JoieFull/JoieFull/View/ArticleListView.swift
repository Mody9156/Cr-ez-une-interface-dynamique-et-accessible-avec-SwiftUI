import SwiftUI
struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @State var presentArticles: Bool = false
    @Environment (\.horizontalSizeClass) private var horizontalSizeClass
    var articleCatalog : ArticleCatalog
    var isDeviceLandscapeMode : Bool{
        horizontalSizeClass == .regular
    }
    @State var selectedArticle: ArticleCatalog? = nil 
    @State var addNewElement  : Bool = false
    var body: some View {
        
        NavigationStack {
            ScrollView(showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        
                        ArticlesFinder( sectionName: "Hauts", categoryName: "TOPS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addNewElement)
                        
                        ArticlesFinder( sectionName: "Bas", categoryName: "BOTTOMS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addNewElement)
                        
                        ArticlesFinder( sectionName: "Sacs", categoryName: "ACCESSORIES", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addNewElement)
                    }
                    
                    if isDeviceLandscapeMode {
                            if let article =  selectedArticle {
                                DetailView(articleCatalog: article, addInFavoris: $addNewElement)
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

                        DetailView(articleCatalog: article, addInFavoris: $addInFavoris)
                        
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
                            
                            LikesView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30, addInFavoris: $addInFavoris)
                                .padding()
                        }
                        
                    }.accessibilityLabel(Text("You select \(article.name)"))
                    
                    
                    InfoExtract(article: article)
                    
                }

                }
           
        }
        
    }
}


struct LikesView :View {
    var article: ArticleCatalog
    var width : Double
    var height : Double
    var widthFrame : Double
    var heightFrame : Double
    @Binding var addInFavoris : Bool
    var body: some View {
            
           
                HStack{
                    ZStack {
                        
                        Capsule()
                            .fill(.white)
                            .frame(width: widthFrame, height: heightFrame)
                        HStack{
                            Image(systemName: addInFavoris ? "heart.fill":"heart")
                                .resizable()
                                .frame(width: width, height: height)
                                .foregroundColor(addInFavoris ? .yellow : .black)
                            
                            
                            if let likes = article.likes {
                                Text("\(addInFavoris ?( likes + 1) :  likes)")
                                    .foregroundColor(.black)
                                
                            }
                        }
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
                        
                        LikesView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30, addInFavoris: $addInFavoris)
                            .padding()
                    }.border(presentArticles ? .blue : .clear, width:3)
                    
                    
                    
                }
            }.accessibilityLabel(Text("You select \(article.name)"))
            
            InfoExtract(article: article)
        }
    }
}

struct InfoExtract: View {
    var article: ArticleCatalog
    var note : Int = 4
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
                    if let article = note {
                        
                        Text("\(Double(article), format: .number.rounded(increment: 0.1))")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .lineSpacing(2.71)
                            .multilineTextAlignment(.leading)
                    }
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
