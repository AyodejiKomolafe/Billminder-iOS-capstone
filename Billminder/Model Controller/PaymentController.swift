//
//  PaymentController.swift
//  Billminder
//
//  Created by Kvng Eko on 12/14/22.
//

import Foundation
import CoreData


class PaymentController {
    
    static let shared = PaymentController()
    let notificationScheduler = NotificationScheduler()
    
    private func fetchRequest(bill: Bill?) -> NSFetchRequest<Payment> {
        let request = NSFetchRequest<Payment>(entityName: "Payment")
        if let bill {
            request.predicate = NSPredicate(format: "bill == %@", bill)
        } else {
            request.predicate = NSPredicate(value: true)
        }
        return request
    }
    
    var payments: [Payment] = []
    
    func createPayment(amount: Double, date: Date, bill: Bill) {
        let payment = Payment(amount: amount, date: date, bill: bill)
        payments.append(payment)
        CoreDataStack.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("billDetailViewController.reloadData.notification"), object: nil)
        if bill.remainingBalance() == 0 {
            //send another notification
            NotificationCenter.default.post(name: NSNotification.Name("homeViewController.reloadData.notification"), object: nil)
            notificationScheduler.clearNotifications(bill: bill)
            CoreDataStack.saveContext()
        }
    }
    
    func fetchPayments(for bill: Bill?) {
        let request = fetchRequest(bill: bill)
        let lastPayment = (try? CoreDataStack.context.fetch(request)) ?? []
        payments = lastPayment.filter { $0.hasPayment() }
    }
    
    func delete(_ payment: Payment) {
       if let index = payments.firstIndex(of: payment) {
            payments.remove(at: index )
       }
        CoreDataStack.context.delete(payment)
        CoreDataStack.saveContext()
    }
    
}
