//
//  AddBillViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/14/22.
//

import UIKit

class AddBillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var minimumDueTextField: UITextField!
    @IBOutlet weak var repeatReminderPickerView: UIPickerView!
    @IBOutlet weak var addPaymentButton: UIButton!
    
    var pickerData:[String] = [String]()
    
    var bill: Bill?
    var payment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        repeatReminderPickerView.delegate = self
        repeatReminderPickerView.dataSource = self
        pickerData = ["Every 2 Days", "Every 7 days", "Every 14 days", "Every 30 Days"]
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
    
    @IBAction func addPaymentButtonTapped(_ sender: UIButton) {
        guard let billName = billNameTextField.text,
              !billName.isEmpty,
              let minimumDue = Double(minimumDueTextField.text!),
              let billAmount = Double(amountTextField.text!),
              !billAmount.isNaN else {return}
        let dueDate = dueDatePicker.date
        let reminderDate = reminderDatePicker.date
        let repeatReminderPickerValue = pickerData[repeatReminderPickerView.selectedRow(inComponent: 0)]
        BillController.shared.createBill(billName: billName, billAmount: billAmount, dueDate: dueDate, reminderDate: reminderDate, minimumDue: minimumDue, repeatReminder: repeatReminderPickerValue)
        
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
    
    
    // MARK: - Navigation
}
