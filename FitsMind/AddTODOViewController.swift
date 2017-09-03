//
//  AddTODOViewController.swift
//  FitsMind
//
//  Created by abdelrahman mohamed on 9/3/17.
//  Copyright © 2017 abdelrahman mohamed. All rights reserved.
//

import UIKit
import RealmSwift
import BEMCheckBox

class AddTODOViewController: UIViewController {
    
    let realm = try! Realm()
    
    var todo: TODOItem?
    
    @IBOutlet weak var todoTF: UITextField!
    @IBOutlet weak var important: BEMCheckBox!{
        didSet{
            important?.boxType = .square
        }
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if todo != nil {
            try! realm.write {
                todo!.text = todoTF.text
                todo!.priority = (important?.on)!
                todo!.lastUpdate = Date()
            }
        }
        todo = TODOItem(text: todoTF.text, dueDate: nil, priority: important.on)
        try! realm.write {
            realm.add(todo!)
        }
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        todoTF.text = todo?.text
        important.setOn(todo?.priority ?? false, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
