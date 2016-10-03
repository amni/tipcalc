//
//  ViewController.swift
//  tipcalc
//
//  Created by Alan Ni on 9/18/16.
//  Copyright © 2016 Alan Ni. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var customTipLabel: UILabel!
    @IBOutlet weak var customTipField: UITextField!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    @IBOutlet weak var billCurrencyLabel: UILabel!
    @IBOutlet weak var tipCurrencyLabel: UILabel!
    @IBOutlet weak var totalCurrencyLabel: UILabel!
    
    @IBOutlet weak var splitLabel: UILabel!
    
    @IBOutlet weak var plusLabel: UILabel!
    
    @IBOutlet weak var perPersonLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var numberPplLabel: UILabel!
    var numberPpl = 1
    var animatedLabels:[UILabel] = [UILabel]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTipField.hidden = true
        customTipLabel.hidden = true
        backButton.hidden = true
        tipSegment.hidden = false

        

        animatedLabels = [splitLabel, minusLabel, plusLabel, perPersonLabel, numberPplLabel]
        
        for label in animatedLabels{
            label.center.x  -= view.bounds.width
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("billText") != nil {
            billField.text = defaults.objectForKey("billText") as! String
        }
        billField.becomeFirstResponder()
        let locale = NSLocale.currentLocale()
        let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol) as! String
        
        billCurrencyLabel.text = currencySymbol
        tipCurrencyLabel.text = currencySymbol
        totalCurrencyLabel.text = currencySymbol
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("onTapOnTotalLabel:"))
        totalLabel.addGestureRecognizer(tap)
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
    
    
    @IBAction func onTapOnTotalLabel(sender:UITapGestureRecognizer) {
       numberPpl += 1
       self.animatePlusSplitLabel()
    }
    
    
    @IBAction func onTapOnMinusLabel(sender: AnyObject) {
        numberPpl-=1
        self.animateMinusSplitLabel()

    }
    
    func animatePlusSplitLabel(){
        self.calculateTip(nil)
        if (numberPpl == 2) {
            UIView.animateWithDuration(0.5, animations: {
                for label in self.animatedLabels{
                    label.center.x += self.view.bounds.width
                }
            })
        }

    }
    
    func animateMinusSplitLabel(){
        self.calculateTip(nil)
        if (numberPpl <= 1) {
            UIView.animateWithDuration(0.5, animations: {
                for label in self.animatedLabels{
                    label.center.x -= self.view.bounds.width
                }
            })
        }
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    
    func calculateSplit(total:Double){
        numberPplLabel.text = String(numberPpl)
        splitLabel.text = String(format: "%.2f", total/Double(numberPpl)    )
        
    }
    
    @IBAction func onBackTouch(sender: AnyObject) {
        
        tipSegment.hidden = false
        customTipField.hidden = true
        customTipLabel.hidden = true
        backButton.hidden = true
        tipSegment.selectedSegmentIndex = 0
        calculateTip(self)
    }
    
    @IBAction func calculateTip(sender: AnyObject?) {
        let tipPercentages = [0.15, 0.18, 0.20]
        let bill = Double(billField.text!) ?? 0
        var tipPct = 0.15
        if (tipSegment.selectedSegmentIndex == 3)
        {
            tipSegment.hidden = true
            customTipField.hidden = false
            customTipLabel.hidden = false
            backButton.hidden = false
            tipPct = (Double(customTipField.text!) ?? 0)/100
        }
        else {
            tipPct = tipPercentages [tipSegment.selectedSegmentIndex]

        }
        let tip = bill * tipPct
        let total = bill + tip

        calculateSplit(total)
        
        tipLabel.text = String(format: "%.2f", tip)
        totalLabel.text = String(format: "%.2f", total)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text, forKey: "billText")
        defaults.synchronize()
    }
    
}

