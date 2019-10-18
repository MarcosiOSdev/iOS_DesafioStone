import UIKit

var str = "2016-05-01 10:51:41.584544"

var df = DateFormatter()
df.dateFormat = "yyyy-MM-dd"
df.locale = Locale(identifier: "en_US_POSIX")
if let date = df.date(from: str) {
    print(date)
}
print("fim")
