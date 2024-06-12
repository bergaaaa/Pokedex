//
//  TablePokedexViewController.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import Foundation
import UIKit

class TablePokedexViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(tableView)
        tableView.backgroundColor = .yellow
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
}

extension TablePokedexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .blue
        return cell
    }
}
