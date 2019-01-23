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
    
    // values
    private let _tasks = BehaviorRelay<[Task]>(value: [])

    // Observables
    let reloadData: Observable<Void>
    let deselectRow: Observable<IndexPath>
    
    init(inputBarText: Observable<String?>,
         doneButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         filterButtonSelected: Observable<Int>,
         filterStatus: FilterStatus = .all,
         taskModel: TaskModelProtocol = TaskModel()) {
        self.taskModel = taskModel
        self.filterStatus = filterStatus
        self.reloadData = _tasks.map { _ in }
        self.deselectRow = itemSelected.map { $0 }

        _ = filterButtonSelected
            .subscribe { [weak self] index in
                print(index)
                guard
                    let me = self,
                    let indexValue = index.element,
                    let newFilterStatus = FilterStatus(rawValue: indexValue) else { return }
                me.filterStatus = newFilterStatus
            }
        
        _ = itemSelected
            .withLatestFrom(_tasks) { ($0, $1) }
            .flatMap { [weak self] indexPath, tasks -> Observable<Event<[Task]>> in
                guard let me = self, indexPath.row < tasks.count else {
                    return .empty()
                }
                return me.taskModel.changeStateTask(tasks: me.tasks, indexPath: indexPath)
                .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
        
        _ = doneButtonClicked
            .withLatestFrom(inputBarText)
            .flatMapFirst { [weak self] text -> Observable<Event<[Task]>> in
                guard let me = self, let content = text else {
                    return .empty()
                }
                return me.taskModel.registerTask(tasks: me.tasks, text: content)
                .materialize()
            }
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
    }
}
