import SwiftUI
struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @State var presentArticles: Bool = false
    @State var selectedArticle: ArticleCatalog? // Ajouter une variable d'état pour l'article sélectionné
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        // Passer les bindings aux ArticlesFinder (ici on n'a pas la définition, mais ça doit fonctionner de manière similaire)
                        ArticlesFinder( sectionName: "Hauts", categoryName: "TOPS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle)
                        
                        ArticlesFinder( sectionName: "Bas", categoryName: "BOTTOMS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle)
                        
                        ArticlesFinder( sectionName: "Sacs", categoryName: "ACCESSORIES", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle)
                    }
                    .onAppear {
                        Task {
                            try? await articleListViewModel.loadArticles()
                        }
                    }
                    
                    
                }
            }
               
            
        }
    }
}

struct ShowCategories: View {
    var article: ArticleCatalog
    var category : String = ""
    @Environment (\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var presentArticles : Bool
    @Binding var selectedArticle: ArticleCatalog? // Binding pour l'article sélectionné
    
    
    var isDeviceLandscapeMode : Bool{
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        
        if article.category == category {
            
            VStack {
                
                
                if isDeviceLandscapeMode {
                   
//                    // NavigationLink pour afficher DetailView si un article est sélectionné
//                    if let selectedArticle = selectedArticle {
//                        NavigationLink(destination: DetailView(articleCatalog: selectedArticle), isActive: $presentArticles) {
//                            EmptyView()
//                        }
//                    }
                }else{
                    //
                    NavigationLink {
                        
                        DetailView(articleCatalog: article)
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
                            
                            LikesView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30)
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

struct ArticlesFinder: View {
    var sectionName : String
    var categoryName : String
    @Binding var presentArticles : Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog? // @Binding pour l'article sélectionné
    
    var body: some View {
        VStack {
            Section(header:Text(sectionName)
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .lineSpacing(4.25)
                .multilineTextAlignment(.leading)) {
                    
                    ScrollView(.horizontal){
                        
                        HStack {
                            
                            ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                                ShowCategories(article: article,category: categoryName, presentArticles: $presentArticles, selectedArticle: $selectedArticle)
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
    
    var body: some View {
        VStack {
            VStack {
                Button {
                    presentArticles.toggle()
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
                        
                        LikesView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30)
                            .padding()
                    }.border(presentArticles ? .blue : .clear, width:3)
                    
                    
                    
                }
            }.accessibilityLabel(Text("You select \(article.name)")).sheet(isPresented: $presentArticles) {
                DetailView(articleCatalog: article)
            }
            
            InfoExtract(article: article)
        }
    }
}

struct InfoExtract: View {
    var article: ArticleCatalog
    
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
                    if let article = article.likes {
                        
                        Text("\(article)")
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
