//
//  NetworkManager.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    
    func makeRequest<T: Codable>(to endpoint: String, completion: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.statusCode(httpResponse.statusCode)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data!)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.statusCode(httpResponse.statusCode)))
                return
            }
            guard let data else { return }
            completion(.success(data))
        }
        task.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case statusCode(Int)
    }
}
