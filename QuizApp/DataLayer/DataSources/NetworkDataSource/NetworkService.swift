//
//  NetworkService.swift
//  QuizApp
//
//  Created by Kompjuter on 15/05/2021.
//

import Foundation

class NetworkService {
    static let singletonNetworkService = NetworkService()
    private init() {
        //pass
    }
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
    
    func getQuizzes() -> [Quiz] {
        let group = DispatchGroup()
        var quizzes: [Quiz] = []
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return []}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        group.enter()
        DispatchQueue.global().async {
            NetworkService().executeUrlRequest(request) { (result: Result<GetQuizzesResponse, RequestError>) in
                switch result {
                case.failure(let error):
                    print(error)
                    return
                case.sucess(let value):
                    quizzes = value.quizzes
                }
                group.leave()
                    
            }
        }
        group.wait()
        return quizzes
    }
    
    func postLogin(username: String, password: String) -> Bool {
        let group = DispatchGroup()
        var loggedIn = false
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return false}
        let parameters: [String: Any] = [
            "username" : username,
            "password" : password
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return false}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        group.enter()
        NetworkService().executeUrlRequest(request) { (result: Result<LoginResponse, RequestError>) in
            switch result {
            case.failure(let error):
                return
            case.sucess(let value):
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(value.id, forKey: "user_id")
                userDefaults.setValue(value.token, forKey: "user_token")
                loggedIn = true
            }
            group.leave()
            
        }
        group.wait()
        return loggedIn
    }
    
    func postResult(timeInterval: Double, numberOfCorrect: Int) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
        let parameters: [String: Any] = [
            "quiz_id" : UserDefaults.standard.integer(forKey: "quiz_id"),
            "user_id" : UserDefaults.standard.integer(forKey: "user_id"),
            "time" : timeInterval,
            "no_of_correct" : numberOfCorrect
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.string(forKey: "user_token")!, forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        NetworkService().executeUrlRequest(request) { (result: Result<PostResultResponse, RequestError>) in
            switch result {
            case.failure(let error):
                return
            case.sucess(let value):
                print("result sent successfully \(value)")
            }
            
        }
    }
}
