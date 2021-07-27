//
//  GameCommandCreator.swift
//  XO-game
//
//  Created by Lev on 7/26/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameCommandCreator {
    
    static let shared = GameCommandCreator()
    
    private init() {}
    
    func createCommand(for action: GameAction) {
        let command = GameCommand(for: action)
        GameInvoker.shared.addCommand(command)
    }
    
}
