' ********************************************************************************************************
' ********************************************************************************************************
' **  Roku Donkey Kong Channel - http://github.com/lvcabral/Donkey-Kong-Roku
' **
' **  Created: November 2016
' **  Updated: January 2017
' **
' **  Remake in BrigthScript developed by Marcelo Lv Cabral - http://lvcabral.com
' ********************************************************************************************************
' ********************************************************************************************************

Function CreateKong()
    this = {}
    'Constants
    this.const = m.const
    'Properties
    this.charType = "kong"
    this.board = m.board
    this.anims = m.anims
    this.belts = m.belts
    this.blockX = m.board.kong.blockX
    this.blockY = m.board.kong.blockY
    this.offsetX = 0
    this.offsetY = m.board.map[this.blockY][Int(this.blockX / 2)].o - 1
    if m.board.name = "barrels"
        this.charAction = "rollWildBarrel"
        this.barrels = -1
    else
        this.charAction = "shakeArms"
    end if
    this.frameName = "kong-1"
    this.frame = 0
    this.frameOffset = {x: 0, y: 0}
    this.frameEvent = ""
    if m.board.kong.belt <> invalid
        this.belt = m.board.kong.belt
    end if
    if m.board.kong.switchBelt <> invalid
        this.switchBelt = m.board.kong.switchBelt
    end if
    'Methods
    this.update = update_kong
    return this
End Function

Sub update_kong()
    if m.charAction = "lostFloor" or m.charAction = "kidnapLady" or m.charAction = "kidnapConv"
        actionArray = m.anims.kong.sequence.Lookup(m.charAction)
        m.frameName = "kong-" + itostr(actionArray[m.frame].id)
        m.frameOffset = {x: 0, y: 0}
        m.frameEvent = ""
        if actionArray[m.frame].x <> invalid then m.frameOffset.x = actionArray[m.frame].x
        if actionArray[m.frame].y <> invalid then m.frameOffset.y = actionArray[m.frame].y
        if actionArray[m.frame].e <> invalid then m.frameEvent = actionArray[m.frame].e
        m.frame++
        if m.frame = actionArray.Count()
            m.frame = actionArray.Count() - 1
        end if
    else if m.belt <> invalid and GetBlockType(m.blockX, m.blockY) = m.const.MAP_CONV_BELT
        if m.belts[m.belt].direction = "L"
            m.offsetX -= 2
        else
            m.offsetX += 2
        end if
        if m.blockX > 0 and m.offsetX < 0
            m.blockX--
            m.offsetX += m.const.BLOCK_WIDTH
        else if m.offsetX > m.const.BLOCK_WIDTH
            m.blockX++
            m.offsetX -= m.const.BLOCK_WIDTH
        end if
        if m.blockX = 3 and m.offsetX <= 0
            m.belts[m.belt].direction = "R"
            if m.switchBelt <> invalid
                if m.belts[m.switchBelt].direction = "R"
                    m.belts[m.switchBelt].direction = "L"
                else
                    m.belts[m.switchBelt].direction = "R"
                end if
            end if
        else if m.blockX = 19 and m.offsetX >= 0
            m.belts[m.belt].direction = "L"
        end if
    else
        actionArray = m.anims.kong.sequence.Lookup(m.charAction)
        frame = actionArray[m.frame]
        m.frameName = "kong-" + itostr(frame.id)
        m.frameEvent = ""
        if frame.t <> invalid
            if m.cycles = invalid
                m.cycles = Int(frame.t / m.const.GAME_SPEED)
                if frame.e <> invalid then m.frameEvent = frame.e
            else
                m.cycles--
            end if
        else
            m.cycles = 0
            if frame.e <> invalid then m.frameEvent = frame.e
        end if
        if m.cycles = 0
            m.frame++
            if m.frame >= actionArray.Count() then m.frame = 0
            m.cycles = invalid
        end if
    end if
End Sub
