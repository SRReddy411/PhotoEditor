//
//  BottomSheetViewController.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//
import UIKit

protocol StickerDelegate {
    func viewTapped(view: UIView)
    func imageTapped(image: UIImage)
    func bottomSheetDidDisappear()
}

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate,UISearchBarDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var isFiltered = false
    var searchBar : UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search"
        
        s.tintColor = .white
        
        s.searchBarStyle = UISearchBarStyle.default
        s.sizeToFit()
        return s
    }()
    var collectioView: UICollectionView!
    // var emojisCollectioView: UICollectionView!
    
    //  var emojisDelegate: EmojisCollectionViewDelegate!
    
    var stickers : [String] = []
    var filtersArray:[String] = []
    var stickerDelegate : StickerDelegate?
    
    let screenSize = UIScreen.main.bounds.size
    
    let fullView: CGFloat = 100 // remainder of screen height
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 380
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionViews()
        scrollView.contentSize = CGSize(width: 2.0 * screenSize.width,
                                               height: scrollView.frame.size.height)
        //
        //       // scrollView.isPagingEnabled = true
              scrollView.delegate = self
        
        // pageControl.numberOfPages = 2
        
        holdView.layer.cornerRadius = 3
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
//        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.handleRotate(_:)))
//        rotate.delegate = self
//        view.addGestureRecognizer(rotate)
    }
    
    
//    func handleRotate(_ recognizer: UIRotationGestureRecognizer) {
//        if let view = recognizer.view {
//            view.transform = view.transform.rotated(by: recognizer.rotation)
//            recognizer.rotation = 2
//        }
//
//
//    }
    
    func configureCollectionViews() {
        
        let frame = CGRect(x: 0,
                           y: scrollView.frame.size.height/2-40,
                           width: UIScreen.main.bounds.width,
                           height: view.frame.height)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        let width = (CGFloat) ((screenSize.width - 30) / 3.0)
        layout.itemSize = CGSize(width: width, height: 100)
        
        collectioView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectioView.backgroundColor = .white
        scrollView.addSubview(collectioView)
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: 40))
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        scrollView.addSubview(searchBar)
        
        collectioView.register(StickerCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "StickerCollectionViewCell")
        collectioView.delegate = self
        collectioView.dataSource = self
        //searchBar.delegate = self
        
        collectioView.register(
            UINib(nibName: "StickerCollectionViewCell", bundle: Bundle(for: StickerCollectionViewCell.self)),
            forCellWithReuseIdentifier: "StickerCollectionViewCell")
        
        //-----------------------------------
        
        //        let emojisFrame = CGRect(x: scrollView.frame.size.width,
        //                                 y: 0,
        //                                 width: UIScreen.main.bounds.width,
        //                                 height: view.frame.height - 40)
        //
        //        let emojislayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        emojislayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        //        emojislayout.itemSize = CGSize(width: 60, height: 60)
        //
        //        emojisCollectioView = UICollectionView(frame: emojisFrame, collectionViewLayout: emojislayout)
        //        emojisCollectioView.backgroundColor = .clear
        //        scrollView.addSubview(emojisCollectioView)
        //        emojisDelegate = EmojisCollectionViewDelegate()
        //        emojisDelegate.stickerDelegate = stickerDelegate
        //        emojisCollectioView.delegate = emojisDelegate
        //        emojisCollectioView.dataSource = emojisDelegate
        //
        //        emojisCollectioView.register(
        //            UINib(nibName: "EmojiCollectionViewCell", bundle: Bundle(for: EmojiCollectionViewCell.self)),
        //            forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let `self` = self else { return }
            let frame = self.view.frame
            let yComponent = self.partialView
            self.view.frame = CGRect(x: 0,
                                     y: yComponent,
                                     width: frame.width,
                                     height: UIScreen.main.bounds.height - self.partialView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectioView.frame = CGRect(x: 0,
                                     y: 40,
                                     width: UIScreen.main.bounds.width,
                                     height: view.frame.height)
        
        //        emojisCollectioView.frame = CGRect(x: scrollView.frame.size.width,
        //                                           y: 0,
        //                                           width: UIScreen.main.bounds.width,
        //                                           height: view.frame.height - 40)
        
        scrollView.contentSize = CGSize(width: screenSize.width,
                                        height: scrollView.frame.size.height)
        //        scrollView.contentSize = CGSize(width: 2.0 * screenSize.width,
        //                                        height: scrollView.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Pan Gesture
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if y + translation.y >= fullView {
            let newMinY = y + translation.y
            self.view.frame = CGRect(x: 0, y: newMinY, width: view.frame.width, height: UIScreen.main.bounds.height - newMinY )
            self.view.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration
            //velocity is direction of gesture
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    if y + translation.y >= self.partialView  {
                       self.removeBottomSheetView()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    }
                } else {
                    if y + translation.y >= self.partialView  {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.fullView)
                        self.view.layoutIfNeeded()
                    }
                }
                
            }, completion: nil)
        }
    }
    
    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.stickerDelegate?.bottomSheetDidDisappear()
        })
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    
    
}

extension BottomSheetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        let pageWidth = scrollView.bounds.width
        //        let pageFraction = scrollView.contentOffset.x / pageWidth
        //        self.pageControl.currentPage = Int(round(pageFraction))
    }
}

// MARK: - UICollectionViewDataSource
extension BottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltered == true{
            
            return filtersArray.count
        }else{
            print("stickers count ",stickers.count)
            return stickers.count
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFiltered == true{
            stickerDelegate?.imageTapped(image: UIImage(named: filtersArray[indexPath.row])!)
            //stickerDelegate?.imageTapped(image: uiimagefiltersArray[indexPath.item])
        }else{
            stickerDelegate?.imageTapped(image: UIImage(named: stickers[indexPath.row])!)
            //stickerDelegate?.imageTapped(image: stickers[indexPath.item])
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "StickerCollectionViewCell"
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StickerCollectionViewCell
        if isFiltered == true{
            cell.stickerImage.image = UIImage(named: filtersArray[indexPath.item])
        }else{
            cell.stickerImage.image = UIImage(named: stickers[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: view.frame.width, height: 40)
    //    }
    //   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //    let identifier = "StickerCollectionViewCell"
    //        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    //        header.addSubview(searchBar)
    //        searchBar.translatesAutoresizingMaskIntoConstraints = false
    //        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
    //        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
    //        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
    //        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
    //        return header
    //    }
    
    //MARK:- SEARCH BAR Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            isFiltered = false;
            filtersArray.removeAll()
            collectioView.reloadData()
            searchBar.resignFirstResponder()
        }else{
            isFiltered = true;
            
            print("search text",searchText)
            let predicate = NSPredicate(format: "SELF contains %@", searchText)
            print("search text using predicate",predicate)
            stickers.removeDuplicates()
            print("STICKERS ARRAY ",stickers)
            filtersArray.removeAll()
            filtersArray = stickers.filter { predicate.evaluate(with: $0) }
            print(" after search text using predicate",filtersArray)
            
            collectioView.reloadData()
            
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        isFiltered = false;
        filtersArray.removeAll()
        collectioView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
