//
//  CountryListViewModel.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import Foundation
import RxSwift
import RxCocoa

class CountryListViewModel {
    
    private let filterCityArray = BehaviorRelay<[SMCityData]>(value: [])

    private let disposeBag = DisposeBag()
    var cityArray: Observable<SMBaseCityArray>?
    var cityObserver: Observable<[SMCityData]> {
        return filterCityArray.asObservable()
    }
}

extension CountryListViewModel {
    
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
