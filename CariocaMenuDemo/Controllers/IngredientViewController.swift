//
//  IngredientViewController.swift
//  DeepLearning
//
//  Created by Hell Rocky on 6/18/19.
//  Copyright © 2019 Hell Rocky. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (item?.nu?.count)! > section ? (item?.nu?[section].mini.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as! InfoTableViewCell
        cell.textLabel?.text = itemDetail[(item?.nu?[indexPath.section].mini[indexPath.row].name)!]
        cell.textLabel?.textAlignment = .left
        cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        cell.detailTextLabel?.text = item?.nu?[indexPath.section].mini[indexPath.row].amount
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:40,height:20))
        if let value=item?.nu?[indexPath.section].mini[indexPath.row].dailyvalue{
            label.text = value + " %"
        }else{
            label.text = "0" + " %"
        }
        cell.accessoryView = label
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return item?.nu?.count != nil ? (item?.nu?.count)! + 4 : 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! InfoTableViewCell
        headerCell.backgroundColor = UIColor.white
        switch section {
        case 0:
            headerCell.textLabel?.text = "Thông tin dinh dưỡng"
            headerCell.detailTextLabel?.text = ""
            headerCell.frame.size = CGSize(width: headerCell.frame.width, height: 50)
            headerCell.textLabel?.font = UIFont(name: (headerCell.textLabel?.font.fontName)!+"-Bold", size: 20)
        case 1:
            headerCell.textLabel?.text = InfoViewController.vietnam_name[(item?.item.name)!]
            headerCell.detailTextLabel?.text = ""
        case 2:
            headerCell.textLabel?.text = "Khối lượng"
            headerCell.detailTextLabel?.text = item?.item.amount
        case 3:
            headerCell.textLabel?.text = "Số liệu cho mỗi phần ăn"
            headerCell.detailTextLabel?.text = ""
            headerCell.textLabel?.font = UIFont(name: (headerCell.textLabel?.font.fontName)!+"-Bold", size: 18)
        default:
            headerCell.textLabel?.text = itemDetail[(item?.nu?[section-4].name)!]
            headerCell.detailTextLabel?.text = item?.nu?[section-4].amount ?? "0g"
            let label = UILabel.init(frame: CGRect(x:0,y:0,width:40,height:20))
            if let value=item?.nu?[section-4].dailyvalue{
                label.text = value + " %"
            }else{
                label.text = "0 %"
            }
            headerCell.accessoryView = label
        }
        
        return headerCell
    }
    
    @IBOutlet weak var tableview: UITableView!
    var item: listItem?
    var itemDetail=["Calories": "Lượng Calo","Calories from Fat": "Calo do chất béo cung cấp", "Cholesterol": "Lượng Cholesterol",
                    "Sodium": "Lượng muối", "Potassium": "Kali", "Vitamin A": "Vitamin A", "Vitamin C": "Vitamin C", "Iron": "Sắt", "Calcium": "Canxi", "Total Fat": "Tổng lượng chất béo", "Total Carbohydrates": "Tổng lượng Carbohydrates (bột)",
                    "Saturated Fat": "Lượng chất béo no", "Trans Fat": "Chất béo Trans" ,"Polyunsaturated Fat": "Chất béo không bảo hòa đa", "Monounsaturated Fat": "Chất béo không bảo hòa đơn", "Dietary Fiber": "Lượng chất sơ", "Sugars": "Lượng đường"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate=self
        tableview.dataSource=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
