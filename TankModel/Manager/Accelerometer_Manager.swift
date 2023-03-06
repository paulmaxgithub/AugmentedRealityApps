//
//  Accelerometer_Manager.swift
//  TankModel
//
//  Created by PaulmaX on 4.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import CoreMotion
import CoreGraphics
import Combine

final class Accelerometer_Manager {
    
    static let run = Accelerometer_Manager()
    
    private let motionManager = CMMotionManager()
    
    public var orientation = CurrentValueSubject<CGFloat, Never>(0)
    
    init() {
        setupAccelerometer()
    }
    
    private func setupAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1/60
            motionManager.startAccelerometerUpdates(to: .main) { [unowned self] data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    guard let data = data else { return }
                    accelerometerDidChange(with: data.acceleration)
                }
            }
        } else {
            print("Accelerometer is not available!")
        }
    }
    
    private func accelerometerDidChange(with acceleration: CMAcceleration) {
        var accelerationValue_X = 0.0, accelerationValue_Y = 0.0
        
        accelerationValue_X = filtered(currentAcceleration: accelerationValue_X,
                                         updatedAcceleration: acceleration.x)
        
        accelerationValue_Y = filtered(currentAcceleration: accelerationValue_Y,
                                         updatedAcceleration: acceleration.y)
        
        if accelerationValue_X > 0 {
            orientation.send(-accelerationValue_Y)
        } else {
            orientation.send(accelerationValue_Y)
        }
    }
    
    private func filtered(currentAcceleration: Double, updatedAcceleration: Double) -> Double {
        let K_Filtering = 0.5
        return (updatedAcceleration * K_Filtering) + (currentAcceleration * (1 - K_Filtering))
    }
}
