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

    //Defaul map position (Moscow center)
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private let locationManager = CLLocationManager()
    private let defaultZoom: Float = 17.0

    private var trackLocation = false

    private var route: GMSPolyline?
    private var path: GMSMutablePath?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupLocationManager()
    }

    @IBAction func tapAddMarketButton(_ sender: UIBarButtonItem) {
        guard let coordinate = locationManager.location?.coordinate
        else { return }

        addMarker(at: coordinate)
    }

    @IBAction func actionTrackLocation(_ sender: UIBarButtonItem) {
        if trackLocation{
            sender.title = "Track location"
            locationManager.stopUpdatingLocation()
            trackLocation = false
        } else{
            sender.title = "Storp tracking"
            locationManager.startUpdatingLocation()
            trackLocation = true
            startNewTrack()
        }
    }

    @IBAction func actionGoToNorilsk(_ sender: UIBarButtonItem) {
        goToAdress("Norilsk")
    }

    private func goToAdress(_ adress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { [weak self] plecamarks, error in
            print(error?.localizedDescription ?? "Error is null")
            guard let placemark = plecamarks?.first,
            let coordinate = placemark.location?.coordinate else { return }
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12.0)
            self?.mapView.camera = camera
        }
    }

    private func setupLocationManager(){
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = 100.0
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        //locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self;
    }

    private func setupMap() {
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate, zoom: defaultZoom)
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

    private func addMarker(at coordinate: CLLocationCoordinate2D, title: String = "", snippet: String = ""){
        let marker = GMSMarker.init(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .clear)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }

    private func startNewTrack(){
        route?.map = mapView
        route = GMSPolyline()

        route?.strokeColor = .white
        route?.strokeWidth = 3

        path = GMSMutablePath()
        route?.map = mapView
    }

    private func addPointToTrack(at coordinate: CLLocationCoordinate2D){
        path?.add(coordinate)
        route?.path = path
        //Save dateTime with coordinate to Reals
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(at: coordinate)
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = locationManager.location?.coordinate
        else { return false }

        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoom)
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
        //print("Did update locations \(location.coordinate)")
        addPointToTrack(at: location.coordinate)
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mapView.camera = camera
    }
}
