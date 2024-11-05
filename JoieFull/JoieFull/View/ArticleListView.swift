//
//  ArticleListView.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import SwiftUI

// Vue principale pour afficher la liste des articles
struct ArticleListView: View {
    @ObservedObject var articleListViewModel: ArticleListViewModel
    @State var presentArticles: Bool = false
    @State var selectedArticle: ArticleCatalog? = nil
    @State var addInFavoris: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var searchText = ""
    
    // Détecte si l'appareil est en mode paysage
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                HStack {
                    VStack(alignment: .leading) {
                        // Affiche différentes sections d'articles (Hauts, Bas, Sacs)
                        ArticlesFinder(sectionName: "Hauts", categoryName: "TOPS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder(sectionName: "Bas", categoryName: "BOTTOMS", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                        
                        ArticlesFinder(sectionName: "Sacs", categoryName: "ACCESSORIES", presentArticles: $presentArticles, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, searchText: $searchText, addInFavoris: $addInFavoris)
                    }
                    
                    // Affiche les détails d'un article sélectionné en mode paysage
                    if isDeviceLandscapeMode, let article = selectedArticle {
                        DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                    }
                }
                .onAppear {
                    Task {
                        try? await articleListViewModel.loadArticles()
                    }
                }
            }
            .background(isDeviceLandscapeMode ? Color("Background") : Color("Color"))
            .searchable(text: $searchText, prompt: "Rechercher un article")
            .accessibilityLabel("Barre de recherche")
            .accessibilityHint("Tapez pour rechercher un article par son nom ou sa description.")
        }
    }
}

// Vue pour afficher les catégories d'articles
struct ShowCategories: View {
    var article: ArticleCatalog
    var category: String = ""
    @Binding var presentArticles: Bool
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?
    @Binding var addInFavoris: Bool
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // Détecte si l'appareil est en mode paysage
    var isDeviceLandscapeMode: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        // Affiche l'article uniquement si sa catégorie correspond
        if article.category == category {
            if isDeviceLandscapeMode {
                ExtractionDeviceLandscapeMode(presentArticles: $presentArticles, article: article, articleListViewModel: articleListViewModel, selectedArticle: $selectedArticle, addInFavoris: $addInFavoris)
            } else {
                VStack {
                    // Lien vers la vue de détail de l'article
                    NavigationLink {
                        DetailView(articleCatalog: article, articleListViewModel: articleListViewModel)
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: article.picture.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 198)
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            LikesView(article: article, articleListViewModel: articleListViewModel)
                                .padding()
                        }
                        .accessibilityLabel("Voir les détails de \(article.name)")
                    }
                    
                    // Information additionnelle de l'article
                    InfoExtract(article: article, articleListViewModel: articleListViewModel, presentArticles: $presentArticles, selectedArticle: $selectedArticle)
                }
            }
        }
    }
}

// Vue pour l'affichage en mode paysage
struct ExtractionDeviceLandscapeMode: View {
    @Binding var presentArticles: Bool
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var selectedArticle: ArticleCatalog?
    @Binding var addInFavoris: Bool
    
    var body: some View {
        VStack {
            Button {
                // Sélectionne ou désélectionne l'article
                selectedArticle = (selectedArticle == article) ? nil : article
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: article.picture.url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
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
                        .stroke(selectedArticle?.id == article.id ? Color("Cyan") : .clear, lineWidth: 3)
                )
            }
            .accessibilityLabel("Vous avez sélectionné \(article.name)")
            
            // Information additionnelle de l'article
            InfoExtract(article: article, articleListViewModel: articleListViewModel, presentArticles: $presentArticles, selectedArticle: $selectedArticle)
        }
    }
}

// Vue pour afficher les likes d'un article
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
                        .foregroundColor(articleListViewModel.isFavoris(article: article) ? Color("AccentColor") : .black)
                    
                    if let likes = article.likes {
                        Text("\(articleListViewModel.isFavoris(article: article) ? (likes + 1) : likes)")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

// Vue pour afficher les informations de l'article
struct InfoExtract: View {
    var article: ArticleCatalog
    @StateObject var articleListViewModel: ArticleListViewModel
    @Binding var presentArticles: Bool
    @Binding var selectedArticle: ArticleCatalog?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Nom de l'article
                Text(article.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : Color("foreground"))
                    .frame(maxWidth: 100)
                    .accessibilityLabel("\(article.name), prix : \(article.price)€")
                
                // Prix actuel de l'article
                Text("\(article.price, format: .number.rounded(increment: 10.0))€")
                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : Color("foreground"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                // Note de l'article
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("AccentColor"))
                        .accessibilityLabel("Note : \(articleListViewModel.grade) étoiles")
                    
                    Text("\(Double(articleListViewModel.grade), format: .number.rounded(increment: 0.1))")
                        .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : Color("foreground"))
                }
                
                // Prix original barré
                Text("\(article.original_price, format: .number.rounded(increment: 10.0))€")
                    .strikethrough()
                    .foregroundColor(selectedArticle?.id == article.id ? Color("Cyan") : Color("foreground"))
                    .opacity(selectedArticle?.id == article.id ? 1 : 0.7)
            }
        }
    }
}

// Vue pour filtrer les articles par catégorie
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
                            ForEach(searchResults.sorted(by: { $0.name < $1.name }), id: \.name) { article in
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
