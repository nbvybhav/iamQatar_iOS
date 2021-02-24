//
//  FeedDetailsViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 06/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class FeedDetailsViewController: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var imgFeed: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- VARIABLES
    @objc var feedSlug = ""
    var responseDict = NSDictionary()
    
    
    //MARK;- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUi()
        self.getFeedDetails()
        
    }
    
    //MARK:- API CALL
    func getFeedDetails(){
        
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + IAQFeedsDetailsApi
        apiService.target = self
        
        let paramter = ["user_id":userId(),"slug":self.feedSlug]
        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                
                DispatchQueue.main.async {
                    
                    if let newsData = responseDict.value(forKey: "value") as? NSDictionary{
                        self.responseDict = newsData
                        self.setContentView()
                    }
                    
                }
            }
        }
    }
    
    //MARK:- METHODS
    func setUi(){
        
        self.navigationItem.title = "IAQ FEEDS"
        
        self.lblDate.text = ""
        self.lblTitle.text = ""
        self.lblContent.text = ""
        
    }
    func setContentView(){
        
        let imageArray = (self.responseDict.value(forKey: "images") ?? []) as! NSArray
        if imageArray.firstObject != nil{
            self.imgFeed.setImage(withUrlString: "\((imageArray.firstObject as AnyObject).value(forKey: "image") ?? "")")
        }
        
        self.lblTitle.text = "\(self.responseDict.value(forKey: "title") ?? "")"
        
        self.setDescription()
        
        let dateStr = "\(self.responseDict.value(forKey: "created_date") ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateStr) else { return }
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm a"//"yyyy-MM-dd"//2019-09-25
        let dateString = dateFormatter.string(from: date)
        
        var author = "\(self.responseDict.value(forKey: "author") ?? "")"
        author = author == "" ? "" : " by \(author)"
        
        self.lblDate.text = dateString + author
        
        self.setContentViewHeight()
        
    }
    
    func setDescription(){
        
        let description = "\(self.responseDict.value(forKey: "description") ?? "")"
        
        let customHeader = "<link rel='stylesheet' href='style.css' type='text/css'><meta name='viewport' content='initial-scale=0.0'/>"
        //                let newHtml = HtmlString.replacingOccurrences(of: "<head>", with: "<head>" + customHeader)
        let newHtml = customHeader + description + "</head>"
        
        let htmlData = NSString(string: newHtml).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        
        var attributedString : NSMutableAttributedString?
        attributedString?.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Medium", size: 12.0)!, range: NSRange(location: 0, length: attributedString?.length ?? 0))
        
        attributedString =  try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)

        
        self.lblContent.attributedText = attributedString
        
    }

//    public convenience init?(HTMLString html: String, font: UIFont? = nil) throws {
//        let options : [NSAttributedString.DocumentReadingOptionKey : Any] =
//            [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//             NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
//
//        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
//            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//        }
//
//        if let font = font {
//            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
//                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//            }
//            var attrs = attr.attributes(at: 0, effectiveRange: nil)
//            attrs[NSAttributedString.Key.font] = font
//            attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
//            self.init(coder: attr)
//        } else {
//            try? self.init(data: data, options: options, documentAttributes: nil)
//        }
//    }
    
    func setContentViewHeight(){
        
        self.imageViewHeightConstraint.constant = self.view.frame.width / 1.7
        self.view.layoutIfNeeded()
        self.mainContentViewHeightConstraint.constant = self.lblContent.frame.origin.y + self.lblContent.frame.height + 20
        
    }
    
    //MARK:- BTN ACTIOS
    @IBAction func shareAction(_ sender: UIButton) {
        
        let shareString = self.lblContent.text ?? ""
        
        var shareItems = [Any]()
        if let image = self.imgFeed.image{
            shareItems.append(image)
        }
        
        shareItems.append(shareString)
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.saveToCameraRoll]//UIActivity.ActivityType.copyToPasteboard
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
}
