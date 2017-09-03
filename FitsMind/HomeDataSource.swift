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
    
    var notificationToken: NotificationToken? = nil
    var results: Results<TODOItem>!
    
    var numberOfSections: Int {
        return 1
    }
    
    init(tableView: UITableView) {
        
        results = realm.objects(TODOItem.self).sorted(byKeyPath: "done")
        notificationToken = results.addNotificationBlock {(changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                           with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    deinit {
        notificationToken?.stop()
    }

    
    
    func numberOfItemsFor(_ section: Int) -> Int {
       
        return results.count
    }
    
    
    func cellForRowAt(index: IndexPath) -> TODOItem {
        
        return results[index.row]
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
            item.proirity = state
        }
    }
}
