//
//  APIRequestManagerTests.swift
//  CountrySearchTests
//
//  Created by Avinash Aman on 09/09/22.
//

import Foundation
import XCTest
import RxSwift

@testable import CountrySearch

class APIRequestManagerTests: XCTestCase {

    private let disposeBag = DisposeBag()
    let timeout: TimeInterval = 60.0

    func test_WebserviceCallingForFetchingCityList() {
        let completedExpectation = expectation(description: "Completed")
        var cityArray: Observable<SMBaseCityArray>?
        cityArray = APIRequestManager.shared.callWebserviceForFetchingCitiesList()
        cityArray?.subscribe(onNext: { (response) in
            XCTAssertEqual(response.cityArray.count == 0, false)
            completedExpectation.fulfill()
        }, onError: { _ in
            completedExpectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [completedExpectation], timeout: timeout)
    }
}
