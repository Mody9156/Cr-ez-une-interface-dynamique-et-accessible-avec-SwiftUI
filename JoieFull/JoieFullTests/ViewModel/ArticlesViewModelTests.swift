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


    func testWhenLoadArticlesNoThrowsError() async throws {
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
        
        let articleListViewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        do{
           let loadArticles =  try await articleListViewModel.loadArticles()
            XCTAssertNotNil(loadArticles)
            print("function passé")
        }catch let error {
            print("Error")
            XCTAssertEqual(error as? ArticleListViewModel.ArticleListViewModelError, .loadArticlesError)
        }
    }
    func testWhenLoadArticlesThrowsError() async throws {
        let mockNetworkService = MockNetworkService()
        
        let articleListViewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        do{
           let loadArticles =  try await articleListViewModel.loadArticles()
            XCTAssertNotNil(loadArticles)
        }catch let error {
            XCTAssertEqual(error as? ArticleListViewModel.ArticleListViewModelError, .loadArticlesError)
        }
    }
    func testWhenReloadArticlesNotThrowsErrors()async throws {

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
        
        let articleListViewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        let reloadArticles: () = try await articleListViewModel.reloadArticles()
        XCTAssertNotNil(reloadArticles)
    }

   
}
