//
//  ViewController.swift
//  JabyJob
//
//  Created by DMG swift on 30/12/21.
//

import UIKit

struct IntroData {
    var imgName: String?
    var title: String?
    var des: String?
    init(imgName: String?,title: String?,des: String?) {
        self.imgName = imgName
        self.title = title
        self.des = des
    }
}


class IntroVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageDot: UIPageControl!
    @IBOutlet weak var colletView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    
    var dateIntro = [IntroData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dateIntro.removeAll()
        btnSkip.isHidden = false
        pageDot.currentPage = 0
        pageDot.numberOfPages = 3
        self.colletView.isPagingEnabled = true
        self.colletView.contentMode = .scaleAspectFill
        bgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        dateIntro.append(IntroData(imgName: "employment-opportunity-hiring-jobs-icon", title: "SEARCH JOBS", des: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."))
        dateIntro.append(IntroData(imgName: "young-smiley-businesswomen-working-with-laptop-desk", title: "APPLY JOBS", des: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."))
        dateIntro.append(IntroData(imgName: "cheerful-young-businessman-checking-email-tablet-looking-camera", title: "READY TO WORK", des: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."))
        
        colletView.reloadData()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @IBAction func didTapSkip(_ sender: Any) {
//        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "SignUp", identifire: "SignUpVC")
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpVC")
        self.navigationController?.pushViewController(vc, animated: true)
        
        if UserDefaultData.value(forKey: "user") as? Int == 2 {
            UserDefaultData.set(true, forKey: "introJob")
        }else {
            UserDefaultData.set(true, forKey: "introIntrJob")
        }
        
       
        
    }
    @IBAction func didNext(_ sender: UIButton) {
        var count = 0
        let visibleItems: NSArray = self.colletView.indexPathsForVisibleItems as NSArray
           let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
           let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < dateIntro.count {
                count = count + nextItem.row
               self.colletView.scrollToItem(at: nextItem, at: .left, animated: true)

            }else {
                let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpVC")
                self.navigationController?.pushViewController(vc, animated: true)
                if UserDefaultData.value(forKey: "user") as? Int == 2 {
                    UserDefaultData.set(true, forKey: "introJob")
                }else {
                    UserDefaultData.set(true, forKey: "introIntrJob")
                }
                
//                appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "SignUp", identifire: "SignUpVC")
            }
       
    }
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let path = collectionView.indexPathsForVisibleItems.first {
            if path.row == 2 {
                btnSkip.isHidden = true
            }else {
                btnSkip.isHidden = false
            }
            pageDot.currentPage = path.row
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colletView.frame.size.width, height: colletView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateIntro.count
    }
    func collectionView(_ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as? IntroCell else { return UICollectionViewCell() }
        cell.img.image = UIImage(named: dateIntro[indexPath.row].imgName ?? "")
        cell.lblHearer.text = dateIntro[indexPath.row].title
        cell.lblDes.text = dateIntro[indexPath.row].des
        return cell
    }
}
class IntroCell: UICollectionViewCell {
    @IBOutlet weak var lblHearer: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var img: UIImageView!
}
extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    func addShadow1(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}

