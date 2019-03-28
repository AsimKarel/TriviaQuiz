//
//  MainScreenViewController.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var uNameTextField: UITextField!
    var player:PlayerModel!;
    override func viewDidLoad() {
        super.viewDidLoad()
        player = PlayerModel();
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startNewGameTapped(_ sender: Any) {
        player.name = uNameTextField.text!;
        performSegue(withIdentifier: "newGameSegue", sender: self)
    }
    
    @IBAction func historyTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue"{
            if let destination = segue.destination as? Question1ViewController{
                destination.player = player;
            }
        }
    }
    
    
    
}
