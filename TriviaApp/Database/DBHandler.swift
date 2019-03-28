//
//  DBHandler.swift
//  TriviaApp
//
//  Created by Asim Karel on 29/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
class DBHandler {
    
    func saveGame(player:PlayerModel) {
        let playerId = DBManager.shared.savePlayer(player: player);
        if playerId != 0{
            for option in player.selectedOptions{
                DBManager.shared.saveResult(option: option, player: playerId)
            }
        }
        
    }
    
    
    
}
