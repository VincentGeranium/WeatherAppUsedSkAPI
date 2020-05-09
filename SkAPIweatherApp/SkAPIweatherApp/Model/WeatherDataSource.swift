//
//  WeatherDataSource.swift
//  SkAPIweatherApp
//
//  Created by 김광준 on 2020/05/07.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherDataSource {
    static let shared = WeatherDataSource()
    private init() {}
    
    var summary: WeatherSummary?
    var forecastList = [ForecastData]()
    
    let group = DispatchGroup()
    let workQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)
    
    func fetch(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        workQueue.async {
            self.fetchSummary(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }
        
        group.enter()
        workQueue.async {
            self.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    private func fetchSummary(lat: Double, lon: Double, completion: @escaping () -> ()) {
        let apiUrl = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"

        guard let url: URL = URL(string: apiUrl) else { fatalError("Url Error") }

        //let url = URL(string: apiUrl)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }

            if let error = error {
                print(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invaild Response")
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("\(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                fatalError("Invaild data")
            }
            
            do {
                let decoder = JSONDecoder()
                self.summary = try decoder.decode(WeatherSummary.self, from: data)
                
                
                
            } catch {
                print(error)
            }
        }

        task.resume()

    }
    
    private func fetchForecast(lat: Double, lon: Double, completion: @escaping () -> ()) {
        // 배열의 초기화
        forecastList.removeAll()
        
        let apiUrl = "https://apis.openapi.sk.com/weather/forecast/3days?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"

        guard let url: URL = URL(string: apiUrl) else { fatalError("Url Error") }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }

            if let error = error {
                print(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invaild Response")
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("\(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                fatalError("Invaild data")
            }
            
            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Forecast.self, from: data)
                self.forecastList.append(contentsOf: forecast.weather.arrayRepresentation())
            } catch {
                print(error)
            }
        }

        task.resume()

    }
}
