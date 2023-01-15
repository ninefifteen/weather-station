//
//  StationCalloutView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import UIKit

class StationCalloutView: UIView {

    // MARK: - API
    
    init(station: Station) {
        viewModel = StationCalloutViewModel(station: station)
        super.init(frame: .zero)
        configureView()
        configureConstraints()
        populateLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var viewModel: StationCalloutViewModel
    
    var stationIdLabel = UIHeadlineLabel()
    var stationNameLabel = UIHeadlineLabel()
    
    private let detailStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let headerStackView = UIStackView()
    
    private let separator = UIView()
    
    // MARK: - Functions
    
    func configureView() {
        headerStackView.axis = .vertical
        headerStackView.distribution = .fillProportionally
        headerStackView.alignment = .center
        headerStackView.spacing = 4
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.addArrangedSubview(stationIdLabel)
        headerStackView.addArrangedSubview(stationNameLabel)
        
        detailStackView.axis = .vertical
        detailStackView.distribution = .fillProportionally
        detailStackView.alignment = .leading
        detailStackView.spacing = 4
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        detailStackView.addArrangedSubview(
            StationCalloutDetailRowView(
                keyText: viewModel.temperatureKeyLabelText,
                valueText: viewModel.temperatureValueLabelText
            )
        )
        
        let windSpeedView = StationCalloutDetailRowView(
            keyText: viewModel.windSpeedKeyLabelText,
            valueText: viewModel.windSpeedValueLabelText
        )
        windSpeedView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.addArrangedSubview(
            windSpeedView
        )

        detailStackView.addArrangedSubview(
            StationCalloutDetailRowView(
                keyText: viewModel.windDirectionKeyLabelText,
                valueText: viewModel.windDirectionValueLabelText
            )
        )

        detailStackView.addArrangedSubview(
            StationCalloutDetailRowView(
                keyText: viewModel.precipitaionKeyLabelText,
                valueText: viewModel.precipitationValueLabelText
            )
        )
        
        separator.backgroundColor = .label
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .center
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(separator)
        mainStackView.addArrangedSubview(detailStackView)
        addSubview(mainStackView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    func populateLabels() {
        stationIdLabel.text = viewModel.stationIdValueLabelText
        stationNameLabel.text = viewModel.stationNameValueLabelText
    }
}
