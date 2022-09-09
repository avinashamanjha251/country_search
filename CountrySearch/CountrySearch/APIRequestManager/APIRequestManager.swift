//
//  APIRequestManager.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import Foundation
import RxCocoa
import RxSwift

/********************************************************************
 CLASS NAME: APIRequestManager
 ********************************************************************
 DESCRIPTION: Class for calling web services
 ********************************************************************
 CHANGE HISTORY
 ********************************************************************
 * Version       : 1.0
 * Date           : 08/09/2022
 * Name         : Avinash Aman
 * Change      : First time implementation
 ********************************************************************/

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

protocol APIRequestProtocol {
    func callWebserviceForFetchingCitiesList<T: Codable>() -> Observable<T>
}

class APIRequestManager: APIRequestProtocol {
    let baseURL = URL(string: "https://raw.githubusercontent.com/SiriusiOS/ios-assignment/main/cities.json")!
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    static let shared: APIRequestManager = APIRequestManager()

    private init() { }

    func callWebserviceForFetchingCitiesList<T: Codable>() -> Observable<T> {
        // create an observable and emit the state as per response.
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.baseURL,
                                                  completionHandler: { (data, _, error) in
                if let err = error {
                    observer.onError(err)
                } else {
                    guard let dataValue = data else { return }
                    guard let array = try? JSONSerialization.jsonObject(with: dataValue,
                                                                        options: []) as? JSONArray ?? [] else {
                        observer.onError(NSError(domain: "NSCocoaErrorDomain", code: 3840))
                        return }
                    guard let baseCityList: T = SMBaseCityArray(fromArray: array) as? T else {
                        observer.onError(NSError(domain: "NSCocoaErrorDomain", code: 3840))
                        return }
                    observer.onNext(baseCityList)
                    observer.onCompleted()
                }
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}
