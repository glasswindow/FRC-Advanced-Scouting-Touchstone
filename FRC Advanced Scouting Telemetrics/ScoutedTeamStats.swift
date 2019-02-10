//
//  ScoutedTeamStats.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 1/11/19.
//  Copyright © 2019 Kampfire Technologies. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

struct ScoutedTeamAttributes: Codable {
    let robotWeight: Double?
    let robotLength: Double?
    let canBanana: Bool?
}

typealias ScoutedTeamStat = Statistic<ScoutedTeam>
extension ScoutedTeam: Equatable {
    
    //TODO: - Cache this object
    var decodedAttributes: ScoutedTeamAttributes? {
        get {
            do {
                if let data = self.attributes?.data(using: .utf8) {
                    return try JSONDecoder().decode(ScoutedTeamAttributes.self, from: data)
                } else {
                    return nil
                }
            } catch {
                //Record error
                CLSNSLogv("Error decoding scouted team attribute json data: \(error)", getVaList([]))
                Crashlytics.sharedInstance().recordError(error)
                return nil
            }
        }
    }
    
    var attributeDictionary: [String: Any]? {
        get {
            do {
                if let data = self.attributes?.data(using: .utf8) {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                } else {
                    return nil
                }
            } catch {
                //Record error
                CLSNSLogv("Error decoding scouted team attribute json data into dictionary: \(error)", getVaList([]))
                Crashlytics.sharedInstance().recordError(error)
                return nil
            }
        }
    }
    
    ///Called in Statistics.swift when getting all of the stats for SocutedTeams
    static var stats: [Statistic<ScoutedTeam>] {
        get {
            return [
                Statistic<ScoutedTeam>(name: "Robot Length", id: "length", function: { (scoutedTeam, callback) in
                    callback(StatValue.initWithOptional(value: scoutedTeam.decodedAttributes?.robotLength))
                }),
                Statistic<ScoutedTeam>(name: "Robot Weight", id: "weight", function: { (scoutedTeam, callback) in
                    callback(StatValue.initWithOptional(value: scoutedTeam.decodedAttributes?.robotWeight))
                })
            ]
        }
    }
    
    var frontImage: UIImage? {
        get {
            return nil
        }
    }
}

public func ==(lhs: ScoutedTeam, rhs: ScoutedTeam) -> Bool {
    return lhs.eventKey == rhs.eventKey && lhs.teamKey == rhs.teamKey
}
