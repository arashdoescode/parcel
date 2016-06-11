//
//  SecondViewController.swift
//  parcel
//
//  Created by Arash on 6/11/16.
//  Copyright © 2016 Arash. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class SecondViewController: UIViewController {
    
    let socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://genietesting.herokuapp.com")!,options: [.Log(true)])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        socket.on("listeningHere") { data, ack in
            print(data)
            print("Im listening here")
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("dataBoard") as! ThirdViewController

            self.presentViewController(vc, animated: true, completion: nil)
        }
        
   
    }

   
}
