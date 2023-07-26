//
//  PokemonManager.swift
//  Poke App
//
//  Created by Erix on 23/07/23.
//

import Foundation


protocol PokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel])
    func didFailWithError(error: String)
}

struct PokemonManager {
    
    let pokemonUrl: String = "https://pokeapi.co/api/v2/pokemon/?limit=151"
    let delegate: PokemonManagerDelegate?
    
    func fetchPokemonApi() {
        performRequest(with: pokemonUrl)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: "\(String(describing: error))" )
                } else {
                    if let safeData = data {
                        if let pokemons = self.parseJSON(pokemonData: safeData) {
                            delegate?.didUpdatePokemon(pokemons: pokemons)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let listPokemon = decodeData.results?.map { item in
                PokemonModel(name: item.name, imageUrl: item.url)
            }
            return listPokemon
        } catch {
            return nil
        }
    }
}
