//
//  HomeViewController.swift
//  FitsMind
//
//  Created by abdelrahman mohamed on 9/3/17.
//  Copyright © 2017 abdelrahman mohamed. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    struct StoryBoard {
        static let CellID = "TODOCell"
    }

    var dataSource: HomeDataSource?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = HomeDataSource(sort: .done, tableView: tableView)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @IBAction func updateSort(_ sender: Any) {
        let action = UIAlertController(title: "Sorting", message: "Sort list by:", preferredStyle: .actionSheet)
        let done = UIAlertAction(title: "Done", style: .default) { (_) in
            self.dataSource?.sortType = .done
            action.dismiss(animated: true, completion: nil)
        }
        action.addAction(done)

        let date = UIAlertAction(title: "Due date", style: .default) { (_) in
            self.dataSource?.sortType = .date
            action.dismiss(animated: true, completion: nil)
        }
        action.addAction(date)

        let proirity = UIAlertAction(title: "Proirity", style: .default) { (_) in
            self.dataSource?.sortType = .priority
            action.dismiss(animated: true, completion: nil)
        }
        action.addAction(proirity)

        let dismiss = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            action.dismiss(animated: true, completion: nil)
        }
        action.addAction(dismiss)

        present(action, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsFor(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.CellID, for: indexPath) as! HomeTableViewCell
        cell.configueWith((dataSource?.cellForRowAt(index: indexPath))!)
        cell.delegate = dataSource
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            self.dataSource?.delete(index)
            tableView.cellForRow(at: indexPath)?.endEditing(true)

        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (_, index) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTODOViewController") as! AddTODOViewController
            vc.todo = self.dataSource?.cellForRowAt(index: index)
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.cellForRow(at: indexPath)?.endEditing(true)

        }
        return [delete, edit]
    }
    
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource?.filter(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.sortType = .done
    }
}

