//
//  StationAnnotationView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/16/23.
//

import MapKit
import UIKit

class StationAnnotationView: MKAnnotationView {
    
    // MARK: - API
        
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .reverseLabel
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        view.layer.cornerRadius = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomCornerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    private func configureView() {
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.anchorPoint = CGPointMake(0.5, 1.0)
        backgroundColor = .blue
        
        addSubview(bottomCornerView)
        addSubview(containerView)
        containerView.addSubview(label)
        
        let angle = (45.0 * CGFloat.pi) / 180
        let transform = CGAffineTransform(rotationAngle: angle)
        bottomCornerView.transform = transform
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            bottomCornerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bottomCornerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomCornerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            bottomCornerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bottomCornerView.widthAnchor.constraint(equalToConstant: 18),
            bottomCornerView.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
    }
}
