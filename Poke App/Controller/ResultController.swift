//
//  ResultController.swift
//  Poke App
//
//  Created by Erix on 25/07/23.
//

import UIKit
import Kingfisher

class ResultController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBAction func buttonReplay(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var name = ""
    var pokemonImageUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonName.text = name.capitalized
        if let imageUrl = URL(string: pokemonImageUrl) {
            pokemonImage.kf.setImage(with: imageUrl)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
