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
    
    func displayWindIndicator(_ display: Bool, windDirection: Double = 0) {
        if display {
            let degrees: CGFloat = windDirection
            let radians: CGFloat = degrees * (.pi / 180)
            windIndicator.transform = CGAffineTransform(rotationAngle: radians)
            stackView.addArrangedSubview(windIndicator)
        } else {
            stackView.removeArrangedSubview(windIndicator)
            windIndicator.removeFromSuperview()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
        
    private lazy var bottomCornerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var bubbleView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var normalView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectedView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var  windIndicator: UIImageView = {
        let image = UIImage(systemName: "arrow.up")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .reverseLabel
        return imageView
    } ()
    
    private lazy var normalAnchorPoint = CGPointMake(0.5, 0.87)
    private lazy var selectedAnchorPoint = CGPointMake(0.5, 0.14)
    
    // MARK: - Functions
    
    private func configureView() {
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.anchorPoint = normalAnchorPoint
        backgroundColor = .clear
        
        addSubview(normalView)
        addSubview(selectedView)
        
        stackView.addArrangedSubview(label)
        
        normalView.addSubview(bottomCornerView)
        normalView.addSubview(bubbleView)
        bubbleView.addSubview(stackView)
        
        let angle = (45.0 * CGFloat.pi) / 180
        let transform = CGAffineTransform(rotationAngle: angle)
        bottomCornerView.transform = transform
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            normalView.centerXAnchor.constraint(equalTo: centerXAnchor),
            normalView.bottomAnchor.constraint(equalTo: bottomAnchor),
            normalView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            normalView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            normalView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bottomCornerView.bottomAnchor.constraint(equalTo: normalView.bottomAnchor, constant: -8),
            bottomCornerView.centerXAnchor.constraint(equalTo: normalView.centerXAnchor),
            bottomCornerView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            bottomCornerView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            bottomCornerView.widthAnchor.constraint(equalToConstant: 18),
            bottomCornerView.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        NSLayoutConstraint.activate([
            bubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            selectedView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            selectedView.heightAnchor.constraint(equalToConstant: 10),
            selectedView.widthAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layer.anchorPoint = selected ? selectedAnchorPoint : normalAnchorPoint
        normalView.layer.opacity = selected ? 0 : 1
        selectedView.layer.opacity = selected ? 1 : 0
    }
}
