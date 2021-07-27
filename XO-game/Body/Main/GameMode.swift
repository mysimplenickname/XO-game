//
//  GameMode.swift
//  XO-game
//
//  Created by Lev on 7/25/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum GameMode {
    
    case pvp
    case pvc
    
    var firstPlayer: String {
        switch self {
        case .pvp: return "First player"
        case .pvc: return "Player"
        }
    }
    
    var secondPlayer: String {
        switch self {
        case .pvp: return "Second player"
        case .pvc: return "Computer"
        }
    }
    
}
