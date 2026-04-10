//
//  SceneDelegate.swift
//  ToastUIDemo
//
//  Created by xiaobocui on 2026/4/10.
//

import UIKit
//import SwiftUI
//import ToastUI
import os
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let layoutLogger = Logger(subsystem: "com.cxb.ToastUIDemo", category: "SceneLayout")

    private let windowBackgroundColor = UIColor.systemRed
    private let rootControllerBackgroundColor = UIColor.systemYellow

    var window: UIWindow?
    //private var toastHostWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            logLayout("ToastUIDemo: scene is not UIWindowScene: \(type(of: scene))")
            return
        }

        logSceneWindowState("sceneWillConnectTo - beforeCreateWindow", scene: windowScene, window: nil)

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = ViewController()
        rootViewController.view.backgroundColor = rootControllerBackgroundColor
        window.rootViewController = rootViewController
        rootViewController.setNeedsStatusBarAppearanceUpdate()
        window.backgroundColor = windowBackgroundColor
        self.window = window
        window.makeKeyAndVisible()
        logSceneWindowState("sceneWillConnectTo - afterMakeKeyAndVisible", scene: windowScene, window: window)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.logSceneWindowState("sceneWillConnectTo - async 200ms", scene: windowScene, window: window)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.logSceneWindowState("sceneWillConnectTo - async 1s", scene: windowScene, window: window)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        logSceneWindowState("sceneDidBecomeActive", scene: windowScene, window: window)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        logSceneWindowState("sceneWillEnterForeground", scene: windowScene, window: window)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        logSceneWindowState("sceneDidEnterBackground", scene: windowScene, window: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        logSceneWindowState("sceneDidDisconnect", scene: windowScene, window: window)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (or in the face of an impending shutdown).
        guard let windowScene = scene as? UIWindowScene else { return }
        logSceneWindowState("sceneWillResignActive", scene: windowScene, window: window)
    }

    private func logSceneWindowState(_ tag: String, scene: UIWindowScene, window: UIWindow?) {
        if #available(iOS 13.0, *) {
            let allWindowSummaries = scene.windows.map { win in
                "\(NSString(string: NSCoder.string(for: win.frame))) safeArea=\(win.safeAreaInsets) bg=\(String(describing: win.backgroundColor)) level=\(win.windowLevel.rawValue) hidden=\(win.isHidden)"
            }.joined(separator: " || ")
            logLayout("ToastUIDemo [\(tag)] scene.windows = \(allWindowSummaries)")
            logLayout("ToastUIDemo [\(tag)] rootViewSuperview=\(String(describing: window?.rootViewController?.view.superview))")
        }

        let sceneBounds = scene.coordinateSpace.bounds
        let sceneWindowBounds = scene.screen.bounds
        let statusBarFrame = scene.statusBarManager?.statusBarFrame ?? .zero
        let safeArea = window?.safeAreaInsets ?? .zero

        let windowFrame = window?.frame ?? .zero
        let windowBounds = window?.bounds ?? .zero
        let rootVC = window?.rootViewController
        let rootViewFrame = rootVC?.view.frame ?? .zero
        let rootViewBounds = rootVC?.view.bounds ?? .zero
        let rootViewWindow = rootVC?.view.window
        let rootBackground = rootVC?.view.backgroundColor

        logLayout("ToastUIDemo [\(tag)] sceneBounds=\(NSString(string: NSCoder.string(for: sceneBounds))) sceneWindowBounds=\(NSString(string: NSCoder.string(for: sceneWindowBounds)))")
        logLayout("ToastUIDemo [\(tag)] statusBarFrame=\(NSString(string: NSCoder.string(for: statusBarFrame)))")
        logLayout("ToastUIDemo [\(tag)] windowFrame=\(NSString(string: NSCoder.string(for: windowFrame))) windowBounds=\(NSString(string: NSCoder.string(for: windowBounds))) windowSafeArea=\(safeArea)")
        logLayout("ToastUIDemo [\(tag)] rootVC=\(String(describing: rootVC)) rootViewFrame=\(NSString(string: NSCoder.string(for: rootViewFrame))) rootViewBounds=\(NSString(string: NSCoder.string(for: rootViewBounds)) ) rootViewWindow=\(String(describing: rootViewWindow)) rootBackground=\(String(describing: rootBackground))")
        logLayout("ToastUIDemo [\(tag)] screenNativeScale=\(window?.screen.nativeScale ?? 0) nativeBounds=\(NSString(string: NSCoder.string(for: window?.screen.nativeBounds ?? .zero)))")
        logLayout("ToastUIDemo [\(tag)] windowAutorez=\(String(describing: window?.autoresizingMask))")
    }

    private func logLayout(_ message: String) {
        debugPrint(message)
        layoutLogger.info("\(message, privacy: .public)")
        NSLog("%@", message)
        #if DEBUG
        appendLogToTempFile(message)
        #endif
    }

    private func appendLogToTempFile(_ message: String) {
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("ToastUIDemo_layout.log")
        let entry = "\(Date()): \(message)\n"
        if let data = entry.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: path) {
                if let fileHandle = try? FileHandle(forWritingTo: URL(fileURLWithPath: path)) {
                    try? fileHandle.seekToEnd()
                    try? fileHandle.write(contentsOf: data)
                    try? fileHandle.close()
                }
            } else {
                try? data.write(to: URL(fileURLWithPath: path), options: .atomic)
            }
        }
    }
}
