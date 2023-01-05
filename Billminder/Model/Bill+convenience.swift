//
//  Bill+convenience.swift
//  Billminder
//
//  Created by Kvng Eko on 12/13/22.
//

import CoreData

extension Bill {
    @discardableResult convenience init(billName: String, billAmount: Double, dueDate: Date, reminderDate: Date, minimumDue: Double, repeatReminder: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = UUID().uuidString
        self.billName = billName
        self.billAmount = billAmount
        self.dueDate = dueDate
        self.reminderDate = reminderDate
        self.minimumDue = minimumDue
        self.repeatReminder = repeatReminder
    }
    
    func hasBalance() -> Bool {
        remainingBalance() != 0.0
    }
    
    func totalPaid() -> Double {
        guard let payments = payments as? Set<Payment>
        else {return 0.0}
        
        return payments.reduce(0) { $0 + $1.amount }
    }
    
    func remainingBalance() -> Double {
        if totalPaid() == billAmount {
            return  0.0
        } else {
            return  billAmount - totalPaid()
        }
    }
}


