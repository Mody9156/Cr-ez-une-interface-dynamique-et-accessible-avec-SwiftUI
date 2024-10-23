//
//  TestsArticlesViewModel.swift
//  JoieFullTests
//
//  Created by KEITA on 23/10/2024.
//

import XCTest
@testable import JoieFull
import SwiftUI

final class ArticlesViewModelTests: XCTestCase {


    func testExample() throws {
        let articleListViewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: MockHTTPService))
    }


    class MockHTTPService: HTTPService {
        var mockData: Data?
        var mockResponse: HTTPURLResponse?
        var mockError: Error?
        
        func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            if let error = mockError {
                throw error
            }
            
            guard let data = mockData, let response = mockResponse else {
                throw URLError(.badServerResponse)
            }
            
            return (data, response)
        }
    }

}
