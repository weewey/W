//
//  AppConfig.swift
//  W
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Foundation

public class AppConfig {
    
    private let configDictionary: [String: Any]
    
    public init() {
        self.configDictionary = Bundle.main.infoDictionary!["AppConfig"] as! [String: Any]
    }
    
    public var trainingSessionHost: URL { return URL(string: getKey("TrainingSessionHost"))! }
    
    private func getKey<T>(_ key: String) -> T {
        return configDictionary[key] as! T
    }
}
