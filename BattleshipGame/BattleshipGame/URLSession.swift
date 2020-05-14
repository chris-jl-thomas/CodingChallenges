//
//  URLSession.swift
//  BattleshipGame
//
//  Created by Chris Thomas on 14/05/2020.
//  Copyright © 2020 John Lewis PLC. All rights reserved.
//

import Combine
import Foundation

class Resource {
    private var cancellable: AnyCancellable?
    
    func makeAPIRequest(with shots: [String], player: String, game: Game, _ completion: @escaping (APIResponse) -> Void) {
        
        var urlComponents = URLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "shots", value: shots.joined()),
            URLQueryItem(name: "game", value: game.rawValue),
            URLQueryItem(name: "player", value: player)
        ]
        
        guard let url = urlComponents.url else { return } 
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard
                    let response = output.response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
        .decode(type: APIResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error): print("Nope, \(error)")
            case .finished: return
            }
        }, receiveValue: { model in
            completion(model)
        })
    }
    
    func cancel() {
        self.cancellable?.cancel()
    }
}

enum Game: String {
    
    case test = "TESTGAME"
    case game1 = "game1"
    case game2 = "game2"
}

enum HTTPError: Error {
    case statusCode
}
