//
//  BeerCell.swift
//  CodeChallenge11App
//
//  Created by Chris Thomas on 22/08/2019.
//  Copyright © 2019 John Lewis plc. All rights reserved.
//

import UIKit

class BeerCell: UITableViewCell {
    
    static let reuseIdentifier = "BeerCell"
    
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var pubNameLabel: UILabel!

    func update(with beer: Beer) {
        beerNameLabel.text = beer.name
        pubNameLabel.text = beer.pubName
    }
}
