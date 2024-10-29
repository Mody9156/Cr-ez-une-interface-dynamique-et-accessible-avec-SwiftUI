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
    @State private var url : String = "https://www.facebook.com/sharer/sharer.php?u=https://developer.apple.com/xcode/swiftui/"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var isDeviceLandscapeMode_two: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                ForEach([articleCatalog]) { article in
                    
                    ZStack(alignment: .bottomTrailing){
                        
                        ZStack (alignment: .topTrailing){
                            
                            AsyncImage(url: URL(string: article.picture.url)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height:570)
                                        .clipShape(RoundedRectangle(cornerRadius: 20,style: .continuous))
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
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                                .opacity(0.4)
                                .padding([.bottom, .trailing,.top], 20)
                            
                            ShareLink(item: URL(string: url)!, subject: Text("Check out this link"), message: Text("If you want to learn Swift, take a look at this website.")) {
                                Image("Share")
                                    .padding([.trailing,.top],5)
                                
                            }
                            .padding([.top, .trailing], 30)
                            .foregroundColor(.black)
                            .accessibilityLabel("Partager ce contenu")
                            
                        }
                        .padding(isDeviceLandscapeMode ? 0 : 16)
                        
                        LikesViewForDetailView(article: article, articleListViewModel: articleListViewModel)
                            .padding([.bottom, .trailing], 20)
                            .padding()
                    }
                    .padding(isDeviceLandscapeMode ? 0 : 16)
                    
                    VStack {
                        
                        SupplementData(article: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                        
                        ReviewControl(articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                    }
                }
            }
        }
    }
}

struct LikesViewForDetailView :View {
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
                            .foregroundColor(articleListViewModel.isFavoris(article: article) ? Color("AccentColor") : .black)
                        
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
    @State var commentText: String = ""
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @State var comments: [Comment] = []
    @StateObject var articleListViewModel: ArticleListViewModel
    @State var activeStart: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        Section {
            VStack {
                // User Image and Star Ratings
                HStack {
                    Image("UserPicture")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50)
                        .clipShape(Circle())

                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            ImageSystemName(sortArray: index, articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                                .padding(.trailing)
                        }
                    }
                    Spacer()
                }
                .padding([.leading, .trailing], isDeviceLandscapeMode ? 0 : 16)
            }
            .padding()

            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isDeviceLandscapeMode ? Color("Background") : Color.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )

                    TextField("Partagez ici vos impressions sur cette pièce", text: $commentText)
                        .font(.title3)
                        .padding()
                        .accessibilityValue("Zone de texte pour vos impressions sur l'article")
                }
                .padding()

                Button(action: {
                    if !commentText.trimmingCharacters(in: .whitespaces).isEmpty && !valueCombiner.isEmpty {
                        let newComment = Comment(text: commentText, stars: Set(valueCombiner))
                        comments.append(newComment)
                        commentText = ""
                        valueCombiner.removeAll()
                        activeStart = true
                    }
                }) {
                    Text("Envoyer")
                        .frame(width: 100, height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding()
                .accessibilityLabel("Envoyer votre commentaire")

                if activeStart {
                    ForEach(comments, id: \.text) { comment in
                        HStack {
                            Image("UserPicture")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(Array(comment.stars), id: \.self) { star in
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 27.51, height: 23.98)
                                            .foregroundColor(Color("AccentColor"))
                                    }
                                }
                                Text(comment.text)
                            }
                        }
                        .padding([.leading, .trailing], isDeviceLandscapeMode ? 0 : 16)

                        Divider()
                    }
                }
            }
            .padding()
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
            Image(systemName: showStart ? "star.fill" : "star")
                .resizable()
                .frame(width:27.45, height: 27.45)
                .foregroundColor(showStart ? Color("AccentColor") : .black)
                .opacity(showStart ? 1 : 0.5)
            
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack{
                    VStack(alignment: .leading) {
                        
                        Text(article.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading,isDeviceLandscapeMode ? 0 : 16)
                            .padding(.bottom, isDeviceLandscapeMode ? 0 : 2)
                        
                        Text("\(article.price,format: .number.rounded(increment: 10.0))€")
                            .font(.title2)
                            .padding(.leading,isDeviceLandscapeMode ? 0 : 16)

                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("AccentColor"))
                            
                            let currentRating = valueCombiner.isEmpty ? articleListViewModel.grade : addition()
                            
                            let averageRating = (articleListViewModel.grade + currentRating) / 2
                            
                            Text("\( Double(averageRating), format: .number.rounded(increment: 0.1))")
                                .font(.title2)
                                .padding(.trailing,isDeviceLandscapeMode ? 0 : 16)
                                .padding(.bottom, isDeviceLandscapeMode ? 0 : 2)


                            
                            
                        }
                        
                        Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                            .strikethrough()
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .opacity(0.7)
                            .padding(.trailing,isDeviceLandscapeMode ? 0 : 16)

                        
                    }.padding()
                    
                }
                
                Text(article.picture.description)
                    .font(.title3)
                    .padding([.leading,.trailing],isDeviceLandscapeMode ? 0 : 16)
                
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
