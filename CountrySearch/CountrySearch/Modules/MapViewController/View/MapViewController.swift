//
//  MapViewController.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView: MKMapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    func initialSetup() {
        title = "Map"
        view.backgroundColor = .white
        mapView.center = view.center
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(0)
        }
    }
}
