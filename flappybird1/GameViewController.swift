//
//  GameViewController.swift
//  flappybird1
//
//  Created by Harley Trung on 3/12/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    let PIPE_WIDTH      = CGFloat(40)
    let PIPE_MAX_HEIGHT = CGFloat(320)
    
    var animator: UIDynamicAnimator!
    var gravity = UIGravityBehavior()
    var pipeBehavior: UIDynamicItemBehavior!
    
    var isPlaying = false
    var originalPositionY: CGFloat!
    var birdPush: UIPushBehavior!
    var pipePush: UIPushBehavior!
    var timer: NSTimer?
    
    @IBOutlet weak var velocityLabel: UILabel!
    
    @IBOutlet weak var birdView: UIImageView!
    @IBAction func onPlayTouched(sender: UIButton) {
        if isPlaying {
            isPlaying = false
            sender.setTitle("Play", forState: .Normal)
            animator.removeAllBehaviors()
            birdView.frame.origin.y = originalPositionY
        } else {
            isPlaying = true
            sender.setTitle("Stop", forState: .Normal)
            setupGame()
        }
        
    }
    @IBAction func onScreenTapped(sender: UITapGestureRecognizer) {
        // whenever tapped, push bird up
        birdPush.active = true
        animator.addBehavior(birdPush)
    }
    
    func setupGame() {
        gravity.addItem(birdView)
        animator.addBehavior(gravity)
        pipePush.active = true
        animator.addBehavior(pipePush)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "onTimer", userInfo: nil, repeats: true)
    }
    
    func onTimer() {
        drawPipes()
    }
    
    func drawPipes() {
        let SCREEN_HEIGHT = view.frame.height
        let SCREEN_WIDTH  = view.frame.width
        let PIPE_GAP:CGFloat = 100
        
        let bottomPipe = UIImageView(image: UIImage(named: "pipeBottom"))
        let topPipe = UIImageView(image: UIImage(named: "pipeTop"))
        
        // change this amount each time
        let bottomPipeHeight = randomPipeHeight()
        let topPipeHeight = SCREEN_HEIGHT - bottomPipeHeight - PIPE_GAP
        
        bottomPipe.frame = CGRect(x: SCREEN_WIDTH, y: SCREEN_HEIGHT - bottomPipeHeight, width: PIPE_WIDTH, height: PIPE_MAX_HEIGHT)
        topPipe.frame    = CGRect(x: SCREEN_WIDTH, y: topPipeHeight - PIPE_MAX_HEIGHT, width: PIPE_WIDTH, height: PIPE_MAX_HEIGHT)
        
        view.addSubview(bottomPipe)
        view.addSubview(topPipe)
        
        let dynamicProperties = UIDynamicItemBehavior(items: [bottomPipe, topPipe])
        dynamicProperties.allowsRotation = false
        dynamicProperties.resistance = 0
        dynamicProperties.density = 0
        animator.addBehavior(dynamicProperties)
        
        pipePush.addItem(bottomPipe)
        pipePush.addItem(topPipe)
    }
    
    func randomPipeHeight() -> CGFloat {
        return CGFloat(arc4random_uniform(220) + 100);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        originalPositionY = birdView.frame.origin.y
        
        birdPush = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        birdPush.pushDirection = CGVectorMake(0, -1.1)
        birdPush.active = false
        
        pipePush = UIPushBehavior(items: [], mode: .Continuous)
        pipePush.pushDirection = CGVectorMake(-1, 0)
        pipePush.active = false
        
        drawPipes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

