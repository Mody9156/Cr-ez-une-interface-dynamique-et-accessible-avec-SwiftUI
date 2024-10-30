//
//  MockCatalogProduct.swift
//  JoieFullTests
//
//  Created by KEITA on 23/10/2024.
//

import Foundation
import SwiftUI
@testable import JoieFull

class MockNetworkService: HTTPService {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var shouldReturnError = false
    var mockError: Error?

    // Mock de la méthode request
    func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if shouldReturnError, let error = mockError {
            throw error  // Simuler l'erreur spécifiée
        }

        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)  // Simuler une erreur si les données ou la réponse sont manquantes
        }

        return (data, response)
    }
}
