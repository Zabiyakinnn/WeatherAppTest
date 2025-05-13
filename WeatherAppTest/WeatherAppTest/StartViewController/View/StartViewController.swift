//
//  ViewController.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import UIKit

class StartViewController: UIViewController {
    
    private let viewModel = StartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground

        viewModel.locationRequest()
    }


}

