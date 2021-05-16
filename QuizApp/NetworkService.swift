//
//  NetworkService.swift
//  QuizApp
//
//  Created by Kompjuter on 15/05/2021.
//

import Foundation

class NetworkService {
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print((response as? HTTPURLResponse)!.statusCode)
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            print(data)
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.dataEncodingError))
                return
            }
            
            completionHandler(.sucess(value))
        }
        dataTask.resume()
    }
}
