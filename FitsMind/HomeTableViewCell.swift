//
//  HomeTableViewCell.swift
//  FitsMind
//
//  Created by abdelrahman mohamed on 9/3/17.
//  Copyright © 2017 abdelrahman mohamed. All rights reserved.
//

import UIKit
import BEMCheckBox
protocol HomeTableViewCellDelegate: class {
    func updateDone(state: Bool, item: TODOItem)
    func updateProirity(state: Bool, item: TODOItem)
}

class HomeTableViewCell: UITableViewCell {

    weak var delegate: HomeTableViewCellDelegate?
    
    var todo: TODOItem!
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var doneButton: BEMCheckBox!
    @IBOutlet weak var proirityButton: BEMCheckBox!{
        didSet{
            proirityButton.boxType = .square
        }
    }
    
    
    
    func configueWith(_ todo: TODOItem) -> Void {
        self.todo = todo
        todoLabel.text = todo.text
        doneButton.isSelected = todo.done
        doneButton.setOn(todo.done, animated: true)
        proirityButton.setOn(todo.priority, animated: true)
    }
    
    
    
    @IBAction func updateDone(_ sender: BEMCheckBox){
        delegate?.updateDone(state: sender.on, item: todo)
    }
    
    
    @IBAction func updateProirity(_ sender: BEMCheckBox){
        delegate?.updateProirity(state: sender.on, item: todo)
    }
   

    
}
