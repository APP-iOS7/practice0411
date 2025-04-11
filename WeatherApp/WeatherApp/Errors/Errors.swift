//
//  Errors.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation


enum APIError: Error {
    case invalidURL
    case decodingFailed
    case noData
    case requestFailed(error: Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingFailed:
            return "Decoding Failed"
        case .noData:
            return "No Data"
        case .requestFailed:
            return "Request Failed"
        }
    }
}
