-- Replace main.lua with this for full gridview (not list)

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"
import "CoreLibs/crank"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(32, 32)

gridview:setNumberOfColumns(8)
gridview:setNumberOfRows(2, 5, 3)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("images/gridBackground", 7, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

gridview:setSectionHeaderHeight(24)

gridview:addHorizontalDividerAbove(2, 1)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()

function gridview:drawSectionHeader(section, x, y, width, height)
    local fontHeight = gfx.getSystemFont():getHeight()
    gfx.drawTextAligned("*Section " .. section .. "*", x + width / 2, y + (height/2 - fontHeight/2) + 2, kTextAlignment.center)
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    if selected then
        gfx.fillCircleInRect(x, y, width, height)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.drawCircleInRect(x, y, width, height)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
    local cellText = tostring(row) .. "-" .. tostring(column)
    local fontHeight = gfx.getSystemFont():getHeight()
    gfx.drawTextInRect(cellText, x, y + (height/2 - fontHeight/2) + 2, width, height, nil, nil, kTextAlignment.center)
end

function pd.update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        gridview:selectPreviousColumn(false)
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        gridview:selectNextColumn(false)
    end

    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        gridview:selectNextRow(true)
    elseif crankTicks == -1 then
        gridview:selectPreviousRow(true)
    end

    if gridview.needsDisplay then
        local gridviewImage = gfx.image.new(200, 100)
        gfx.pushContext(gridviewImage)
            gridview:drawInRect(0, 0, 200, 100)
        gfx.popContext()
        gridviewSprite:setImage(gridviewImage)
    end

    gfx.sprite.update()
    pd.timer.updateTimers()
end
