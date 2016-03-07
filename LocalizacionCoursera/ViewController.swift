//
//  ViewController.swift
//  LocalizacionCoursera
//
//  Created by Francisco Betancourt on 06/03/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var moverme: UISwitch!
  @IBOutlet weak var mapa: MKMapView!
  @IBOutlet weak var selector: UISegmentedControl!
  
  var estado:Bool = false
  
  var hay_origen:Bool = false
  var origen:CLLocation?
  
  private let manejador = CLLocationManager()
  
  var punto = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    selector.tintColor = UIColor.whiteColor()
    
    manejador.delegate = self
    manejador.desiredAccuracy = kCLLocationAccuracyBest
    // filtro
    manejador.distanceFilter = 50.0
    manejador.requestWhenInUseAuthorization()
    
    var punto = CLLocationCoordinate2D()
    
    mapa.delegate = self
    
    if let latitude = manejador.location?.coordinate.latitude, let longitude = manejador.location?.coordinate.longitude {
      let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      self.mapa.setRegion(region, animated: true)
      
      punto.longitude = longitude
      punto.latitude = latitude
      
      let inicioPin:MKPointAnnotation = MKPointAnnotation()
      inicioPin.title = "Inicio!"
      inicioPin.coordinate = punto
      mapa.addAnnotation(inicioPin)
      
    } else {
      let alert = UIAlertController(title: "Error", message: "No se puede localizar su ubicación, habilítela en las opciones de simulador.", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      manejador.startUpdatingLocation()
      mapa.showsUserLocation = true
    } else {
      manejador.stopUpdatingLocation()
      mapa.showsUserLocation = false
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Latitud: \(manager.location?.coordinate.latitude) Longitud: \(manager.location?.coordinate.longitude)")
    
    // Para visualizar siempre el punto
    if let latitude = manager.location?.coordinate.latitude, let longitude = manager.location?.coordinate.longitude {
      
      if !hay_origen {
        origen = CLLocation(latitude: latitude, longitude: longitude)
        hay_origen = true
      }
      
      let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      
      // Creamos el pin
      let pin = MKPointAnnotation()
      pin.coordinate = center
      pin.title = ("Latitud: \(Double(round(latitude*100/100))), Longitud: \(Double(round(longitude*100/100)))")
      if let punto = origen {
        pin.subtitle = "Distancia recorrida: \(Double(round(manager.location!.distanceFromLocation(punto)*100)/100))"
      } else {
        print("No hay punto de partida.")
      }
      
      self.mapa.addAnnotation(pin)
      self.mapa.setRegion(region, animated: true)
    } else {
      let alert = UIAlertController(title: "Error", message: "No se puede localizar su ubicación, habilítela en las opciones de simulador.", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("\(error)")
  }
  
  @IBAction func cambiarTipoMapa(sender: UISegmentedControl) {
    switch (sender.selectedSegmentIndex) {
    case 0:
      mapa.mapType = .Standard
      sender.tintColor = UIColor.whiteColor()
    case 1:
      mapa.mapType = .Satellite
      sender.tintColor = UIColor.whiteColor()
    default:
      mapa.mapType = .Hybrid
      sender.tintColor = UIColor.whiteColor()
    }
  }
  
  
}

