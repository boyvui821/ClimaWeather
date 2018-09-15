//
//  ChangeCityViewController.swift
//  ClimaWeather
//
//  Created by Nguyen Hieu Trung on 9/13/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate{
    func UserEnteredANewCityName(city:String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate:ChangeCityDelegate?

    @IBOutlet weak var changeCityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func PressGetWeather(_ sender: Any) {
        
        var ctityName = changeCityTextField.text;
        delegate?.UserEnteredANewCityName(city: ctityName!);
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
