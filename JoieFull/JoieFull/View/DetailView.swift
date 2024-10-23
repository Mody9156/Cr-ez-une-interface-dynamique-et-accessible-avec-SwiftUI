import SwiftUI

// Vue principale de détail pour un article spécifique
struct DetailView: View {
    var articleCatalog: ArticleCatalog
    @State var valueCombiner: [Int] = []
    @StateObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach([articleCatalog]) { article in
                    ZStack(alignment: .bottomTrailing) {
                        ZStack(alignment: .topTrailing) {
                            ArticleImageView(article: article)
                            ShareButtonView()
                        }
                        LikesViewForDetailView(article: article, articleListViewModel: articleListViewModel)
                            .padding([.bottom, .trailing], 30)
                    }
                    ArticleDetailSection(article: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                }
            }
        }
    }
}

// Vue pour afficher l'image de l'article
struct ArticleImageView: View {
    var article: ArticleCatalog
    
    var body: some View {
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
    }
}

// Vue pour afficher le bouton de partage
struct ShareButtonView: View {
    var body: some View {
        ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!) {
            Label("", image: "Share")
        }
        .padding([.top, .trailing], 30)
        .accessibilityLabel("Partager ce contenu")
    }
}

// Vue pour le système de likes (favoris) dans la vue de détail
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
                            .frame(width: 20.92, height: 20.92)
                            .foregroundColor(articleListViewModel.isFavoris(article: article) ? .yellow : .black)
                        
                        if let likes = article.likes {
                            let adjustedLikes = articleListViewModel.isFavoris(article: article) ? likes + 1 : likes
                            Text("\(adjustedLikes)").foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}

// Vue contenant la section des détails supplémentaires de l'article et les avis
struct ArticleDetailSection: View {
    var article: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @StateObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        VStack {
            SupplementData(article: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
            ReviewControl(articleCatalog: article, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
        }
    }
}

// Vue pour les données supplémentaires de l'article (prix, description, note)
struct SupplementData: View {
    var article: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @StateObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(article.name)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    Text("\(article.price, format: .number.rounded(increment: 10.0))€")
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        let currentRating = valueCombiner.isEmpty ? articleListViewModel.grade : addition()
                        let averageRating = (articleListViewModel.grade + currentRating) / 2
                        
                        Text("\(Double(averageRating), format: .number.rounded(increment: 0.1))")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                    }
                    
                    Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                        .strikethrough()
                        .foregroundColor(.gray)
                }
            }
            
            Text(article.picture.description)
                .font(.system(size: 14))
                .padding(.top)
        }
        .padding()
    }
    
    func addition() -> Int {
        valueCombiner.max() ?? 0
    }
}

// Vue pour les avis des utilisateurs
struct ReviewControl: View {
    @State private var comment: String = ""
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @State private var comments: Set<String> = []
    @StateObject var articleListViewModel: ArticleListViewModel
    @State private var activeStart: Bool = false
    
    var body: some View {
        VStack {
            // Affichage des étoiles
            RatingView(articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
            
            // Champ de texte pour les commentaires
            CommentFieldView(comment: $comment, comments: $comments, activeStart: $activeStart)
            
            // Affichage des commentaires envoyés
            if activeStart {
                ForEach(Array(comments), id: \.self) { comment in
                    UserCommentView(comment: comment, valueCombiner: valueCombiner)
                    Divider()
                }
            }
        }
        .padding()
    }
}

// Vue pour afficher les étoiles et permettre leur sélection
struct RatingView: View {
    var articleCatalog: ArticleCatalog
    @Binding var valueCombiner: [Int]
    @StateObject var articleListViewModel: ArticleListViewModel
    
    var body: some View {
        HStack {
            Image("UserPicture")
                .resizable()
                .clipShape(Circle())
                .frame(width: 50)
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    ImageSystemName(sortArray: index, articleCatalog: articleCatalog, valueCombiner: $valueCombiner, articleListViewModel: articleListViewModel)
                }
            }
        }
    }
}

// Vue pour afficher une zone de texte pour les commentaires
struct CommentFieldView: View {
    @Binding var comment: String
    @Binding var comments: Set<String>
    @Binding var activeStart: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(minHeight: 117)
                
                TextField("Partagez ici vos impressions sur cette pièce", text: $comment)
                    .padding()
            }
            
            Button {
                if !comment.trimmingCharacters(in: .whitespaces).isEmpty {
                    comments.insert(comment)
                    comment = ""
                    activeStart = true
                }
            } label: {
                Text("Envoyer")
                    .frame(width: 100, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding()
        }
    }
}

// Vue pour afficher les commentaires d'utilisateurs
struct UserCommentView: View {
    var comment: String
    var valueCombiner: [Int]
    
    var body: some View {
        HStack {
            Image("UserPicture")
                .resizable()
                .clipShape(Circle())
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                HStack {
                    ForEach(valueCombiner, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 27.51, height: 23.98)
                            .foregroundColor(.yellow)
                    }
                }
                Text(comment)
            }
        }
    }
}
