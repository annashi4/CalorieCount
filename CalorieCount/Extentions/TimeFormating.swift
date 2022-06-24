import Foundation


func culcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
     
    if minutes == 1 {
        return ("1 minutie ago")
    }else if minutes < 60 {
        return "\(minutes) minutes ago"
    } else if minutes >= 60 && hours < 24 {
        return ("\(hours) hours ago")
    }else {
        return ("\(days) days ago")
    }
}
