//
//  CoinModel.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 19.08.2024.
//

import Foundation
import UIKit

struct CoinModel: Hashable {

    var image: UIImage
    let name: String
    let code: String
    var price: Double
    var min: Double
    var max: Double

    var priceWithCurrency: String {
        return String(format: "$ %.2f", price)
    }

    var minWithCurrency: String {
        return String(format: "$ %.2f", min)
    }

    var maxWithCurrency: String {
        return String(format: "$ %.2f", max)
    }

}
