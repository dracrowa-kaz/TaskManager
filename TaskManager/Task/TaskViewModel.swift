//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import RxSwift
import RxCocoa

enum FilterStatus: Int {
    case all = 0
    case active = 1
    case completed = 2
}

var count = 0

final class TaskViewModel {
    private let taskModel: TaskModelProtocol
    private var filterStatus: FilterStatus
    private let disposeBag = DisposeBag()

    // computed values
    var tasks: [Task] {
        switch self.filterStatus {
        case .all:
            return _tasks.value
        case .active:
            return _tasks.value.filter{ !$0.isDone }
        case .completed:
            return _tasks.value.filter{ $0.isDone }
        }
    }
    
    var allTasks: [Task] {
        return _tasks.value
    }
    
    // values
    private let _tasks = BehaviorRelay<[Task]>(value: [])

    // Observables
    let reloadData: Observable<Void>
    let deselectRow: Observable<IndexPath>

    init(inputBarText: Driver<String>,
         doneButtonClicked: Signal<()>,
         itemSelected: Observable<IndexPath>,
         filterButtonSelected: Observable<Int>,
         filterStatus: FilterStatus = .all,
         clearButtonTapped: Observable<Void>,
         itemDelete: Observable<IndexPath>,
         itemDeleteFromButton: Observable<Double>,
         taskModel: TaskModelProtocol = TaskModel()) {
        
        self.taskModel = taskModel
        self.filterStatus = filterStatus
        self.reloadData = _tasks.map { _ in }
        self.deselectRow = itemSelected.map { $0 }

        _ = itemDeleteFromButton
            .subscribe { [weak self] index in
                 guard let me = self, let id = index.element else {
                    return
                }
                count += 1
                me.taskModel.removeTask(tasks: me.allTasks, id: id)
                .materialize()
                .flatMap { event -> Observable<[Task]> in
                    event.element.map(Observable.just) ?? .empty()
                }
                .bind(to: me._tasks)
                .disposed(by: me.disposeBag)
            }
        
        _ = clearButtonTapped
            .flatMapFirst { [weak self] () -> Observable<Event<[Task]>> in
                guard let me = self else {
                    return .empty()
                }
                return me.taskModel.clearDoneTasks(tasks: me.allTasks)
                .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
        
        _ = itemDelete
            .withLatestFrom(_tasks){ ($0, $1) }
            .flatMap { [weak self] indexPath, tasks -> Observable<Event<[Task]>> in
                guard let me = self, indexPath.row < tasks.count else {
                    return .empty()
                }
                let task = me.tasks[indexPath.row]
                return me.taskModel.removeTask(tasks: me.allTasks, id: task.id)
                    .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
            
        _ = filterButtonSelected
            .subscribe { [weak self] index in
                guard
                    let me = self,
                    let indexValue = index.element,
                    let newFilterStatus = FilterStatus(rawValue: indexValue) else { return }
                me.filterStatus = newFilterStatus
                me._tasks.accept(me.allTasks)
            }
        
        _ = itemSelected
            .withLatestFrom(_tasks) { ($0, $1) }
            .flatMap { [weak self] indexPath, tasks -> Observable<Event<[Task]>> in
                guard let me = self, indexPath.row < tasks.count else {
                    return .empty()
                }
                let task = me.tasks[indexPath.row]
                return me.taskModel.changeStateTask(tasks: me.allTasks, id: task.id)
                .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
        
        _ = doneButtonClicked
            .asObservable()
            .withLatestFrom(inputBarText)
            .filter { $0.count > 0 } // validation
            .flatMapFirst { [weak self] text -> Observable<Event<[Task]>> in
                guard let me = self else {
                    return .empty()
                }
                return me.taskModel.registerTask(tasks: me.allTasks, text: text)
                .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
    }
}
