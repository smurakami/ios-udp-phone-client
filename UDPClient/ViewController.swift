//
//  ViewController.swift
//  UDPClient
//
//  Created by 村上晋太郎 on 2016/02/04.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UDPDelegate {
    
    let udp = UDP()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        udp.delegate = self
        
        udp.startConnectedToHostName("192.168.10.5", port: 5000) // to iphone
        
        print(udp.getIPAddress())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let data = "hello".dataUsingEncoding(NSUTF8StringEncoding)
        udp.sendData(data)
        
    }

    // delegate
    func udp(udp: UDP!, didReceiveData data: NSData!, fromAddress addr: NSData!) {
        print("did receive data")
        print(String(data: data, encoding: NSUTF8StringEncoding))
    }
    
    func udp(udp: UDP!, didReceiveError error: NSError!) {
        print("did receive error")
        print(error.description)
    }
    
    func udp(udp: UDP!, didSendData data: NSData!, toAddress addr: NSData!) {
        print("did send data")
    }
    
    func udp(udp: UDP!, didStopWithError error: NSError!) {
        print("did stop")
        print(error.description)
    }
    
    func udp(udp: UDP!, didStartWithAddress address: NSData!) {
        print("start")
    }
    
    func udp(udp: UDP!, didFailToSendData data: NSData!, toAddress addr: NSData!, error: NSError!) {
        print("fail")
        print(error.description)
    }
}

