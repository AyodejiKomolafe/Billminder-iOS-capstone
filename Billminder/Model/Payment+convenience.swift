//
//  PaymentDate+convenience.swift
//  Billminder
//
//  Created by Kvng Eko on 12/13/22.
//

import CoreData

extension Payment {
    @discardableResult convenience init(amount: Double, date: Date, bill: Bill, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.amount = amount
        self.date = date
        self.bill = bill
    }
    
    func hasPayment() -> Bool {
        amount != 0.0
    }
}
