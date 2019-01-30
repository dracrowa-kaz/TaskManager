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
        let inputSearchBar = UISearchBar()
        let signal = inputSearchBar.rx.searchButtonClicked.asSignal()
        let taskText = scheduler.createHotObservable([
                Recorded.next(1, "a"),
                Recorded.next(2, "b"),
                Recorded.next(3, "c"),
            ])

        let observer = scheduler.createObserver(TaskViewModel.self)
        
        let tableView = UITableView()

        // Signal<()>
        let viewModel = TaskViewModel(
            inputBarText: taskText.asObservable().asDriver(onErrorJustReturn: ""),
            doneButtonClicked: signal,
            itemSelected: tableView.rx.itemSelected.asObservable(),
            filterButtonSelected: inputSearchBar.rx.selectedScopeButtonIndex.asObservable(),
            clearButtonTapped: inputSearchBar.rx.resultsListButtonClicked.asObservable(),
            itemDelete: tableView.rx.itemDeleted.asObservable(),
            itemDeleteFromButton: PublishSubject<Double>().asObservable()
        )
        
        viewModel.

        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
