import UIKit
import ViewAnimator
import Koloda
import JGProgressHUD
import Panels

class DemoYOLOViewController: UIViewController, DemoController, IngredientDelegate{
    @IBOutlet weak var imageview: UIImageView!
    weak var menuController: CariocaController?
    @IBOutlet weak var buttonview: UIView!
    @IBOutlet weak var yolo: UILabel!
    var kolodaView: KolodaView!
    var hud: JGProgressHUD!
    var info = [String:Any](){
        didSet{
            kolodaView.reloadData()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var panel: (UIViewController & Panelable)?
    lazy var panelManager = Panels(target: self)

    @IBOutlet weak var choice: UISegmentedControl!
    override func viewDidLoad() {
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.shadowOpacity = 1
        imageview.layer.shadowOffset = .zero
        imageview.layer.shadowRadius = 10
        imageview.layer.shadowPath = UIBezierPath(rect: imageview.bounds).cgPath
        
        kolodaView=KolodaView()
        view.addSubview(kolodaView)
        kolodaView.translatesAutoresizingMaskIntoConstraints = false
        kolodaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive=true
        kolodaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive=true
        kolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive=true
        kolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive=true
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.isHidden=true
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Processing Image"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 30.0)
        UIView.animate(views: [imageview, yolo, buttonview],
                       animations: [fromAnimation],
                       duration: 1.0)
    }
    
    @IBAction func chooseimage(_ sender: Any) {
        let imagepicker=UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate=self
        imagepicker.allowsEditing = false
        imagepicker.modalPresentationStyle = .overCurrentContext
        present(imagepicker, animated: true, completion: nil)
    }
    
    @IBAction func takeimage(_ sender: Any) {
        let imagepicker=UIImagePickerController()
        imagepicker.sourceType = .camera
        imagepicker.delegate=self
        imagepicker.allowsEditing = false
        imagepicker.modalPresentationStyle = .overCurrentContext
        present(imagepicker, animated: true, completion: nil)
    }
    func updateIngredients(list: listItem?) {
        if panel != nil{
            (panel as! IngredientsViewController).item = list
            view.bringSubview(toFront: panel!.view)
            panel?.view.isHidden=false
        }else{
            panel = UIStoryboard.instantiatePanel(identifier: "Ingredients")
            let panelConfiguration = PanelConfiguration(size: .thirdQuarter)
            (panel as! IngredientsViewController).item = list
            panelManager.show(panel: panel!, config: panelConfiguration)
        }
    }
}

extension DemoYOLOViewController: KolodaViewDelegate, KolodaViewDataSource{
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        if panel != nil{
            panel?.view.isHidden=true
        }
        kolodaView.revertAction()
        koloda.isHidden=true
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return 1
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view=Bundle.main.loadNibNamed("CNNView", owner: self, options: nil)?.first as! CNNView
        view.delegate = self
        if let filepath_mark = (info["info"] as? listNu)?.filepath_mark{
            view.imageview.setImage(url: URL(string: "https://deeplearning.vlute.edu.vn:9091/uploads/"+filepath_mark)!)
        }else{
            view.imageview.image = info["image"] as? UIImage
        }
        view.list = info["info"] as? listNu
        view.label1.text = "Ingredients:"
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        //        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
        return nil
    }
}

extension DemoYOLOViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true) {
                self.hud.show(in: self.view)
                WebServices.LoadIngredients(downloadString: "https://deeplearning.vlute.edu.vn:9091/cal/uploads", param: ["file": image, "type": "3", "mark": String(self.choice.selectedSegmentIndex + 1)]) { (list) in
                    if let list=list{
                        self.info = ["image": image, "info": list]
                        let blurEffect = UIBlurEffect(style: .dark)
                        let blurEffectView = UIVisualEffectView(effect: blurEffect)
                        blurEffectView.frame = self.view.bounds
                        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        blurEffectView.tag = 100
                        blurEffectView.isHidden=true
                        
                        self.view.addSubview(blurEffectView)
                        self.view.bringSubview(toFront: self.kolodaView)
                        blurEffectView.isHidden=false
                        self.kolodaView.isHidden=false
                        self.hud.dismiss()
                    }
                }
            }
        }
    }
}
