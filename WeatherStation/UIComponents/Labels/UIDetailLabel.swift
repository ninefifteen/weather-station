//
//  UIDetailLabel.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/15/23.
//

import UIKit

class UIDetailLabel: UILabel {
    
    // MARK: - API
    
    init() {
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func configure() {
        textAlignment = .left
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = false
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
