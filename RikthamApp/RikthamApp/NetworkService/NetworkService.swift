//
//  NetworkService.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation

typealias Envelope<T: Codable> = Result<T>

protocol YelpEndPoint {
    var url: URL? { get }
}

enum Result <T>{
    case success(T)
    case failure(AppError)
}


protocol NetworkServiceType: AnyObject {
    func request<T: Codable>(with endPoint: YelpEndPoint, completion: @escaping (Envelope<T>) -> ())
}

/// Manager for handling all REST API calls
final class NetworkService: NetworkServiceType {
    
    static let shared = NetworkService()
    //1 creating the session
    private let session: URLSession
    
    private init(configuration: URLSessionConfiguration) {
        configuration.timeoutIntervalForRequest = 60.00
        configuration.httpAdditionalHeaders = ["Authorization": AppConstants.apiKey]
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    //Data call with request
    
    func request<T: Codable>(with endPoint: YelpEndPoint, completion: @escaping (Envelope<T>) -> ()) {
        guard let url = endPoint.url else {
            completion(.failure(.urlError))
            return
        }
        print("Service URL: \(url.absoluteString)")
        let task = self.session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse  else {
                completion(.failure(.networkError))
                return
            }
            if httpResponse.statusCode == 200, let responsedata = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: responsedata)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    completion(.failure(.jsonDecodingError))
                }
                
            } else {
                completion(.failure(.networkError))
            }
        }
        task.resume()
    }
    
}
