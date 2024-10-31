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
            
            XCTAssertEqual(loadArticles.count , 2)
            XCTAssertEqual(loadArticles[0].name , "Sac à bandoulière")
            XCTAssertFalse(loadArticles.isEmpty)
            XCTAssertEqual(loadArticles[1].name , "Ceinture en cuir")
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
    
    
    
    
    func testLoadArticlesFromURL_DecodingError() async {
           // Créez un mock de votre service HTTP
           let mockNetworkService = MockNetworkService()
           
           // Simulez des données malformées qui ne peuvent pas être décodées
           let mockData = """
           { "invalid": "data" } // Données malformées
           """.data(using: .utf8)!

           // Assignez les données malformées au mock
           mockNetworkService.mockData = mockData
           mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

           // Instanciez votre classe CatalogProduct
           let catalogProduct = CatalogProduct(httpService: mockNetworkService)

           // Testez la fonction pour vous assurer qu'elle lève l'erreur attendue
           do {
               let _ = try await catalogProduct.loadArticlesFromURL()
               XCTFail("La fonction aurait dû lever une erreur de décodage.")
           } catch {
               XCTAssertEqual(error as? CatalogProduct.CandidateFetchError, .loadArticlesFromURLError)
           }
       }
    
    
    func testLoadArticlesFromURL_InvalidStatusCode() async {
           let mockNetworkService = MockNetworkService()
           mockNetworkService.mockData = Data() // Pas de données
           mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)

           let catalogProduct = CatalogProduct(httpService: mockNetworkService)

           do {
               let _ = try await catalogProduct.loadArticlesFromURL()
               XCTFail("La fonction aurait dû lever une erreur httpResponseInvalid.")
           } catch {
               XCTAssertEqual(error as? CatalogProduct.CandidateFetchError, .httpResponseInvalid)
           }
       }
 
    
    func testLoadArticlesFromURL_DecodingThrowsError() async {
        let mockNetworkService = MockNetworkService()
        let mockData = """
           { "invalid": "data" }
           """.data(using: .utf8)!
        
        mockNetworkService.mockData = mockData
        mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let catalogProduct = CatalogProduct(httpService: mockNetworkService)
        
        do {
            let _ = try await catalogProduct.loadArticlesFromURL()
            XCTFail("La fonction aurait dû lever une erreur de décodage.")
        } catch {
            XCTAssertEqual(error as? CatalogProduct.CandidateFetchError, .loadArticlesFromURLError)
        }
    }
   

}
