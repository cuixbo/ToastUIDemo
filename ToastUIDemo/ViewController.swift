//
//  ViewController.swift
//  ToastUIDemo
//
//  Created by xiaobocui on 2026/4/10.
//

import UIKit
import SwiftUI
import ToastUI

final class ViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        true
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func makeToastButton(title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = UIColor(red: 47 / 255.0, green: 128 / 255.0, blue: 237 / 255.0, alpha: 1)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }

    private func makeLabeledButtonRow(
        labelText: String,
        buttonTitle: String,
        action: @escaping () -> Void
    ) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 110).isActive = true

        let button = makeToastButton(title: buttonTitle, action: action)
        row.addArrangedSubview(label)
        row.addArrangedSubview(button)
        return row
    }

    private func makeSectionHeader(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        ToastManager.shared.queueMode = .dropOldestVisibleLimit(3)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])

        let testSections: [(String, [(String, String, () -> Void)])] = [
            (
                "1. 基础能力",
                [
                    ("1.1", "Info（仅标题）", { [weak self] in self?.showToastOnlyTitle() }),
                    ("1.2", "仅标题-提交成功", { [weak self] in self?.showToastOnlyTitleSubmitSuccess() }),
                    ("1.3", "仅标题-长文左对齐折行", { [weak self] in self?.showToastOnlyTitleLongTextLeft() }),
                    ("1.4", "Info（默认）", { [weak self] in self?.showToastInfo() }),
                    ("1.5", "Success", { [weak self] in self?.showToastSuccess() }),
                    ("1.6", "Error", { [weak self] in self?.showToastError() }),
                    ("1.7", "Warning", { [weak self] in self?.showToastWarning() }),
                ]
            ),
            (
                "2. 视觉样式",
                [
                    ("2.1", "非渐变背景", { [weak self] in self?.showToastNonGradient() }),
                    ("2.2", "不显示 Icon", { [weak self] in self?.showToastNoIcon() }),
                    ("2.3", "胶囊样式", { [weak self] in self?.showToastCapsule() }),
                    ("2.4", "字体+间距样式", { [weak self] in self?.showToastCustomStyling() }),
                ]
            ),
            (
                "3. 文本布局",
                [
                    ("3.1", "宽度自适应（短文本）", { [weak self] in self?.showToastAdaptiveShort() }),
                    ("3.2", "宽度自适应（长文本）", { [weak self] in self?.showToastAdaptiveLong() }),
                    ("3.3", "左对齐", { [weak self] in self?.showToastAlignLeft() }),
                    ("3.4", "居中对齐", { [weak self] in self?.showToastAlignCenter() }),
                    ("3.5", "右对齐", { [weak self] in self?.showToastAlignRight() }),
                    ("3.6", "仅标题（无 Message）", { [weak self] in self?.showToastOnlyTitle() }),
                    ("3.7", "仅标题-左对齐", { [weak self] in self?.showToastOnlyTitleAlignLeft() }),
                    ("3.8", "仅标题-居中对齐", { [weak self] in self?.showToastOnlyTitleAlignCenter() }),
                    ("3.9", "仅标题-右对齐", { [weak self] in self?.showToastOnlyTitleAlignRight() }),
                ]
            ),
            (
                "4. Glass",
                [
                    ("4.1", "Glass（液态效果）", { [weak self] in self?.showToastGlass() }),
                    ("4.2", "Glass（无 icon）", { [weak self] in self?.showToastGlassNoIcon() }),
                    ("4.3", "Glass（长文本宽度自适应）", { [weak self] in self?.showToastGlassAdaptiveLong() }),
                ]
            ),
            (
                "5. 预设",
                [
                    ("5.1", "nonGradient", { [weak self] in self?.showToastPresetNonGradient() }),
                    ("5.2", "noIcon", { [weak self] in self?.showToastPresetNoIcon() }),
                    ("5.3", "capsule", { [weak self] in self?.showToastPresetCapsule() }),
                    ("5.4", "autoWidth", { [weak self] in self?.showToastPresetAutoWidth() }),
                ]
            ),
            (
                "6. 行为",
                [
                    ("6.1", "显示关闭按钮", { [weak self] in self?.showToastShowCloseButton() }),
                    ("6.2", "enableCopy", { [weak self] in self?.showToastEnableCopy() }),
                ]
            ),
            (
                "8. Progress",
                [
                    ("8.1", "基础 Progress", { [weak self] in self?.showToastProgressBasic() }),
                    ("8.2", "Progress 0%~100%", { [weak self] in self?.showToastProgressIncrement() }),
                ]
            ),
            (
                "7. 组合/配置",
                [
                    ("7.1", "iconSpacing 缩短", { [weak self] in self?.showToastIconSpacingShort() }),
                    ("7.2", "titleMessageSpacing 放大", { [weak self] in self?.showToastTitleMessageSpacingLarge() }),
                    ("7.3", "horizontalMargin 变化", { [weak self] in self?.showToastHorizontalMarginLarge() }),
                    ("7.4", "horizontalAlignment leading", { [weak self] in self?.showToastContainerAlignLeading() }),
                    ("7.5", "horizontalAlignment trailing", { [weak self] in self?.showToastContainerAlignTrailing() }),
                ]
            )
        ]

        for section in testSections {
            stackView.addArrangedSubview(makeSectionHeader(section.0))
            for test in section.1 {
                stackView.addArrangedSubview(
                    makeLabeledButtonRow(
                        labelText: test.0,
                        buttonTitle: test.1,
                        action: test.2
                    )
                )
            }
        }
    }

    private func showToastInfo() {
        ToastManager.shared.info(
            title: "如果你看到了这条消息，说明接入成功。",
            message: "这是默认样式的 Info Toast，便于对比其他配置。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                lineLimit: 2,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isCapsule: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastSuccess() {
        ToastManager.shared.success(
            title: "成功",
            message: "这条消息用于验证 success 样式是否正常。",
            duration: 2.0,
            alignment: .top
        )
    }

    private func showToastError() {
        ToastManager.shared.error(
            title: "失败",
            message: "这条消息用于验证 error 样式是否正常。",
            duration: 2.0,
            alignment: .top
        )
    }

    private func showToastWarning() {
        ToastManager.shared.warning(
            title: "警告",
            message: "这条消息用于验证 warning 样式是否正常。",
            duration: 2.0,
            alignment: .top
        )
    }

    private func showToastNonGradient() {
        ToastManager.shared.info(
            title: "非渐变样式",
            message: "背景色设置为 #242424，不使用渐变。",
            duration: 2.5,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                lineLimit: 2,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isCapsule: false
            )
        )
    }

    private func showToastNoIcon() {
        ToastManager.shared.info(
            title: "无 Icon",
            message: "这条 Toast 已关闭图标，不占位。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: false,
                useGradientBackground: false
            )
        )
    }

    private func showToastCapsule() {
        ToastManager.shared.info(
            title: "胶囊样式",
            message: "圆角更大，形态更像气泡。",
            duration: 2.5,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isCapsule: true
            )
        )
    }

    private func showToastAdaptiveShort() {
        ToastManager.shared.info(
            title: "短文本",
            message: "短内容。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: false,
                useGradientBackground: false,
                isWidthAdaptive: true
            )
        )
    }

    private func showToastAdaptiveLong() {
        ToastManager.shared.info(
            title: "较长文本",
            message: "这是一条较长的测试文案，用来验证宽度自适应逻辑是否生效：当内容长度超过最大宽度时，Toast 会先扩展到上限再自动换行，保持最大宽度展示，不再持续加宽。",
            duration: 3.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                lineLimit: 0,
                textAlignment: .leading
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: false,
                useGradientBackground: false,
                isWidthAdaptive: true
            )
        )
    }

    private func showToastAlignLeft() {
        ToastManager.shared.info(
            title: "左对齐",
            message: "标题和正文左对齐，适合信息类提示。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false
            )
        )
    }

    private func showToastAlignCenter() {
        ToastManager.shared.info(
            title: "居中对齐",
            message: "标题和正文均居中展示。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false
            )
        )
    }

    private func showToastAlignRight() {
        ToastManager.shared.info(
            title: "右对齐",
            message: "标题和正文右对齐，适合对齐演示。",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .trailing
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .trailing
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false
            )
        )
    }

    private func showToastCustomStyling() {
        ToastManager.shared.info(
            title: "字体+间距样式",
            message: "title 14 号、message 12 号，白色文字。可继续观察 icon 与文字间隔、最大行数行为。",
            duration: 3.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14, weight: .semibold),
                color: .white,
                lineSpacing: 4,
                lineLimit: 1,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 4,
                lineLimit: 3,
                textAlignment: .center
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isCapsule: false,
                isWidthAdaptive: true
            )
        )
    }

    private func showToastGlass() {
        ToastManager.shared.glass(
            title: "Glass",
            message: "这是使用 glass 样式的测试入口。",
            duration: 2.5,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .center,
                useGradientBackground: true
            )
        )
    }

    private func showToastOnlyTitle() {
        ToastManager.shared.info(
            title: "仅标题，不传 Message",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 17),
                color: .black.opacity(0.9),
                lineSpacing: 0,
                lineLimit: 2,
                textAlignment: .center
            ),
            backgroundColor: Color.white,
            configuration: .init(
                horizontalPadding: 20,
                verticalPadding: 12,
                minimumHeight: 48,
                maximumWidth: 292,
                minimumWidth: 96,
                horizontalAlignment: .center,
                contentAlignment: .center,
                showIcon: false,
                useGradientBackground: false,
                isCapsule: true,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }
    
    private func showToastOnlyTitleSubmitSuccess() {
        ToastManager.shared.info(
            title: "提交成功",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 17),
                color: .black.opacity(0.9),
                lineSpacing: 0,
                lineLimit: 2,
                textAlignment: .center
            ),
            backgroundColor: Color.white,
            configuration: .init(
                horizontalPadding: 20,
                verticalPadding: 12,
                minimumHeight: 48,
                maximumWidth: 292,
                minimumWidth: 96,
                horizontalAlignment: .center,
                contentAlignment: .center,
                showIcon: false,
                useGradientBackground: false,
                isCapsule: true,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastOnlyTitleLongTextLeft() {
        ToastManager.shared.info(
            title: "提示文案较长无法避免时，折行需使用左对齐方式",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 17),
                color: .black.opacity(0.9),
                lineSpacing: 0,
                lineLimit: 2,
                textAlignment: .leading
            ),
            backgroundColor: Color.white,
            configuration: .init(
                horizontalPadding: 20,
                verticalPadding: 12,
                minimumHeight: 48,
                maximumWidth: 292,
                minimumWidth: 96,
                horizontalAlignment: .center,
                contentAlignment: .leading,
                showIcon: false,
                useGradientBackground: false,
                isCapsule: true,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastGlassNoIcon() {
        ToastManager.shared.glass(
            title: "Glass 无 Icon",
            message: "同样是 glass 样式，但不显示图标。",
            duration: 2.5,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: false,
                useGradientBackground: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastGlassAdaptiveLong() {
        ToastManager.shared.glass(
            title: "Glass 长文本",
            message: "这是一条更长的 glass 提示内容，用来验证长文本场景下是否会触发宽度上限并自动换行，从而避免单行无限拉伸。",
            duration: 3.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                lineLimit: 0,
                textAlignment: .leading
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white,
                lineSpacing: 0,
                lineLimit: 0,
                textAlignment: .leading
            ),
            configuration: .init(
                horizontalAlignment: .leading,
                showIcon: true,
                useGradientBackground: true,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastOnlyTitleAlignLeft() {
        ToastManager.shared.info(
            title: "仅标题左对齐",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .leading
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                contentAlignment: .leading,
                showIcon: false,
                useGradientBackground: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    

    private func showToastOnlyTitleAlignCenter() {
        ToastManager.shared.info(
            title: "仅标题居中对齐",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .center
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                contentAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastOnlyTitleAlignRight() {
        ToastManager.shared.info(
            title: "仅标题右对齐",
            duration: 2.0,
            alignment: .top,
            titleStyle: .init(
                font: .system(size: 14),
                color: .white,
                lineSpacing: 0,
                textAlignment: .trailing
            ),
            messageStyle: .init(
                font: .system(size: 12),
                color: .white
            ),
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .init(
                horizontalAlignment: .center,
                contentAlignment: .trailing,
                showIcon: true,
                useGradientBackground: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastPresetNonGradient() {
        ToastManager.shared.info(
            title: "Preset nonGradient",
            message: "直接使用 .nonGradient 预设，验证预设值能复用。",
            duration: 2.0,
            alignment: .top,
            configuration: .nonGradient,
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastPresetNoIcon() {
        ToastManager.shared.info(
            title: "Preset noIcon",
            message: "直接使用 .noIcon 预设，图标不显示。",
            duration: 2.0,
            alignment: .top,
            configuration: .noIcon,
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastPresetCapsule() {
        ToastManager.shared.info(
            title: "Preset capsule",
            message: "直接使用 .capsule 预设，形状为胶囊。",
            duration: 2.0,
            alignment: .top,
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .capsule,
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastPresetAutoWidth() {
        ToastManager.shared.info(
            title: "Preset autoWidth",
            message: "短文本 + .autoWidth 预设，适合验证文本长度驱动场景。",
            duration: 2.2,
            alignment: .top,
            backgroundColor: Color(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 36.0 / 255.0),
            configuration: .autoWidth,
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastShowCloseButton() {
        ToastManager.shared.info(
            title: "显示关闭按钮",
            message: "这个测试验证右上角关闭按钮是否可见。",
            duration: 5.0,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false
            ),
            showCloseButton: true,
            enableCopy: false
        )
    }

    private func showToastEnableCopy() {
        ToastManager.shared.info(
            title: "测试复制能力",
            message: "复制这段文本来验证 enableCopy=true 时点击消息会否显示复制入口，或在你的交互逻辑里触发复制动作。",
            duration: 5.0,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false
            ),
            showCloseButton: true,
            enableCopy: true
        )
    }

    private func showToastProgressBasic() {
        ToastManager.shared.progress(title: "Uploading files...", alignment: .top)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            ToastManager.shared.success(title: "Upload complete!")
        }
    }

    private func showToastProgressIncrement() {
        let totalSteps = 11

        for step in 0..<totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(step) * 0.45)) {
                let percent = Int((Double(step) / Double(totalSteps - 1)) * 100)

                if step == totalSteps - 1 {
                    ToastManager.shared.dismiss()
                    ToastManager.shared.success(
                        title: "Upload complete",
                        message: "Your files have been uploaded successfully"
                    )
                } else {
                    ToastManager.shared.progress(title: "Uploading files... \(percent)%", alignment: .top)
                }
            }
        }
    }

    private func showToastIconSpacingShort() {
        ToastManager.shared.info(
            title: "iconSpacing 缩短",
            message: "将 icon 与文字间距缩小到 2，看图标与内容是否更紧贴。",
            duration: 2.5,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .center,
                iconSpacing: 2,
                showIcon: true,
                useGradientBackground: false
            )
        )
    }

    private func showToastTitleMessageSpacingLarge() {
        ToastManager.shared.info(
            title: "titleMessageSpacing 放大",
            message: "标题与内容的间距扩大到 16，检查行块间距是否生效。",
            duration: 2.5,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .center,
                titleMessageSpacing: 16,
                showIcon: true,
                useGradientBackground: false
            )
        )
    }

    private func showToastHorizontalMarginLarge() {
        ToastManager.shared.info(
            title: "horizontalMargin 变化",
            message: "把外边距设置为 40，观察与屏幕边缘距离变化。",
            duration: 2.5,
            alignment: .top,
            configuration: .init(
                horizontalMargin: 40,
                horizontalAlignment: .center,
                showIcon: true,
                useGradientBackground: false,
                isWidthAdaptive: true
            )
        )
    }

    private func showToastContainerAlignLeading() {
        ToastManager.shared.info(
            title: "容器左对齐",
            message: "通过 horizontalAlignment=leading 验证 toast 在横向容器中的定位。",
            duration: 2.0,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .leading,
                showIcon: true,
                useGradientBackground: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }

    private func showToastContainerAlignTrailing() {
        ToastManager.shared.info(
            title: "容器右对齐",
            message: "通过 horizontalAlignment=trailing 验证 toast 在横向容器中的定位。",
            duration: 2.0,
            alignment: .top,
            configuration: .init(
                horizontalAlignment: .trailing,
                showIcon: true,
                useGradientBackground: false,
                isWidthAdaptive: true
            ),
            showCloseButton: false,
            enableCopy: false
        )
    }
}
