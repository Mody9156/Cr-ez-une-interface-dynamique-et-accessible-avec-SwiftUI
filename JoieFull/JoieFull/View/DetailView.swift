//
//  DetailView.swift
//  JoieFull
//
//  Created by KEITA on 13/10/2024.
//
import SwiftUI

struct DetailView: View {
    var articleCatalog: ArticleCatalog
    @State var valueCombiner :  [Int] = []
    @StateObject var articleListViewModel : ArticleListViewModel
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                ForEach([articleCatalog]) { article in
                    
                    ZStack(alignment: .bottomTrailing){
                        
                        ZStack (alignment: .topTrailing){
                            
                            AsyncImage(url: URL(string: article.picture.url)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding()
                                        .accessibilityValue("Image représentant \(article.name)")
                                    
                                } else if phase.error != nil {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.gray)
                                        .padding()
                                        .accessibilityValue("Échec du chargement de l'image pour \(article.name)")
                                } else {
                                    ProgressView()
                                }
                            }
                            ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!) {
                                Label("", image: "Share")
                            }
                            .padding([.top, .trailing], 30)
                            .accessibilityLabel("Partager ce contenu")
                        }
                        
                        LikesViewForDetaileView(article: article, articleListViewModel: articleListViewModel)
                            .padding([.bottom, .trailing], 20)
                        
                    }
                    VStack {
                        SupplementData(article: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                        
                        ReviewControl(articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                    }
                    
                }
            }
        }
    }
}

struct LikesViewForDetaileView :View {
    var article: ArticleCatalog
    var width : Double = 20.92
    var height : Double = 20.92
    var widthFrame : Double = 90
    var heightFrame : Double = 40
    @StateObject var articleListViewModel : ArticleListViewModel
    
    var body: some View {
        
        Button {
            
            articleListViewModel.toggleFavoris(article: article)
        } label: {
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
                            let adjustedLikes = articleListViewModel.isFavoris(article: article) ?( likes + 1) :  likes
                            
                            Text("\(adjustedLikes)")
                                .foregroundColor(.black)
                            
                        }
                    }
                }
            }
        }
    }
}

struct ReviewControl: View {
    @State  var comment: String = ""
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner :  [Int]
    @State var textField : Set<String> = []
    @StateObject var articleListViewModel : ArticleListViewModel
    @State var activeStart : Bool = false
    var body: some View {
        Section{
            VStack() {
                
                HStack {
                    Image("UserPicture")
                        .resizable()
                        .frame(width:50)
                        .clipShape(Circle())
                    
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            ImageSystemName(sortArray: index, articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                        }
                    }
                    Spacer()
                }
            }.padding()
            
            VStack(alignment: .leading){
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 117)
                        .background(Color.white)
                        .foregroundColor(.white)
                        .border(Color.gray, width: 1)
                        .opacity(1)
                        .cornerRadius(10)
                    
                    TextField("Partagez ici vos impressions sur cette pièce", text: $comment)
                        .font(.custom("SF Pro", size: 14))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .accessibilityValue("Zone de texte pour vos impressions sur l'article")
                }
                .padding()
                
                Button {
                    
                    if !comment.trimmingCharacters(in: .whitespaces).isEmpty{
                        textField.insert(comment)
                        comment = ""
                        activeStart = true
                        
                    }
                } label: {
                    Text("Envoyer").frame(width: 100,height: 50).background(.orange).foregroundColor(.white).cornerRadius(5)
                    
                }.padding()
                
                if activeStart{
                    ForEach(Array(textField),id: \.self) { text in
                        
                        HStack {
                            Image("UserPicture")
                                .resizable()
                                .frame(width:50)
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading){
                                HStack {
                                    ForEach(valueCombiner, id: \.self) { index in
                                        Image(systemName:"star.fill")
                                            .resizable()
                                            .frame(width: 27.51, height: 23.98)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                Text(text)
                            }
                        }
                        Divider()
                        
                        
                    }
                }
            }.padding()
        }
    }
}

struct ImageSystemName : View {
    var sortArray : Int
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner : [Int]
    @StateObject var articleListViewModel : ArticleListViewModel
    
    var body: some View {
        let showStart =  valueCombiner.contains(sortArray)
        Button {
            
            appendToArray(order: sortArray)
            if showStart {
                valueCombiner.removeAll()
            }
            
        } label: {
            Image(systemName: showStart ?  "star.fill" : "star")
                .resizable()
                .frame(width: 27.51, height: 23.98)
                .foregroundColor(showStart ? .yellow : .gray)
            
        }.accessibilityElement(children: .combine)
            .accessibilityHint("Cliquez pour ajouter ou retirer une étoile. Actuellement \(sortArray) étoiles sélectionnées.")
        
            .accessibilityLabel(showStart
                                
                                ? "Retirer une étoile à cet article" : "Ajouter une étoile cet article")
        
        
    }
    private func appendToArray(order: Int) {
        if valueCombiner.contains(order) {
            valueCombiner.removeAll()
        } else {
            valueCombiner = Array(1...order)
        }
    }
    
    
}

struct SupplementData: View {
    var article : ArticleCatalog
    @Binding var valueCombiner :  [Int]
    @StateObject var articleListViewModel : ArticleListViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack{
                    VStack(alignment: .leading) {
                        
                        Text(article.name)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .lineSpacing(2.71)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(article.price,format: .number.rounded(increment: 10.0))€")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .lineSpacing(2.71)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            let currentRating = valueCombiner.isEmpty ? articleListViewModel.grade : addition()
                            
                            let averageRating = (articleListViewModel.grade + currentRating) / 2
                            
                            Text("\( Double(averageRating), format: .number.rounded(increment: 0.1))")
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
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                Text(article.picture.description)
                    .font(.custom("SF Pro", size: 14))
                    .fontWeight(.regular)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                
            }
            
        }.padding()
    }
    
    func addition()->Int{
        var array = 0
        
        if !valueCombiner.isEmpty {
            if let lastElement = valueCombiner.sorted().last  {
                array = lastElement
                
            }
        }
        
        return array
    }
    
}


//struct ContentView_Previews_Detail: PreviewProvider {
//    static var previews: some View {
//        DetailView(articleCatalog: ArticleCatalog(id: 2, picture: URLBuilder(url: "", description: ""), name: "", category: "", likes: 33, price: 33.33, original_price: 33.3), valueCombiner: [2], articleListViewModel: ArticleListViewModel(catalogProduct: CatalogProduct()))
//    }
//}
