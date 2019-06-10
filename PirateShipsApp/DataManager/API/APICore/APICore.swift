//
//  APICore.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 14/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

enum HttpResponse {
    case success
    case error
}

final class APICore: APIProvider {
    
    private let defaultError = "Something got wrong, try again in a few minutes."
    
    func request<T>(url: [PathURL], httpMethod: HttpMethod, completion: @escaping (Result<T>) -> Void) where T : Decodable {
        guard let request = makeRequest(
            url: url,
            method: httpMethod) else { return }
        
        URLSession.shared.dataTask(with: request) { [defaultError] (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failed(defaultError))
                return
            }
            
            switch response.statusCode {
            case 400..<600:
                completion(.failed(error?.localizedDescription ?? defaultError))
            default:
                guard let data = data else { return }
                
                do  {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.succeeded(object))
                } catch let jsonError {
                    completion(.failed("\(jsonError.localizedDescription) \(response.statusCode)"))
                }
            }
            
            }.resume()
    }
    
    private func makeRequest(url: [PathURL], method: HttpMethod) -> URLRequest? {
        let currentUrl = url.reduce("") { $0 + $1.rawValue }
        guard let `url` = URL(string: currentUrl) else { return nil}
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        return request
    }
    
    
}
