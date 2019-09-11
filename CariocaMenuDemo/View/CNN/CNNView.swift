//
//  CNNView.swift
//  CariocaMenuDemo
//
//  Created by Hell Rocky on 8/1/19.
//  Copyright © 2019 CariocaMenu. All rights reserved.
//

import UIKit

class CNNView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageview: UIImageView!
    weak var delegate: IngredientDelegate?
    var list: listNu?{
        didSet{
            tableview.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds=true
        create()
    }
    func create() {
        tableview.separatorStyle = .none
    }
}

extension CNNView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.lst?.count ?? list?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableview.register(UINib(nibName: "CNNCell", bundle: nil), forCellReuseIdentifier: "CNNCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNNCell", for: indexPath) as! CNNCell
        if list?.type == "1"{
            cell.name.text = list?.result[indexPath.row]
        }else{
            cell.name.text = VietNam.vietnam_name[(list?.lst?[indexPath.row].item.name)!]
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.updateIngredients(list: list?.lst![indexPath.row])
    }
    
}

protocol IngredientDelegate: class {
    func updateIngredients(list: listItem?)
}
