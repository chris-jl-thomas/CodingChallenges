//
//  API.swift
//  CodeChallenge11App
//
//  Created by Chris Thomas on 22/08/2019.
//  Copyright © 2019 John Lewis plc. All rights reserved.
//

import Foundation

enum API {}

extension API {
    struct Pubs: Codable {
        let pubs: [Pub]
        
        enum CodingKeys: String, CodingKey {
            case pubs = "Pubs"
        }
    }
    
    struct Pub: Codable {
        let name: String
        let postCode: String?
        let regularBeers: [String]?
        let guestBeers: [String]?
        let pubService: String
        let id: String
        let branch: String
        let createTS: String
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case postCode = "PostCode"
            case regularBeers = "RegularBeers"
            case guestBeers = "GuestBeers"
            case pubService = "PubService"
            case id = "Id"
            case branch = "Branch"
            case createTS = "CreateTS"
        }
    }
}
