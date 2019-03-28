//
//  Question2ViewController.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit

class Question2ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    var player:PlayerModel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = player.questions[1].title!;
        answersTable.tableHeaderView = UIView(frame: CGRect.zero);
        answersTable.tableFooterView = UIView(frame: CGRect.zero);
        answersTable.allowsMultipleSelection = true;
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.questions[1].options.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Q2AnswerCell", for: indexPath) as! Q2AnswerTableViewCell;
        cell.titleLabel.text = player.questions[1].options[indexPath.row].title!;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player.selectedOptions.append(OptionModel(id: player.questions[1].options[indexPath.row].id, qId: player.questions[1].id))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        player.selectedOptions.removeAll(where: { (model) -> Bool in
            return model.id == player.questions[1].options[indexPath.row].id && model.qId == player.questions[1].id
        })
    }
    @IBAction func finishTapped(_ sender: Any) {
        print(player.selectedOptions)
        DBHandler().saveGame(player: player);
        performSegue(withIdentifier: "unwindToMainScreenSegue", sender: self)
    }
    
}
