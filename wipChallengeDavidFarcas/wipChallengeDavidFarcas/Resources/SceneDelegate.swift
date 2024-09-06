//
//  SceneDelegate.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 16.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
    }

    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let viewController = MarketViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

}
