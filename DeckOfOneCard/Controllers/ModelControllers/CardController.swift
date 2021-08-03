//
//  File.swift
//  DeckOfOneCard
//
//  Created by Andrew Saeyang on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardController{
    
    //https://deckofcardsapi.com/api/deck/new/draw/?count=1
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    //static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        // 1 - Prepare URL
        
        guard let url = baseURL else {return completion(.failure(.invalidURL))}
        //let finalURL = baseURL.appendingPathComponent("?count=1")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let query = URLQueryItem(name: "count", value: String(1))
        
        components?.queryItems = [query]
        
        guard let finalURL = components?.url else { return }
        
        print(finalURL)
        
        // 2 - Contact server
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            // 3 - Handle errors from the server
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("CARD DRAW STATUS CODE:\(response.statusCode)")
            }
            // 4 - Check for json data
            guard let data = data else{ return completion(.failure(.noData))}
            
            // 5 - Decode json into a Card
            do{
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else { return }
                return completion(.success(card))
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.noData))
            }
            
        }.resume()
        
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void){
        // 1 - Prepare URL
        //pulling off card that is passed in
        guard let imageUrl = card.image else { return completion(.failure(.invalidURL)) }
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: imageUrl){ data, response, error in
            
            // 3 - Handle errors from the server
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            // 4 - Check for image data
            guard let data = data else { return completion(.failure(.noData))}
            
            // 5 - Initialize an image from the data
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            
            return completion(.success(image))
        
        }.resume()
    }
}
