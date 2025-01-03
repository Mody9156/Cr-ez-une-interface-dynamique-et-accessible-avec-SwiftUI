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
    
    enum CandidateFetchError: Error ,Equatable{
        case httpResponseInvalid
        case loadArticlesFromURLError
    }
    
    func createURLRequest() throws -> URLRequest{
        let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    func loadArticlesFromURL() async throws -> [ArticleCatalog] {
        
        let (data,response) = try await httpService.request(createURLRequest())
        
        guard response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid
        }
        
        do{
            
            let DecoderArticles = try JSONDecoder().decode([ArticleCatalog].self, from: data)
            
            return DecoderArticles
            
        }catch{
            
            throw CandidateFetchError.loadArticlesFromURLError
        }
    }
}
