//
//  DetailView.swift
//  JoieFull
//
//  Created by KEITA on 13/10/2024.
//
import SwiftUI

struct DetailView: View {
    var articleCatalog: ArticleCatalog
    @State private var comment: String = ""
    @State var showRightColor: Bool = false

    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                ForEach([articleCatalog]) { article in
                    
                    ZStack(alignment: .bottomTrailing){
                        
                        ZStack (alignment: .topTrailing){

                            AsyncImage(url: URL(string: article.picture.url)) { image in
                               image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .padding()
                                    .accessibilityValue("Image représentant \(article.name)")


                            } placeholder: {
                                ProgressView()
                            }
                            
                            ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!) {
                                Label("", image: "Share")
                            }
                            .padding([.top, .trailing], 30)
                            .accessibilityLabel("Partager ce contenu")
                        }
                        
                        LikesView(article: article,width:
                                    20.92,height: 20.92,widthFrame: 90,heightFrame: 40)
                        .padding([.bottom, .trailing], 30)
                        
                    }
                    VStack {
                        SupplementData(article: article, showRightColor: $showRightColor)
                        
                        ReviewControl(comment: $comment, articleCatalog: articleCatalog, showRightColor: $showRightColor)
                    }
                    
                }
            }
        }
    }
}





struct ReviewControl: View {
    @Binding var comment : String
    var articleCatalog: ArticleCatalog
    @Binding var showRightColor: Bool
    var body: some View {
        Section{
            VStack(alignment: .leading) {
                
                HStack {
                    Image("UserPicture")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width:50)
                    
                    HStack {
                        ImageSystemName(showRightColor: $showRightColor,  order: 1, articleCatalog: articleCatalog)
                        ImageSystemName(showRightColor: $showRightColor,  order: 2, articleCatalog: articleCatalog)
                        ImageSystemName(showRightColor: $showRightColor,  order: 3, articleCatalog: articleCatalog)
                        ImageSystemName(showRightColor: $showRightColor,  order: 4, articleCatalog: articleCatalog)
                        ImageSystemName(showRightColor: $showRightColor,  order: 5, articleCatalog: articleCatalog)
                    }
                    Spacer()
                }
            }.padding()
            
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
            
        }
    }
}

struct ImageSystemName : View {
    @State var foregroundColor : Color = .gray
    @Binding var showRightColor: Bool
    @State var start : String = "star"
    var order : Int
    var articleCatalog: ArticleCatalog
    @State var add : [Int] = []
    var body: some View {
        
        Button {
            
            showRightColor.toggle()
           
            if showRightColor{
                foregroundColor = .yellow
                start = "star.fill"
                add = Array(1..<order)
                for adds in add {
                    print(adds)
                }
                print("add \(order)")
            }else{
                foregroundColor = .gray
                start = "star"
                print("hallo")
                
            }
                        
        } label: {
            Image(systemName: start)
                .resizable()
                .frame(width: 27.51, height: 23.98)
                .foregroundColor(foregroundColor)
            
        }.accessibilityElement(children: .combine)
            
            .accessibilityLabel(showRightColor ? "Retirer une étoile à cet article" : "Ajouter une étoile cet article")
            .onTapGesture {
                showRightColor.toggle()
                
            }
        
    }
   
    
}

struct SupplementData: View {
    var article : ArticleCatalog
    @Binding var showRightColor : Bool
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
                            
                            if let articleLikes = article.likes {
                                Text("\(articleLikes)")
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
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(articleCatalog: ArticleCatalog(id: 33, picture: URLBuilder(url: "", description: "Simple"), name: "Jack", category: "", price: 33.33, original_price: 33.33), showRightColor: true)
    }
}
