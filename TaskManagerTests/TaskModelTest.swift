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
    
    func testRemoveTask() {
        let tasks = [Task(id: 1, isDone: false, text: "aaa")]
        _ = model.removeTask(tasks: tasks, id: 1).subscribe ({
            guard let removedTasks = $0.element else {
                return
            }
            XCTAssertEqual(removedTasks.count, 0)
        })
    }
    
    func testRegisterTask() {
        _ = model.registerTask(tasks: [], text: "new").subscribe({
            guard let tasks = $0.element else {
                return
            }
            XCTAssertEqual(tasks.count, 1)
        })
    }
    
    func testClearDoneTasks() {
        let doneTasks = [Task(id: 1, isDone: true, text: "aaa"), Task(id: 2, isDone: true, text: "aaa")]
        _ = model.clearDoneTasks(tasks: doneTasks).subscribe({
            guard let tasks = $0.element else {
                return
            }
            XCTAssertEqual(tasks.count, 0)
        })
    }
    
    func testChangeTasks() {
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
