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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
  
    func loadArticlesFromURL() async throws -> [ArticleCatalog] {
        do{
            let (data,response) = try await httpService.request(createURLRequest())
            
            guard response.statusCode == 200 else {
                throw CandidateFetchError.httpResponseInvalid(statusCode: response.statusCode)
            }
            
            let DecoderArticles = try JSONDecoder().decode([ArticleCatalog].self, from: data)
            
            return DecoderArticles
            
        }catch{
            throw CandidateFetchError.loadArticlesFromURLError
        }
    }
}
