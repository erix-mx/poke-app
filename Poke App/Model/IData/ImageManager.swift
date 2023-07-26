//
//  ImageManager.swift
//  Poke App
//
//  Created by Erix on 23/07/23.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdatePokemon(imageModel: ImageModel)
    func didFailWithError(error: String)
}

struct ImageManager {
    
    let delegate: ImageManagerDelegate?
    
    func fetchImage(from imageUrl: String) {
        performRequest(with: imageUrl)
        
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: "\(String(describing: error))" )
                } else {
                    if let safeData = data {
                        if let imageModel = self.parseJSON(imageData: safeData){
                            delegate?.didUpdatePokemon(imageModel: imageModel)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            return ImageModel(imageUrl: decodeData.sprites.other?.officialArtwork.frontDefault)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
