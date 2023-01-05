//
//  BillController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/13/22.
//

import CoreData

class BillController {
    static let shared = BillController()
    
    let notificationScheduler = NotificationScheduler()
    
    private init() {
        //listen for billpaidinfull notification
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableDataNotificationRecieved), name: NSNotification.Name("homeViewController.reloadData.notification"), object: nil)
        //once recieved, call fetchbills()
        fetchBills()
    }
    @objc private func reloadTableDataNotificationRecieved() {
    }
    
    private lazy var fetchRequest: NSFetchRequest<Bill> = {
        let request = NSFetchRequest<Bill>(entityName: "Bill")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var sections: [[Bill]] {[upcomingBill, billHistory]}
    var upcomingBill: [Bill] = []
    var billHistory: [Bill] = []
    
    
    
    //CRUD
    
    func createBill(billName:String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: String) {
        let bill = Bill(billName: billName, billAmount: billAmount, dueDate: dueDate, reminderDate: reminderDate, minimumDue: minimumDue, repeatReminder: repeatReminder)
        upcomingBill.append(bill)
        addBillReminder(bill: bill)
        CoreDataStack.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("logoView.reloadData.notification"), object: nil)
    }
    
    func fetchBills() {
        let bills = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        upcomingBill = bills.filter { $0.hasBalance()}
        billHistory = bills.filter { !$0.hasBalance()}
        
    }
    
    func updateBill(bill: Bill, billName: String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: String) {
        bill.billName = billName
        bill.billAmount = billAmount
        bill.dueDate = dueDate
        bill.reminderDate = reminderDate
        bill.minimumDue = minimumDue
        bill.repeatReminder = repeatReminder
        addBillReminder(bill: bill)
        NotificationCenter.default.post(name: NSNotification.Name("billDetailViewController.reloadRemainingBalance.notification"), object: nil)
        CoreDataStack.saveContext()
    }
    
    func updateEditedBill() {
        CoreDataStack.saveContext()
        fetchBills()
    }
    
    var bill: Bill?
    
    func markBills() {
        guard let bill = bill else {return}
        if let index = upcomingBill.firstIndex(of: bill) {
            upcomingBill.remove(at: index)
            billHistory.append(bill)
        } else {
            if let index = billHistory.firstIndex(of: bill) {
                billHistory.remove(at: index)
                upcomingBill.append(bill)
            }
        }
        CoreDataStack.saveContext()
    }
    
    func deleteBill(bill: Bill) {
        CoreDataStack.context.delete(bill)
        notificationScheduler.clearNotifications(bill: bill)
        CoreDataStack.saveContext()
        fetchBills()
    }
    
    func addBillReminder(bill: Bill) {
        notificationScheduler.scheduleNotifications(bill: bill)
        CoreDataStack.saveContext()
    }
    
    func delete(_ bill: Bill) {
        if let index = upcomingBill.firstIndex(of: bill) {
            upcomingBill.remove(at: index )
        } else if let index = billHistory.firstIndex(of: bill) {
            billHistory.remove(at: index)
        }
        CoreDataStack.context.delete(bill)
        notificationScheduler.clearNotifications(bill: bill)
        CoreDataStack.saveContext()
    }
}

