//
//  BillDetailViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/15/22.
//

import UIKit

class BillDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let notificationScheduler = NotificationScheduler()
    
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var dueAmountLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var repeatReminderLabel: UILabel!
    @IBOutlet weak var remainingBalanceLabel: UILabel!
    @IBOutlet weak var billTotalAmountLabel: UILabel!
    
    var bill: Bill?
    var payment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        BillController.shared.fetchBills()
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.layer.cornerRadius = 15
        paymentTableView.layer.borderWidth = 3
        paymentTableView.layer.borderColor = UIColor.purple.cgColor
        addPaymentButton.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.gray.cgColor,UIColor.black.cgColor, UIColor.black.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        fetchPayments()
        styleElements()
        displayRepeat()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataNotificationRecieved), name: NSNotification.Name("billDetailViewController.reloadData.notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataNotificationRecieved), name: NSNotification.Name("billDetailViewController.reloadRemainingBalance.notification"), object: nil)
        
    }
    
    @objc private func reloadDataNotificationRecieved() {
        paymentTableView.reloadData()
        remainingBalanceLabel.text = "90"
        updateViews()
    }
 
    func updateViews() {
        guard let bill = bill
        else { return }
        self.billName.text = bill.billName
        self.dueDateLabel.text = "\(String(describing: DateFormatter.billDate.string(from: bill.dueDate ?? Date())))"
        self.reminderDateLabel.text = "\(String(describing: DateFormatter.billDate.string(from: bill.reminderDate ?? Date())))"
        if bill.remainingBalance() != 0 {
            dueAmountLabel.text = "\(bill.minimumDue)"
            remainingBalanceLabel.text = "\(bill.remainingBalance())"
        } else {
            dueAmountLabel.text = "\(bill.minimumDue)"
            remainingBalanceLabel.text = "\(bill.remainingBalance())"
        }
        paidLabel.text = String(bill.totalPaid())
        if bill.remainingBalance() < 0 {
            remainingBalanceLabel.text = "0.0"
        }
        billTotalAmountLabel.text = String(bill.billAmount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPayments()
        updateViews()
    }
    
    func fetchPayments() {
        PaymentController.shared.fetchPayments(for: bill)
    }
    
    @IBAction func reminderButtonTapped(_ sender: Any) {
        guard let bill = bill else {return}
        notificationScheduler.clearNotifications(bill: bill)
    }
    
    @IBAction func addPaymentButtonTapped(_ sender: Any) {
    }
    
    func styleElements(){
        dueAmountLabel.layer.borderWidth = 3
        dueAmountLabel.layer.cornerRadius = 10
        dueAmountLabel.layer.backgroundColor = UIColor.red.cgColor
        dueAmountLabel.layer.borderColor = UIColor.red.cgColor
        paidLabel.layer.borderWidth = 3
        paidLabel.layer.cornerRadius = 10
        paidLabel.layer.backgroundColor = UIColor.black.cgColor
        paidLabel.layer.borderColor = UIColor.black.cgColor
        balanceLabel.layer.borderWidth = 3
        balanceLabel.layer.cornerRadius = 10
        balanceLabel.layer.backgroundColor = UIColor.black.cgColor
        balanceLabel.layer.borderColor = UIColor.black.cgColor
        billName.layer.borderWidth = 3
        billName.layer.cornerRadius = 10
        billName.layer.backgroundColor = UIColor.systemPurple.cgColor
        billName.layer.borderColor = UIColor.systemPurple.cgColor
        billTotalAmountLabel.layer.borderWidth = 3
        billTotalAmountLabel.layer.cornerRadius = 10
        billTotalAmountLabel.layer.backgroundColor = UIColor.systemGreen.cgColor
        billTotalAmountLabel.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentController.shared.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as? PaymentTableViewCell
        else { return UITableViewCell() }
        let payment = PaymentController.shared.payments[indexPath.row]
        cell.configure(with: payment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Payment History"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let paymentToDelete = PaymentController.shared.payments[indexPath.row]
            PaymentController.shared.delete(paymentToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func displayRepeat() {
        if bill?.repeatReminder == true {
            repeatReminderLabel.text = "Yes"
        } else {
            repeatReminderLabel.text = "No"
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bill = bill
        else { return }
        if segue.identifier == "toEditView" {
            let destination = segue.destination as? EditBillViewController
            destination?.delegate = self
            destination?.bill = bill
        } else if segue.identifier == "toAddPayment" {
            let destination = segue.destination as? AddPaymentViewController
            destination?.bill = bill
        }
    }
}

extension BillDetailViewController: EditDetailDelegate {
    func BillEdited(billName: String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: Bool) {
        guard let bill = bill
        else { return }
        bill.billName = billName
        bill.billAmount = billAmount
        bill.dueDate = dueDate
        bill.reminderDate = reminderDate
        bill.minimumDue = minimumDue
        bill.repeatReminder = repeatReminder
        BillController.shared.updateEditedBill()
        updateViews()
    }
}
