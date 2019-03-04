//
//  ViewController.swift
//  Json
//
//  Created by Antonius George on 12/07/18.
//  Copyright © 2018 Apple Developer Academy @ Binus. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,     UNUserNotificationCenterDelegate {

    @IBOutlet weak var githubURL: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var githubImage: UIImageView!
    @IBOutlet weak var githubName: UILabel!
    @IBOutlet weak var githubLocation: UILabel!
    @IBOutlet weak var githubFollowers: UILabel!
    @IBOutlet weak var githubRepo: UILabel!
    

    struct MyGitHub: Codable {
        
        let name: String?
        let location: String?
        let followers: Int?
        let avatarUrl: URL?
        let repos: Int?
        
        private enum CodingKeys: String, CodingKey {
            case name
            case location
            case followers
            case repos = "public_repos"
            case avatarUrl = "avatar_url"
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
            githubName.text = ""
            githubLocation.text = ""
            githubFollowers.text = ""
            githubRepo.text = ""
        
        
        UNUserNotificationCenter.current().delegate = self
        //printNotification()
    
        
        
        
        /*
        guard let gitUrl = URL(string: "https://api.github.com/users/shashikant86") else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(MyGitHub.self, from: data)
                print(gitData.name ?? "None")
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
 */
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func printNotification(_ type:Int) {
        let content = UNMutableNotificationContent()
        content.title = "Hey"
        if type == 1{
        content.body = "We found the JSON your are looking for"
        }else {
        content.body = "We didn't find anything, sorry..."
        }
        content.sound = UNNotificationSound.default()
        
        print("contentFilled")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        print("added trigger")
        
        let request = UNNotificationRequest(identifier: "GitJson", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    
    @IBAction func onCLick(_ sender: UIButton) {
        
        githubImage.image = nil
        githubName.text = ""
        githubLocation.text = ""
        githubFollowers.text = ""
        githubRepo.text = ""
        
        let userText = githubURL.text?.lowercased()
        
        guard let gitUrl = URL(string: "https://api.github.com/users/" + userText!) else { return }
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in guard let data = data else { return }
            do {
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(MyGitHub.self, from: data)
                
                
                
                DispatchQueue.main.sync {
                    defer{
                        self.printNotification(1)
                    }

                    
                    if let gimage = gitData.avatarUrl {
                        let data = try? Data(contentsOf: gimage)
                        let image: UIImage = UIImage(data: data!)!
                        self.githubImage.image = image
                    }
                    
                    
                    if let gname = gitData.name {
                        self.githubName.text = gname
                    }
                    if let glocation = gitData.location {
                        self.githubLocation.text = glocation
                    }
                    
                    if let gfollowers = gitData.followers {
                        self.githubFollowers.text = String(gfollowers)
                    }
                    
                    if let grepos = gitData.repos {
                        self.githubRepo.text = String(grepos)
                    }
                    //self.setLabelStatus(value: false)
                }
                
                
            } catch let err {
                //self.printNotification(2)
                print("Err", err)
            }
            }.resume()
    }

}

