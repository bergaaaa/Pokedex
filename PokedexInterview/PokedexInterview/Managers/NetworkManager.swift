//
//  NetworkManager.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func createRequest(for path: String, httpMethod: String = "GET") -> URLRequest? {
        guard let url = URL(string: path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data) {
                print(jsonData)
            }

            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decodedResponse, nil)
                }
            } else {
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
}

extension NetworkManager {
    public func getPokemons(offset: Int, completion: GetPokemonClosure?) {
        guard let request = createRequest(for: Endpoint.pokemon(offset).path) else {
            return
        }
        
        executeRequest(request: request, completion: completion)
    }
    
    public func getPokemonDetail(url: String, completion: GetPokemonDetailClosure?) {
        guard let request = createRequest(for: url) else {
            return
        }
        
        executeRequest(request: request, completion: completion)
    }
}
