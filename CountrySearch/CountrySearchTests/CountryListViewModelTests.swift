//
//  CountryListViewModelTests.swift
//  CountrySearchTests
//
//  Created by Avinash Aman on 09/09/22.
//

import Foundation
import XCTest

@testable import CountrySearch

class CountryListViewModelTests: XCTestCase {

    let viewModel: CountryListViewModel = CountryListViewModel()
    let timeout: TimeInterval = 60.0

    func test_FetchCityList() {
        let completedExpectation = expectation(description: "Completed")
        viewModel.fetchCityList {
            completedExpectation.fulfill()
        }
        wait(for: [completedExpectation], timeout: timeout)
    }
}
