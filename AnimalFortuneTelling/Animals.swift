import CoreData
import Foundation

struct Animals: Equatable {
		var animalName:String
		var future: Bool
		var goal:Bool
		var right:Bool
		var type:Int
}


//第一引数と第二引数の比較結果を返す
//sqlで言うところのwhere句みたいな使い方ができる！！！！
func ==(lhs: Animals, rhs:Animals) -> Bool {
   return lhs.animalName == rhs.animalName
}

extension Animals{
    init(managedAnimalCoraData: NSManagedObject){
        self.animalName = managedAnimalCoraData.valueForKey("animalName") as! String
        self.future = managedAnimalCoraData.valueForKey("future") as! Bool
        self.goal = managedAnimalCoraData.valueForKey("goal") as! Bool
        self.right = managedAnimalCoraData.valueForKey("right") as! Bool
        self.type = managedAnimalCoraData.valueForKey("tyoe") as! Int
    }

}
