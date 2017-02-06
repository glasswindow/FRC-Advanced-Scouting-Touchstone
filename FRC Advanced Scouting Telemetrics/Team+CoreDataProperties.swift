//
//  Team+CoreDataProperties.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 12/18/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//

import Foundation
import CoreData


extension Team: HasLocalEquivalent {
    var localEntityName: String {
        get {
            return "LocalTeam"
        }
    }
    typealias SelfObject = Team
    typealias LocalType = LocalTeam
    
    static func specificFR() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<Team>(entityName: "Team") as! NSFetchRequest<NSFetchRequestResult>;
    }
    
    static func genericFetchRequest() -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: "Team")
    }

    @NSManaged public var key: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var nickname: String?
    @NSManaged public var rookieYear: NSNumber?
    @NSManaged public var teamNumber: String?
    @NSManaged public var website: String?
    @NSManaged public var eventPerformances: NSSet?
    @NSManaged public var transientLocal: LocalTeam?

}

extension Team: HasStats {
    var stats: [StatName:()->StatValue] {
        get {
            return [
                StatName.LocalRank: {
                    let teamRanking = DataManager().localTeamRanking()
                    if let index = teamRanking.index(of: self) {
                        return StatValue.Integer(index)
                    } else {
                        return StatValue.NoValue
                    }
                },
                StatName.TeamNumber: {
                    if let intNumber = Int(self.teamNumber!) {
                        return StatValue.Integer(intNumber)
                    } else {
                        return StatValue.NoValue
                    }
                },
                StatName.RookieYear: {
                    if let intNumber = self.rookieYear?.intValue {
                        return StatValue.Integer(intNumber)
                    } else {
                        return StatValue.NoValue
                    }
                },
                StatName.RobotHeight: {
                    if let doubleValue = self.local.robotHeight?.doubleValue {
                        return StatValue.Double(doubleValue)
                    } else {
                        return StatValue.NoValue
                    }
                },
                StatName.RobotWeight: {
                    if let doubleVal = self.local.robotWeight?.doubleValue {
                        return StatValue.Double(doubleVal)
                    } else {
                        return StatValue.NoValue
                    }
                },
                StatName.ScoringStrategy: {
                    var doesGears: Bool
                    var doesFuel: Bool
                    
                    doesGears = (SimpleCapability(rawValue: self.local.gearsCapability ?? "") ?? .No) == .Yes
                    
                    let highGoalCapability = Capability(rawValue: self.local.highGoalCapability ?? "") ?? .No
                    let lowGoalCapability = Capability(rawValue: self.local.lowGoalCapability ?? "") ?? .No
                    if highGoalCapability == .Yes || highGoalCapability == .Somewhat || lowGoalCapability == .Yes || lowGoalCapability == .Somewhat {
                        doesFuel = true
                    } else {
                        doesFuel = false
                    }
                    
                    switch (doesGears, doesFuel) {
                    case (true, true):
                        return StatValue.String("Both")
                    case (false, true):
                        return StatValue.String("Fuel")
                    case (true, false):
                        return StatValue.String("Gears")
                    case (false, false):
                        return StatValue.NoValue
                    }
                },
                StatName.DriveTrain: {
                    StatValue.initWithOptional(value: self.local.driveTrain)
                },
                StatName.LowGoalCapability: {
                    StatValue.initWithOptional(value: self.local.lowGoalCapability)
                },
                StatName.HighGoalCapability: {
                    StatValue.initWithOptional(value: self.local.highGoalCapability)
                },
                StatName.ClimberCapability: {
                    StatValue.initWithOptional(value: self.local.climberCapability)
                }
            ]
        }
    }
    
    enum StatName: String, CustomStringConvertible, StatNameable {
        case LocalRank = "Local Rank"
        case TeamNumber = "Team Number"
        case RookieYear = "Rookie Year"
        case RobotHeight = "Robot Height"
        case RobotWeight = "Robot Weight"
        case ScoringStrategy = "Scoring Strategy"
        case DriveTrain = "Drive Train"
        case LowGoalCapability = "Low Goal Capability"
        case HighGoalCapability = "High Goal Capability"
        case ClimberCapability = "Climber Capability"
        
        
        var description: String {
            get {
                return self.rawValue
            }
        }
        
        static let allValues: [StatName] = [.LocalRank, .TeamNumber, .RookieYear, .RobotHeight, .RobotWeight, .ScoringStrategy, .DriveTrain, .LowGoalCapability, .HighGoalCapability, .ClimberCapability]
    }
}

// MARK: Generated accessors for eventPerformances
extension Team {

    @objc(addEventPerformancesObject:)
    @NSManaged public func addToEventPerformances(_ value: TeamEventPerformance)

    @objc(removeEventPerformancesObject:)
    @NSManaged public func removeFromEventPerformances(_ value: TeamEventPerformance)

    @objc(addEventPerformances:)
    @NSManaged public func addToEventPerformances(_ values: NSSet)

    @objc(removeEventPerformances:)
    @NSManaged public func removeFromEventPerformances(_ values: NSSet)

}
