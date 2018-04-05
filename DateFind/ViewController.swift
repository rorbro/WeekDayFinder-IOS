//
//  ViewController.swift
//  DateFind
//
//  Created by BJ Brooks  on 6/20/17.
//  Copyright © 2017 brookswebpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var startOverButton: UIButton!
    @IBAction func startOver(_ sender: Any) {
        resetApp()
        startOverButton.alpha = 0
        selectionTextField.alpha = 1
        dateLabel.text = ""
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitPressed(_ sender: Any) {
        calculateWeekDay(month: month, day: day, year: year)
    }
    
    var date = "You entered: "
    
    let months = ["January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"]
    
    var days = [Int]()
    
    var yearView: UIView?
    
    var month = ""
    
    var monthNum = 0
    
    var day = 0
    
    var year = 0
    
    var selectedMonth: String?
    
    var selectedDay: Int?
    
    var isMonthSubmitted = false
    
    var isDaySubmitted = false
    
    func addDaysToMonth (numToAdd: Int) {
        for i in 1...numToAdd {
            days.append(29+i)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       startOverButton.alpha = 0
         for i in 1...29 {
         days.append(i)
         }
        submitButton.alpha = 0
        createPicker()
        createToolbar()
        
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true 

        startOverButton.layer.cornerRadius = 5
        startOverButton.clipsToBounds = true

    }

    func createPicker () {
    
        if (!isMonthSubmitted) {
            let monthPicker = UIPickerView()
            monthPicker.delegate = self
            selectionTextField.inputView = monthPicker
        } else {
            let dayPicker = UIPickerView()
            dayPicker.delegate = self
            selectionTextField.inputView = dayPicker
        }
    
    }
    
    func createToolbar () {
    
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(ViewController.doneButtonPressed))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        selectionTextField.inputAccessoryView = toolbar
    }
    
    func doneButtonPressed() {
        if (selectionTextField.text != "") {
        view.endEditing(true)
        
        if (!isMonthSubmitted) {                //submit MONTH
            let testString = String(selectedMonth!)

            if let testString2 = testString {
                month = testString2
                
                switch testString2 {
                case "January", "March", "May", "July", "August", "October", "December":
                    addDaysToMonth(numToAdd: 2)
                case "April", "June", "September", "November":
                    addDaysToMonth(numToAdd: 1)
                default: break
                }
                date += testString2 + " "
                dateLabel.text = date
            }
            isMonthSubmitted = true
            createPicker()
            createToolbar()
            selectionTextField.placeholder = "Click to Select Day"
        } else if (!isDaySubmitted) {            //MONTH submitted, submit DAY
            let testDay = Int(selectionTextField.text!)
            if let daytry = testDay {
                day = daytry
            
            date += "\(selectedDay!)"
         dateLabel.text = date
            selectionTextField.inputView = yearView
            selectionTextField.keyboardType = UIKeyboardType.numberPad
            isDaySubmitted = true
                selectionTextField.placeholder = "Click to Enter Year"
            }
        } else {                                //MONTH & DAY submitted, submit YEAR
            let testNum = Int(selectionTextField.text!)
            if let yeartry = testNum {
                year = yeartry
                if (year <= 1000000) {
                
                 if (((month == "February" && day == 29) && (((year-2000)%4 != 0) || ((year-2000)%100 == 0) && ((year-2000)%400 != 0)))) {
                        dateLabel.text = "\(year) is not a leap year. Try again."
                        resetApp()
                 } else {
                    date += ", " + "\(year)"
                    dateLabel.text = date
                    selectionTextField.alpha = 0
                    submitButton.alpha = 1
                }
                } else {
                    dateLabel.text = "Enter a smaller number for the year"
                }
            }
        }
        } else {
            if (!isMonthSubmitted) {
            dateLabel.text = "Select a month from the list below"
                
            } else if (!isDaySubmitted) {
                dateLabel.text = "Select a day from the list below"
            } else {
                dateLabel.text = "Enter in a year"
            }
        }
        selectionTextField.text = ""

    }
    
 func calculateLeapDays (earlyYear: Int, futureYear: Int) -> Int {
    var leapDays = 0
    var counter = 0
    var leapYear = 0
    var extraLeapDays = 0
    
    if ((futureYear - earlyYear) < 4) {
        counter = earlyYear
        while (counter <= futureYear) {
            if (counter % 4 == 0) {
                leapDays += 1
                if (counter % 100 == 0) && (counter % 400 != 0) {
                    leapDays -= 1
                }

            }
            counter += 1
        }
    } else {
        for i in 1...4 {
            if ((earlyYear + i - 1) % 4 == 0) {
                leapDays += 1
                if ((earlyYear + i - 1) % 100 == 0) && ((earlyYear + i - 1) % 400 != 0) {
                    leapDays -= 1
                }

                leapYear = earlyYear + i - 1
            }
        }
        
        leapDays += (futureYear - leapYear) / 4
        extraLeapDays += leapDays/100
        leapDays -= leapDays/25
        leapDays += extraLeapDays
    }
    
    
    return leapDays
    
    }


 func getDaysOfMonth (month: Int) -> Int {
        switch month {
            case 1, 3, 5, 7, 8, 10, 12:
                return 31
            case 4, 6, 9, 11:
                return 30
            case 2:
                return 28
            default:
                return 0
        }
     }

    
 func adjustDaysOfMonth (month: Int, year: Int) -> Int {
        switch month {
            case 1, 3, 5, 7, 8, 10, 12:
                return 1
            case 4, 6, 9, 11:
                return 0
            case 2:
                if (year % 4 == 0) {
                    return -1
                } else {
                    return -2
                }
            default:
                return 0
        }
     }

    
    func calculateWeekDay (month: String, day: Int, year: Int) {
        submitButton.alpha = 0
        var finalDay = 6
        var daySum = 0
        var yearDifference = 0
        var yearPlus = true
        var leapDays = 0
        var addMonthDays = 0
        var dayDifference = 0
        var finalDifference = 0
        var finalDayString = "Saturday"
        
        // CALCULATE MONTH DAYS
        
        switch month {
        case "January":
            monthNum = 1
        case "February":
            monthNum = 2
            addMonthDays = 31
        case "March":
            monthNum = 3
            addMonthDays = 59
        case "April":
            monthNum = 4
            addMonthDays = 90
        case "May":
            monthNum = 5
            addMonthDays = 120
        case "June":
            monthNum = 6
            addMonthDays = 151
        case "July":
            monthNum = 7
            addMonthDays = 181
        case "August":
            monthNum = 8
            addMonthDays = 212
        case "September":
            monthNum = 9
            addMonthDays = 243
        case "October":
            monthNum = 10
            addMonthDays = 273
        case "November":
            monthNum = 11
            addMonthDays = 304
        case "December":
            monthNum = 12
            addMonthDays = 334
        default:
            break
        }
        
        if (year > 2000) {
            yearDifference = year - 2000
            yearPlus = true
            leapDays += 1

             if (yearDifference >= 3) {
                leapDays += calculateLeapDays (earlyYear: (2000 + 1), futureYear: (year - 1))
             }
            if (year % 4 == 0) && (monthNum > 2) {
                leapDays += 1
                if (year % 100 == 0) && (year % 400 != 0) {
                    leapDays -= 1
                }

            }

        } else if (year < 2000){
            yearDifference = 2000 - year
            yearPlus = false
            
             if (yearDifference >= 3) {
                leapDays += calculateLeapDays (earlyYear: (year + 1), futureYear: (2000 - 1))
             }
            if (year % 4 == 0) && (monthNum < 3) {
                leapDays += 1
                if (year % 100 == 0) && (year % 400 != 0) {
                    leapDays -= 1
                }

            }

        } else {
            if (monthNum > 2) {
                leapDays += 1
            }
        }

        //CALCULATE YEAR DAYS
            daySum += yearDifference
        
        dayDifference += monthNum
        
     if (yearPlus) {
            finalDifference = addMonthDays + (day-1) + yearDifference + leapDays

        } else {
            finalDifference = addMonthDays + (day-1) - yearDifference - leapDays
        }
        finalDay = finalDifference % 7
        
        switch finalDay {
        case 0:
            finalDayString = "Saturday"
        case -1, 6:
            finalDayString = "Friday"
        case -2, 5:
            finalDayString = "Thursday"
        case -3, 4:
            finalDayString = "Wednesday"
        case -4, 3:
            finalDayString = "Tuesday"
        case -5, 2:
            finalDayString = "Monday"
        case -6, 1:
            finalDayString = "Sunday"
        default:
            break
        }
        
        dateLabel.text = "The week day for " + month + " \(day), \(year) is " + finalDayString
        startOverButton.alpha = 1
    }
    
    func resetApp () {
        
        selectionTextField.placeholder = "Click to Enter Month"
    
        date = "You entered: "
        
        month = ""
        
        day = 0
        
        year = 0
        
        selectedMonth = ""
        
        selectedDay = 0
        
        isMonthSubmitted = false
        
        isDaySubmitted = false
        
        if days.count > 29 {
            let tempNum = days.count
            for i in 1...(tempNum - 29) {
                days.remove(at: tempNum-i)
            }
        }
        submitButton.alpha = 0
        createPicker()
        createToolbar()
    }
    
        func numberOfComponents (in pickerView:UIPickerView) -> Int {
            return 1
        }
        
        func pickerView (_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if (!isMonthSubmitted) {
                return months.count
            } else {
                return days.count
            }
        }
        
        func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if (!isMonthSubmitted) {
                return months[row]
            } else {
                return "\(days[row])"
            }
        }
        
        func pickerView (_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if (!isMonthSubmitted) {
                selectedMonth = months[row]
                selectionTextField.text = selectedMonth
            } else {
                selectedDay = days[row]
                selectionTextField.text = "\(selectedDay!)"
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

