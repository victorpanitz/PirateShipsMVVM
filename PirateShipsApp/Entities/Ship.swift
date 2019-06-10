//
//  Ship.swift
//  PirateShipsApp
//
//  Created by Victor on 13/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

enum PirateGreeting: String {
    case ah = "Ahoi!"
    case ay = "Aye Aye!"
    case ar = "Arrr!"
    case yo = "Yo ho hooo!"
}

/*
 private func getGreetingType() -> String {
 return ship.type == .yo ? "Yo ho hooo!" :
 ship.type == .ar ? "Arrr!" :
 ship.type == .ay ? "Aye Aye!" :
 "Ahoi!"
 }
 */

struct Ship {
    var title: String?
    var imageUrl: String?
    var description: String?
    var type: PirateGreeting?
    var price: Double?
    var id: Int?

    init(output: ShipOutput) {
        self.title = output.title
        self.imageUrl = output.image
        self.description = output.detail
        self.type = output.type == "yo" ? .yo : output.type == "ay" ? .ay : output.type == "ar" ? .ar : .ah
        self.price = output.price
        self.id = output.id
    }
    
    init(ship_CD: Ship_CD) {
        self.title = ship_CD.title
        self.imageUrl = ship_CD.image
        self.description = ship_CD.detail
        self.type = ship_CD.type == "yo" ? .yo : ship_CD.type == "ay" ? .ay : ship_CD.type == "ar" ? .ar : .ah
        self.price = ship_CD.price
        self.id = Int(ship_CD.id)
    }

    init(id: Int, title: String, imageUrl: String, description: String, type: PirateGreeting, price: Double) {
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.type = type
        self.price = price
        self.id = id
    }

    var toDict: [String: Any?] {
        return [
            "id": id,
            "title": title,
            "image": imageUrl,
            "detail": description,
            "type": type == .yo ? "yo" : type == .ay ? "ay" : type == .ar ? "ar" : "ah",
            "price": price,
        ]
    }
    
}

extension Ship: Equatable { }
