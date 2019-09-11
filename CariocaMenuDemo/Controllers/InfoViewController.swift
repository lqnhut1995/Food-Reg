//
//  InfoViewController.swift
//  DeepLearning
//
//  Created by Hell Rocky on 6/18/19.
//  Copyright © 2019 Hell Rocky. All rights reserved.
//

import UIKit
import Lightbox

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info?.lst?.count ?? info?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "infocell", for: indexPath) as! InfoTableViewCell
        if info?.type == "1"{
            cell.textLabel?.text = info?.result[indexPath.row]
        }else{
            cell.textLabel?.text = InfoViewController.vietnam_name[(info?.lst?[indexPath.row].item.name)!]
        }
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if info?.type != "1"{
            let bundle=UIStoryboard(name: "Main", bundle: nil)
            let ingre=bundle.instantiateViewController(withIdentifier: "IngreID") as! IngredientViewController
            ingre.item = info?.lst?[indexPath.row]
            navigationController?.pushViewController(ingre, animated: true)
        }
    }

    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageview: UIImageView!
    var image=UIImage()
    var info:listNu?
    static var vietnam_name=["Beef":"Thịt Bò", "Bun":"Bánh Mỳ", "Sausage":"Xúc Xích", "Mustard":"Tương Cà", "Lemon":"Chanh",
                             "Sauce":"Nước Sốt",
                             "Onion":"Hành Tây", "Basil":"Rau Húng Quế", "Scallions":"Hành Lá",
                             "Noodles":"Bún", "Pork":"Thịt Heo", "Tomato":"Cà Chua", "Cheese":"Phô Mai", "Bean Sprouts":"Giá Đậu", "Fish":"Cá", "Potato":"Khoai Tây", "Corn Tortillas":"Bánh Ngô"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate=self
        tableview.dataSource=self
        if let filepath_mark = info?.filepath_mark, info?.type != "1"{
            imageview.setImage(url: URL(string: "https://deeplearning.vlute.edu.vn:9091/uploads/"+filepath_mark)!)
        }else{
            imageview.image = image
        }
        imageview.contentMode = .scaleAspectFit
        imageview.isUserInteractionEnabled=true
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        var controller = LightboxController()
        if let filepath_mark = info?.filepath_mark{
            controller = LightboxController(images: [LightboxImage(imageURL: URL(string: "https://deeplearning.vlute.edu.vn:9091/uploads/"+filepath_mark)!)])
        }else{
            controller = LightboxController(images: [LightboxImage(image: image)])
        }
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = false
        present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitpressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension InfoViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate{
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    
}
