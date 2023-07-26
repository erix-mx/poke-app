//
//  PokemonData.swift
//  Poke App
//
//  Created by Erix on 23/07/23.
//

import Foundation

// MARK: - Welcome
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}
