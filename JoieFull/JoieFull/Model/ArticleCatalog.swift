//
//  ArticleCatalog.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation

struct ArticleCatalog : Identifiable,Decodable {
    var id = UUID()
    var picture : URL
    var name :String
    var category : String
    var likes : Int
    var price : Double
    var original_price : Double
    
}

