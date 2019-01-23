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
}

final class TaskModel: TaskModelProtocol {
    func registerTask(tasks: [Task], text: String) -> Observable<[Task]> {
        return Observable.create { [weak self] observer in
            let newTask = Task(isDone: false, text: text)
            var newTasks = tasks
            newTasks.append(newTask)
            observer.onNext(newTasks)
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    /*func registerTask(text: String) -> Observable<Task> {
        return Observable.create { observer in
            let task = Task(isDone: false, text: text)
            observer.onNext(task)
            observer.onCompleted()
            return Disposables.create {}
        }
    }*/
}
