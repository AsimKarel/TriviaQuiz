//
//  Question1ViewController.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit

class Question1ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    var player:PlayerModel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTable.tableHeaderView = UIView(frame: CGRect.zero);
        answersTable.tableFooterView = UIView(frame: CGRect.zero);
        questionLabel.text = player.questions[0].title!;
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.questions[0].options.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Q1AnswerCell", for: indexPath) as! Q1AnswerTableViewCell;
        cell.titleLabel.text = player.questions[0].options[indexPath.row].title!;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
}
