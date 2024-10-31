//
//  MockCatalogProduct.swift
//  JoieFullTests
//
//  Created by KEITA on 23/10/2024.
//

import Foundation
import SwiftUI
@testable import JoieFull

class SubNetworkService: HTTPService {
    var subData: Data?
    var subResponse: HTTPURLResponse?
    var shouldReturnError = false
    var subError: Error?

    // Mock de la méthode request
    func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if shouldReturnError, let error = subError {
            throw error  // Simuler l'erreur spécifiée
        }

        guard let data = subData, let response = subResponse else {
            throw URLError(.badServerResponse)  // Simuler une erreur si les données ou la réponse sont manquantes
        }

        return (data, response)
    }
}
