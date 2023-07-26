//
//  ImageData.swift
//  Poke App
//
//  Created by Erix on 23/07/23.
//

import Foundation

struct ImageData: Codable {
    let sprites: Sprites
}

class Sprites: Codable {
    let other: Other?
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault, frontShiny: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
