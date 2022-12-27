//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ColorDemoController: UIViewController {
    private var sections: [DemoColorSection] = [
        DemoColorSection(text: "App specific color", colorViews: [
            DemoColorView(text: "brandBackground1", colorProvider: { (view: UIView) -> UIColor in return Colors2.brandBackground1(for: view.theme) })
        ]),
        DemoColorSection(text: "Neutral colors", colorViews: [
            // DemoColorView(text: "gray950", color: Colors.gray950)
        ]),
        DemoColorSection(text: "Shared colors", colorViews: [
            // DemoColorView(text: Colors.Palette.pinkRed10.name, color: Colors.Palette.pinkRed10.color),
        ]),
        DemoColorSection(text: "Message colors", colorViews: [
            // DemoColorView(text: Colors.Palette.dangerShade30.name, color: Colors.Palette.dangerShade30.color),
        ]),
        DemoColorSection(text: "Presence colors", colorViews: [
//            DemoColorView(text: Colors.Palette.presenceAvailable.name, color: Colors.Palette.presenceAvailable.color),
//            DemoColorView(text: Colors.Palette.presenceAway.name, color: Colors.Palette.presenceAway.color),
//            DemoColorView(text: Colors.Palette.presenceBlocked.name, color: Colors.Palette.presenceBlocked.color),
//            DemoColorView(text: Colors.Palette.presenceBusy.name, color: Colors.Palette.presenceBusy.color),
//            DemoColorView(text: Colors.Palette.presenceDnd.name, color: Colors.Palette.presenceDnd.color),
//            DemoColorView(text: Colors.Palette.presenceOffline.name, color: Colors.Palette.presenceOffline.color),
//            DemoColorView(text: Colors.Palette.presenceOof.name, color: Colors.Palette.presenceOof.color),
//            DemoColorView(text: Colors.Palette.presenceUnknown.name, color: Colors.Palette.presenceUnknown.color)
        ])
    ]

    private var currentDemoListViewController: DemoListViewController? {
        return navigationController?.viewControllers.first as? DemoListViewController
    }

    override func loadView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = TableViewCell.tableBackgroundColor

        let separator = Separator(orientation: .horizontal)
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, separator, tableView])
        stackView.setCustomSpacing(8, after: segmentedControl)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view = UIView(frame: .zero)
        view.addSubview(stackView)

        view.backgroundColor = Colors.navigationBarBackground

        if let currentDemoListViewController = currentDemoListViewController {
            segmentedControl.selectedSegmentIndex = DemoColorTheme.allCases.firstIndex(where: { $0.name == currentDemoListViewController.theme.name }) ?? 0
        } else {
            segmentedControl.selectedSegmentIndex = 0
        }

        // Only use safe area for top and bottom, not left and right, to ensure that the scroll view extends edge to edge
        // when in landscape mode
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTheme), name: Notification.Name.didChangeTheme, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }

    private lazy var segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl(items: DemoColorTheme.allCases.map({ return SegmentItem(title: $0.name) }), style: .primaryPill)
        segmentedControl.onSelectAction = { [weak self] (_, index) in
            guard let strongSelf = self,
                  let window = strongSelf.view.window,
                  let currentDemoListViewController = strongSelf.currentDemoListViewController else {
                return
            }

            currentDemoListViewController.updateColorProviderFor(window: window, theme: DemoColorTheme.allCases[index])
        }
        return segmentedControl
    }()

    @objc private func didChangeTheme() {
        // The controls in this controller are not fully theme-aware yet, so
        // we need to manually poke them and have them refresh their colors.
        sections.forEach { section in
            section.colorViews.forEach { colorView in
                colorView.updateBackgroundColor()
            }
        }
        segmentedControl.updateColors()
    }

    private let tableView = UITableView(frame: .zero, style: .grouped)
}

// MARK: - ColorDemoController: UITableViewDelegate

extension ColorDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let section = sections[section]
        header?.setup(style: .header, title: section.text)
        return header
    }
}

// MARK: - ColorDemoController: UITableViewDataSource

extension ColorDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].colorViews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        let section = sections[indexPath.section]
        let colorView = section.colorViews[indexPath.row]

        cell.setup(title: colorView.text, customView: colorView)
        return cell
    }

}

class DemoColorView: UIView {
    let text: String
    var colorProvider: ((UIView) -> (UIColor))?

    init(text: String, color: UIColor) {
        self.text = text
        super.init(frame: .zero)
        backgroundColor = color
    }

    init(text: String, colorProvider: @escaping (UIView) -> (UIColor)) {
        self.text = text
        super.init(frame: .zero)
        self.colorProvider = colorProvider
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateBackgroundColor()
    }

    func updateBackgroundColor() {
        if let colorProvider = colorProvider,
            let window = window {
            backgroundColor = colorProvider(window)
        }
    }
}

struct DemoColorSection {
    let text: String
    let colorViews: [DemoColorView]

    init(text: String, colorViews: [DemoColorView]) {
        self.text = text
        self.colorViews = colorViews
    }
}
