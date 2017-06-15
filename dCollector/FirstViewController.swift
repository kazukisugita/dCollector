//
//  FirstViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/02.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var animator : UIDynamicAnimator!
    var myLabel : UILabel!

    @IBAction func dissmiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteAllRealms(_ sender: Any) {
        
        let title : String = "Delete All Realms Objects"
        let message: String = "Are you Sure ??"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            
            RealmManager.deleteAll()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
            print("Cancel")
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func fromUserdefaultsfToRealm(_ sender: Any) {
        
//        Transaction.fromUserdefaultsfToRealm())
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /*
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.maxX, y: view.frame.minY))
        path.addLine(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        path.lineWidth = 1.0
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.blue.cgColor
        lineLayer.lineWidth = 1.0
        lineLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        view.layer.addSublayer(lineLayer)
        lineLayer.add(animation, forKey: nil)
        */
        
        // Labelを作成.
        myLabel = UILabel(frame: CGRect(x:0,y:0,width:200,height:50))
        myLabel.backgroundColor = UIColor.orange
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "Hello Swift!!"
        myLabel.textColor = UIColor.white
        myLabel.shadowColor = UIColor.gray
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        self.view.backgroundColor = UIColor.cyan
        self.view.addSubview(myLabel)
        
        // UIDynamiAnimatorの生成とインスタンスの保存.
        animator = UIDynamicAnimator(referenceView: self.view)

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            
            // タッチされた座標を取得.
            let location = touch.location(in: self.view)
            
            // animatorに登録されていたBahaviorを全て削除.
            animator.removeAllBehaviors()
            
            // UIViewをスナップさせるUISnapBehaviorを生成.
            print(location)
            let snap = UISnapBehavior(item: myLabel, snapTo: location)
            
            // スナップを適用させる.
            animator.addBehavior(snap)
        }
    }

    
}

