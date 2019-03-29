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
    
    @IBAction func nextTapped(_ sender: Any) {
//        DBManager.shared.getHistory();
       performSegue(withIdentifier: "Q1ToQ2Segue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player.selectedOptions.append(OptionModel(id: player.questions[0].options[indexPath.row].id, qId: player.questions[0].id))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        player.selectedOptions.removeAll(where: { (model) -> Bool in
            return model.id == player.questions[0].options[indexPath.row].id && model.qId == player.questions[0].id
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Q1ToQ2Segue"{
            if let destination = segue.destination as? Question2ViewController{
                destination.player = player;
            }
        }
    }
    
}
