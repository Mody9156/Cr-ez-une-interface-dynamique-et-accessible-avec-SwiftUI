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
         let mockData = Data("Mock response data".utf8)
         let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
         let mockNetworkService = MockNetworkService(mockData: mockData,mockResponse: mockResponse)
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
    
    func testLoadArticlesFromURL_Success() async throws {
        let mockData =  """
        [
            {"id": "1", "name": "T-shirt", "price": 25.0, "original_price": 30.0, "likes": 10, "picture": {"url": "https://example.com/tshirt.jpg", "description": "T-shirt description"}},
            {"id": "2", "name": "Jeans", "price": 50.0, "original_price": 60.0, "likes": 20, "picture": {"url": "https://example.com/jeans.jpg", "description": "Jeans description"}}
        ]
        """.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(url: URL(string:"https://exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockNetworkService = MockNetworkService(mockData: mockData,mockResponse: mockResponse)

        let catalogProduct =  CatalogProduct(httpService: mockNetworkService)
        
        let loadArticles = try await catalogProduct.loadArticlesFromURL()
        
        XCTAssert(loadArticles.count == 2)
        XCTAssert(loadArticles[1].name == "Jeans")
        XCTAssert(loadArticles[0].name == "T-shirt")
        

    }
    
    func testStatusCodeNoThrowsError()throws{
        
    }

    
    
    class MockNetworkService : HTTPService {
        
        var mockData: Data?
        var mockResponse: HTTPURLResponse?
        var mockError: Error?
        
        init(mockData: Data? = nil, mockResponse: HTTPURLResponse? = nil, mockError: Error? = nil) {
            self.mockData = mockData
            self.mockResponse = mockResponse
            self.mockError = mockError
        }
        
        // Mock de la méthode request
        func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            // Simuler une erreur si elle est définie
            if let error = mockError {
                throw error
            }
            
            // Vérifier que les données et la réponse ne sont pas nulles
            guard let data = mockData,
                  let response = mockResponse else {
                throw URLError(.badServerResponse)
            }
            
            return (data, response)
        }
    }

   
    
}
