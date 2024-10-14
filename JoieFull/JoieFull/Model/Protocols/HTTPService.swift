//
//  HTTPService.swift
//  JoieFull
//
//  Created by KEITA on 14/10/2024.
//

import Foundation


protocol HTTPService {
    func request(_ request : URLRequest) async throws-> (Data,HTTPURLResponse) 
}
