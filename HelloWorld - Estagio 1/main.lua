-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- Inicializando a fisica do jogo
local physics = require("physics")
physics.start()
physics.setGravity(0,0)
-- Isso mostra a fisica dos objetos
-- physics.setDrawMode( "hybrid" )

-- Criando as variaveis
local score = 0
local ship
local asteroid

-- Inicializando os grupos
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Adicionando as imagens
local background = display.newImageRect( backGroup, "background.png", 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY

local ship = display.newImageRect( mainGroup, "ship.png", 99, 79)
ship.x = display.contentCenterX
ship.y = display.contentCenterY + 200
physics.addBody(ship, {radius = 30, isSensor = true})
ship.myName = "ship"

local asteroid = display.newImageRect( mainGroup, "asteroid.png", 112,85)
asteroid.x = display.contentCenterX
asteroid.y = display.contentCenterY - 130
physics.addBody(asteroid, {radius = 30})
asteroid.myName = "asteroid"

-- Texto do score
local scoreText = display.newText( uiGroup, "Score: ".. score, display.contentCenterX, 10, native.systemFont, 36 )

-- Função de mover a nave
local function moveShip( event )
    local ship = event.target
    local phase = event.phase

    if("began" == phase) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetY = event.y - ship.y
    elseif("moved" == phase) then
        ship.y = event.y - ship.touchOffsetY
    elseif("ended" == phase or "cancelled" == phase) then
        display.currentStage:setFocus(nil)
    end
    return true
end

-- Listener do movimento da nave
ship:addEventListener("touch", moveShip)

-- Função que restaura a posição inicial da nave
local function restorePosition()
    ship.isBodyActive = false
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 40

    transition.to(ship, {alpha=1, time=100,
        onComplete = function()
            ship.isBodyActive = true
        end
        })
end

-- Função de colisão da nave com o asteroid
local function onCollision( event )
    if( event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2 

        if((obj1.myName == "ship" and obj2.myName == "asteroid") or (obj1.myName == "asteroid" and obj2.myName == "ship")) then
            score = score + 1
            scoreText.text = "Score: "..score
            ship.alpha = 0
            timer.performWithDelay( 100, restorePosition )
        end
    end
end

-- Listener da colisão
Runtime:addEventListener("collision", onCollision)



