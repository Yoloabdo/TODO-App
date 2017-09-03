//
//  HomeDataSource.swift
//  FitsMind
//
//  Created by abdelrahman mohamed on 9/3/17.
//  Copyright © 2017 abdelrahman mohamed. All rights reserved.
//

import Foundation
import RealmSwift

class HomeDataSource {
    
    

    let realm = try! Realm()
    weak var tableView: UITableView!
    var notificationToken: NotificationToken? = nil
    var results: Results<TODOItem>!
    
    var numberOfSections: Int {
        return 1
    }
    
    var sortType: SortingType{
        didSet{
            updateResults()
        }
    }
    
    func updateResults() -> Void {
        results = realm.objects(TODOItem.self).sorted(byKeyPath: sortType.rawValue)
        notificationToken?.stop()
        notificationToken = nil
        notificationToken = results.addNotificationBlock {[weak self](changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.tableView?.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.tableView?.beginUpdates()
                self?.tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                self?.tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                self?.tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                self?.tableView?.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    
    func filter(searchText: String) -> Void {
        results = realm.objects(TODOItem.self).filter("text contains '\(searchText)'")
        notificationToken?.stop()
        notificationToken = nil
        notificationToken = results.addNotificationBlock {[weak self](changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.tableView?.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.tableView?.beginUpdates()
                self?.tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                            with: .automatic)
                self?.tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                            with: .automatic)
                self?.tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                            with: .automatic)
                self?.tableView?.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    init(sort: SortingType, tableView: UITableView) {
        sortType = sort
        self.tableView = tableView
        updateResults()
    }
    
    deinit {
        notificationToken?.stop()
    }

    
    
    func numberOfItemsFor(_ section: Int) -> Int {
       
        return results?.count ?? 0
    }
    
    
    func cellForRowAt(index: IndexPath) -> TODOItem {
        
        return (results[index.row])
    }
    
    func delete(_ index: IndexPath) -> Void {
        try! realm.write {
            realm.delete(results[index.row])
        }
    }
}


extension HomeDataSource: HomeTableViewCellDelegate {
    func updateDone(state: Bool, item: TODOItem) {
        try! realm.write {
            item.done = state
        }
    }
    
    func updateProirity(state: Bool, item: TODOItem) {
        try! realm.write {
            item.priority = state
        }
    }
}


enum SortingType:String {
    case dueDate, done, priority
}
