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
    
    private lazy var viewModel = TaskViewModel(
        inputBarText: inputBar.rx.text.asObservable(),
        doneButtonClicked: inputBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable()
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        /*inputBar.rx.searchButtonClicked
            .subscribe { [unowned self] _ in
                // ボタンタップ時の処理
                print("aaaa")
        }*/
        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        
        
    }
    
    private func setup() {
        inputBar.setImage(UIImage(), for: .search, state: .normal)
    }
}

extension TaskViewController {
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
}
