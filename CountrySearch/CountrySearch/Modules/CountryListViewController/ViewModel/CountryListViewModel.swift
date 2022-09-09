//
//  CountryListViewModel.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import Foundation
import RxSwift
import RxCocoa

/********************************************************************
 CLASS NAME: CountryListViewModel
 ********************************************************************
 DESCRIPTION: Class for View Model tasks
 ********************************************************************
 CHANGE HISTORY
 ********************************************************************
 * Version       : 1.0
 * Date           : 08/09/2022
 * Name         : Avinash Aman
 * Change      : First time implementation
 ********************************************************************/

class CountryListViewModel {

    private let filterCityArray = BehaviorRelay<[SMCityData]>(value: [])

    private let disposeBag = DisposeBag()
    var cityArray: Observable<SMBaseCityArray>?
    var cityObserver: Observable<[SMCityData]> {
        return filterCityArray.asObservable()
    }
}

extension CountryListViewModel {

    /********************************************************************
     CHANGE HISTORY
     ********************************************************************
     SUMMARY
     ********************************************************************
     * Function Description : Method for fetching city list
     * Version                      : 1.0
     * Date                          : 08/09/2022
     * Name                        : Avinash Aman
     * Change                     : First time implementation
     * param                       : nil
     ********************************************************************/
    func fetchCityList(onCompleted: @escaping (() -> Void)) {
        cityArray = APIRequestManager.shared.callWebserviceForFetchingCitiesList()
        cityArray?.subscribe(onNext: { (value) in
            self.filterCityArray.accept(value.cityArray)
            onCompleted()
        }, onError: { (error) in
            print(error.localizedDescription)
            onCompleted()
        }).disposed(by: disposeBag)
    }
}
