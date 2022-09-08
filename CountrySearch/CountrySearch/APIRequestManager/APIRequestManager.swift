//
//  APIRequestManager.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import Foundation
import RxCocoa
import RxSwift

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

protocol APIRequestProtocol {
    func callWebserviceForFetchingCitiesList<T: Codable>() -> Observable<T>
}

class APIRequestManager: APIRequestProtocol {
    let baseURL = URL(string: "https://raw.githubusercontent.com/SiriusiOS/ios-assignment/main/cities.json")!
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    static let shared: APIRequestManager = APIRequestManager()
    
    private init() { }
    
    func callWebserviceForFetchingCitiesList<T: Codable>() -> Observable<T> {
        //create an observable and emit the state as per response.
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.baseURL,
                                                  completionHandler: { (data, response, error) in
                guard let dataValue = data else { return }
                guard let array = try? JSONSerialization.jsonObject(with: dataValue,
                                                                  options: []) as? JSONArray ?? [] else { return }
                let baseCityList: SMBaseCityArray = SMBaseCityArray(fromArray: array)
                observer.onNext(baseCityList as! T)
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}
