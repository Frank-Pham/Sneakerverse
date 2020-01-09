//
//  NewsDetail2ViewController.swift
//  SneakerApp
//
//  Created by Dung  on 13.12.19.
//  Copyright © 2019 Dung. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import EventKit

class NewsDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var shareBtn: UIButton!
    
    var blogPost : BlogPost?
    var imgArray : [UIImage] = []
    var reminderOn:Bool = false
    var savePost=false
    let animator = CustomAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        let background = BackgroundColor()
        background.createGradientBackground(view: self.view)
        
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        updateUI()
        
    }
    
    //MARK:- Set the Content of the View
    func updateUI(){
        navigationBar.title = blogPost?.title
        textView.text = blogPost?.description
        YoutubeVideoPlayer(videoID: blogPost!.contentVideo, webView: self.webView)
        
        var url = URL(string: blogPost!.cover)
        let data = try? Data(contentsOf: url!)
        imgArray.insert(UIImage(data: data!)!, at: 0)
        
        for i in blogPost!.contentPictures{
            var url = URL(string: i)
             // TODO: try catch einbauen !
            let data = try? Data(contentsOf: url!)
            imgArray.append(UIImage(data: data!)!)
        }
    }

    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
        
    }
    
    // TODO:- shar funktion optimieren mit bilder und link werden noch nicht angezeigt
    @IBAction func sharePost(_ sender: Any) {
        let text = navigationBar.title
          let URL:NSURL = NSURL(string:"https://stockx.com/de-de/")!
          let image = imgArray[0]
          let vc = UIActivityViewController(activityItems:[ text,URL,image], applicationActivities: [])
          if let popoverController = vc.popoverPresentationController{
              popoverPresentationController!.sourceView = self.view
              popoverPresentationController!.sourceRect = self.view.bounds
              
          }
          self.present(vc,animated: true, completion: nil)
    }
    
    // TODO Kalenderfunktion so programmieren das es genau an dem Release ein eintrag macht
    ///create a calendar reminder for special events
    @IBAction func calenderReminder(_ sender: UIButton) {
        if(reminderOn == true){
            sender.tintColor = .lightGray
            reminderOn = false
            return
        }
        reminderOn = true

        animator.buttonScaleAnimation(notificationBtn:sender,color: UIColor(red:0.16, green:0.55, blue:0.30, alpha:1.0)
)
        let eventStore:EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event) { (granted,error) in
            if(granted) && (error == nil)
            {
        let event:EKEvent = EKEvent(eventStore:eventStore)
                event.title = self.navigationBar.title
        event.startDate = Date()
        event.endDate = Date()
        event.notes = "this is a note"
        event.calendar = eventStore.defaultCalendarForNewEvents
        do{
            try eventStore.save(event, span: .thisEvent)
        }catch let error as NSError{
            print("Fehler1 NSERROR: \(error)")
            return
        }
            }
        }
        var message = ToastMessage(message: "Das Event ist in deinem Kalender vermerkt! ✅", view: self.view)
    }
   
    @IBAction func savePost(_ sender: UIButton) {
        if(savePost == true){
            sender.tintColor = .lightGray
            savePost = false
            return
        }
        savePost=true
        animator.buttonScaleAnimation(notificationBtn: sender,color: UIColor(red:0.95, green:0.80, blue:0.02, alpha:1.0))
        // TODO Speichern von BlogPost
    }
    
}


extension NewsDetailViewController :UICollectionViewDataSource,UICollectionViewDelegate{
    ///create a certain number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    ///make the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? BlogPostCollectionViewCell

        cell?.img.image = imgArray[indexPath.row]
        return cell!
    }
    
    
}

extension NewsDetailViewController : UICollectionViewDelegateFlowLayout{
    ///set size of the specified  item's cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    ///spacing between the successive items in the row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

