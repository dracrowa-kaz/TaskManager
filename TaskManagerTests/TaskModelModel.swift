//
//  TaskViewModel.swift
//  TaskManagerTests
//
//  Created by 佐藤和希 on 2019/01/30.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import XCTest
@testable import TaskManager
import RxSwift
import Foundation

class TaskModelTest: XCTestCase {
    
    let model: TaskModel = TaskModel()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChangeTasks() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let isDone = false
        let tasks = [Task(id: 1, isDone: isDone, text: "aaa")]
        _ = model.changeStateTask(tasks: tasks, id: 1).subscribe({
            guard let newIsDone = $0.element?.first?.isDone else {
                return
            }
            XCTAssertNotEqual(newIsDone, isDone)
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
