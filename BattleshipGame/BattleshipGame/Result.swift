//
//  Result.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let results: [String]
}

let url = URL(string: "https://challenge27.appspot.com/")!
