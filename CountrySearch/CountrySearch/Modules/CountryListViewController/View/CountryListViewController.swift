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

/********************************************************************
 CLASS NAME: CountryListViewController
 ********************************************************************
 DESCRIPTION: Class for display city list along with country namd and coordinates
 ********************************************************************
 CHANGE HISTORY
 ********************************************************************
 * Version       : 1.0
 * Date           : 08/09/2022
 * Name         : Avinash Aman
 * Change      : First time implementation
 ********************************************************************/

class CountryListViewController: UIViewController {

    private let countryTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    private let searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    private let bgSeparator: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    private let viewModel: CountryListViewModel = CountryListViewModel()
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    private let cityList = BehaviorRelay<[SMCityData]>(value: [])
    private let filteredList = BehaviorRelay<[SMCityData]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        webServices()
        bindUI()
    }

    private func initialSetup() {
        title = "Country List"
        view.backgroundColor = .white
        activityView.center = view.center
        view.addSubview(countryTable)
        view.addSubview(searchBar)
        view.addSubview(bgSeparator)
        view.addSubview(activityView)
        addConstraintsToUI()
        configureTableCell()
    }

    private func configureTableCell() {
        countryTable.register(CountryListTableCell.self,
                              forCellReuseIdentifier: CountryListTableCell.cellId)
        countryTable.tableFooterView = UIView()
        countryTable.keyboardDismissMode = .onDrag
        countryTable.backgroundColor = .clear
    }

    private func addConstraintsToUI() {
        searchBar.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        bgSeparator.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.bottom.equalTo(searchBar)
            make.height.equalTo(1)
        }
        countryTable.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.bottom.equalTo(0)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }

    private func webServices() {
        activityView.startAnimating()
        viewModel.fetchCityList {
            DispatchQueue.main.async { [weak self] in
                self?.activityView.stopAnimating()
            }
        }
    }

    private func bindUI() {
        bindCityObserver()
        bindCellUI()
        bindForTableViewDidSelectEvent()
        bindSearchEvent()
        bindSearchBarEvents()
    }

    private func bindCityObserver() {
        // Here we subscribe the subject in viewModel to get the value here
        viewModel.cityObserver.subscribe(onNext: { (value) in
            self.filteredList.accept(value)
            self.cityList.accept(value)
        }, onError: { _ in
            self.errorAlert()
        }).disposed(by: disposeBag)
    }

    private func bindCellUI() {
        // This binds the table datasource with tableview and also connects the cell to it.
        filteredList.bind(to: countryTable.rx.items(cellIdentifier: CountryListTableCell.cellId,
                                                    cellType: CountryListTableCell.self)) { _, dataSource, aCell in
            aCell.configureCellUI(data: dataSource)
            aCell.selectionStyle = .none
        }.disposed(by: disposeBag)
    }

    private func bindForTableViewDidSelectEvent() {
        // Replacement to didSelectRowAt() of tableview delegate functions
        countryTable.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let viewController: MapViewController = MapViewController()
            viewController.viewModel.cityData = self.filteredList.value[indexPath.row]
            self.hideSearchCancelButton()
            self.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindSearchEvent() {
        /*
         Search functionality: Combines the complete data model to search field
         and binds results to data model binded to the tableview.
         */
        Observable.combineLatest(cityList.asObservable(),
                                 searchBar.rx.text,
                                 resultSelector: { cities, search in
            return cities.filter { (city) -> Bool in
                self.filterUserList(cityData: city, searchText: search)
            }
        }).bind(to: filteredList).disposed(by: disposeBag)
    }

    private func bindSearchBarEvents() {
        let cancelButtonClicked = searchBar.rx.cancelButtonClicked
        let searchButtonClicked = searchBar.rx.searchButtonClicked
        setupSearchBarButtonEvent(buttonClicked: cancelButtonClicked)
        setupSearchBarButtonEvent(buttonClicked: searchButtonClicked)
        setupSearchBarTextEditEvent()
    }

    private func setupSearchBarButtonEvent(buttonClicked: ControlEvent<Void>) {
        buttonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.hideSearchCancelButton()
            })
            .disposed(by: disposeBag)
    }

    private func setupSearchBarTextEditEvent() {
        searchBar.rx.textDidBeginEditing.subscribe { [weak searchBar] _ in
            searchBar?.becomeFirstResponder()
            searchBar?.showsCancelButton = true
        }.disposed(by: disposeBag)
        searchBar.rx.textDidEndEditing.subscribe { [weak self] _ in
            self?.hideSearchCancelButton()
        }.disposed(by: disposeBag)
    }

    private func hideSearchCancelButton() {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    // Search function
    private func filterUserList(cityData: SMCityData,
                                searchText: String?) -> Bool {
        if let search = searchText,
           !search.isEmpty,
           !cityData.name.lowercased().hasPrefix(search.lowercased()) {
            return false
        }
        return true
    }

    private func errorAlert() {
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
