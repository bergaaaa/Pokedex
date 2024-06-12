//
//  PokedexInterviewTests.swift
//  PokedexInterviewTests
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import XCTest
@testable import PokedexInterview

final class PokedexInterviewTests: XCTestCase {

    func testViewModelEmpty() throws {
        let viewModel = PokedexViewModel()
        
        XCTAssertTrue(viewModel.pokemonList.isEmpty)
    }
    
    func testViewController() throws {
        let viewController = PokedexViewController()
        XCTAssertTrue(viewController.viewModel.displayedList.isEmpty)
        
        viewController.viewModel = ViewModelMocked()
        viewController.viewDidLoad()
        XCTAssertFalse(viewController.viewModel.displayedList.isEmpty)
    }
}

class ViewModelMocked: PokedexViewModel {
    override func getPokemons(completion: @escaping () -> Void) {
        self.displayedList = [Pokemon(id: 0, name: "Kyogre", type1: .water, description: ""),
                            Pokemon(id: 1, name: "Groudon", type1: .fire, description: ""),
                            Pokemon(id: 2, name: "Rayquaza", type1: .dragon, type2: .dragon, description: "")]
        
        completion()
    }
}
