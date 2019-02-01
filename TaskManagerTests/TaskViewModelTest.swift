//
//  TaskManagerTests.swift
//  TaskManagerTests
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import XCTest
@testable import TaskManager
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class TaskViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // reloadData {
        let resultText = "cde"
        let doneEvent = scheduler.createHotObservable([
            Recorded.next(4, ())
        ])
        
        let taskText = scheduler.createHotObservable([
            Recorded.next(1, "a"),
            Recorded.next(2, "b"),
            Recorded.next(3, resultText),
        ])
        // }
        
        // itemSelected {
        let itemSelected = scheduler.createHotObservable([
            Recorded.next(5, IndexPath(row: 0, section: 0))
        ])
        // }
        
        // itemDeleted {
        let itemDeleted = scheduler.createHotObservable([
            Recorded.next(6, IndexPath(row: 0, section: 0))
        ])
        // }
        
        let viewModel = TaskViewModel(
            inputBarText: taskText.asObservable().asDriver(onErrorJustReturn: ""),
            doneButtonClicked: doneEvent.asObservable(),
            itemSelected: itemSelected.asObservable(),
            filterButtonSelected: Observable<Int>.empty(),
            clearButtonTapped: Observable<Void>.empty(),
            itemDelete: itemDeleted.asObservable()
        )

        // reloadData
        scheduler.scheduleAt(4, action: {
            XCTAssertEqual(viewModel.allTasks.first!.text, resultText)
            XCTAssertEqual(viewModel.allTasks.count, 1)
        })
        
        // itemSelected
        scheduler.scheduleAt(5, action: {
            XCTAssertEqual(viewModel.allTasks.first!.isDone, true)
        })
        
        // itemDeleted
        scheduler.scheduleAt(6, action: {
            XCTAssertEqual(viewModel.allTasks.count, 0)
        })
        
        scheduler.start()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
