//
//  EditBillViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/15/22.
//

import UIKit

protocol EditDetailDelegate: AnyObject {
    func BillEdited(billName: String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: Bool)
}

class EditBillViewController: UIViewController {
    var repeatReminder = true
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var minimumDueTextField: UITextField!
    @IBOutlet weak var repeatReminderSegmentedControl: UISegmentedControl!
    
    var pickerData:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        doneButton.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.gray.cgColor, UIColor.black.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    weak var delegate: EditDetailDelegate?
    var bill: Bill?
    var payment: Payment?
    
    func updateViews() {
        guard let bill = bill else {return}
        self.billNameTextField.text = bill.billName
        self.amountTextField.text = "\(bill.billAmount)"
        self.dueDatePicker.date = bill.dueDate ?? Date()
        self.reminderDatePicker.date = bill.reminderDate ?? Date()
        self.minimumDueTextField.text = "\(bill.minimumDue)"
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let bill = bill,
              let billName = billNameTextField.text,
              !billName.isEmpty,
              let updatedBillAmount = Double(amountTextField.text ?? "\(bill.billAmount)"),
              let minimumDue = Double(minimumDueTextField.text ?? "\(bill.minimumDue)")
        else { return }
        let dueDate = dueDatePicker.date
        let reminderDate = reminderDatePicker.date
        
        BillController.shared.updateBill(bill: bill, billName: billName, billAmount: updatedBillAmount, dueDate: dueDate, reminderDate: reminderDate, minimumDue: minimumDue, repeatReminder: repeatReminder)
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func repeatControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.repeatReminder = true
        } else {
            self.repeatReminder = false
        }
    }
}
