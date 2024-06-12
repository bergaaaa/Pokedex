//
//  Endpoints.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

enum Endpoint {
    case details(String)
    case pokemon(Int)
    
    var path: String {
        switch self {
        case .details(let id): return "https://pokeapi.co/api/v2/pokemon/\(id)"
        case .pokemon(let offset):
            if offset > 0 {
                return "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)"
            }
            return "https://pokeapi.co/api/v2/pokemon"
        }
    }
}
