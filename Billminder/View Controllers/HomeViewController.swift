//
//  HomeViewController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/19/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let notificationScheduler = NotificationScheduler()
    
    @IBOutlet weak var addButtonTapped: UIButton!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var billTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        billTableView.delegate = self
        billTableView.dataSource = self
        BillController.shared.fetchBills()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor,UIColor.gray.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        logoView.layer.borderWidth = 3
        logoView.layer.borderColor = UIColor.purple.cgColor
        billTableView.layer.borderWidth = 3
        billTableView.layer.borderColor = UIColor.purple.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableDataNotificationRecieved), name: NSNotification.Name("homeViewController.reloadData.notification"), object: nil)
    }
    
    @objc private func reloadTableDataNotificationRecieved() {
        billTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BillController.shared.fetchBills()
        billTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BillController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BillController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "billsCell", for: indexPath) as? BillTableViewCell
        else { return UITableViewCell() }
        let bill = BillController.shared.sections[indexPath.section][indexPath.row]
        cell.bill = bill
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Unpaid Bills"
        } else if section == 1 {
            return "Fully Paid Bills"
        } else {
            return nil
        }
    }
    
    func styleElements() {
        logoView.addVerticalGradientLayer()
        logoView.layer.cornerRadius = 30
        billTableView.layer.cornerRadius = 30
        addButtonTapped.layer.cornerRadius = 5
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let billToDelete = BillController.shared.sections[indexPath.section][indexPath.row]
            BillController.shared.delete(billToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            notificationScheduler.clearNotifications(bill: billToDelete)
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = billTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? BillDetailViewController
            else { return }
            let billSelected = BillController.shared.sections[indexPath.section][indexPath.row]
            destination.bill = billSelected
        }
    }
}
