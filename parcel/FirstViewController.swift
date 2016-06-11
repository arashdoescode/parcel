//
//  FirstViewController.swift
//  parcel
//
//  Created by Arash on 6/11/16.
//  Copyright © 2016 Arash. All rights reserved.
//

import UIKit
import SocketIOClientSwift


class FirstViewController: UIViewController {
    
    let socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://genietesting.herokuapp.com")!,options: [.Log(true)])

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        socket.connect()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var clickIt: UIButton!
    
    @IBAction func buttonPressed(sender: AnyObject) {
        socket.emit("clickit")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
