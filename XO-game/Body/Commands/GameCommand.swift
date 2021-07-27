//
//  Command.swift
//  XO-game
//
//  Created by Lev on 7/26/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameCommand {
    
    private var action: GameAction
    
    init(for action: GameAction) {
        self.action = action
    }
    
    func command() {
        
        switch action {
        case .playerTurn(
                let player,
                let position,
                let gameboard
        ):
            gameboard.setPlayer(player, at: position)
        }
        
    }
    
}
