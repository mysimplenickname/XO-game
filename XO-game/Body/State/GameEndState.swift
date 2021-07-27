//
//  GameEndState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameEndState: GameState {
    var isMoveCompleted: Bool = false
    
    public let winnerPlayer: Player?
    weak var gameViewController: GameViewController?
    
    private let gameMode: GameMode?
    
    init(gameMode: GameMode?, winnerPlayer: Player?, gameViewController: GameViewController) {
        self.gameMode = gameMode
        
        self.winnerPlayer = winnerPlayer
        self.gameViewController = gameViewController
    }
    
    func addSign(at position: GameboardPosition) {}
    
    func begin() {
        
        guard let gameVC = gameViewController else { return }
        gameVC.winnerLabel.isHidden = false
        
        if let winnerPlayer = winnerPlayer {
            gameVC.winnerLabel.text = setPlayerName(player: winnerPlayer) + " won"
        } else {
            gameVC.winnerLabel.text = "No winner/Draw"
        }
        
        gameVC.firstPlayerTurnLabel.isHidden = true
        gameVC.secondPlayerTurnLabel.isHidden = true
    }
    
    private func setPlayerName(player: Player) -> String {
        switch player {
        case .first:
            return gameMode?.firstPlayer ?? "First player"
        case .second:
            return gameMode?.secondPlayer ?? "Second player"
        }
    }
    
}
