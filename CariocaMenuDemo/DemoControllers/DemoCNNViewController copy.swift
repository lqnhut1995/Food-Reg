import UIKit
import Koloda
import JGProgressHUD
import ViewAnimator

class DemoCNNViewController: UIViewController, DemoController {

    @IBOutlet weak var pdata: UILabel!
    @IBOutlet weak var cnn: UILabel!
    var hud: JGProgressHUD!
    var kolodaView: KolodaView!
    @IBOutlet weak var takeimage: UIButton!
    @IBOutlet weak var chooseimage: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    weak var menuController: CariocaController?
    var info = [String:Any]()
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.shadowOpacity = 1
        imageview.layer.shadowOffset = .zero
        imageview.layer.shadowRadius = 10
        imageview.layer.shadowPath = UIBezierPath(rect: imageview.bounds).cgPath
        
        chooseimage.layer.cornerRadius = 5
        chooseimage.layer.borderWidth = 1
        chooseimage.layer.borderColor = UIColor.white.cgColor
        
        takeimage.layer.cornerRadius = 5
        takeimage.layer.borderWidth = 1
        takeimage.layer.borderColor = UIColor.white.cgColor
        
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
        
        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        UIView.animate(views: [imageview, chooseimage, takeimage, pdata, cnn],
                       animations: [zoomAnimation, rotateAnimation, fromAnimation],
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
}

extension DemoCNNViewController: KolodaViewDelegate, KolodaViewDataSource{
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.revertAction()
        koloda.isHidden=true
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return info["info"] != nil ? 1 : 0
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view=Bundle.main.loadNibNamed("CNNView", owner: self, options: nil)?.first as! CNNView
        view.imageview.image = info["image"] as? UIImage
        view.list = info["info"] as? listNu
        view.label1.text = "Food's Idea:"
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
        return nil
    }
}

extension DemoCNNViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true) {
                self.hud.show(in: self.view)
                WebServices.LoadIngredients(downloadString: "https://deeplearning.vlute.edu.vn:9091/cal/uploads", param: ["file": image, "type": "1", "mark": "1"]) { (list) in
                    if let list=list{
                        self.info = ["image": image, "info": list]
                        self.kolodaView.reloadData()
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
