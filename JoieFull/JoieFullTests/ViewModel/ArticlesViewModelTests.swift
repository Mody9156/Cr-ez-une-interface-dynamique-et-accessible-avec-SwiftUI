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


    func testLoadArticlesSuccessfully() async throws {
        let mockNetworkService = MockNetworkService()
        let mockData = """
        [
            {
                "id": 1,
                "picture": {
                    "url": "https://example.com/image1.jpg",
                    "description": "Description 1"
                },
                "name": "Article 1",
                "category": "Category 1",
                "likes": 100,
                "price": 10.0,
                "original_price": 15.0
            },
            {
                "id": 2,
                "picture": {
                    "url": "https://example.com/image2.jpg",
                    "description": "Description 2"
                },
                "name": "Article 2",
                "category": "Category 2",
                "likes": 200,
                "price": 20.0,
                "original_price": 25.0
            }
        ]
        """.data(using: .utf8)!
        
        mockNetworkService.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.mockResponse = mockResponse
        
        let viewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        do {
            let articles = try await viewModel.loadArticles()
            XCTAssertEqual(articles.count, 2)
//            XCTAssertEqual(viewModel.articleCatalog.count, 2)
        } catch {
            XCTFail("Le chargement des articles a échoué : \(error)")
        }
    }

    func testLoadArticlesThrowsError() async throws {
        let mockNetworkService = MockNetworkService()
        
        // Simulez une réponse avec une erreur
        mockNetworkService.mockError = URLError(.badServerResponse)
        
        let viewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        do {
            let _ = try await viewModel.loadArticles()
            XCTFail("La fonction aurait dû lever une erreur lors du chargement.")
        } catch {
            XCTAssertEqual(error as? ArticleListViewModel.ArticleListViewModelError, .loadArticlesError)
        }
    }

    func testReloadArticles() async throws {
        let mockNetworkService = MockNetworkService()
        let mockData = """
        [
            {
                "id": 1,
                "picture": {
                    "url": "https://example.com/image1.jpg",
                    "description": "Description 1"
                },
                "name": "Article 1",
                "category": "Category 1",
                "likes": 100,
                "price": 10.0,
                "original_price": 15.0
            }
        ]
        """.data(using: .utf8)!
        
        mockNetworkService.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.mockResponse = mockResponse
        
        let viewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: mockNetworkService))
        
        do {
            let articles: () = try await viewModel.reloadArticles()
            
            XCTAssertEqual(viewModel.articleCatalog.count, 1)
        } catch {
            XCTFail("Le rechargement des articles a échoué : \(error)")
        }
    }
    
    func testToggleFavoris() {
        let mockArticle = ArticleCatalog(id: 1, picture: URLBuilder(url: "https://example.com/image1.jpg", description: "Description 1"), name: "Article 1", category: "Category 1", likes: 100, price: 10.0, original_price: 15.0)
        
        let viewModel = ArticleListViewModel(catalogProduct: CatalogProduct(httpService: MockNetworkService()))
        
        // Ajouter à favoris
        viewModel.toggleFavoris(article: mockArticle)
        XCTAssertTrue(viewModel.isFavoris(article: mockArticle))
        
        // Retirer des favoris
        viewModel.toggleFavoris(article: mockArticle)
        XCTAssertFalse(viewModel.isFavoris(article: mockArticle))
    }

}
