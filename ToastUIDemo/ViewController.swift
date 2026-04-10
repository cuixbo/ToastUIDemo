//
//  ViewController.swift
//  ToastUIDemo
//
//  Created by xiaobocui on 2026/4/10.
//

import UIKit
//import ToastUI
//import SwiftUI
import os
import Foundation

final class ViewController: UIViewController {
    private let layoutLogger = Logger(subsystem: "com.cxb.ToastUIDemo", category: "ViewLayout")

    override var prefersStatusBarHidden: Bool {
        true
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    private lazy var showToastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Toast", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapShowToast), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        logLayout("ToastUIDemo [ViewController] viewDidLoad: frame=\(NSCoder.string(for: view.frame)) bounds=\(NSCoder.string(for: view.bounds)) safeArea=\(view.safeAreaInsets)")
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logLayout("ToastUIDemo [ViewController] viewWillAppear(animated:\(animated)) - frame=\(NSCoder.string(for: view.frame)) bounds=\(NSCoder.string(for: view.bounds)) safeArea=\(view.safeAreaInsets)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logLayout("ToastUIDemo [ViewController] viewDidAppear(animated:\(animated)) - frame=\(NSCoder.string(for: view.frame)) bounds=\(NSCoder.string(for: view.bounds)) safeArea=\(view.safeAreaInsets)")
        if let window = view.window {
            logLayout("ToastUIDemo [ViewController] attached window frame=\(NSCoder.string(for: window.frame)) bounds=\(NSCoder.string(for: window.bounds)) windowSafeArea=\(window.safeAreaInsets)")
        } else {
            logLayout("ToastUIDemo [ViewController] attached window = nil")
        }
        let containerVC = navigationController ?? self
        logLayout("ToastUIDemo [ViewController] root container=\(String(describing: containerVC.parent)) hasWindow=\(containerVC.view.window != nil)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logLayout("ToastUIDemo [ViewController] viewWillLayoutSubviews - frame=\(NSCoder.string(for: view.frame)) bounds=\(NSCoder.string(for: view.bounds)) safeArea=\(view.safeAreaInsets)")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logLayout("ToastUIDemo [ViewController] viewDidLayoutSubviews - frame=\(NSCoder.string(for: view.frame)) bounds=\(NSCoder.string(for: view.bounds)) safeArea=\(view.safeAreaInsets)")
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

    private func setupUI() {
        view.addSubview(showToastButton)
        NSLayoutConstraint.activate([
            showToastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showToastButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showToastButton.heightAnchor.constraint(equalToConstant: 52),
            showToastButton.widthAnchor.constraint(equalToConstant: 180),
        ])
    }

    @objc private func didTapShowToast() {
        // Toast 接入已注释，避免在 demo 中触发库调用。
        // Task { @MainActor in
        //     ToastManager.shared.info(
        //       title:  "如果你看到了这条消息，说明接入成功。",
        //       message: nil,
        //       duration: 2.0,
        //       alignment: .top,
        //       backgroundColor: Color.cyan,
        //       configuration: .minimal,
        //       showCloseButton: false,
        //       enableCopy: false
        //     )
        // }
    }
}
