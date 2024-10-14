//
//  CatalogProduct.swift
//  JoieFull
//
//  Created by KEITA on 14/10/2024.
//

import Foundation

class CatalogProduct {
    
    func createURLRequest()throws -> URLRequest{
        let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
