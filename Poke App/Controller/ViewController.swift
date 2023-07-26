//
//  ViewController.swift
//  Poke App
//
//  Created by Erix on 20/07/23.
//
import UIKit
import Kingfisher

class ViewController: UIViewController, PokemonManagerDelegate, ImageManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    // MARK: - Properties
    
    lazy var pokemonManager = PokemonManager(delegate: self)
    lazy var imageManager = ImageManager(delegate: self)
    var gameModel = GameModel()
    
    // Data game
    var random4Pokemons: [PokemonModel] = [] {
        didSet {
            setButtonTitles()
        }
    }
    var correctAnswer: String = ""
    var correctImage: String = ""
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokemonName.text = ""
        labelScore.text = "Score: 0"
        decoreButtons()
        pokemonManager.fetchPokemonApi()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - PokemonManagerDelegate
    
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        let random4Pokemons = pokemons.chose(4)
        let randomIndex = Int.random(in: 0...3)
        self.random4Pokemons = random4Pokemons
        correctAnswer = random4Pokemons[randomIndex].name
        
        let imageUrl = random4Pokemons[randomIndex].imageUrl
        imageManager.fetchImage(from: imageUrl)
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
    // MARK: - ImageManagerDelegate
    
    func didUpdatePokemon(imageModel: ImageModel) {
        DispatchQueue.main.async {
            if let safeUrl = imageModel.imageUrl {
                self.correctImage = safeUrl
                let url = URL(string: safeUrl)
                let effect = ColorControlsProcessor(brightness: 1, contrast: 1, saturation: 1, inputEV: 0)
                self.pokemonImage.kf.setImage(
                    with: url,
                    options: [
                        .processor(effect)
                    ]
                )
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonSelector(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            DispatchQueue.main.async {
                let url = URL(string: self.correctImage)
                self.pokemonImage.kf.setImage(
                    with: url
                )
            }
            if gameModel.checkAnswer(userAnswer: title, correctAnswer: correctAnswer) {
                pokemonName.text = "Yes, it's \(title)."
                labelScore.text = "Score: \(gameModel.getScore())"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    pokemonName.text = ""
                    pokemonManager.fetchPokemonApi()
                }
            } else {
                pokemonName.text = "❌"
                self.performSegue(withIdentifier: "goToResult", sender: self)
                resetGame()
            }
        }
    }
    
    // MARK: - Helpers
    
    func decoreButtons() {
        for button in answerButtons {
            button.layer.cornerRadius = button.frame.width / 2.0
            print("Button frame: \(button.frame)")
        }
    }
    
    func setButtonTitles() {
        for (index, button) in answerButtons.enumerated() {
            DispatchQueue.main.async { [self] in
                let attributeText = NSAttributedString(
                    string: "\(random4Pokemons[safe: index]?.name.capitalized ?? "Unknown")",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold),
                        NSAttributedString.Key.foregroundColor: UIColor.white
                    ]
                )
                button.setAttributedTitle(attributeText, for: .normal)
            }
        }
    }
    
    func resetGame() {
        pokemonManager.fetchPokemonApi()
        pokemonName.text = ""
        labelScore.text = "Score: 0"
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destination = segue.destination as! ResultController
            destination.name = correctAnswer
            destination.pokemonImageUrl = correctImage
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// Extensions

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index]: nil
    }
}

extension Collection {
    func chose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
