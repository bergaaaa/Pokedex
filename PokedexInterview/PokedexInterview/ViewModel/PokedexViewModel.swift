//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import Foundation

class PokedexViewModel {
    
    static let itemsPerPage = 20
    
    var pokemonList: [Pokemon] = []
    
    var filteredList: [Pokemon] = []
    var displayedList: [Pokemon] = []
    
    var isLoading = false
    var currentPage = 0
    var isLastPage = false
    
    var filterText: String? {
        didSet {
            if let filterText = self.filterText, !filterText.isEmpty {
                self.filteredList = self.pokemonList.filter { pokemon in
                    pokemon.name.lowercased().contains(filterText.lowercased()) ||
                    pokemon.type1.description.lowercased().contains(filterText.lowercased()) ||
                    (pokemon.type2?.description.lowercased().contains(filterText.lowercased()) ?? false)
                }
            } else {
                self.filteredList = self.pokemonList
            }
        }
    }
    var group = DispatchGroup()
    
    func getPokemons(completion: @escaping() -> Void) {
        NetworkManager.shared.getPokemons(offset: currentPage * 20, completion: { [weak self] pokeList, error in
            guard let self = self, error == nil else { return }

            for pokemon in pokeList?.results ?? [] {
                if !self.pokemonList.contains(where: { $0.name == pokemon.name }) {
                    self.group.enter()
                    self.getPokemonDetail(url: pokemon.url ?? "")
                }
            }
            
            self.group.notify(queue: .main) {
                completion()
            }
        })
    }
    
    func getPokemonDetail(url: String) {
        NetworkManager.shared.getPokemonDetail(url: url, completion: { [weak self] details, error in
            guard let self = self, let details = details, error == nil else { return }
            
            var type2: PokemonType? = nil
            if details.types.count > 1 {
                type2 = PokemonType.getType(from: details.types[1].type.name)
            }
            
            pokemonList.append(
                Pokemon(
                    id: details.id,
                    name: details.name,
                    type1: PokemonType.getType(from: details.types.first?.type.name ?? ""),
                    type2: type2,
                    description: details.name,
                    weight: details.weight,
                    imageName: details.sprites?.front_default
                )
            )
            
            pokemonList = pokemonList.sorted(by: { $0.id < $1.id })

            if let filterText = self.filterText, !filterText.isEmpty {
                self.filteredList = self.pokemonList.filter { pokemon in
                    pokemon.name.lowercased().contains(filterText.lowercased()) ||
                    pokemon.type1.description.lowercased().contains(filterText.lowercased()) ||
                    (pokemon.type2?.description.lowercased().contains(filterText.lowercased()) ?? false)
                }
            }  else {
                filteredList = self.pokemonList
            }
            
            self.group.leave()
        })
    }
}
