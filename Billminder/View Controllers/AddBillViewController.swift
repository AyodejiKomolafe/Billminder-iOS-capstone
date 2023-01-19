//
//  AddBillViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/14/22.
//

import UIKit

class AddBillViewController: UIViewController {
    
    var repeatReminder = true
    
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var minimumDueTextField: UITextField!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var repeatReminderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addNewBillLabel: UILabel!
    
    var bill: Bill?
    var payment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.gray.cgColor, UIColor.black.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        addPaymentButton.layer.cornerRadius = 10
    }
    
    func setUpViews() {
        self.amountTextField.keyboardType = .numberPad
        self.minimumDueTextField.keyboardType = .numberPad
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func billNameDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func amountDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
  
    @IBAction func minimumDueDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func addPaymentButtonTapped(_ sender: UIButton) {
        guard let billName = billNameTextField.text,
              !billName.isEmpty,
              let minimumDue = Double(minimumDueTextField.text!),
              let billAmount = Double(amountTextField.text!),
              !billAmount.isNaN else {return}
        let dueDate = dueDatePicker.date
        let reminderDate = reminderDatePicker.date
        BillController.shared.createBill(billName: billName, billAmount: billAmount, dueDate: dueDate, reminderDate: reminderDate, minimumDue: minimumDue, repeatReminder: repeatReminder)
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func repeatControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.repeatReminder = true
        } else {
            self.repeatReminder = false
        }
    }
    
    // MARK: - Navigation
}
