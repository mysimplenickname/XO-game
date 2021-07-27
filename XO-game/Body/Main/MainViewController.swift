//
//  MainViewController.swift
//  XO-game
//
//  Created by Lev on 7/25/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var pvpButton: UIButton!
    @IBOutlet weak var pvcButton: UIButton!
    
    private var gameMode: GameMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameViewController else { return }
        gameVC.gameMode = gameMode
    }

    @IBAction func pvpButtonTapped(_ sender: Any) {
        gameMode = .pvp
        performSegue(withIdentifier: "ToGameViewControllerSegue", sender: nil)
    }
    
    @IBAction func pvcButtonTapped(_ sender: Any) {
        gameMode = .pvc
        performSegue(withIdentifier: "ToGameViewControllerSegue", sender: nil)
    }
    
}
