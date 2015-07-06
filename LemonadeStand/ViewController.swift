//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Omer Winrauke on 7/6/15.
//  Copyright (c) 2015 Omer Winrauke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //amount of money
    @IBOutlet weak var moneyQuantityLabel: UILabel!
    
    //amount of supplies available for day
    @IBOutlet weak var lemonQuantityLabel: UILabel!
    @IBOutlet weak var iceQuantityLabel: UILabel!
    
    //amount of supplies purchased before day start
    @IBOutlet weak var lemonsPurchasedLabel: UILabel!
    @IBOutlet weak var icePurchasedLabel: UILabel!
    
    //amount of supplies used before day star
    @IBOutlet weak var lemonsMixedLabel: UILabel!
    @IBOutlet weak var iceMixedLabel: UILabel!
    
    //UIImage view for weather
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //ammount variables
    var lemonQuantity = 1;
    var iceQuantity = 1;
    var moneyAvailable = 10;
    var lemonMixed = 0;
    var iceMixed = 0;
    
    //floating point vars
    var lemonadeRatio:Double = 0;
    var customers:[Double] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadInitialSupplies();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //buttons in the UI
    
    @IBAction func buyLemonButtonPressed(sender: UIButton) {
        if (moneyAvailable < 2) {
            showAlertWithText(message: "Insuficient funds!");
        }
        else {
            moneyAvailable -= 2;
            lemonQuantity++;
            var updatedPurchased = lemonsPurchasedLabel.text
            var updatedPurchasedQuantity = updatedPurchased?.toInt();
            var updatedPurchasedQuantityInt = updatedPurchasedQuantity!;
            updatedPurchasedQuantityInt++;
            lemonsPurchasedLabel.text = "\(updatedPurchasedQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func buyIceButtonPressed(sender: UIButton) {
        if (moneyAvailable < 1) {
            showAlertWithText(message: "Insuficient funds!");
        }
        else {
            moneyAvailable -= 1;
            iceQuantity++;
            var updatedPurchased = icePurchasedLabel.text
            var updatedPurchasedQuantity = updatedPurchased?.toInt();
            var updatedPurchasedQuantityInt = updatedPurchasedQuantity!;
            updatedPurchasedQuantityInt++;
            icePurchasedLabel.text = "\(updatedPurchasedQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func returnLemonButtonPressed(sender: UIButton) {
        if (lemonsPurchasedLabel.text?.toInt()! <= 0 || lemonQuantity <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            moneyAvailable += 2;
            lemonQuantity--;
            var updatedPurchased = lemonsPurchasedLabel.text
            var updatedPurchasedQuantity = updatedPurchased?.toInt();
            var updatedPurchasedQuantityInt = updatedPurchasedQuantity!;
            updatedPurchasedQuantityInt--;
            lemonsPurchasedLabel.text = "\(updatedPurchasedQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func returnIceButtonPressed(sender: UIButton) {
        if (icePurchasedLabel.text?.toInt()! <= 0 || iceQuantity <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            moneyAvailable += 1;
            iceQuantity--;
            var updatedPurchased = icePurchasedLabel.text
            var updatedPurchasedQuantity = updatedPurchased?.toInt();
            var updatedPurchasedQuantityInt = updatedPurchasedQuantity!;
            updatedPurchasedQuantityInt--;
            icePurchasedLabel.text = "\(updatedPurchasedQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func addOneLemonToMixButtonPressed(sender: UIButton) {
        if (lemonQuantity <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            lemonQuantity--;
            lemonMixed++;
            var updatedMix = lemonsMixedLabel.text;
            var updatedMixQuantity = updatedMix?.toInt();
            var updatedMixQuantityInt = updatedMixQuantity!;
            updatedMixQuantityInt++;
            lemonsMixedLabel.text = "\(updatedMixQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func addOneIceToMixButtonPressed(sender: UIButton) {
        if (iceQuantity <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            iceQuantity--;
            iceMixed++;
            var updatedMix = iceMixedLabel.text;
            var updatedMixQuantity = updatedMix?.toInt();
            var updatedMixQuantityInt = updatedMixQuantity!;
            updatedMixQuantityInt++;
            iceMixedLabel.text = "\(updatedMixQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func removeOneLemonFromMixButtonPressed(sender: UIButton) {
        if (lemonsMixedLabel.text?.toInt()! <= 0 || lemonMixed <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            lemonQuantity++;
            lemonMixed--;
            var updatedMix = lemonsMixedLabel.text;
            var updatedMixQuantity = updatedMix?.toInt();
            var updatedMixQuantityInt = updatedMixQuantity!;
            updatedMixQuantityInt--;
            lemonsMixedLabel.text = "\(updatedMixQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func removeOneIceFromMixButtonPressed(sender: UIButton) {
        if (iceMixedLabel.text?.toInt()! <= 0 || iceMixed <= 0) {
            showAlertWithText(message: "Insuficient supplies");
        }
        else {
            iceQuantity++;
            iceMixed--;
            var updatedMix = iceMixedLabel.text;
            var updatedMixQuantity = updatedMix?.toInt();
            var updatedMixQuantityInt = updatedMixQuantity!;
            updatedMixQuantityInt--;
            iceMixedLabel.text = "\(updatedMixQuantityInt)";
            updateView();
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        if (checkMixed()) {
        lemonadeRatio = Double(lemonMixed)/Double(iceMixed);
        createCustomers();
        customerPay();
        updateView();
        println(lemonadeRatio);
        newDay();
        }
        else {
            showAlertWithText(message: "No lemonade mixed!");
        }
    }
    
    func loadInitialSupplies() {
        moneyQuantityLabel.text = "$\(moneyAvailable)";
        moneyQuantityLabel.hidden = false;
        lemonQuantityLabel.text = "\(lemonQuantity)";
        lemonQuantityLabel.hidden = false;
        iceQuantityLabel.text = "\(iceQuantity)";
        iceQuantityLabel.hidden = false;
    }
    
    func updateView() {
        moneyQuantityLabel.text = "$\(moneyAvailable)";
        lemonQuantityLabel.text = "\(lemonQuantity)";
        iceQuantityLabel.text = "\(iceQuantity)";
    }
    
    func showAlertWithText(header:String = "Warning", message:String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func createCustomers() {
        var numberOfCustomer = Int(arc4random_uniform(UInt32(10))) + 1;
        var currentWeather = Int(arc4random_uniform(UInt32(3)));
        if (currentWeather == 0 && numberOfCustomer > 3) {
            numberOfCustomer -= 3;
            weatherImageView.image = UIImage(named: "Cold");
        }
        else if (currentWeather == 2) {
            numberOfCustomer += 4;
            weatherImageView.image = UIImage(named: "Warm");
        }
        else {
            weatherImageView.image = UIImage(named: "Mild");
        }
        for (var i = 0; i < numberOfCustomer; i++) {
            var randomNumber = Int(arc4random_uniform(UInt32(10))) + 1;
            var tasteDecimal = Double(randomNumber)/10.0;
            customers.append(tasteDecimal);
        }
    }
    
    func customerPay() {
        for (var i = 0; i < customers.count; i++) {
            if (customers[i] <= 0.4 && lemonadeRatio > 1) {
                moneyAvailable++;
            }
            else if (customers[i] > 0.4 && customers[i] <= 0.6 && lemonadeRatio == 1) {
                moneyAvailable++;
            }
            else if (customers[i] > 0.6 && lemonadeRatio < 1){
                moneyAvailable++;
            }
        }
    }
    
    func newDay() {
        lemonsPurchasedLabel.text = "\(0)";
        icePurchasedLabel.text = "\(0)";
        lemonsMixedLabel.text = "\(0)";
        iceMixedLabel.text = "\(0)";
        lemonadeRatio = 0.0;
    }
    
    func checkMixed() -> Bool{
        if (lemonMixed == 0 && iceMixed == 0) {
            return false;
        }
        else {
            return true;
        }
    }
}

