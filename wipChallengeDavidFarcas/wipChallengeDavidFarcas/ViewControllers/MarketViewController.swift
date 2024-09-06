//
//  ViewController.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 16.08.2024.
//

import UIKit
import CryptoAPI
import RealmSwift

class MarketViewController: UIViewController {

    private var crypto: Crypto?
    private var viewModel = MarketViewModel()
    private let app = App(id: "app-wip-challenge-pghgwrd")
    // swiftlint:disable implicitly_unwrapped_optional
    private var dataSource: UITableViewDiffableDataSource<Section, CoinModel>!
    // swiftlint:enable implicitly_unwrapped_optional
    // swiftlint:disable force_try
    private var realm = try! Realm()
    // swiftlint:enable force_try
    // MARK: UI Components
    private let marketLabel = UILabel()
    private let marketTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        crypto = Crypto(delegate: self)
        connectToCryptoAPI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disconnectFromCryptoAPI()
    }

    private func connectToCryptoAPI() {
        guard let crypto = crypto else { return }

        let result = crypto.connect()

        switch result {
        case .success(let isConnected):
            if isConnected {
                print("Successfully connected to CryptoAPI")
                viewModel.getCoins(with: crypto) { isLoaded in
                    if isLoaded {
                        DispatchQueue.main.async {
                            self.updateDataSource()
                        }
                    }
                }
            } else {
                print("Failed to connect to CryptoAPI")
            }
        case .failure(let error):
            if let cryptoError = error as? CryptoError {
                switch cryptoError {
                case .connectAfter(let date):
                    print("Cannot connect to CryptoAPI before \(date)")
                @unknown default:
                    fatalError("Unknown Error")
                }
            } else {
                print("Failed to connect to CryptoAPI with error: \(error.localizedDescription)")
            }
        }
    }

    private func disconnectFromCryptoAPI() {
        crypto?.disconnect()
        print("Disconnected from CryptoAPI")
    }


    func setupUI() {
        view.backgroundColor = .white

        marketLabel.text = "Market"
        marketLabel.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        marketLabel.font = .robotoFont(ofSize: 30, weight: .bold)

        view.addSubview(marketLabel)
        view.addSubview(marketTableView)

        marketLabel.translatesAutoresizingMaskIntoConstraints = false
        marketTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            marketLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            marketLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            marketTableView.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 32),
            marketTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            marketTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            marketTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            ])
    }

    func setupTableView() {
        marketTableView.backgroundColor = .systemBackground
        marketTableView.allowsSelection = false
        marketTableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        marketTableView.delegate = self
        dataSource = UITableViewDiffableDataSource(
            tableView: marketTableView,
            cellProvider: { _, indexPath, _ -> UITableViewCell? in
                guard let cell = self.marketTableView.dequeueReusableCell(
                    withIdentifier: CoinCell.identifier,
                    for: indexPath
                ) as? CoinCell else {
                    fatalError("Unable to dequeue CoinCell")
                }
                if indexPath.row < self.viewModel.coinsModel.count {
                    let coin = self.viewModel.coinsModel[indexPath.row]
                    cell.configure(with: coin)
                }
                return cell
            }
        )
    }

}

extension MarketViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.coinsModel.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CoinModel>()
        snapshot.appendSections([.first])
        snapshot.appendItems(self.viewModel.coinsModel)

        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }

}

extension MarketViewController: CryptoDelegate {

    func cryptoAPIDidConnect() {
        print("Connected to CryptoAPI")
    }


    func cryptoAPIDidUpdateCoin(_ coin: CryptoAPI.Coin) {
        print("Updated coin \(coin.name) with price \(coin.price)")

        // Find the index of the updated coin in the coins array
        if let index = viewModel.coinsModel.firstIndex(where: { $0.code == coin.code }) {
            // Update the CoinModel at the found index
            let oldCoinValue = viewModel.coinsModel[index].price
            viewModel.coinsModel[index].min = min(coin.price, viewModel.coinsModel[index].min)
            viewModel.coinsModel[index].max = max(coin.price, viewModel.coinsModel[index].max)
            viewModel.coinsModel[index].price = coin.price
            let coinDatabaseModel = CoinDatabaseModel()
            coinDatabaseModel.name = coin.name
            coinDatabaseModel.code = coin.code
            coinDatabaseModel.price = coin.price

            DispatchQueue.main.async {
                do {
                    try self.realm.write {
                        self.realm.add(coinDatabaseModel, update: .modified)
                    }

                    // Verify if the coin is in the database
                    if let savedCoin = self.realm.object(ofType: CoinDatabaseModel.self, forPrimaryKey: coin.code) {
                        print("Coin saved: \(savedCoin)")
                    } else {
                        print("Failed to save coin")
                    }
                } catch {
                    print("Error writing to Realm: \(error.localizedDescription)")
                }
                let indexPath = IndexPath(row: index, section: 0)

                self.updateDataSource()

                if let cell = self.marketTableView.cellForRow(at: indexPath) as? CoinCell {
                    if oldCoinValue < coin.price {
                        cell.updatePriceAnimation(true)
                    } else {
                        cell.updatePriceAnimation(false)
                    }

                }
            }
        }
    }


    func cryptoAPIDidDisconnect() {
        print("Disconnected from CryptoAPI")
    }


}

enum Section {
    case first
}
