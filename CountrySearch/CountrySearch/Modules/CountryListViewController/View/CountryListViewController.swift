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
    let searchBar: UISearchBar = {
    let searchBar: UISearchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    let viewModel: CountryListViewModel = CountryListViewModel()
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    let cityList = BehaviorRelay<[SMCityData]>(value: [])
    let filteredList = BehaviorRelay<[SMCityData]>(value: [])

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
        activityView.center = view.center
        view.addSubview(countryTable)
        view.addSubview(activityView)
        countryTable.register(CountryListTableCell.self,
                              forCellReuseIdentifier: CountryListTableCell.cellId)
        countryTable.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        countryTable.tableHeaderView = searchBar
        countryTable.tableFooterView = UIView()
    }
    
    func webServices() {
        activityView.startAnimating()
        viewModel.fetchCityList {
            DispatchQueue.main.async { [weak self] in
                self?.activityView.stopAnimating()
            }
        }
    }
    
    func bindUI() {
        //Here we subscribe the subject in viewModel to get the value here
        viewModel.cityObserver.subscribe(onNext: { (value) in
            self.filteredList.accept(value)
            self.cityList.accept(value)
        },onError: { error in
            self.errorAlert()
        }).disposed(by: disposeBag)
        
        //This binds the table datasource with tableview and also connects the cell to it.
        filteredList.bind(to: countryTable.rx.items(cellIdentifier: CountryListTableCell.cellId,
                                                              cellType: CountryListTableCell.self)) { row, dataSource, aCell in
            aCell.configureCellUI(data: dataSource)
            aCell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        //Replacement to didSelectRowAt() of tableview delegate functions
        countryTable.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let viewController: MapViewController = MapViewController()
            viewController.viewModel.cityData = self.filteredList.value[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
        
        //Search functionality: Combines the complete data model to search field and binds results to data model binded to the tableview.
        Observable.combineLatest(cityList.asObservable(),
                                 searchBar.rx.text,
                                 resultSelector: { users, search in
            return users.filter { (user) -> Bool in
                self.filterUserList(cityData: user, searchText: search)
            }
        }).bind(to: filteredList).disposed(by: disposeBag)
    }
    
    //Search function
    func filterUserList(cityData: SMCityData, searchText: String?) -> Bool {        
        if let search = searchText, !search.isEmpty, !cityData.name.hasPrefix(search) {
            return false
        }
        return true
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Check your Internet connection and Try Again!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}
