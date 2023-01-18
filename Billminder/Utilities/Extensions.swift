//
//  Extensions.swift
//  Billminder
//
//  Created by Kvng Eko on 12/19/22.
//

import UIKit

extension UIView {
    func setGradientToTableView(tableView: UITableView) {
        let gradientBackgroundColors = [
            #colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1).cgColor
        ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    func addVerticalGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor,
            #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 5, y: 5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func gradientLoad() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.white.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
