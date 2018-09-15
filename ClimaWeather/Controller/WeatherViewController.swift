//
//  WeatherViewController.swift
//  ClimaWeather
//
//  Created by Nguyen Hieu Trung on 9/13/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather";
    
    let API_KEY = "2bbad6b25dbd19492ee92d665b8ec411";
    
    var locationManager = CLLocationManager();
    var weatherDataModel = WeatherDataModel();

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperaterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func getWeatherData(url: String, params: [String:String]){
        //var urlAPI = "\(url)?lat=\(params["lat"]!)&lon=\(params["lon"]!)&appid=\(params["appid"]!)";

//        Alamofire.request(urlAPI).responseJSON { (response) in
//            if response.result.isSuccess{
//                var jsonData:JSON = JSON(arrayLiteral: response.value)
//                print(jsonData)
//                self.updateWeatherData(json: jsonData[0]);
//            }else{
//                print(response.result.error)
//            }
//        }
        
        
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
                if response.result.isSuccess{
                    var jsonData:JSON = JSON(arrayLiteral: response.value)
                    print(jsonData)
                    self.updateWeatherData(json: jsonData[0]);
                }else{
                    print(response.result.error)
                }
        }
    }
    
    func updateWeatherData(json:JSON){
        print(json["name"]);
        
        if let tempResult = json["main"]["temp"].double{
            var temp = Float(tempResult) - 273.15;
            weatherDataModel.temperature = Int(temp);
            weatherDataModel.city = json["name"].string;
            weatherDataModel.condition = json["weather"][0]["id"].intValue;
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(consition: weatherDataModel.condition);
            
            updateUIWithWeatherData();
        }else{
            cityLabel.text = "City Unavalable";
        }
    }
    
    func updateUIWithWeatherData(){
        temperaterLabel.text = String(weatherDataModel.temperature) + "℃";
        cityLabel.text = weatherDataModel.city;
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }

    
    
    @IBAction func PressShowChangeCity(_ sender: Any) {
        performSegue(withIdentifier: "ToChangeCity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ToChangeCity"{
            if let destination = segue.destination as? ChangeCityViewController{
                destination.delegate = self;
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1];
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            print("longitude: \(location.coordinate.longitude)");
            print("latitude: \(location.coordinate.latitude)");
            
            let longitude = location.coordinate.longitude;
            let latitude = location.coordinate.latitude;
            print("latitude: \(String(latitude))")
            print("longitude: \(String(longitude))")
            
            
            let params:[String:String] = ["lat":String(latitude), "lon":String(longitude), "appid": API_KEY];
            getWeatherData(url: WEATHER_URL, params: params);
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Unknow Location";
        
    }
}

//Sử dụng delegate từ ChangeCityDelegate
extension WeatherViewController:ChangeCityDelegate{
    func UserEnteredANewCityName(city: String) {
        print(city);
        
        let params:[String:String] = ["q": city, "appid":API_KEY];
        getWeatherData(url: WEATHER_URL, params: params);
    }
    
    
}






