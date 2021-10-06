//
//  ViewController.swift
//  Maps
//
//  Created by Коломенский Александр on 06.10.2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    //Moscov center
    private let coordinateMoscovCenter = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private let locationManager = CLLocationManager()
    private let defaultZoom: Float = 17.0

    private var trackLocation = false


    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupLocationManager()
    }

    @IBAction func tapAddMarketButton(_ sender: UIBarButtonItem) {
        addMarker(at: coordinateMoscovCenter)
    }

    @IBAction func actionTrackLocation(_ sender: UIBarButtonItem) {
        if trackLocation{
            locationManager.stopUpdatingLocation()
            trackLocation = false
        } else{
            locationManager.startUpdatingLocation()
            trackLocation = true
        }
    }

    private func setupLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self;
    }

    private func setupMap() {
        //Moscov center
        //let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscovCenter, zoom: defaultZoom)
        mapView.camera = camera

        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true

        setCustomMapStyle()

        mapView.delegate = self
    }

    private func setCustomMapStyle(){
        guard let styleUrl = Bundle.main.url(forResource: "map-style", withExtension: "json")
        else { return }

        let mapStyle = try? GMSMapStyle(contentsOfFileURL: styleUrl)
        mapView.mapStyle = mapStyle
    }

    private func addMarker(at coordinate: CLLocationCoordinate2D){
        let marker = GMSMarker.init(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .clear)
        marker.title = "Titel fo marker"
        marker.snippet = "Text description for marker"
        marker.map = mapView
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(at: coordinate)
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscovCenter, zoom: defaultZoom)
        mapView.animate(to: camera)
        return true
    }
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate{

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            let location = locations.last
        else { return }
        addMarker(at: location.coordinate)
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mapView.camera = camera
    }
}
