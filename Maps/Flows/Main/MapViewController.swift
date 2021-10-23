//
//  ViewController.swift
//  Maps
//
//  Created by Коломенский Александр on 06.10.2021.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonLocationStartStop: UIBarButtonItem!

    //Defaul map position (Moscow center)
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private let locationManager = LocationManager.instance
    private let defaultZoom: Float = 17.0

    private var trackLocation = false

    private var route: GMSPolyline?
    private var path: GMSMutablePath?
    private var currentLocation: CLLocationCoordinate2D?

    private var dataBase: DataBaseLocationProtocol = RealDataBase()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupLocationManager()

    }

    @IBAction func tapAddMarketButton(_ sender: UIBarButtonItem) {
        guard let coordinate = currentLocation
        else { return }
        addMarker(at: coordinate)
    }

    @IBAction func actionTrackLocation(_ sender: UIBarButtonItem) {
        if trackLocation{
            stopLocation()
            finishTrack()
        } else{
            startLocation()
            startNewTrack()
        }
    }

    @IBAction func actionGoToNorilsk(_ sender: UIBarButtonItem) {
        goToAdress("Norilsk")
    }

    @IBAction func actionShowPrevTrack(_ sender: UIButton) {
        if !trackLocation{
            showPreviuosPath()
        }else{
            showOkCancel()
        }
    }

    private func stopLocation() {
        buttonLocationStartStop.title = "Start tracking"
        locationManager.stopUpdatingLocation()
        trackLocation = false
    }

    private func startLocation() {
        buttonLocationStartStop.title = "Storp tracking"
        locationManager.startUpdatingLocation()
        trackLocation = true
    }

    private func showPreviuosPath() {
        let prePath =  dataBase.loadPath(name: dataBase.defaultPathName)
        startNewTrack()
        for coord in prePath{
            addPointToTrack(at: coord)
        }

        guard let path = path else { return }
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }

    private func goToAdress(_ adress: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { [weak self] plecamarks, _ in
            guard let placemark = plecamarks?.first,
            let coordinate = placemark.location?.coordinate else { return }
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12.0)
            self?.mapView.camera = camera
        }
    }


    private func checkLoactionStatus(status: CLAuthorizationStatus) {
        print("Location status \(status)")
        switch status {
        case .notDetermined:
            self.locationManager.requestAuthorithation()
        case .restricted, .denied:
            print("Location access denied")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }

    }

    private func setupLocationManager() {
        locationManager
            .authorithationStatus
            .bind { [weak self] status in
                self?.checkLoactionStatus(status: status)
                }
            .disposed(by: disposeBag)

        locationManager
            .location
            .bind { [weak self] location in
                print("Location \(location)")
                self?.updateTrack(location: location)
                self?.currentLocation = location
            }
            .disposed(by: disposeBag)
    }

    private func updateTrack(location: CLLocationCoordinate2D) {
        if trackLocation {
            addPointToTrack(at: location)
            let camera = GMSCameraPosition.camera(withTarget: location, zoom: defaultZoom)
            mapView.camera = camera
        }
    }

    private func setupMap() {
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate, zoom: defaultZoom)
        mapView.camera = camera

        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true

        setCustomMapStyle()

        mapView.delegate = self
    }

    private func setCustomMapStyle() {
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

    private func startNewTrack() {

        mapView.clear()

        route?.map = mapView
        route = GMSPolyline()

        route?.strokeColor = .white
        route?.strokeWidth = 3

        path = GMSMutablePath()
        route?.map = mapView
    }

    private func finishTrack() {

        dataBase.deletePath(name: dataBase.defaultPathName)

        guard let routePath = route?.path else { return }
        for i in 0..<routePath.count() {
            let coordinate = routePath.coordinate(at: i)
            dataBase.addPoint(path: dataBase.defaultPathName, coordinate: coordinate)
        }
        print("Save path to DataBase complet")
    }

    private func addPointToTrack(at coordinate: CLLocationCoordinate2D) {
        path?.add(coordinate)
        route?.path = path
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(at: coordinate)
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = currentLocation
        else { return false }

        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoom)
        mapView.animate(to: camera)
        return true
    }
}

extension MapViewController {

    func showOkCancel() {

        let refreshAlert = UIAlertController(title: "Alert", message: "To show old track yuo must stop tracking. Stop tracking ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.stopLocation()
            self?.showPreviuosPath()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }

}
