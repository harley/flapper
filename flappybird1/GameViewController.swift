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
    var isPlaying = false
    var originalPositionY: CGFloat!
    
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
        let push = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        push.pushDirection = CGVectorMake(0, -1.1)
        push.active = true
        animator.addBehavior(push)
    }
    
    func setupGame() {
        gravity.addItem(birdView)
        animator.addBehavior(gravity)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        originalPositionY = birdView.frame.origin.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

