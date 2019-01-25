//
//  ViewController.swift
//  TaskManager
//
//  Created by 佐藤和希 on 2019/01/23.
//  Copyright © 2019 佐藤和希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputBar: UISearchBar!
    
    private let buttonHiddenSUbject = BehaviorSubject(value: false)
    var buttonHidden: Observable<Bool> { return buttonHiddenSUbject }
    
    var tasksVariable = Variable([Task]())
    
    private lazy var viewModel = TaskViewModel(
        inputBarText: inputBar.rx.text.asObservable(),
        doneButtonClicked: inputBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable(),
        filterButtonSelected: inputBar.rx.selectedScopeButtonIndex.asObservable(),
        clearButtonTapped: inputBar.rx.resultsListButtonClicked.asObservable(),
        itemDelete: tableView.rx.itemDeleted.asObservable()
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()

        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)
        
        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        
        buttonHidden.subscribe({ button in
            self.inputBar.isHidden = button.element!
        })
        
        tasksVariable.asObservable().subscribe({ event in
            print(event.element?.count)
        })
    }
    
    private func setup() {
        inputBar.showsCancelButton = false
        inputBar.setImage(UIImage(), for: .search, state: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 64
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        let task = viewModel.tasks[indexPath.row]
        cell.configure(task: task)
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
}

extension TaskViewController {
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
            print("me.tableView.deselectRow(at: indexPath, animated: true)")
            
            do {
                let task = Task(id: 1, isDone: true, text: "aaa")
                var tasks = try self.tasksVariable.value
                tasks.append(task)
                self.tasksVariable.value = tasks
                
                let val = try !self.buttonHiddenSUbject.value()
                print(val)
                self.buttonHiddenSUbject.onNext(val)
            } catch {
                // buttonHidden が既に完了またはエラーで終了している場合
            }
        }
    }
    
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
}
