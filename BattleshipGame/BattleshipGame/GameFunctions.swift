//
//  GameFunctions.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Foundation

class GameFunctions {
    
    let resource = Resource()
    var lastResult: APIResponse?
    
    func makeGuess() {
        resource.makeAPIRequest(with: ["A0"], player: "TestRandC", game: .test) { result in
            self.lastResult = result
            print(result)
        }
    }
}
