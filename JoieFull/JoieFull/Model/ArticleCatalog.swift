//
//  ArticleCatalog.swift
//  JoieFull
//
//  Created by KEITA on 10/10/2024.
//

import Foundation
import SwiftUI

struct ArticleCatalog : Equatable,Identifiable,Codable{
    static func == (lhs: ArticleCatalog, rhs: ArticleCatalog) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id : Int
    var picture : URLBuilder
    var name :String
    var category : String
    var likes : Int?
    var price : Double
    var original_price : Double
    
}

struct URLBuilder : Codable {
    var url : String
    var description : String
}

