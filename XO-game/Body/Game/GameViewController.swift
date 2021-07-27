//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    var gameMode: GameMode?
    
    private var counter: Int = 0
    public let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    var marks: [GameboardPosition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLabels()
        
        switch gameMode {
        case .pvp:
            
            firstTurn()
            
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                
                self.currentState.addSign(at: position)
                self.marks.append(position)
                if self.currentState.isMoveCompleted {
                    self.nextTurn()
                }
            }
            
        case .pvc:
            firstPlayerTurn()
            
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                
                self.currentState.addSign(at: position)
                self.counter += 1
                if self.currentState.isMoveCompleted {
                    self.nextPlayerTurn()
                }
                
    //            self.gameboardView.placeMarkView(XView(), at: position)
            }
        default:
            break
        }
        
    }
    
    private func firstTurn() {
        let firstPlayer: Player = .first
        currentState = TurnState(
            player: firstPlayer,
            gameViewController: self,
            markViewPrototype: firstPlayer.markViewPrototype,
            marks: marks
        )
    }
    
    private func secondTurn() {
        let secondPlayer: Player = .second
        currentState = TurnState(
            player: secondPlayer,
            gameViewController: self,
            markViewPrototype: secondPlayer.markViewPrototype,
            marks: marks
        )
    }
    
    private func nextTurn() {
        
        guard let turnState = currentState as? TurnState else { return }
        
        switch turnState.player {
        case .first:
            if turnState.marks.count > 4 {
                marks = []
                gameboardView.clear()
                secondTurn()
            } else {
                firstTurn()
            }
        case .second:
            if turnState.marks.count > 4 {
                endGame()
            } else {
                secondTurn()
            }
        default:
            break
        }
        
    }
    
    private func endGame() {
        
        gameboardView.clear()
        gameboardView.savedPositions.forEach { position, mark in
            gameboardView.placeMarkView(mark, at: position)
        }
        
        if let winner = referee.determineWinner() {
            currentState = GameEndState(
                gameMode: gameMode,
                winnerPlayer: winner,
                gameViewController: self
            )
        } else {
            currentState = GameEndState(
                gameMode: nil,
                winnerPlayer: nil,
                gameViewController: self
            )
        }
        
    }
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        currentState = PlayerGameState(
            player: firstPlayer,
            gameViewController: self,
            gameBoard: gameBoard,
            gameboardView: gameboardView,
            markViewPrototype: firstPlayer.markViewPrototype
        )
    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(gameMode: gameMode, winnerPlayer: winner, gameViewController: self)
            Logger.shared.log(action: .gameFinished(winner: winner))
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(winner: nil))
            currentState = GameEndState(gameMode: nil, winnerPlayer: nil, gameViewController: self)
            return
        }
        
        if let playerState = currentState as? PlayerGameState {
            let nextPlayer = playerState.player.next
            currentState = PlayerGameState(player: nextPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameboardView: gameboardView,
                                           markViewPrototype: nextPlayer.markViewPrototype)
            if gameMode == .pvc && nextPlayer == .second {
                gameboardView.fakeTouch()
            }
        }
    }
    
    private func prepareLabels() {
        
        firstPlayerTurnLabel.text = gameMode?.firstPlayer
        secondPlayerTurnLabel.text = gameMode?.secondPlayer
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        gameboardView.clear()
        gameBoard.clear()
        
        gameboardView.savedPositions = [:]
        
        switch gameMode {
        case .pvp:
            marks = []
            firstTurn()
        case .pvc:
            counter = 0
            firstPlayerTurn()
        default:
            break
        }
        Logger.shared.log(action: .restartGame)
    }
}

