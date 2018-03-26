import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    /// sound volumes
    static let VOLUME: [Sound: Float] = [
        .CloudExplosion: 0.25,
        .Explosion: 0.25,
        .DropAGift: 1.0,
        .GiftWasTaken: 1.0,
        .RewardForIncreaseBlockContainerPositionY: 1.0,
        .ShotOfGunnerBlock: 0.5,
        .ShotOfUser: 0.5,
        .SpectralShot: 0.5,
    ]

    /// general sounds
    enum Sound: String {
        case CloudExplosion = "explosion-cloud"
        case Explosion = "explosion-destruction"
        case DropAGift = "gift-drop"
        case GiftWasTaken = "gift-take"
        case RewardForIncreaseBlockContainerPositionY = "reward-IncreaseBlockContainerPositionY"
        case ShotOfGunnerBlock = "laser-gunner"
        case ShotOfUser = "laser-user"
        case SpectralShot = "laser-spectral"

        /// returns all enums
        static func all() -> [Sound] {
            return [
                .CloudExplosion,
                .Explosion,
                .DropAGift,
                .GiftWasTaken,
                .RewardForIncreaseBlockContainerPositionY,
                .ShotOfGunnerBlock,
                .ShotOfUser,
                .SpectralShot
            ]
        }
    }

    /// music sounds
    enum Music: String {
        case GameModeScaredyCat = "music-difficulty-scaredyCat"
        case GameModeSimple = "music-difficulty-simple"
        case GameModeNormal = "music-difficulty-normal"
        case GameModeHard = "music-difficulty-hard"
        case GameModeExtrem = "music-difficulty-extrem"
        case Menu = "music-menu"

        /// returns all enums
        static func all() -> [Music] {
            return [
                .GameModeScaredyCat,
                .GameModeSimple,
                .GameModeNormal,
                .GameModeHard,
                .GameModeExtrem,
                .Menu
            ]
        }
    }

    /// shared instance of AudioPlayer
    class var shared: AudioPlayer {
        struct Static {
            static let instance: AudioPlayer = AudioPlayer()
        }
        return Static.instance
    }

    /// audio play for music
    private var musicPlayer: [Music: AVAudioPlayer] = [:]

    /// active sound players
    private var soundPlayerActive: [AVAudioPlayer] = []

    /// this is the current player
    private var currentMusic: Music?

    /// the last played music
    private var lastMusic: Music?

    /// setting instance
    private var setting: Setting! = Setting.sharedSetting()

    /// singletone
    override private init() {
        super.init()

        // setting listener
        self.setting.addListener(Setting.EventType.MusicEnabledHasChanged, {
            // start the music
            if (self.setting.musicEnabled == true && self.lastMusic != nil) {
                self.playMusic(self.lastMusic!)
            }

            // stop the music
            else if (self.setting.musicEnabled == false) {
                if (self.currentMusic != nil) {
                    self.lastMusic = self.currentMusic
                }
                self.stopMusic()
            }
        })
    }

    // destruct
    deinit {
        self.setting.removeListener(self)
    }

    /// creates a audio player for a file
    private func createPlayer(file: String) -> AVAudioPlayer? {
        let audioPlayer: AVAudioPlayer

        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(file, ofType: "mp3")!))
        }
        catch let error as NSError  {
            NSLog("Audioplayer for %@ can not be created. Error: %@", file, error.description)
            return nil
        }

        audioPlayer.prepareToPlay()
        audioPlayer.stop()

        return audioPlayer
    }

    /// create a music player
    private func createPlayer(music: Music) -> AVAudioPlayer? {
        guard let player = self.createPlayer(music.rawValue) else {
            return nil
        }

        player.volume = 0.0
        player.numberOfLoops = -1
        player.prepareToPlay()

        return player
    }

    /// create a sound player
    private func createPlayer(sound: Sound) -> AVAudioPlayer? {
        guard let player = self.createPlayer(sound.rawValue) else {
            return nil
        }

        player.volume = AudioPlayer.VOLUME[sound]!
        player.numberOfLoops = 0
        player.delegate = self
        player.prepareToPlay()

        return player
    }

    /// plays a sound
    func playSound(sound: Sound) {
        if (self.setting.soundEnabled == false) {
            return
        }

        // play
        guard let player = self.createPlayer(sound) else {
            return
        }

        player.play()

        // store the player so that the player is not dropped from memory
        self.soundPlayerActive.append(player)
    }

    /// play some music
    func playMusic(music: Music) {
        if (self.setting.musicEnabled == false) {
            self.lastMusic = music
            return
        }

        // do no play the music which is currently playing
        if (self.currentMusic != nil && self.currentMusic == music) {
            return
        }

        // stops the music
        self.stopMusic()

        // create?
        if (self.musicPlayer[music] == nil) {
            self.musicPlayer[music] = self.createPlayer(music)
        }

        guard let player = self.musicPlayer[music] else {
            return
        }

        self.currentMusic = music
        player.play()
        player.fade(toVolume: 0.25, overTime: 1.0, completion: {})
    }

    /// stops the current music
    func stopMusic() {
        guard let music = self.currentMusic else {
            return
        }

        guard let player = self.musicPlayer[music] else {
            return
        }

        self.currentMusic = nil
        player.fadeOut(overTime: 1.0, completion: player.stop)
    }

    /// player is finished
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        for var i = 0; i < self.soundPlayerActive.count; i++ {
            if (self.soundPlayerActive[i] === player) {
                self.soundPlayerActive.removeAtIndex(i)
                return
            }
        }
    }
}
