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
import UIKit

public enum TestError: Error {
    case test
}

final class TaskViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputBar: UISearchBar!
    
    var deleteIndexPathSubject = PublishSubject<IndexPath>()

    private lazy var viewModel = TaskViewModel(
        inputBarText: inputBar.rx.text.orEmpty.asDriver() ,
        doneButtonClicked: inputBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable(),
        filterButtonSelected: inputBar.rx.selectedScopeButtonIndex.asObservable(),
        clearButtonTapped: inputBar.rx.resultsListButtonClicked.asObservable(),
        itemDelete: deleteIndexPathSubject.asObserver()
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
        
        cell.deleteButton.rx.tap.subscribe ({ [unowned self] _ in
            self.deleteIndexPathSubject.onNext(indexPath)
        })
        .disposed(by: cell.disposeBag)
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.deleteIndexPathSubject.onNext(indexPath)
        }
    }
}

extension TaskViewController {
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
}
