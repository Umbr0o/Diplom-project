//
//  GMSMapViewDelegate.swift
//  Diplom-project
//
//  Created by Артем Томило on 1.06.22.
//

import GoogleMaps
import GoogleMapsUtils
import GooglePlaces
import UIKit

extension MapViewController: GMSMapViewDelegate {
    
    //MARK: - Did tap marker
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let data = marker.userData as? MyAnnotations else { return true }
        getInfoAboutPlace(placeID: data.placeID, coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude))
        
        markerInfoView.lockView()
        UIView.animate(withDuration: 1.5) {
            self.markerInfoView.unlockView()
        }
        
        NSLayoutConstraint.deactivate([
            hiddenMarkerInfoViewConstraint
        ])
        
        NSLayoutConstraint.activate([
            showMarkerInfoViewConstraint
        ])
        view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        if marker == mapView.selectedMarker {
            hideInfoView()
        }
        
        mapView.animate(toLocation: marker.position)
        if marker.userData is GMUCluster {
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
        }
        NSLog("Did tap a normal marker")
        return false
    }
    
    //MARK: - Did tap at coordinate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideInfoView()
    }
    
    //MARK: - Hide infoView func
    
    func hideInfoView() {
        NSLayoutConstraint.deactivate([
            showMarkerInfoViewConstraint
        ])
        
        NSLayoutConstraint.activate([
            hiddenMarkerInfoViewConstraint
        ])
        view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
