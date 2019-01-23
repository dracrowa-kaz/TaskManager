//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import RxSwift
import RxCocoa


final class TaskViewModel {
    private let taskModel: TaskModelProtocol
    private let disposeBag = DisposeBag()
    
    // computed values
    var tasks: [Task] { return _tasks.value }
    
    // values
    private let _tasks = BehaviorRelay<[Task]>(value: [])

    // Observables
    let reloadData: Observable<Void>
    
    init(inputBarText: Observable<String?>,
         doneButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         taskModel: TaskModelProtocol = TaskModel()) {
        self.taskModel = taskModel
        self.reloadData = _tasks.map { _ in }
        
        let tasksResponse = doneButtonClicked
            .withLatestFrom(inputBarText)
            .flatMapFirst { [weak self] text -> Observable<Event<[Task]>> in
                guard let me = self, let content = text else {
                    return .empty()
                }
                return me.taskModel.registerTask(tasks: me.tasks, text: content)
                .materialize()
            }
        
        tasksResponse
            .flatMap { event -> Observable<[Task]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _tasks)
            .disposed(by: disposeBag)
        
        tasksResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
            }
            .subscribe(onNext: { error in
                // TODO: Error Handling
            })
            .disposed(by: disposeBag)
        print(tasks)
    }
}
