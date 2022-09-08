//
//  CountryListViewController.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import UIKit
import SnapKit

class CountryListViewController: UIViewController {
    
    let countryTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    func initialSetup() {
        title = "Country List"
        view.backgroundColor = .white
        view.addSubview(countryTable)
        countryTable.dataSource = self
        countryTable.delegate = self
        countryTable.register(CountryListTableCell.self,
                              forCellReuseIdentifier: CountryListTableCell.cellId)
        countryTable.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        reloadTable()
    }    
}


extension CountryListViewController: UITableViewDataSource,
                                     UITableViewDelegate {
    
    func reloadTable() {
        countryTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = countryTable.dequeueReusableCell(withIdentifier: CountryListTableCell.cellId) as! CountryListTableCell
        aCell.selectionStyle = .none
        return aCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let viewController: MapViewController = MapViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
