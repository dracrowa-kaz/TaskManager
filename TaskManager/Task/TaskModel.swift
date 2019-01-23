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
    func removeTask(tasks: [Task], indexPath: IndexPath) ->  Observable<[Task]>
    func changeStateTask(tasks: [Task], indexPath: IndexPath) ->  Observable<[Task]>
}

final class TaskModel: TaskModelProtocol {
    func changeStateTask(tasks: [Task], indexPath: IndexPath) -> Observable<[Task]> {
        return Observable.create { observer in
            let taskBeforeChangeState = tasks[indexPath.row]
            var newTasks = tasks
            newTasks.remove(at: indexPath.row)
            let newTask = Task(isDone: !taskBeforeChangeState.isDone, text: taskBeforeChangeState.text)
            newTasks.insert(newTask, at: indexPath.row)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    func removeTask(tasks: [Task], indexPath: IndexPath) -> Observable<[Task]> {
        return Observable.create { observer in
            var newTasks = tasks
            newTasks.remove(at: indexPath.row)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }

    func registerTask(tasks: [Task], text: String) -> Observable<[Task]> {
        return Observable.create { observer in
            let newTask = Task(isDone: false, text: text)
            var newTasks = tasks
            newTasks.append(newTask)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
}
