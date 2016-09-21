//
//  ViewController.swift
//  tipcalc
//
//  Created by Alan Ni on 9/18/16.
//  Copyright © 2016 Alan Ni. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("billText") != nil {
            billField.text = defaults.objectForKey("billText") as! String
        }
        billField.becomeFirstResponder()

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let intValue = defaults.integerForKey("segmentIndex")
        tipSegment.selectedSegmentIndex = intValue
        calculateTip(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func animateText(sender: AnyObject) {
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }


    @IBAction func calculateTip(sender: AnyObject) {
        let tipPercentages = [0.15, 0.18, 0.20]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages [tipSegment.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text, forKey: "billText")
        defaults.synchronize()
    }

}

