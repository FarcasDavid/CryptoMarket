//
//  MarketViewModel.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 19.08.2024.
//

import Foundation
import CryptoAPI
import UIKit

class MarketViewModel {

    var coinsModel: [CoinModel] = []
    private var coins: [Coin] = []
    private let dispatchGroup = DispatchGroup()

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    func getCoins(with crypto: Crypto, completion: @escaping (Bool) -> Void) {
        coins = crypto.getAllCoins()
        coinsModel = coins.map { coin in
            return CoinModel(
                image: UIImage(),
                name: coin.name,
                code: coin.code,
                price: coin.price,
                min: coin.price,
                max: coin.price
            )
        }
        for (index, coin) in coins.enumerated() {
            self.dispatchGroup.enter()
            downloadImage(from: coin.imageUrl ?? "") { image in
                if let image = image {
                    self.coinsModel[index].image = image
                }
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
    }

}
