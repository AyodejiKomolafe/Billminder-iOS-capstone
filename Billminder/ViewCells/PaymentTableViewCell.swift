//
//  PaymentTableViewCell.swift
//  Billminder
//
//  Created by Kvng Eko on 12/21/22.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    weak var delegate: PaymentTableViewCell?
    static let shared = PaymentTableViewCell()

    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    
    func configure(with payment: Payment) {
            paymentAmountLabel.text = "\(payment.amount)"
            paymentDateLabel.text = DateFormatter.paymentDate.string(from: payment.date ?? Date())
    }
}
