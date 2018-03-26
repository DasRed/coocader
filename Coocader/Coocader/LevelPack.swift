import Foundation

class LevelPack {
    /// gobal language as fallback
    static let LANGUAGE_GLOBAL = "en"

    /// absolute fallbacl
    static let LANGUAGE_FALLBACK = "de"

    /// the id of this level pack
    private(set) var id: String!

    /// creation date
    private(set) var dateCreation: NSDate!

    /// localized name
    private(set) var name: String!

    /// localized description
    private(set) var description: String!

    /// store identifier to test, if LP was buyed or not
    private(set) var storeIdentifier: String?

    /// achievement identifier to test, if LP was buyed or not
    private(set) var achievementIdentifier: String?

    /// contains all required other levelpacks wich must be completed
    private(set) var require: [String] = []

    /// raw level data
    private var levelData: [[String: AnyObject]] = []

    /// contains all levels in this level pack
    lazy private(set) var levels: [String: Level] = {
        var levels: [String: Level] = [:]
        for level in self.levelsSorted {
            levels[level.id] = level
        }

        return levels
    }()

    /// contains all levels sorted
    lazy private var levelsSorted: [Level] = {
        var levelsSorted: [Level] = []
        /// create the levels
        var levelPreviousId: String? = nil

        for (index, levelJson) in self.levelData.enumerate() {
            guard let level = Level(levelPack: self, index: index, json: levelJson, levelPreviousId: levelPreviousId) else {
                NSLog("LevelPack: Json does not contain valid level for index %i", index)
                continue
            }

            levelPreviousId = level.id
            //self.levels[level.id] = level
            levelsSorted.append(level)
        }

        return levelsSorted
    }()

    /// delta for x for matrix position
    private(set) var xDelta: Double! = 0

    /// delta for y for matrix position
    private(set) var yDelta: Double! = 0

    /// is this levelpack completed
    var completed: Bool {
        get {
            for level in self.levelsSorted {
                if (level.completed == false) {
                    return false
                }
            }

            return true
        }
    }

    /// test if levelpack is playable
    var playable: Bool {
        get {
            // level must be buyed
            if (self.storeIdentifier != nil && DBLevelPack.shared.wasLevelPackBuyed(self.id) == false) {
                return false
            }

            // requirements must be solved
            if (self.require.count != 0) {
                for id in self.require {
                    guard let levelPack = self.levelPackHandler.levelPacks[id] else {
                        continue
                    }

                    if (levelPack.completed == false) {
                        return false
                    }
                }
            }

            // success
            return true
        }
    }

    /// count of levels completed
    var countCompleted: Int {
        get {
            var countCompleted: Int = 0
            for level in self.levels.values {
                if (level.completed == true) {
                    countCompleted++
                }
            }

            return countCompleted
        }
    }

    /// returns the progress from 0 to 100
    var progress: Double {
        get {
            return Double(self.countCompleted) * 100.0 / Double(self.levels.count)
        }
    }

    /// the levelpack handler which contains this level
    private(set) var levelPackHandler: LevelPackHandler!

    /// returns the current avg difficulty
    var difficulty: Float {
        get {
            var sum: Float = 0
            for level in self.levels.values {
                sum += Float(level.difficulty.asInt()) + 1.0
            }

            let avg = sum / Float(self.levels.count)
            let avgInt = floor(avg)
            let decimal = avg - avgInt

            if (0 <= decimal && decimal < 0.33) {
                return avgInt
            }
            else if (0.33 <= decimal && decimal < 0.66) {
                return avgInt + 0.5
            }

            return avgInt + 1.0
        }
    }

    /// constructor
    init?(levelPackHandler: LevelPackHandler, json: [String: AnyObject]) {
        self.levelPackHandler = levelPackHandler

        #if !DEBUG
            if (json["debug"] != nil && (json["debug"] as! Bool) == true) {
                return nil
            }
        #endif

        // test correct version
        guard (json["version"] as? Float) == 1.0 else {
            NSLog("LevelPack: Missing version or has not the value 1.0 in json data")
            return nil
        }

        // test id
        guard (json["id"] as? String) != nil else {
            NSLog("LevelPack: Json does not contain valid ID")
            return nil
        }
        self.id = json["id"] as! String

        // date of creation
        guard json["dateCreation"] != nil else {
            NSLog("LevelPack: Json does not contain valid DateCreation")
            return nil
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let dateCreation = formatter.dateFromString(json["dateCreation"] as! String) else {
            NSLog("LevelPack: Json does not contain valid DateCreation")
            return nil
        }
        self.dateCreation = dateCreation

        // test name
        guard let name = self.selectTextFromLanguageMapFromJson(json, key: "name") else {
            NSLog("LevelPack: Json does not contain valid Name")
            return nil
        }
        self.name = name

        // test description
        guard let description = self.selectTextFromLanguageMapFromJson(json, key: "description") else {
            NSLog("LevelPack: Json does not contain valid Description")
            return nil
        }
        self.description = description

        // test storeIdentifier
        if (json["storeIdentifier"] != nil) {
            self.storeIdentifier = json["storeIdentifier"] as? String
        }

        // test achievementIdentifier
        if (json["achievementIdentifier"] != nil) {
            self.achievementIdentifier = json["achievementIdentifier"] as? String
        }

        // test xDelta
        if (json["xDelta"] != nil) {
            self.xDelta = json["xDelta"] as? Double
        }

        // test yDelta
        if (json["yDelta"] != nil) {
            self.yDelta = json["yDelta"] as? Double
        }

        // test require
        if (json["require"] != nil) {
            // test name
            if ((json["require"] as? [String]) != nil) {
                self.require = json["require"] as! [String]
            }
            // as string
            else if ((json["require"] as? String) != nil) {
                self.require = [json["require"] as! String]
            }
        }

        /// test matrix
        guard (json["levels"] as? [[String: AnyObject]]) != nil else {
            NSLog("LevelPack: Json does not contain valid levels")
            return nil
        }

        self.levelData = json["levels"] as! [[String: AnyObject]]
        /*
        /// create the levels
        var levelPreviousId: String? = nil

        for (index, levelJson) in (json["levels"] as! [[String: AnyObject]]).enumerate() {
            guard let level = Level(levelPack: self, index: index, json: levelJson, levelPreviousId: levelPreviousId) else {
                NSLog("LevelPack: Json does not contain valid level for index %i", index)
                return nil
            }

            levelPreviousId = level.id
            self.levels[level.id] = level
            self.levelsSorted.append(level)
        }
*/
    }

    /// create from a .clpf file
    convenience init?(levelPackHandler: LevelPackHandler, file: String) {
        // test load data
        guard let data = NSData(contentsOfFile: file) else {
            NSLog("Matrix: Can not read data for level file %@.", file)
            return nil
        }

        // test convert
        var json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)

        }
        catch let error as NSError {
            NSLog("Matrix: Can not parse json data for level file %@. Error: %@", file, error.description)
            return nil
        }

        // convert
        guard let jsonConverted = (json as? [String: AnyObject]) else {
            NSLog("Matrix: Can not convert json data for level file %@.", file)

            return nil
        }
        
        self.init(levelPackHandler: levelPackHandler, json: jsonConverted)
    }

    /// returns the localized name form a array for [LANGUAGE: TEXT, ... ]
    internal func selectTextFromLanguageMapFromJson(json: [String: AnyObject], key: String) -> String? {
        // test name
        guard (json[key] as? [String: String]) != nil else {
            return nil
        }
        let texts = json[key] as! [String: String]

        // find name by current lang
        let language = String(NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! NSString)
        if (texts[language] != nil) {
            return texts[language]
        }
        else if (texts[LevelPack.LANGUAGE_GLOBAL] != nil) {
            return texts[LevelPack.LANGUAGE_GLOBAL]
        }
        else if (texts[LevelPack.LANGUAGE_FALLBACK] != nil) {
            return texts[LevelPack.LANGUAGE_FALLBACK]
        }
        else if (texts.count > 0) {
            return texts.first!.1
        }
        return nil
    }

    /// sorted levels
    func sorted() -> [Level] {
        return self.levelsSorted
    }

    /// mark this one as buyed
    func markAsBuyed() {
        DBLevelPack.shared.markLevelPackAsBuyed(self)
    }

    /// reports for achievement if exists
    func reportForAchievement() {
        guard let identifier = self.achievementIdentifier else {
            return
        }

        EGC.reportAchievement(progress: self.progress, achievementIdentifier: NSBundle.mainBundle().bundleIdentifier! + "." + identifier)
    }
}