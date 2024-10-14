import SwiftUI

struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @Environment (\.verticalSizeClass) private var verticalSizeClass
    @Environment (\.horizontalSizeClass) private var horizontalSizeClass
    let articleCatalog : [ArticleCatalog]
    
    //Iphone
    var isDeviceLandscapeMode : Bool{
         horizontalSizeClass == .regular
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators:true) {
                VStack(alignment: .leading){
                    if isDeviceLandscapeMode {
                        HStack {
                            
                            ArticlesFinder(sectionName: "Hauts", categoryName: "TOPS", articleListViewModel: articleListViewModel)
                            ArticlesFinder(sectionName: "Bas", categoryName: "BOTTOMS", articleListViewModel: articleListViewModel)
                            
                            ArticlesFinder(sectionName: "Sacs", categoryName: "ACCESSORIES", articleListViewModel: articleListViewModel)
                            Spacer()
                            DetailView(articleCatalog: articleCatalog)
                        }
                        
                       
                       
                    }else{
                        ArticlesFinder(sectionName: "Hauts", categoryName: "TOPS", articleListViewModel: articleListViewModel)
                        
                        ArticlesFinder(sectionName: "Bas", categoryName: "BOTTOMS", articleListViewModel: articleListViewModel)
                        
                        ArticlesFinder(sectionName: "Sacs", categoryName: "ACCESSORIES", articleListViewModel: articleListViewModel)
                       
                        
                    }
                    
                }.onAppear{
                    Task{
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
                        .frame(width: 198, height: 297)
                        .cornerRadius(20)
                        
                        LikesView(article: article,width: 14.01,height: 12.01,widthFrame: 60,heightFrame: 30)
                            .padding()
                    }
                    
                }.accessibilityLabel(Text("You select \(article.name)"))
                
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
    @StateObject var articleListViewModel: ArticleListViewModel
    var body: some View {
        Section(header:Text(sectionName)
            .font(.system(size: 22))
            .fontWeight(.semibold)
            .lineSpacing(4.25)
            .multilineTextAlignment(.leading)) {
                
                ScrollView(.horizontal){//Show TOPS
                    
                    LazyHStack {
                        
                        ForEach(articleListViewModel.articleCatalog, id: \.name) { article in
                            ShowCategories(article: article,category: categoryName)
                        }
                        
                    }
                }
                
            }.padding(.leading)
            .padding(.trailing)
    }
}
