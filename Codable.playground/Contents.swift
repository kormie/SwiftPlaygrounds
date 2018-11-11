import UIKit
import PlaygroundSupport

//let viewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
//let view = UIView(frame: viewFrame)
//view.backgroundColor = .white
//PlaygroundPage.current.liveView = view

enum FlightRules: String, Decodable {
    case visual = "VFR"
    case instrument = "IFR"
}

struct Aircraft: Decodable {
    var identification: String
    var color: String
}

struct FlightPlan: Decodable {
    var aircraft: Aircraft
    var route: [String]
    var flightRules: FlightRules
    private var departureTimes: [String: Date]
    var proposedDepartureDate: Date? {
        return departureTimes["proposed"]
    }
    var actualDepartureDate: Date? {
        return departureTimes["actual"]
    }
    var remarks: String?
    private enum CodingKeys: String, CodingKey {
        case aircraft
        case flightRules = "flight_rules"
        case route
        case departureTimes = "departure_time"
        case remarks
    }
}

let json = """
{
    "aircraft": {
        "identification": "NA12345",
        "color": "Blue/White"
    },
    "route": ["KTTD", "KHIO"],
    "departure_time": {
        "proposed": "2018-04-27T14:15:00-0700",
        "actual": "2018-04-27T14:20:00-0700"
    },
    "flight_rules": "IFR",
    "remarks": null
}
""".data(using: .utf8)!

var decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

let plan = try! decoder.decode(FlightPlan.self, from: json)
print(plan.remarks ?? "No remarks")
print(plan.actualDepartureDate ?? "No Departure Time Set")
print(plan.route)
print(plan.aircraft.color)
