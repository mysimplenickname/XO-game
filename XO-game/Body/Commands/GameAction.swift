//
//  Actions.swift
//  XO-game
//
//  Created by Lev on 7/26/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum GameAction {
    
    case playerTurn(player: Player, position: GameboardPosition, gameboard: Gameboard)

}
