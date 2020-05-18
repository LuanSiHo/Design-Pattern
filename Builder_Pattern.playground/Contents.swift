import UIKit

// Product
public struct MilkTea {
    public let type: MilkTeaType
    public let size: Size
    public let toppings: Topping
}

extension MilkTea: CustomStringConvertible {
    public var description: String {
        return "type: \(type) - size: \(size) - toppings: \(toppings.description)"
    }
}

public enum MilkTeaType: String {
    case Classic
    case Matcha
    case Pearl
}

public enum Size: String {
    case Small
    case Medium
    case Large
}

public struct Topping: OptionSet {
    public static let LycheeJelly = Topping(rawValue: 1 << 0)
    public static let StrawberryJelly = Topping(rawValue: 1 << 1)
    public static let AloeJelly = Topping(rawValue: 1 << 2)
    public static let coconutJelly = Topping(rawValue: 1 << 3)
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension Topping: CustomStringConvertible {
    static var debugDescription: [(Self, String)] = [
        (.LycheeJelly, "Lychee Jelly"),
        (.StrawberryJelly, "Strawberry Jelly"),
        (.AloeJelly, "Aloe Jelly"),
        (.coconutJelly, "coconut Jelly")
    ]
    
    public var description: String {
        let result: [String] = Self.debugDescription.filter { contains($0.0)}.map {$0.1}
        return "\(result)"
    }
}

// Builder
public class MilkTeaBuilder {
    public private(set) var type: MilkTeaType = .Classic
    public private(set) var size: Size = .Medium
    public private(set) var toppings: Topping = []
    
    private var soldOutTypes: [MilkTeaType] = []
    
    // check available milk tea type
    private func isTypeAvailable(value: MilkTeaType) -> Bool {
        if soldOutTypes.contains(value) {
            return false
        }
        return true
    }
    
    public func setType(value: MilkTeaType) throws {
        guard isTypeAvailable(value: value) else {
            throw Error.SoldOutType
        }
        self.type = value
    }
    
    public func setSize(value: Size) {
        self.size = value
    }
    
    public func addToppings(value: Topping) {
        self.toppings.insert(value)
    }
    
    public func removeTopping(value: Topping) {
        self.toppings.remove(value)
    }
    
    func build() -> MilkTea {
        return MilkTea(type: type, size: size, toppings: toppings)
    }
}

// Director
public class Bartender {
    func createClassicMilkTea() throws -> MilkTea {
        let builder = MilkTeaBuilder()
        try builder.setType(value: .Classic)
        builder.setSize(value: .Medium)
        builder.addToppings(value: [.AloeJelly, .LycheeJelly])
        return builder.build()
    }
    
    func createMatchaMilkTea() throws -> MilkTea {
        let builder = MilkTeaBuilder()
        try builder.setType(value: .Matcha)
        builder.setSize(value: .Medium)
        builder.addToppings(value: [.coconutJelly])
        return builder.build()
    }
}

public enum Error: Swift.Error {
    case SoldOutType
    case SoldOutTopping
}

// MARK: - Example
let Christopher = Bartender()

do {
    let classicMilkTea = try Christopher.createClassicMilkTea()
    print(classicMilkTea.description)
} catch Error.SoldOutType {
    print("Not enough milktea type")
} catch let error {
    print("An Error occurs: \(error)")
}
