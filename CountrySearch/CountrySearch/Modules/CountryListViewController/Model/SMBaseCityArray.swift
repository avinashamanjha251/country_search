//
//	SMBaseCityArray.swift
//
//	Create by Avinash Aman on 8/9/2022
//	Copyright © 2022 Avinash Aman. All rights reserved.


import Foundation

struct SMBaseCityArray: Codable {
    
    var cityArray: [SMCityData] = []
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromArray array: JSONArray) {
        let aList = array.map { SMCityData(fromDictionary: $0) }
        let sortedList = aList.sorted {
            $0.name < $1.name
        }
        cityArray = sortedList
    }
    
    init() { }
    init(from decoder: Decoder) throws { }
    func encode(to encoder: Encoder) throws { }
}

struct SMCityData {
    
    let id: Int
    let coord: SMCoordinate
    let country: String
    let name: String
    
    var title: String {
        name + ", " + country
    }
    var subTitle: String {
        "\(coord.lat) \(coord.lon)"
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        id = dictionary["_id"] as? Int ?? 0
        if let coordData = dictionary["coord"] as? [String:Any] {
            coord = SMCoordinate(fromDictionary: coordData)
        } else {
            coord  = SMCoordinate(fromDictionary: [:])
        }
        country = dictionary["country"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
    }
    
    
}

struct SMCoordinate {
    
    let lat: Double
    let lon: Double
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        lat = dictionary["lat"] as? Double ?? 0.0
        lon = dictionary["lon"] as? Double ?? 0.0
    }
    
}
