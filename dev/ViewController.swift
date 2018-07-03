//
//  ViewController.swift
//  tyg
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import UIKit
import Bond
import tyg

class ViewController: UIViewController {

    let options: [String: UIViewController.Type] = [
        "keyboard": KeyboardTestViewController.self,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.navigationItem.title = "Tests"

        let table = UITableView()
        self.view.addSubview(table)
        table.frame = self.view.frame
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.delegate = self
        table.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Type = [UIViewController.Type](options.values)[indexPath.row]
        let viewController = Type.init()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = [String](options.keys)[indexPath.row]
        return cell
    }
}

