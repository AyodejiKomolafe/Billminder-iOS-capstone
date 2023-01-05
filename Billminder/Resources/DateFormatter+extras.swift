//
//  DateFormatter+extras.swift
//  Billminder
//
//  Created by Kvng Eko on 12/14/22.
//

import Foundation
extension DateFormatter {
    static let billDate : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let paymentDate : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
