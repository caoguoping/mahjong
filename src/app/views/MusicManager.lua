local CURRENT_MODULE_NAME = ...

local s_inst = nil
local MusicManager = class("MusicManager")

function MusicManager:getInstance()
    if nil == s_inst then
        s_inst = MusicManager.new()
        s_inst:init()
    end
    return s_inst
end

function MusicManager:init()

    self.isMusicOn = true
    self.isEffectOn = true

end

function MusicManager:playMusic(fileName , loop)
    if self.isMusicOn then
        cc.SimpleAudioEngine:getInstance():playMusic(fileName, loop)
    end
end

function MusicManager:playEffect(fileName, loop)

    if self.isEffectOn then
         cc.SimpleAudioEngine:getInstance():playEffect(fileName, loop)
    end

end

function MusicManager:stopMusic( )
    if self.isMusicOn then
         cc.SimpleAudioEngine:getInstance():stopMusic(true)
    end
end

function MusicManager:halfMusicVolume()
    local engine = cc.SimpleAudioEngine:getInstance()
    local volume = engine:getMusicVolume()
    engine:setMusicVolume(volume * 0.5)
end

function MusicManager:doubleMusicVolume()
    local engine = cc.SimpleAudioEngine:getInstance()
    local volume = engine:getMusicVolume()
    engine:setMusicVolume(volume * 2)
end

return MusicManager
