function love.load(arg)
	love.graphics.setDefaultImageFilter("nearest","nearest")
	scale = 4
	xsize = 1024/4
	ysize = 384/4
	local m = love.graphics.getModes()
	local M = m[1]
	for i,v in ipairs(m) do
		if v.height>M.height and v.width>M.width then
			M=m
		end
	end

	love.graphics.setMode(M.width,M.height,true)
	screen = love.graphics.newCanvas(512,512)
	screen:setFilter("nearest","nearest")
	love.mouse.setVisible(false)
	require("useful")
	require("rioter")

	gstate = require "gamestate"
	game = require("game")
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function keyreleased(key, uni)
	gstate.keyreleased(key)
end

function love.update(dt)
	love.mouse.setPosition(math.min(love.mouse.getX(),xsize*scale-scale),  math.min(love.mouse.getY(),ysize*scale-scale))
	gstate.update(dt)
end

function love.draw()
	love.mouse.setPosition(math.min(love.mouse.getX(),xsize*scale-scale),  math.min(love.mouse.getY(),ysize*scale-scale))
	screen:clear()
	love.graphics.setCanvas(screen)
	gstate.draw()
	love.graphics.setCanvas()
	love.graphics.push()
	--love.graphics.translate(love.graphics.getWidth()/2-xsize/2,love.graphics.getHeight()/2-ysize/2)
	love.graphics.setScissor(love.graphics.getWidth()/2-xsize*2,love.graphics.getHeight()/2-ysize*2,xsize*scale,ysize*scale)
	love.graphics.draw(screen,love.graphics.getWidth()/2-xsize*2,love.graphics.getHeight()/2-ysize*2,0,scale,scale)
	love.graphics.setScissor()
	love.graphics.pop()
	if love.keyboard.isDown("p") then
		local img = love.graphics.newScreenshot()
		img:encode("scrot.png")
	end
end
