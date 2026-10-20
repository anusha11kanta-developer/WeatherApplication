//
//  WeatherScreen+UIKit.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
import UIKit
final class WeatherViewController: UIViewController {

    private let viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bind()
    }

    private func bind() {
        // bind viewModel updates → UI labels
    }
}
extension String {

    var isValidCityName: Bool {

        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return false
        }

        let regex = #"^[\p{L}\s.'-]+$"#

        return trimmed.range(
            of: regex,
            options: .regularExpression
        ) != nil
    }
}
