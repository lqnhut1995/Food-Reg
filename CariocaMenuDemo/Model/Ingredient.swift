//
//  Ingredient.swift
//  DeepLearning
//
//  Created by Hell Rocky on 6/19/19.
//  Copyright © 2019 Hell Rocky. All rights reserved.
//

import Foundation
import ObjectMapper

class info{
    var id: Int
    var name: String
    var amount: String
    
    init() {
        id=0
        name=""
        amount=""
    }
    init(id: Int, name: String, amount: String) {
        self.id=id
        self.name=name
        self.amount=amount
    }
}

class mini_nutrition: info, Mappable{
    var dailyvalue: String?
    
    required init?(map: Map) {
        super.init(id: 0, name: "", amount: "")
    }
    
    func mapping(map: Map) {
        
        id <- map["subnutritionid"]
        name <- map["subnutritionname"]
        amount <- map["subnutritionamount"]
        dailyvalue <- map["subnutritiondailyvalue"]
    }
}

class nutrition: info, Mappable{
    var dailyvalue: String?
    var mini=[mini_nutrition]()
    
    required init?(map: Map) {
        super.init(id: 0, name: "", amount: "")
    }
    
    func mapping(map: Map) {
        
        mini <- map["items"]
        id <- map["nutritiondetailid"]
        name <- map["nutritiondetailname"]
        amount <- map["nutritiondetailamount"]
        dailyvalue <- map["nutritiondetaildailyvalue"]
    }
}

class listItem: Mappable{
    var item = info()
    var nu: [nutrition]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        nu <- map["items"]
        item.id <- map["id"]
        item.name <- map["name"]
        item.amount <- map["amount"]
    }
}

class listNu: Mappable{
    var lst: [listItem]?
    var filepath_mark : String?
    var result = [String]()
    var type : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        filepath_mark <- map["file.filepath_mark"]
        lst <- map["info"]
        result <- map["info.result.0"]
        type <- map["file.type"]
    }
}

class VietNam{
    static var vietnam_name=["Beef":"Thịt Bò", "Bun":"Bánh Mỳ", "Sausage":"Xúc Xích", "Mustard":"Tương Cà", "Lemon":"Chanh",
                             "Sauce":"Nước Sốt",
                             "Onion":"Hành Tây", "Basil":"Rau Húng Quế", "Scallions":"Hành Lá",
                             "Noodles":"Bún", "Pork":"Thịt Heo", "Tomato":"Cà Chua", "Cheese":"Phô Mai", "Bean Sprouts":"Giá Đậu", "Fish":"Cá", "Potato":"Khoai Tây", "Corn Tortillas":"Bánh Ngô"]
}
