//
//  EditBillViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/15/22.
//

import UIKit

protocol EditDetailDelegate: AnyObject {
    func BillEdited(billName: String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: String)
}

class EditBillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var repeatReminderPickerView: UIPickerView!
    @IBOutlet weak var minimumDueTextField: UITextField!
    
    var pickerData:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        repeatReminderPickerView.delegate = self
        repeatReminderPickerView.dataSource = self
        pickerData = ["Every 2 Days", "Every 7 days", "Every 14 days", "Every 30 Days"]
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
        self.amountTextField.text = "\(bill.remainingBalance())"
        self.dueDatePicker.date = bill.dueDate ?? Date()
        self.reminderDatePicker.date = bill.reminderDate ?? Date()
        self.minimumDueTextField.text = "\(bill.minimumDue)"
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let bill = bill  else {return}
        guard let billName = billNameTextField.text,
              !billName.isEmpty else {return}
        guard let updatedRemainingBalance = Double(amountTextField.text ?? "\(bill.remainingBalance())") else { return }
        let dueDate = dueDatePicker.date
        let reminderDate = reminderDatePicker.date
        let repeatReminder = pickerData[repeatReminderPickerView.selectedRow(inComponent: 0)]
        guard let minimumDue = Double(minimumDueTextField.text ?? "\(bill.minimumDue)") else {return}
        BillController.shared.updateBill(bill: bill, billName: billName, billAmount: updatedRemainingBalance, dueDate: dueDate, reminderDate: reminderDate, minimumDue: minimumDue, repeatReminder: repeatReminder)
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var repeatReminderPickerValue = pickerData[repeatReminderPickerView.selectedRow(inComponent: (0))]
    }
}
