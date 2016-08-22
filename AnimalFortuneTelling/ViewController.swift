//
//  ViewController.swift
//  AnimalFortuneTelling
//
//  Created by ハラダ アズサ on 2016/08/19.
//  Copyright © 2016年 ハラダ アズサ. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class ViewController: UIViewController {
    private let coreDataStack = CoreDataStack()
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var yourAnimal: UILabel!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var results:NSArray = readData()
        if(results.count == 0) {
            // 初期データーの投入
            writeAnimals()
            results = readData()
        }
        
        //占いボタン生成
        //let btn: UIButton = UIButton(frame: CGRectMake(100, 150, 200, 30))
        //writeBtn.backgroundColor = UIColor.magentaColor()
        btn.setTitle("★占う★", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        date.setValue(UIColor.whiteColor(), forKey: "textColor")
        date.setValue(false, forKey: "highlightsToday")
        
        text.editable = false
        text.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func format(dayValue:NSDate) -> String {
        var yourValue : Int
        
        let birthYear = year(date.date)
        let birthDay = day(date.date)
        
        let referenceValue = monthReferenceValue(month(date.date))
        print(referenceValue)
        switch month(date.date) {
        case 1,2:
            yourValue = (birthYear-4)*5+Int((birthYear-1)/4) + referenceValue + birthDay
        case 3...12:
            yourValue = (birthYear+1)*5+Int(birthYear/4)+referenceValue+birthDay
        default :
            yourValue = -1
        }
        return yourValue%60 != 0 ? String(yourValue%60) : "60"
    }
    
    func buttonTapped(sender: UIButton) {
        let year = format(date.date)
        print(year)
        
        
        let a = try! getJson(year)
        yourAnimal.text = a.yourAnimal
        text.text = a.animalText
        
        text.backgroundColor = UIColor.clearColor()
        text.hidden = false
        
        let moon = "MOON"
        
        let results:NSArray = readData()
        if (results.count > 0 ) {
            for i in results {
                let obj = i as! NSManagedObject
                let txt = obj.valueForKey("animalName") as! String
               
                if txt == a.animal {
                    let type = obj.valueForKey("type") as! Int
                    
                    backgroundImage.hidden = false
                    
                    switch type {
                    case 1:
                        backgroundImage.image = UIImage(named: moon+".png")
                    case 2:
                        backgroundImage.image = UIImage(named: "EARTH.png")
                    case 3:
                        backgroundImage.image = UIImage(named: "SUN.png")
                    default:
                        backgroundImage.hidden = true
                        text.backgroundColor = UIColor.whiteColor()
                        
                    }
                    
                }
            }
        }
        
        self.view.bringSubviewToFront(text)//テキストビューを最前面へ
        
    }
    
    func year(time: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let comp: NSDateComponents = calendar.components(NSCalendarUnit.Year,fromDate: time)
        return comp.year
    }
    
    func month(time: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let comp: NSDateComponents = calendar.components(NSCalendarUnit.Month,fromDate: time)
        return comp.month
    }
    
    func day(time: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let comp: NSDateComponents = calendar.components(NSCalendarUnit.Day,fromDate: time)
        return comp.day
    }
    
    func monthReferenceValue(month:Int) -> Int {
        var num = -1
        switch Int(month){
        case 1: num = 15
        case 2: num = 46
        case 3: num = 49
        case 4: num = 20
        case 5: num = 29
        case 6: num = 21
        case 7: num = 51
        case 8: num = 22
        case 9: num = 53
        case 10: num = 23
        case 11: num = 54
        case 12: num = 24
        default: num-1
        }
        return num
    }
    
    
    /**
     Jsonパース
     
     - parameter num: 誕生式から割り出した番号
     
     - returns (yourAnimal,animalText): (動物タイプ、説明）
     */
    
    func getJson(num: String?)
        throws -> (yourAnimal:String,animalText:String,animal:String) {
            
            var yourAnimal = ""
            var animalText = ""
            var animal = ""
            
            if let filePath = NSBundle.mainBundle().pathForResource("animalType", ofType: "json") {
                do {
                    let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: filePath), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        for (_, subJson) in jsonObj["result"] {
                            if let title = subJson["number"].string {
                                if num == title {
                                    yourAnimal = subJson["title"].string!
                                    animalText = subJson["text"].string!
                                    animal = subJson["animal"].string!
                                }
                            }
                        }
                        
                    } else {
                        print("ファイルが開けません。")
                    }
                } catch let error as NSError {
                    throw error
                }
            } else {
                print("パスがみつかりません")
            }
            return (yourAnimal,animalText,animal)
    }
    
    func getYourType(){
        
    }
    
    func readData() -> NSArray{
       
        //let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = coreDataStack.managedObjectContext
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "AnimalType")
        
        let results: NSArray! = try! categoryContext.executeFetchRequest(categoryRequest)
       
        return results
    }
    
    func writeAnimals() {
        
        // plist の読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("AnimalData", ofType: "plist")!
        
        let masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        
       // let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = coreDataStack.managedObjectContext
        
        for i in 1...masterDataDictionary.count {
            let indexName: String = "animal" + String(i)
            let item: AnyObject = masterDataDictionary[indexName]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "AnimalType",
                inManagedObjectContext: categoryContext
            )
            let data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            
            data.setValue(item["動物名"] as! String, forKey: "animalName")
            data.setValue(item["タイプ"] as! NSNumber, forKey: "type")
            data.setValue(item["未来展望型"] as! Bool, forKey: "future")
            data.setValue(item["右脳派"] as! Bool, forKey: "right")
            data.setValue(item["目標志向型"] as! Bool, forKey: "goal")
            
            try! categoryContext.save()
            
        }
    }
    
    //    // データ読み込み
    //    func readData1() -> String{
    //        var ret = ""
    //
    //        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    //        let context: NSManagedObjectContext = appDelegate.managedObjectContext
    //        let request = NSFetchRequest(entityName:  "AnimalType")
    //        request.returnsObjectsAsFaults = false
    //
    //        do {
    //            let results : Array = try context.executeFetchRequest(request)
    //            if (results.count > 0 ) {
    //                // 見つかったら読み込み
    //                let obj = results[0] as! NSManagedObject
    //                let txt = obj.valueForKey(ITEM_NAME) as! String
    //                print("READ:\(txt)")
    //                ret = txt
    //            }
    //        } catch let error as NSError {
    //            // エラー処理
    //            print("READ ERROR:\(error.localizedDescription)")
    //        }
    //        return ret
    //    }
    
    
}

