//
//  TimeInterval+.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 17.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func toString(allowedUnits: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        return formatter.string(from: self)
    }
}
