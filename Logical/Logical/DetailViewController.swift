//
//  DetailViewController.swift
//  Logical
//
//  Created by Ethan Gill on 1/23/16.
//  Copyright © 2016 Ethan Gill. All rights reserved.
//

import UIKit

import GraphView
import Axiomatic

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var graphView: GraphView!
    var currentColor = UIColor.purpleColor()
    var colorPickerVC: SwiftColorPickerViewController!
    var oldColorRect: CGRect!
    @IBOutlet weak var canView: CanvasView!
    var canvasView: CanvasView {
        return canView as CanvasView
    }
    
    @IBOutlet weak var colorButton: UIBarButtonItem!
    let size = CGSize(width: 80, height: 80)
    var circleGestureRecognizer:CircleGestureRecognizer?
    var lineGestureRecognizer:LineGestureRecognizer?
    let pencilGestureRecognizer = PencilGestureRecognizer()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        //        if let detail = self.detailItem {
        //            if let label = self.detailDescriptionLabel {
        //                label.text = detail.description
        //            }
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let red: UIView = RoundedView()
        red.backgroundColor = .redColor()
        red.frame.size = size
        
        let blue: UIView = RoundedView()
        blue.backgroundColor = .blueColor()
        blue.frame.size = size
        
        let green: UIView = RoundedView()
        green.backgroundColor = .greenColor()
        green.frame.size = size
        
        let yellow: UIView = RoundedView()
        yellow.backgroundColor = .yellowColor()
        yellow.frame.size = size
        
        let purple: UIView = RoundedView()
        purple.backgroundColor = .purpleColor()
        purple.frame.size = size
        
        let brown: UIView = RoundedView()
        brown.backgroundColor = .brownColor()
        brown.frame.size = size
        
        let orange: UIView = RoundedView()
        
        orange.backgroundColor = .orangeColor()
        orange.frame.size = size
        
        let gray: UIView = RoundedView()
        gray.backgroundColor = .grayColor()
        gray.frame.size = size
        
        self.graphView = GraphView(graph: Graph(nodes: [red, blue ,green ,yellow ,purple ,brown ,orange ,gray], undirectedEdges: [(red,blue), (blue, green), (green, yellow), (purple, brown), (brown, red), (red, orange), (orange, gray), (yellow, gray)]))
        // self.graphView.graph.addNode("Hello")
        //self.view.backgroundColor = UIColor.darkTextColor()
        self.graphView.frame = self.view.frame
        self.graphView.panGestureRecognizer.delegate = self
        
        self.view.addSubview(self.graphView)
        self.graphView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
        self.graphView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        self.graphView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        self.graphView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        
        
        self.canvasView.backgroundColor = UIColor.clearColor()
        self.canvasView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
        self.canvasView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        self.canvasView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        self.canvasView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        self.canvasView.userInteractionEnabled = false
        self.view.addSubview(canvasView)
        canvasView.addSubview(reticleView)
        
        
        //the circle gesture recognizer
        self.circleGestureRecognizer = CircleGestureRecognizer(target: self, action: "circled:")
        self.circleGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(circleGestureRecognizer!)
        
        self.lineGestureRecognizer = LineGestureRecognizer(target: self, action: "line:")
        self.lineGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(lineGestureRecognizer!)
        
        self.pencilGestureRecognizer.delegate = self
        self.pencilGestureRecognizer.pencilDelegate = self
        self.view.addGestureRecognizer(pencilGestureRecognizer)

        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        let colorPicker = self.view.viewWithTag(12)!
        self.view.bringSubviewToFront(colorPicker)
        oldColorRect = colorPicker.frame
        colorPicker.alpha = 0;
        colorPicker.frame = CGRectMake(colorPicker.frame.origin.x, colorPicker.frame.origin.y - 400, colorPicker.frame.size.width, colorPicker.frame.size.height);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var visualizeAzimuth = false
    
    let reticleView: ReticleView = {
        let view = ReticleView(frame: CGRect.null)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidden = true
        
        return view
    }()
    
//    // MARK: Touch Handling
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if touches.first?.type == .Stylus{
//            self.canvasView.drawTouches(touches, withEvent: event)
//            
//            if visualizeAzimuth {
//                for touch in touches {
//                    if touch.type == .Stylus {
//                        reticleView.hidden = false
//                        updateReticleViewWithTouch(touch, event: event)
//                    }
//                }
//            }
//        } else {
//            super.touchesBegan(touches, withEvent: event)
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if touches.first?.type == .Stylus{
//        canvasView.drawTouches(touches, withEvent: event)
//        
//        if visualizeAzimuth {
//            for touch in touches {
//                if touch.type == .Stylus {
//                    updateReticleViewWithTouch(touch, event: event)
//                    
//                    // Use the last predicted touch to update the reticle.
//                    guard let predictedTouch = event?.predictedTouchesForTouch(touch)?.last else { return }
//                    
//                    updateReticleViewWithTouch(predictedTouch, event: event, isPredicted: true)
//                }
//            }
//            }
//        } else {
//            super.touchesMoved(touches, withEvent: event)
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if touches.first?.type == .Stylus{
//            canvasView.drawTouches(touches, withEvent: event)
//            canvasView.endTouches(touches, cancel: false)
//            
//            if visualizeAzimuth {
//                for touch in touches {
//                    if touch.type == .Stylus {
//                        reticleView.hidden = true
//                    }
//                }
//            }
//        }
//        super.touchesEnded(touches, withEvent: event)
//    }
//    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        guard let touches = touches else { return }
//        if touches.first?.type == .Stylus {
//            canvasView.endTouches(touches, cancel: true)
//            
//            if visualizeAzimuth {
//                for touch in touches {
//                    if touch.type == .Stylus {
//                        reticleView.hidden = true
//                    }
//                }
//            }
//        }
//        super.touchesCancelled(touches, withEvent: event)
//    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "colorPicker") {
            colorPickerVC = segue.destinationViewController as! SwiftColorPickerViewController
            colorPickerVC.delegate = self
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
        canvasView.updateEstimatedPropertiesForTouches(touches)
    }
    
    // MARK: Actions
    
    //    @IBAction func clearView(sender: UIBarButtonItem) {
    //        canvasView.clear()
    //    }
    //
    //    @IBAction func toggleDebugDrawing(sender: UIButton) {
    //        canvasView.isDebuggingEnabled = !canvasView.isDebuggingEnabled
    //        visualizeAzimuth = !visualizeAzimuth
    //        sender.selected = canvasView.isDebuggingEnabled
    //    }
    //
    //    @IBAction func toggleUsePreciseLocations(sender: UIButton) {
    //        canvasView.usePreciseLocations = !canvasView.usePreciseLocations
    //        sender.selected = canvasView.usePreciseLocations
    //    }
    
    // MARK: Rotation
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.LandscapeLeft, .LandscapeRight]
    }
    
    // MARK: Convenience
    
    func updateReticleViewWithTouch(touch: UITouch?, event: UIEvent?, isPredicted: Bool = false) {
        guard let touch = touch where touch.type == .Stylus else { return }
        
        reticleView.predictedDotLayer.hidden = !isPredicted
        reticleView.predictedLineLayer.hidden = !isPredicted
        
        let azimuthAngle = touch.azimuthAngleInView(view)
        let azimuthUnitVector = touch.azimuthUnitVectorInView(view)
        let altitudeAngle = touch.altitudeAngle
        
        if isPredicted {
            reticleView.predictedAzimuthAngle = azimuthAngle
            reticleView.predictedAzimuthUnitVector = azimuthUnitVector
            reticleView.predictedAltitudeAngle = altitudeAngle
        }
        else {
            let location = touch.preciseLocationInView(view)
            reticleView.center = location
            reticleView.actualAzimuthAngle = azimuthAngle
            reticleView.actualAzimuthUnitVector = azimuthUnitVector
            reticleView.actualAltitudeAngle = altitudeAngle
        }
    }
    
    func circled(c: CircleGestureRecognizer) {
        if c.state == .Ended {
            //findCircledView(c.fitResult.center)
            if c.isCircle == true {
            }
        }
        if c.state == .Began {
            //circlerDrawer.clear()
            //goToNextTimer?.invalidate()
        }
        if c.state == .Changed {
            //circlerDrawer.updatePath(c.path)
        }
        if c.state == .Ended || c.state == .Failed || c.state == .Cancelled {
            if c.isCircle {
                self.createNewNode(c.fitResult)
            }
            if c.isCircle == false{
            self.canvasView.clear()
            }
        }
    }
    
    func line(l: LineGestureRecognizer) {
        
        var firstNode:UIView?
        var lastNode:UIView?
        let localFirst = l.touchedPoints.first!
        let localLast = l.touchedPoints.last!
        if l.state == .Ended {

            //try to find nodes under the start and end points on the line
            for node in self.graphView.graph.nodes {

                //let firstPoint = self.graphView.convertPoint(localFirst, fiew: nil)
                print(localFirst)
               // let isPointInsideView = CGRectContainsPoint(node.frame, localFirst)
                //print(self.graphView.hitTest(localFirst, withEvent: nil))
                
                
                if self.graphView.hitTest(self.graphView.convertPoint(localFirst, fromView: self.view), withEvent: nil) == node {
                    firstNode = node
                    break
                }
            }
            if firstNode != nil {
                for node in self.graphView.graph.nodes {

                    if self.graphView.hitTest(self.graphView.convertPoint(localLast, fromView: self.view), withEvent: nil) == node {
                        lastNode = node
                        break
                    }
                }
            }
            if (lastNode != nil) && (firstNode != nil) && (lastNode != firstNode) {
                //create an edge
                self.graphView.graph.addDirectedEdge(from: firstNode!, to: lastNode!)
            }
        }
    }
    
    @IBAction func showColorPopover(sender: AnyObject) {
        if (self.view.viewWithTag(12)!.alpha == 0) {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
                self.view.viewWithTag(12)!.alpha = 1;
                self.view.viewWithTag(12)!.frame = self.oldColorRect;
                }) { (Bool) -> Void in
                    print("complete")
            }
        } else {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
                self.view.viewWithTag(12)!.alpha = 0;
                self.view.viewWithTag(12)!.frame = CGRectMake(self.view.viewWithTag(12)!.frame.origin.x, self.view.viewWithTag(12)!.frame.origin.y - 400, self.view.viewWithTag(12)!.frame.size.width, self.view.viewWithTag(12)!.frame.size.height);

                }) { (Bool) -> Void in
                    print("complete")
            }
        }
    }
    
    @IBAction func addBasicNode(sender: AnyObject) {
        let newView = RoundedView()
        let coord = CGPointMake(self.view.center.x, -80)
        //no size yet
        newView.frame.size = CGSize(width: 80, height: 80)
        newView.alpha = 1.0
        newView.frame.origin.x = coord.x
        newView.frame.origin.y = coord.y
        newView.backgroundColor = currentColor
        
        self.graphView.graph.addNode(newView)
    }
    
    
    func createNewNode(fit:CircleResult){
        let newView = RoundedView()
        let coord = self.canvasView.convertPoint(CGPointMake((fit.center.x - fit.radius), (fit.center.y - fit.radius)), fromView: newView)
        //no size yet
        newView.frame.size = CGSize(width: 80, height: 80)
        newView.alpha = 1.0
        newView.frame.origin.x = coord.x
        newView.frame.origin.y = coord.y
        newView.backgroundColor = currentColor
        self.graphView.graph.addNode(newView)
        
        self.canvasView.clear()
//        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.05, initialSpringVelocity: 0.1, options: [], animations: {
//            newView.frame.size = CGSize(width: 80, height: 80)
//            newView.alpha = 1.0
//            }, completion: {
//                success in
//                print("YAY")
//        })
//        let duration:NSTimeInterval = 0.5;// match this to the value of the UIView animateWithDuration: call
//        CATransaction.begin()
//        CATransaction.setValue(NSNumber(float: Float(duration)), forKey: kCATransactionAnimationDuration)
//        newView.layer.mask?.bounds = CGRectMake(0, 0, 80, 80)
//        CATransaction.commit()
        
    }
    
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer == self.circleGestureRecognizer {
            return touch.type == .Stylus
        } else if gestureRecognizer == self.lineGestureRecognizer {
            return touch.type == .Stylus
        } else if gestureRecognizer == self.pencilGestureRecognizer {
            return touch.type == .Stylus
        } else {
            //everything else
            return touch.type != .Stylus
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //TODO: this should depend on if it's a pencil GR or not
        //ie pencil GR should with other pencil GR, but not with non-pencil GR
        return true
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.lineGestureRecognizer && otherGestureRecognizer == self.circleGestureRecognizer {
            return true
        }
        return false
    }
}

//extension DetailViewController: CircleGestureRecognizerDelegate {
//    func circleDetected(fit:CircleResult) {
//        
//        self.canvasView.clear()
//    }
//    
//    func lineDetected() {
//        self.canvasView.clear()
//    }
//}
extension DetailViewController : SwiftColorPickerDelegate {
    func colorSelectionChanged(selectedColor color: UIColor) {
        currentColor = color;
        colorButton.tintColor = currentColor
    }
}

extension DetailViewController: PencilGestureRecognizerDelegate {
    func drawTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.canvasView.drawTouches(touches, withEvent: event)
    }
    func endTouches(touches: Set<UITouch>, cancel: Bool) {
        self.canvasView.endTouches(touches, cancel: cancel)
    }
    func updateEstimatedPropertiesForTouches(touches: Set<NSObject>) {
        self.canvasView.updateEstimatedPropertiesForTouches(touches)
    }
}

