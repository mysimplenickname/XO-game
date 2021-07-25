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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLabels()
        
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
    }
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        currentState = PlayerGameState(player: firstPlayer, gameViewControler: self,
                                       gameBoard: gameBoard,
                                       gameboardView: gameboardView,
                                       markViewPrototype: firstPlayer.markViewPrototype)
        
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
                                           gameViewControler: self,
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
        counter = 0
        
        firstPlayerTurn()
        
        Logger.shared.log(action: .restartGame)
    }
}

