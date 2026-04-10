//
//  SceneDelegate.swift
//  ToastUIDemo
//
//  Created by xiaobocui on 2026/4/10.
//

import UIKit
import SwiftUI
import ToastUI

private struct ToastBootstrapView: View {
    var body: some View {
        Color.clear
            .ignoresSafeArea()
            .setupToastUI()
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let windowBackgroundColor = UIColor.systemRed

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = ViewController()
        let toastBootstrapController = UIHostingController(rootView: ToastBootstrapView())

        window.rootViewController = rootViewController
        window.backgroundColor = windowBackgroundColor
        self.window = window
        window.makeKeyAndVisible()

        toastBootstrapController.view.backgroundColor = .clear
        toastBootstrapController.view.isUserInteractionEnabled = false
        rootViewController.addChild(toastBootstrapController)
        rootViewController.view.addSubview(toastBootstrapController.view)
        toastBootstrapController.view.frame = rootViewController.view.bounds
        toastBootstrapController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toastBootstrapController.didMove(toParent: rootViewController)
    }
}
