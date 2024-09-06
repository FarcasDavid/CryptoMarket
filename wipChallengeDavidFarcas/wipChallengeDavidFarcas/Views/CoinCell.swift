//
//  CoinCell.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 16.08.2024.
//

import UIKit

class CoinCell: UITableViewCell {

    static let identifier = "CoinCell"

    private let coinLogoImageView = UIImageView()
    private let coinTitleLabel = UILabel()
    private let coinAbbreviationLabel = UILabel()
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    private let minValueLabel = UILabel()
    private let maxValueLabel = UILabel()
    private let currentValueLabel = UILabel()
    private let priceChangeView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with coin: CoinModel) {
        self.coinLogoImageView.image = coin.image
        self.coinTitleLabel.text = coin.name
        self.coinAbbreviationLabel.text = coin.code
        self.currentValueLabel.text = coin.priceWithCurrency
        self.minValueLabel.text = coin.minWithCurrency
        self.maxValueLabel.text = coin.maxWithCurrency

    }

    func updatePriceAnimation(_ flag: Bool) {
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.priceChangeView.backgroundColor =
                flag ? UIColor.green.withAlphaComponent(0.5) : UIColor.red.withAlphaComponent(0.5)
                self.currentValueLabel.textColor = .white
            }, completion: { _ in
                UIView.animate(withDuration: 0.4, animations: {
                    self.priceChangeView.backgroundColor = .clear
                    self.currentValueLabel.textColor = .black
                })
            }
        )
    }


    private func setupUI() {

        coinTitleLabel.text = "Some Coin"
        coinTitleLabel.textColor = .black
        coinTitleLabel.font = .robotoFont(ofSize: 17, weight: .regular)

        coinAbbreviationLabel.text = "SMC"
        coinAbbreviationLabel.textColor = .gray
        coinAbbreviationLabel.font = .robotoFont(ofSize: 17, weight: .regular)

        minLabel.text = "min: "
        minLabel.textColor = .gray
        minLabel.font = .robotoFont(ofSize: 10, weight: .regular)
        maxLabel.text = "max: "
        maxLabel.textColor = .gray
        maxLabel.font = .robotoFont(ofSize: 10, weight: .regular)

        minValueLabel.textColor = .black
        minValueLabel.font = .robotoFont(ofSize: 12, weight: .regular)
        maxValueLabel.textColor = .black
        maxValueLabel.font = .robotoFont(ofSize: 12, weight: .regular)

        currentValueLabel.text = "$ 0.0"
        currentValueLabel.textColor = .black
        currentValueLabel.font = .robotoFont(ofSize: 17, weight: .regular)

        priceChangeView.backgroundColor = .clear
        priceChangeView.layer.cornerRadius = 4

        coinLogoImageView.clipsToBounds = true
        self.contentView.addSubview(coinLogoImageView)
        self.contentView.addSubview(coinTitleLabel)
        self.contentView.addSubview(coinAbbreviationLabel)
        self.contentView.addSubview(minLabel)
        self.contentView.addSubview(maxLabel)
        self.contentView.addSubview(minValueLabel)
        self.contentView.addSubview(maxValueLabel)
        self.contentView.addSubview(priceChangeView)
        self.priceChangeView.addSubview(currentValueLabel)

        coinLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        coinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        coinAbbreviationLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        minValueLabel.translatesAutoresizingMaskIntoConstraints = false
        maxValueLabel.translatesAutoresizingMaskIntoConstraints = false
        currentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChangeView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            coinLogoImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            coinLogoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            coinLogoImageView.heightAnchor.constraint(equalToConstant: 30),
            coinLogoImageView.widthAnchor.constraint(equalToConstant: 30),

            coinTitleLabel.centerYAnchor.constraint(equalTo: coinLogoImageView.centerYAnchor),
            coinTitleLabel.leadingAnchor.constraint(equalTo: coinLogoImageView.trailingAnchor, constant: 12),
            coinAbbreviationLabel.centerYAnchor.constraint(equalTo: coinTitleLabel.centerYAnchor),
            coinAbbreviationLabel.leadingAnchor.constraint(equalTo: coinTitleLabel.trailingAnchor, constant: 16),

            priceChangeView.centerYAnchor.constraint(equalTo: coinTitleLabel.centerYAnchor),
            priceChangeView.trailingAnchor.constraint(
                equalTo: self.contentView.layoutMarginsGuide.trailingAnchor
            ),
            priceChangeView.heightAnchor.constraint(equalToConstant: 30),
            priceChangeView.widthAnchor.constraint(equalToConstant: 100),

            currentValueLabel.centerXAnchor.constraint(equalTo: priceChangeView.centerXAnchor),
            currentValueLabel.centerYAnchor.constraint(equalTo: priceChangeView.centerYAnchor),

            minLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            minLabel.leadingAnchor.constraint(equalTo: coinLogoImageView.trailingAnchor, constant: 8),
            minValueLabel.bottomAnchor.constraint(
                equalTo: self.contentView.layoutMarginsGuide.bottomAnchor
            ),
            minValueLabel.leadingAnchor.constraint(equalTo: minLabel.trailingAnchor),

            maxLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            maxLabel.leadingAnchor.constraint(equalTo: minValueLabel.trailingAnchor, constant: 32),
            maxValueLabel.bottomAnchor.constraint(
                equalTo: self.contentView.layoutMarginsGuide.bottomAnchor
            ),
            maxValueLabel.leadingAnchor.constraint(equalTo: maxLabel.trailingAnchor)
        ])
    }

}
