//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import UIKit
import RxSwift

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkbox: GDCheckbox!
    @IBOutlet weak var deleteButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkbox.isOn = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(task: Task) {
        
        self.contentLabel.text = task.text
        
        checkbox.checkColor = UIColor.red
        checkbox.checkWidth = 3.0
        checkbox.containerColor = UIColor.blue
        checkbox.containerWidth = 5.0
        checkbox.isCircular = true
        checkbox.isRadiobox = false
        checkbox.isSquare = false
        checkbox.shouldAnimate = false
        checkbox.shouldFillContainer = false
        checkbox.isEnabled = false
        self.checkbox.isOn = task.isDone
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    @IBAction func onCheckBoxPress(_ sender: GDCheckbox) {
        // Do some cool stuff
    }
}
