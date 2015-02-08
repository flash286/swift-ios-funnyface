//
//  FaceView.swift
//  Happiness
//
//  Created by Брызгалов Николай on 08.02.15.
//  Copyright (c) 2015 Брызгалов Николай. All rights reserved.
//

import UIKit

class FaceView: UIView {

    
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMounthWidthRatio: CGFloat = 1
        static let FaceRadiusToMounthHeightRatio: CGFloat = 3
        static let FaceRadiusToMounthOffsetRatio: CGFloat = 3
        
    }
    private enum Eye { case Left, Right }
    
    private func beziePathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        var path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
        
    }
    
    private func beziePathForSmile(fractionOfSmile: Double) -> UIBezierPath {
        let mounthWidth = faceRadius /  Scaling.FaceRadiusToMounthWidthRatio
        let mounthHeight = faceRadius / Scaling.FaceRadiusToMounthHeightRatio
        let mounthVerticalOffset = faceRadius / Scaling.FaceRadiusToMounthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfSmile, 1), -1)) * mounthHeight
        
        let start = CGPoint(x: faceCenter.x - mounthWidth / 2, y: faceCenter.y + mounthVerticalOffset)
        let end = CGPoint(x: start.x + mounthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mounthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mounthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    var faceCenter: CGPoint {
        get {
             return convertPoint(center, fromView: superview)
        }
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        beziePathForEye(.Right).stroke()
        beziePathForEye(.Left).stroke()
        
        let smiliness = 20.0
        
        beziePathForSmile(smiliness).stroke()
    }

}
 