
enum WeatherConditions: String, CaseIterable {
    case blowingDust = "Blowing Dust"
    case clear = "Clear"
    case cloudy = "Cloudy"
    case foggy = "Foggy"
    case haze = "Haze"
    case mostlyClear = "Mostly Clear"
    case mostlyCloudy = "Mostly Cloudy"
    case partlyCloudy = "Partly Cloudy"
    case smoky = "Smoky"
    case breezy = "Breezy"
    case windy = "Windy"
    case drizzle = "Drizzle"
    case heavyRain = "Heavy Rain"
    case isolatedThunderstorms = "Isolated Thunderstorms"
    case rain = "Rain"
    case sunShowers = "Sun Showers"
    case scatteredThunderstorms = "Scattered Thunderstorms"
    case thunderstorms = "Thunderstorms"
    case strongStorms = "Strong Storms"
    case frigid = "Frigid"
    case hail = "Hail"
    case hot = "Hot"
    case flurries = "Flurries"
    case sleet = "Sleet"
    case snow = "Snow"
    case sunFlurries = "Sun Flurries"
    case wintryMix = "Wintry Mix"
    case blizzard = "Blizzard"
    case blowingSnow = "Blowing Snow"
    case freezingDrizzle = "Freezing Drizzle"
    case freezingRain = "Freezing Rain"
    case heavySnow = "Heavy Snow"
    case hurricane = "Hurricane"
    case tropicalStorm = "Tropical Storm"
    case unkwown = "Unknown"
    
    var descriptions: String {
        switch self {
        case .blowingDust: return "황사"
        case .clear: return "맑음"
        case .cloudy: return "흐림"
        case .foggy: return "안개"
        case .haze: return "실안개"
        case .mostlyClear: return "대체로 맑음"
        case .mostlyCloudy: return "대체로 흐림"
        case .partlyCloudy: return "부분적으로 흐림"
        case .smoky: return "연기 낌"
        case .breezy: return "산들바람"
        case .windy: return "바람 많음"
        case .drizzle: return "이슬비"
        case .heavyRain: return "폭우"
        case .isolatedThunderstorms: return "국지적 천둥번개"
        case .rain: return "비"
        case .sunShowers: return "해가 있는 소나기"
        case .scatteredThunderstorms: return "산발적 천둥번개"
        case .thunderstorms: return "천둥번개"
        case .strongStorms: return "강한 폭풍"
        case .frigid: return "매우 추움"
        case .hail: return "우박"
        case .hot: return "더움"
        case .flurries: return "눈 날림"
        case .sleet: return "진눈깨비"
        case .snow: return "눈"
        case .sunFlurries: return "햇빛 속 눈발"
        case .wintryMix: return "눈비 섞임"
        case .blizzard: return "눈보라"
        case .blowingSnow: return "강풍 눈보라"
        case .freezingDrizzle: return "얼어붙는 이슬비"
        case .freezingRain: return "어는 비"
        case .heavySnow: return "폭설"
        case .hurricane: return "허리케인"
        case .tropicalStorm: return "열대성 폭풍"
        case .unkwown: return "알 수 없음"
        }
    }
    
    var iconName: String {
        switch self {
        case .clear: return "sun.max"
        case .cloudy: return "cloud"
        case .foggy: return "cloud.fog"
        case .rain, .drizzle, .freezingDrizzle: return "cloud.rain"
        case .heavyRain: return "cloud.heavyrain"
        case .snow, .heavySnow, .flurries, .blowingSnow, .blizzard: return "snow"
        case .thunderstorms, .isolatedThunderstorms, .scatteredThunderstorms: return "cloud.bolt.rain"
        case .sleet, .wintryMix, .freezingRain: return "cloud.sleet"
        case .hail: return "cloud.hail"
        case .sunShowers, .sunFlurries: return "cloud.sun.rain"
        case .partlyCloudy, .mostlyCloudy, .mostlyClear: return "cloud.sun"
        case .hot: return "thermometer.sun"
        case .frigid: return "thermometer.snowflake"
        case .windy, .breezy: return "wind"
        case .smoky, .haze, .blowingDust: return "smoke"
        case .hurricane: return "tornado"
        case .tropicalStorm, .strongStorms: return "cloud.bolt"
        case .unkwown: return "questionmark"
        }
    }
    
    static func getConditionAndIcon(codition: String) -> (conditionString: String, iconName: String) {
        if let condition = WeatherConditions.allCases.first(where: { $0.rawValue == codition }) {
            return (condition.descriptions, condition.iconName)
        }
        else {
            return ("알 수 없음.", "questionmark.app")
        }
    }
    
}

enum UVIndexCategory: String, CaseIterable {
    case low
    case moderate
    case high
    case veryHigh
    case extreme
    
    var categoryString: String {
        switch self {
        case .low:
            return "낮음"
        case .moderate:
            return "보통"
        case .high:
            return "높음"
        case .veryHigh:
            return "매우 높음"
        case .extreme:
            return "위험"
        }
    }
    
    static func getCategory(uvCategory: String) -> String {
        if let gategory = UVIndexCategory(rawValue: uvCategory) {
            return gategory.categoryString
        }
        return ""
    }
}
