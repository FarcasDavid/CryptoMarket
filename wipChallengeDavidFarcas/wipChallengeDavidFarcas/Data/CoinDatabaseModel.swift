//
//  CoinDatabaseModel.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 05.09.2024.
//

import Foundation
import RealmSwift

class CoinDatabaseModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var price: Double = 0.0

    override static func primaryKey() -> String? {
        return "code"
    }
}
