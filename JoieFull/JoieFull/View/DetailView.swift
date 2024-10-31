//  DetailView.swift
//  JoieFull
//
//  Created by KEITA on 13/10/2024.
//

import SwiftUI

struct DetailView: View {
    var articleCatalog: ArticleCatalog
    @State var valueCombiner: [Int] = []
    @StateObject var articleListViewModel: ArticleListViewModel
    @State private var url: String = "https://www.facebook.com/sharer/sharer.php?u=https://developer.apple.com/xcode/swiftui/"
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.presentationMode) private var presentationMode

    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ForEach([articleCatalog]) { article in
                    ZStack(alignment: .bottomTrailing) {
                        ZStack(alignment: .topTrailing) {
                            AsyncImage(url: URL(string: article.picture.url)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 570)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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
                                .padding([.bottom, .trailing, .top], 20)

                            ShareLink(item: URL(string: url)!, subject: Text("Découvrez ce lien"), message: Text("Si vous voulez apprendre Swift, jetez un œil à ce site web.")) {
                                Image("Share")
                                    .padding([.trailing, .top], 5)
                            }
                            .padding([.top, .trailing], 30)
                            .foregroundColor(.black)
                            .accessibilityLabel("Partager le lien vers Facebook")
                            .accessibilityHint("Appuyez pour partager ce lien")
                            .accessibilityAddTraits(.isButton)
                        }
                        .padding(isDeviceLandscapeMode ? 0 : 16)

                        if let like = article.likes {
                            LikesViewForDetailView(article: article, articleListViewModel: articleListViewModel)
                                .padding([.bottom, .trailing], 20)
                                .padding(isDeviceLandscapeMode ? 0 : 16)
                                .accessibilityLabel("\(article.name) a été ajouté aux favoris par \(like) personnes")
                                .accessibilityValue(articleListViewModel.isFavoris(article: articleCatalog)
                                    ? "Appuyez pour supprimer \(article.name) de vos favoris"
                                    : "Appuyez pour ajouter \(article.name) à vos favoris")
                        }
                    }

                    VStack {
                        SupplementData(article: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                        ReviewControl(articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(isDeviceLandscapeMode ? false : true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !isDeviceLandscapeMode {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image("Chevron")
                            Text("Home").foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

struct LikesViewForDetailView: View {
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel

    var body: some View {
        Button {
            articleListViewModel.toggleFavoris(article: article)
        } label: {
            HStack {
                ZStack {
                    Capsule()
                        .fill(.white)
                        .frame(width: 90, height: 40)

                    HStack {
                        Image(systemName: articleListViewModel.isFavoris(article: article) ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(articleListViewModel.isFavoris(article: article) ? Color("AccentColor") : .black)

                        if let likes = article.likes {
                            Text("\(likes + (articleListViewModel.isFavoris(article: article) ? 1 : 0))")
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
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
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
                        .accessibilityLabel("Photo de profil de l'utilisateur de la session")

                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            ImageSystemName(sortArray: index, articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                                .padding(.trailing)
                                .accessibilityLabel("Noter \(articleCatalog.name) de \(index) étoile(s)")
                                .accessibilityValue(valueCombiner.last == index ? "Sélectionnée" : "Non sélectionnée")
                                .accessibilityHint("Appuyez pour donner \(index) étoile(s)")
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
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))

                    TextField("Partagez ici vos impressions sur cette pièce", text: $commentText)
                        .font(.title3)
                        .padding()
                        .accessibilityLabel("Zone de texte pour vos impressions sur l'article")
                        .accessibilityValue(commentText.isEmpty ? "Veuillez insérer du texte." : "Texte saisi : \(commentText)")
                        .accessibilityHint("Tapez vos commentaires ici.")
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
                .accessibilityLabel("Bouton pour envoyer un commentaire")
                .accessibilityHint("Appuyez pour soumettre votre commentaire et vos étoiles")
                .accessibilityValue(commentText.isEmpty ? "Aucun commentaire saisi" : "Commentaire : \(commentText)")
                .accessibilityValue(valueCombiner.isEmpty ? "Aucun étoile n'a été saisi" : "Vous avez sélectionné(e) \(valueCombiner.last ?? 0) étoile(s)")

                if activeStart {
                    ForEach(comments, id: \.text) { comment in
                        HStack {
                            Image("UserPicture")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50)
                                .clipShape(Circle())
                                .accessibilityLabel("Photo de profil de l'utilisateur de la session")

                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(Array(comment.stars), id: \.self) { star in
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 27.51, height: 23.98)
                                            .foregroundColor(Color("AccentColor"))
                                    }
                                    .accessibilityLabel("Vous avez noté \(articleCatalog.name) avec \(comment.stars.count) étoile(s) : \(comment.stars.sorted().map { "\($0)" }.joined(separator: ", "))")
                                }
                                .accessibilityLabel("Vous avez noté \(articleCatalog.name) avec \(comment.stars.count) étoile(s) : \(comment.stars.sorted().map { "\($0)" }.joined(separator: ", "))")

                                Text(comment.text)
                                    .accessibilityLabel("Commentaire : \(comment.text)")
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

struct ImageSystemName: View {
    var sortArray: Int
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @StateObject var articleListViewModel: ArticleListViewModel

    var body: some View {
        let showStart = valueCombiner.contains(sortArray)

        Button {
            appendToArray(order: sortArray)
            if showStart {
                valueCombiner.removeAll()
            }
        } label: {
            Image(systemName: showStart ? "star.fill" : "star")
                .resizable()
                .frame(width: 27.45, height: 27.45)
                .foregroundColor(showStart ? Color("AccentColor") : Color("Start"))
                .opacity(showStart ? 1 : 0.5)
        }
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
    var article: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @StateObject var articleListViewModel: ArticleListViewModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(article.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, isDeviceLandscapeMode ? 0 : 16)
                            .padding(.bottom, isDeviceLandscapeMode ? 0 : 2)

                        Text("\(article.price, format: .number.rounded(increment: 10.0))€")
                            .font(.title2)
                            .padding(.leading, isDeviceLandscapeMode ? 0 : 16)
                            .accessibilityLabel("\(article.name) est à prix réduit, coûtant \(article.price, format: .number.rounded(increment: 10.0))€")
                            .accessibilityHint("Prix après réduction")
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("AccentColor"))
                                .accessibilityLabel("Icône des favoris")

                            let currentRating = valueCombiner.isEmpty ? articleListViewModel.grade : addition()
                            let averageRating = (articleListViewModel.grade + currentRating) / 2

                            Text("\(Double(averageRating), format: .number.rounded(increment: 0.1))")
                                .font(.title2)
                                .padding(.trailing, isDeviceLandscapeMode ? 0 : 16)
                                .padding(.bottom, isDeviceLandscapeMode ? 0 : 2)
                                .accessibilityLabel("La note de l'article est de : \(Double(averageRating), format: .number.rounded(increment: 0.1)) sur 5")
                                .accessibilityHint("Note sur 5 étoiles pour cet article")
                        }

                        Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                            .strikethrough()
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .opacity(0.7)
                            .padding(.trailing, isDeviceLandscapeMode ? 0 : 16)
                            .accessibilityLabel("Prix d'origine : \(article.original_price, format: .number.rounded(increment: 10.0))€")
                            .accessibilityHint("Ce prix est le prix d'origine, maintenant réduit")
                    }
                    .padding()
                }

                Text(article.picture.description)
                    .font(.title3)
                    .padding([.leading, .trailing], isDeviceLandscapeMode ? 0 : 16)
                    .accessibilityLabel("Description de l'image : \(article.picture.description)")
                    .accessibilityHint("Description de l'image pour un meilleur contexte")
            }
        }
        .padding()
    }

    func addition() -> Int {
        var array = 0

        if !valueCombiner.isEmpty {
            if let lastElement = valueCombiner.sorted().last {
                array = lastElement
            }
        }

        return array
    }
}

// struct ContentView_Previews_Detail: PreviewProvider {
//     static var previews: some View {
//         DetailView(articleCatalog: ArticleCatalog(id: 2, picture: URLBuilder(url: "", description: ""), name: "", category: "", likes: 33, price: 33.33, original_price: 33.3), valueCombiner: [2], articleListViewModel: ArticleListViewModel(catalogProduct: CatalogProduct()))
//     }
// }
