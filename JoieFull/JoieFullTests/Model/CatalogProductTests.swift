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
                  
         do {
             let (data,response) = try await mockNetworkService.request(URLRequest(url: URL(string:"https://exemple.com")!))
         }catch{
             XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet, "L'erreur doit être URLError.notConnectedToInternet")

         }
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
