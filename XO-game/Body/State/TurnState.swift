//
//  TurnState.swift
//  XO-game
//
//  Created by Lev on 7/26/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class TurnState: GameState {
    
    var isMoveCompleted: Bool = false
    let player: Player!
    weak var gameViewController: GameViewController?
    var markViewPrototype: MarkView
    
    var marks: [GameboardPosition] = []
    
    init(player: Player, gameViewController: GameViewController, markViewPrototype: MarkView, marks: [GameboardPosition]) {
        self.player = player
        self.gameViewController = gameViewController
        self.markViewPrototype = markViewPrototype
        self.marks = marks
    }
    
    func addSign(at position: GameboardPosition) {
        guard !isMoveCompleted else { return }
        
        gameViewController?.gameboardView.placeMarkView(markViewPrototype, at: position)
//        gameViewController?.gameBoard.setPlayer(player, at: position)
        
        GameCommandCreator.shared.createCommand(for:
                                                    .playerTurn(
                                                        player: player,
                                                        position: position,
                                                        gameboard: gameViewController!.gameBoard
                                                    )
                                                )
        
        marks.append(position)
        
        isMoveCompleted = true
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        case .none:
            break
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
}
