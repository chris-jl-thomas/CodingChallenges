//
//  Beers.swift
//  CodeChallenge11App
//
//  Created by Chris Thomas on 22/08/2019.
//  Copyright © 2019 John Lewis plc. All rights reserved.
//

import Foundation

struct Beer {
    let name: String
    let pubName: String
    let pubService: URL
    let beerType: BeerType
}

enum BeerType {
    case regular
    case guest
}
