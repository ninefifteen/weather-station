//
//  StationCalloutDetailRowView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/15/23.
//

import UIKit

class StationCalloutDetailRowView: UIView {
    
    // MARK: - API

    init(keyText: String, valueText: String) {
        self.keyText = keyText
        self.valueText = valueText
        super.init(frame: .zero)
        configureView()
        configureConstraints()
        populateLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    private let keyText: String
    private let valueText: String
    
    private let separatorText = ":  "
    
    private let keyLabel = UIDetailLabel()
    private let separatorLabel = UIDetailLabel()
    private let valueLabel = UIDetailLabel()
    
    // MARK: - Functions
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(keyLabel)
        stackView.addArrangedSubview(separatorLabel)
        stackView.addArrangedSubview(valueLabel)
        addSubview(stackView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func populateLabels() {
        keyLabel.text = keyText
        valueLabel.text = valueText
        separatorLabel.text = separatorText
    }
}
