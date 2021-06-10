//
//  Task.swift
//  Taskly
//
//  Created by Ahmed Badawi.
//  Copyright © 2021 Badawi. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    
    var name:String?
    var isDone:Bool?
    init(name:String , isDone:Bool = false) {
        self.name = name
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: nameKey) as? String , let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
            else { return }
        self.name = name
        self.isDone = isDone
    }
}
