//
//  AddPaymentViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/21/22.
//

import UIKit

class AddPaymentViewController: UIViewController {
    
    @IBOutlet weak var payImage: UIImageView!
    @IBOutlet weak var paymentDatePicker: UIDatePicker!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    
    var payment: Payment?
    var bill: Bill?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentButton.layer.cornerRadius = 10
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let bill = bill
        else {return}
        guard let paymentAmount = Double(paymentAmountTextField.text ?? "0.0") else {return}
        let lastPaymentMadeDate = paymentDatePicker.date
        if paymentAmount > bill.remainingBalance() {
            presentAlertController()
        } else {
            PaymentController.shared.createPayment(amount: paymentAmount, date: lastPaymentMadeDate, bill: bill)
            self.dismiss(animated: true)
        }
    }
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Overpayment Warning", message: "The amount entered is greater than the remaining amount due", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .cancel)
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
}
