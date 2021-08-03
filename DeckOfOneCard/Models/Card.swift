//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Andrew Saeyang on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct TopLevelObject: Decodable{
    var cards: [Card]
    
}
struct Card: Decodable{
    
    let value: String
    let suit: String
    let image: URL?
    
}
