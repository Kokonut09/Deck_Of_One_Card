//
//  CardsViewController.swift
//  DeckOfOneCard
//
//  Created by Andrew Saeyang on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    // MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        CardController.fetchCard { result in
            
            DispatchQueue.main.async {
                
                switch result{
                case .success(let cards):
                    print(cards)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func drawButtonTapped(_ sender: Any) {
        CardController.fetchCard { [weak self] result in
            DispatchQueue.main.async {
                
                
                switch result{
                
                case .success(let card):
                    self?.fetchImageAndUpdateViews(for: card)
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
                
            }
            
        }
    }
    
    // MARK: - HELPER METHODS
    func fetchImageAndUpdateViews(for card:Card){
        CardController.fetchImage(for: card) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result{
                
                case .success(let image):
                    self?.cardImageView.image = image
                    self?.cardNameLabel.text = "\(card.value) of \(card.suit)"
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
                
            }
            
            
        }
    }
}
