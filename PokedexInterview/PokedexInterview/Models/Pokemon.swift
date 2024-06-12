//
//  Pokemon.swift
//  Pokedex
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import Foundation
import UIKit

struct Pokemon {
    var id: Int
    var name: String
    var type1: PokemonType
    var type2: PokemonType?
    var description: String
    var weight: Double?
    var imageName: String?
}

enum PokemonType {
    case grass
    case poison
    case fire
    case water
    case psychic
    case dark
    case ghost
    case electric
    case dragon
    case rock
    case flying
    case fairy
    case earth
    case fight
    case normal
    case bug
    
    var description: String {
        return String(describing: self).capitalized
    }
    
    static func getType(from typeString: String) -> PokemonType {
        switch typeString {
        case "grass":
            return .grass
        case "poison":
            return .poison
        case "fire":
            return .fire
        case "water":
            return .water
        case "psychic":
            return .psychic
        case "dark":
            return .dark
        case "ghost":
            return .ghost
        case "electric":
            return .electric
        case "dragon":
            return .dragon
        case "rock":
            return .rock
        case "flying":
            return .flying
        case "fairy":
            return .fairy
        case "earth":
            return .earth
        case "fight":
            return .fight
        case "normal":
            return .normal
        case "bug":
            return .bug
        default:
            return .normal
        }
    }
}

typealias GetPokemonClosure = ((PokedexResponse?, Error?) -> Void)
typealias GetPokemonDetailClosure = ((PokemonDetail?, Error?) -> Void)

struct PokedexResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonInfo]?
}

struct PokemonInfo: Codable {
    let name: String?
    let url: String?
}

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let weight: Double?
    let sprites: PokemonSprite?
    let types: [PokemonTypeDetail]
}

struct PokemonSprite: Codable {
    let front_default: String?
}

struct PokemonTypeDetail: Codable {
    let type: PokemonTypeDetailContent
    
}

struct PokemonTypeDetailContent: Codable {
    let name: String
}
