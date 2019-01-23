//
//  TaskModel.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import RxSwift

protocol TaskModelProtocol {
    func registerTask(tasks: [Task], text: String) -> Observable<[Task]>
    func removeTask(tasks: [Task], id: Double) ->  Observable<[Task]>
    func changeStateTask(tasks: [Task], id: Double) ->  Observable<[Task]>
    func clearDoneTasks(tasks: [Task]) ->  Observable<[Task]>
}

final class TaskModel: TaskModelProtocol {
    func clearDoneTasks(tasks: [Task]) -> Observable<[Task]> {
        return Observable.create { observer in
            observer.onNext(tasks.filter { !$0.isDone } )
            observer.onCompleted()
            return Disposables.create {}
        }
    }

    func removeTask(tasks: [Task], id: Double) -> Observable<[Task]> {
        return Observable.create { observer in
            guard let index = tasks.index(where: { $0.id == id }) else {
                return Disposables.create {}
            }
            var newTasks = tasks
            newTasks.remove(at: index)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    func changeStateTask(tasks: [Task], id: Double) -> Observable<[Task]> {
        return Observable.create { observer in
            guard let index = tasks.index(where: { $0.id == id }) else {
                return Disposables.create {}
            }
            let taskBeforeChangeState = tasks[index]
            var newTasks = tasks
            newTasks.remove(at: index)
            let newTask = Task(id: taskBeforeChangeState.id, isDone: !taskBeforeChangeState.isDone, text: taskBeforeChangeState.text)
            newTasks.insert(newTask, at: index)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    func registerTask(tasks: [Task], text: String) -> Observable<[Task]> {
        return Observable.create { observer in
            let newTask = Task(id: Date().timeIntervalSince1970, isDone: false, text: text)
            var newTasks = tasks
            newTasks.append(newTask)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
}
