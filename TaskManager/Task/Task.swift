//
//  Task.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import Foundation

public struct Task: Codable {
    public let isDone: Bool
    public let text: String
    
    public init(
        isDone: Bool,
        text: String
        ){
        self.isDone = isDone
        self.text = text
    }
}
