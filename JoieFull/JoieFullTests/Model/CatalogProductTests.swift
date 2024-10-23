//
//  CatalogProductTests.swift
//  JoieFullTests
//
//  Created by KEITA on 16/10/2024.
//

import XCTest
@testable import JoieFull
import SwiftUI


final class CatalogProductTests: XCTestCase {
    
    
    func testURLRequestCreationWithValidURL() async throws {
        let mockNetworkService = MockNetworkService()
        
        let mockData = Data("Mock response data".utf8)
        mockNetworkService.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.mockResponse = mockResponse
        let catalogProduct =  CatalogProduct(httpService: mockNetworkService)
        
        do {
            let create = try catalogProduct.createURLRequest()
            XCTAssertNotNil(create.url)
            XCTAssertNoThrow(create)
            XCTAssert(create.httpMethod == "GET")
            
        }catch{
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet, "L'erreur doit être URLError.notConnectedToInternet")
            
        }
    }
    
    func testDecoderArticles_Success() async throws {
        let mockNetworkService = MockNetworkService()
        
        let mockData =  """
        [
            {
                "id": 1,
                "picture": {
                    "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/4.jpg",
                    "description": "Sac à bandoulière en cuir noir"
                },
                "name": "Sac à bandoulière",
                "category": "ACCESSORIES",
                "likes": 75,
                "price": 89.99,
                "original_price": 99.99
            },
           {
               "id": 2,
               "picture": {
                   "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/3.jpg",
                   "description": "Ceinture en cuir noir élégante"
               },
               "name": "Ceinture en cuir",
               "category": "ACCESSORIES",
               "likes": 30,
               "price": 35.00,
               "original_price": 40.00
           }

        ]
        """.data(using: .utf8)!
        
        mockNetworkService.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockResponse.method(for: Selector(("GET")))
        mockNetworkService.mockResponse = mockResponse
        let catalogProduct =  CatalogProduct(httpService: mockNetworkService)
        
        let expectedArticles = [
                ArticleCatalog(id: 1, picture: URLBuilder(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/4.jpg", description: "Sac à bandoulière en cuir noir"), name: "Sac à bandoulière", category: "ACCESSORIES", likes: 75, price: 89.99, original_price: 99.99),
                ArticleCatalog(id: 2, picture: URLBuilder(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/3.jpg", description: "Ceinture en cuir noir élégante"), name: "Ceinture en cuir", category: "ACCESSORIES", likes: 30, price: 35.00, original_price: 40.00)
            ]
        do{
            
            let loadArticles = try await catalogProduct.loadArticlesFromURL()
            
            XCTAssert(loadArticles.count == 2)
            XCTAssert(loadArticles[0].name == "Sac à bandoulière")
            XCTAssert(loadArticles[1].name == "Ceinture en cuir")
            XCTAssertEqual(loadArticles, expectedArticles, "Les articles décodés ne correspondent pas aux articles attendus.")

        }catch {
            // Capte l'erreur et passe un message
            XCTFail("Erreur inattendue lors du chargement des articles : \(error)")
        }
        
    }
    
    func testLoadArticlesFromURL_ThrowsErrors() async throws{
        let mockNetworkService = MockNetworkService()
        let mockData =  """
        
            {
                "id": 1,
                "picture": {
                    "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/4.jpg",
                    "description": "Sac à bandoulière en cuir noir"
                },
                "name": "Sac à bandoulière",
                "category": "ACCESSORIES",
                "likes": 75,
                "price": 89.99,
                "original_price": 99.99
            },
           

        """.data(using: .utf8)
        mockNetworkService.mockData = mockData
        
         let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.mockResponse = mockResponse
        
        let catalogProduct =  CatalogProduct(httpService: mockNetworkService)

        do{
            
           let _ = try await catalogProduct.loadArticlesFromURL()
          
        }catch let error{
           
            XCTAssertEqual(error as? CatalogProduct.CandidateFetchError, .loadArticlesFromURLError)
        }
        
    }
    func testStatusCodeNoThrowsError() async throws {
        let mockNetworkService = MockNetworkService()
        let mockData =  """
        [
            {
                "id": 1,
                "picture": {
                    "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/4.jpg",
                    "description": "Sac à bandoulière en cuir noir"
                },
                "name": "Sac à bandoulière",
                "category": "ACCESSORIES",
                "likes": 75,
                "price": 89.99,
                "original_price": 99.99
            },
           {
               "id": 2,
               "picture": {
                   "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/3.jpg",
                   "description": "Ceinture en cuir noir élégante"
               },
               "name": "Ceinture en cuir",
               "category": "ACCESSORIES",
               "likes": 30,
               "price": 35.00,
               "original_price": 40.00
           }

        ]
        """.data(using: .utf8)!
        
        mockNetworkService.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        mockNetworkService.mockResponse = mockResponse
        
        let catalogProduct =  CatalogProduct(httpService: mockNetworkService)
       
        do{
            let _ = try await catalogProduct.loadArticlesFromURL()
            
        }catch let error {
            print("l'erreur est \(error)")
            XCTAssertEqual(error as? CatalogProduct.CandidateFetchError, .httpResponseInvalid)
        }
    }
    
    
    
    class MockNetworkService : HTTPService {
        
        var mockData: Data?
        var mockResponse: HTTPURLResponse?
        var mockError: Error?
        
        // Mock de la méthode request
        func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            if let data = mockData, let response = mockResponse {
                return (data, response)
            } else {
                throw URLError(.badServerResponse)  // Simuler une erreur si les données ou la réponse sont manquantes
            }
            
        }
    }
    
    
    
}
