//
//  BillTableViewCell.swift
//  Billminder
//
//  Created by Kvng Eko on 12/14/22.
//

import UIKit


class BillTableViewCell: UITableViewCell {
    @IBOutlet weak var billNameLabel: UILabel!
    @IBOutlet weak var billDueDateLabel: UILabel!
    
    var bill: Bill?
    private var wasPaidToday: Bool = false
    
    func configure(with bill: Bill) {
        self.bill = bill
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var content = defaultContentConfiguration().updated(for: state)
        var backgroundContent = backgroundConfiguration?.updated(for: state)
        guard let bill = bill
        else { return }
        content.text = bill.billName
        content.secondaryText = DateFormatter.billDate.string(from: bill.dueDate ?? Date())
        content.image = UIImage(systemName: "dollarsign.circle")
        content.textProperties.color = .label
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        content.textToSecondaryTextVerticalPadding = 4
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        content.imageProperties.tintColor = .systemPurple
        content.imageToTextPadding = 16
        contentConfiguration = content
        backgroundConfiguration = backgroundContent
    }
}
