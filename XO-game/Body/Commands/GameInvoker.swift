//
//  GameInvoker.swift
//  XO-game
//
//  Created by Lev on 7/26/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameInvoker {
    
    static let shared = GameInvoker()
    
    private init() {}
    
    private var commands: [GameCommand] = []
    private let numberOfCommandsToExecute: Int = 5
    
    func addCommand(_ command: GameCommand) {
        commands.append(command)
        execute()
    }
    
    private func execute() {
        guard commands.count + 1 >= numberOfCommandsToExecute else { return }
        
        commands.forEach { $0.command() }
        commands = []
    }
    
}
