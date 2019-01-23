//
//  Task.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import Foundation

public struct Task: Codable {
    public let id: Double // Auto increment
    public let isDone: Bool
    public let text: String
    
    public init(
        id: Double,
        isDone: Bool,
        text: String
        ){
        self.id = id
        self.isDone = isDone
        self.text = text
    }
}
