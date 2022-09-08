//
//  CountryListViewController.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CountryListViewController: UIViewController {
    
    let countryTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    let viewModel: CountryListViewModel = CountryListViewModel()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        webServices()
        bindUI()
    }
    
    func initialSetup() {
        title = "Country List"
        view.backgroundColor = .white
        view.addSubview(countryTable)
        countryTable.register(CountryListTableCell.self,
                              forCellReuseIdentifier: CountryListTableCell.cellId)
        countryTable.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(0)
        }
    }
    
    func webServices() {
        viewModel.fetchCityList()
    }
    
    func bindUI() {
        viewModel.cityObserver.bind(to: countryTable.rx.items(cellIdentifier: CountryListTableCell.cellId,
                                                              cellType: CountryListTableCell.self)) { row, dataSource, aCell in
            aCell.configureCellUI(data: dataSource)
            aCell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        countryTable.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let viewController: MapViewController = MapViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
    }
}
