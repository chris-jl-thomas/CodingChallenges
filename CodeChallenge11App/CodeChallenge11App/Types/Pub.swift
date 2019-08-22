//
//  Pub.swift
//  CodeChallenge11App
//
//  Created by Chris Thomas on 22/08/2019.
//  Copyright © 2019 John Lewis plc. All rights reserved.
//

import Foundation

struct Pub {
    let name: String
    let postCode: String?
    let regularBeers: [String]
    let guestBeers: [String]
    let pubService: URL
    let id: String
    let branch: String
    let createTS: Date
}

extension Pub {
    init(_ apiPub :API.Pub) {
        
        guard
            let url = URL(string: apiPub.pubService),
            let date = Pub.formatDate(string: apiPub.createTS)
        else {
            fatalError()
        }
        
        self.name = apiPub.name
        self.postCode = apiPub.postCode
        self.regularBeers = apiPub.regularBeers ?? []
        self.guestBeers = apiPub.guestBeers ?? []
        self.pubService = url
        self.id = apiPub.id
        self.branch = apiPub.branch
        self.createTS = date
    }
    
    static func formatDate(string: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }
}
