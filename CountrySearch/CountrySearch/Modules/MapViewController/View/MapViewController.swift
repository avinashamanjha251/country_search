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
    
    let viewModel: MapViewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetup()
        populateDataOnMap()
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
    
    func populateDataOnMap() {
        guard let data = viewModel.cityData else { return }
        let center = CLLocationCoordinate2D(latitude: data.coord.lat,
                                            longitude: data.coord.lon)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = data.title
        annotation.subtitle = data.subTitle
        mapView.addAnnotation(annotation)
    }
}
