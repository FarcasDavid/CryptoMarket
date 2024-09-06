# CryptoMark et iOS App
## Overview
CryptoMarket is an iOS app developed using UIKit that displays real-time cryptocurrency prices with a sleek and simple UI. Users can monitor price fluctuations for popular cryptocurrencies, including Bitcoin, Ethereum, Litecoin, and more.

The app features a table view with each cell displaying the cryptocurrency’s min/max price, coin code, and the current price. All price changes are stored locally using Realm for easy access and tracking.

## Features
Real-time Cryptocurrency Prices: Prices are fetched from a local CryptoAPI and updated continuously in the app.
Visual Representation: Each coin’s data (min, max, current price) is presented in a clean, simple table view.
Update Animation: When prices are updated, a smooth animation is triggered to highlight the changes, making it easy for users to spot updates.
Local Data Storage: All price changes and historical data are saved using Realm, allowing you to access this data even when offline.

## Technologies Used
UIKit: Core UI development framework for the app.
CryptoAPI: Local API for fetching real-time cryptocurrency data.
Realm: Local database for persistent storage of price data.
