//
//  MockCatalogProduct.swift
//  JoieFullTests
//
//  Created by KEITA on 23/10/2024.
//

import Foundation
import SwiftUI
@testable import JoieFull

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
