//
//  ViewController.swift
//  UDPClient
//
//  Created by 村上晋太郎 on 2016/02/04.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UDPDelegate {
    
    let udp = UDP()
    
    let engine = AVAudioEngine()
    
//    let player = AVAudioPlayerNode()
//    var outputBuffer = AVAudioPCMBuffer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        udp.delegate = self
        udp.startConnectedToHostName("192.168.10.5", port: 5000) // to iphone
        print(udp.getIPAddress())
        
        let bufferSize = UInt32(16537) // 決め打ち。ここを動的に変更できるようにはしたい。
//        outputBuffer = AVAudioPCMBuffer(PCMFormat: player.outputFormatForBus(0), frameCapacity: bufferSize)
//        outputBuffer.frameLength = bufferSize

        
//        engine.attachNode(player)
//        engine.connect(player, to: engine.mainMixerNode, format: player.outputFormatForBus(0))
        
        if let input = engine.inputNode {
            let bus = 0
            input.installTapOnBus(bus, bufferSize: bufferSize, format: input.inputFormatForBus(bus), block: {
                (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
                let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
                
//                for var i = 0; i < frameLength; i += frameStep {
//                    dataArray[i] = floats[i]
//                }
                
                let frameLength = Int(buffer.frameLength)
                let frameStep = Int(self.engine.mainMixerNode.outputFormatForBus(bus).channelCount)
                
                let sendSize = 1024
                
                var dataArray = [Float](count: sendSize, repeatedValue: 0)
                
//                var received = [Float](count: sendSize, repeatedValue: 0)
                
                for var start = 0; start < Int(buffer.frameLength); start += sendSize {
                    let count = min(frameLength - start, sendSize)
                    for var i = 0; i < count; i += frameStep {
                        dataArray[i] = floats[start + i]
                    }
                    let data = NSData(bytes: dataArray, length: (sizeof(Float) * count))
                    
                    self.udp.sendData(data)
//                    data.getBytes(&received, length: Int(data.length))
//                    let receivedCount = Int(data.length / sizeof(Float))
                }
                
//                let data = NSData(bytes: dataArray, length: (sizeof(Float) * dataArray.count))
                
                
//                let bytes = UnsafeBufferPointer<Void>(start: channels[0], count: Int(buffer.frameLength))
                
//                print(floats[0])
//                print(buffer.frameLength)
                
//                var received = [Float](count: dataArray.count, repeatedValue: 0)
//                data.getBytes(&received, length: Int(sizeof(Float) * received.count))
                
//                for var i = 0; i < Int(self.outputBuffer.frameLength); i += Int(self.engine.mainMixerNode.outputFormatForBus(bus).channelCount) {
////                    self.outputBuffer.floatChannelData.memory[i] = floats[i]
//                    self.outputBuffer.floatChannelData.memory[i] = received[i]
//                }
//                self.player.scheduleBuffer(self.outputBuffer, atTime: nil, options: .Interrupts, completionHandler: nil)
            })
        } else {
            print("can't find input node")
        }
        
        engine.prepare()
        try! engine.start()
        
//        player.play()
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

