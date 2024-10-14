//
//  CatalogProduct.swift
//  JoieFull
//
//  Created by KEITA on 14/10/2024.
//

import Foundation

class CatalogProduct {
    
    let httpService : HTTPService
    
    init(httpService : HTTPService = URLSessionHTTPClient()){
        self.httpService = httpService
    }
    
    enum CandidateFetchError: Error {
        case httpResponseInvalid(statusCode:Int)
        case loadArticlesFromURLError
    }
    
    func createURLRequest()throws -> URLRequest{
        let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func loadArticlesFromURL(request:URLRequest) async throws -> ArticleCatalog {
        do{
            let (data,response) = try await httpService.request(request)
            
            guard response.statusCode == 200 else {
                        throw CandidateFetchError.httpResponseInvalid(statusCode: response.statusCode)
                    }
            
            let article = try JSONDecoder().decode(ArticleCatalog.self, from: data)
            
            return article
        }catch{
            throw CandidateFetchError.loadArticlesFromURLError
        }
    }
}
