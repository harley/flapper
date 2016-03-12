//
//  GameViewController.swift
//  flappybird1
//
//  Created by Harley Trung on 3/12/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var animator: UIDynamicAnimator!
    
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var birdPush: UIPushBehavior!
    var pipePush: UIPushBehavior!
    var noRotates: UIDynamicItemBehavior!
    
    var isPlaying = false
    var timer: NSTimer?
    
    var originalOrigin: CGPoint!
    
    // PIPE
    let PIPE_WIDTH      = CGFloat(40)
    let PIPE_MAX_HEIGHT = CGFloat(320)
    
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var birdView: UIImageView!
    
    @IBAction func onPlayTouched(sender: UIButton) {
        if isPlaying {
            isPlaying = false
            sender.setTitle("Play", forState: .Normal)
            
            // reset bird's position
            birdView.frame.origin = originalOrigin
            
            animator.removeAllBehaviors()
            timer!.invalidate()
        } else {
            isPlaying = true
            sender.setTitle("Stop", forState: .Normal)
            // add all behaviors
            setupGame()
        }
    }
    
    @IBAction func onScreenTapped(sender: UITapGestureRecognizer) {
        // whenever tapped, push bird up
        birdPush.active = true
    }
    
    func setupGame() {
        animator.addBehavior(collision)
        animator.addBehavior(gravity)
        animator.addBehavior(birdPush)
        animator.addBehavior(pipePush)
        animator.addBehavior(noRotates)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
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
        animator.addBehavior(dynamicProperties)
        
        addPipeBehaviors(topPipe)
        addPipeBehaviors(bottomPipe)
    }
    
    func addPipeBehaviors(pipe: UIView) {
        pipePush.addItem(pipe)
        collision.addItem(pipe)
        noRotates.addItem(pipe)
    }
    
    
    func randomPipeHeight() -> CGFloat {
        return CGFloat(arc4random_uniform(160) + 160);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        collision.addItem(birdView)
        gravity.addItem(birdView)
        
        originalOrigin = birdView.frame.origin
        
        birdPush = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        birdPush.pushDirection = CGVectorMake(0, -1.1)
        birdPush.active = false
        
        pipePush = UIPushBehavior(items: [], mode: .Continuous)
        pipePush.pushDirection = CGVectorMake(-0.8, 0)
        
        noRotates = UIDynamicItemBehavior(items: [birdView])
        noRotates.allowsRotation = false
        
        drawPipes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}