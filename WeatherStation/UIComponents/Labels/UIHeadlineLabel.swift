//
//  UIHeadlineLabel.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/15/23.
//

import UIKit

class UIHeadlineLabel: UILabel {

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
        textAlignment = .center
        textColor = .label
        font = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
