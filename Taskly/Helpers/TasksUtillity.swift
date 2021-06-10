//
//  TasksUtillity.swift
//  Taskly
//
//  Created by Ahmed Badawi.
//  Copyright © 2021 Badawi. All rights reserved.
//

import Foundation

class TasksUtillity {
    
    private static let Key = "tasks"
    
    
    // archive
    private static func archive(_ tasks: [[Task]]) -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
    }
    
    // fetch
    static func fetch() -> [[Task]]? {
        guard let unarchiveData = UserDefaults.standard.object(forKey: Key) as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchiveData) as? [[Task]] ?? [[]]
    }
    // save
    static func save(_ tasks: [[Task]]) {
        
        // Archive
        let archivedTasks = archive(tasks)
        
        // Set object for key
        UserDefaults.standard.set(archivedTasks, forKey: Key)
        UserDefaults.standard.synchronize()
    }
}
