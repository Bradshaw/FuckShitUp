local state = gstate.new()


function state:init()
	skylineim = love.graphics.newImage("images/skyline.png")
	interim = love.graphics.newImage("images/inter.png")
	vigim = love.graphics.newImage("images/vig.png")
	curim = love.graphics.newImage("images/mouse.png")
end


function state:enter()
	rioter.spawn()
	rioter.spawn()
	rioter.spawn()
	spawntime = 1
	seletime = 0
end


function state:focus()

end


function state:mousepressed(x, y, btn)
	seletime = 0
	selx = math.floor(x/scale)
	sely = math.floor(y/scale)
end


function state:mousereleased(x, y, btn)
	if seletime<0.25 then
		for i,v in ipairs(rioter.all) do
			if v.selected then
				v.tx = math.floor(x/scale)
				v.ty = math.floor(y/scale)
			end
		end
	end
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
end


function state:keyreleased(key, uni)

end


function state:update(dt)
	if love.mouse.isDown("l") then
		seletime = math.min(1,seletime+dt)
	end
	xpos = math.floor(love.mouse.getX()/scale)
	ypos = math.floor(love.mouse.getY()/scale)
	rioter.update(dt)
	spawntime = spawntime-dt
	if spawntime<0 then
		spawntime = spawntime+1
		rioter.spawn()
	end
end


function state:draw()
	love.graphics.draw(interim)
	xpos = math.floor(love.mouse.getX()/scale)
	ypos = math.floor(love.mouse.getY()/scale)
	
	rioter.draw()
	if love.mouse.isDown("l") and seletime>0.2 and math.abs(xpos-selx)>5 and math.abs(ypos-sely)>5 then
		love.graphics.rectangle("line",selx,sely,xpos-selx,ypos-sely)
	end

	love.graphics.draw(skylineim)
	love.graphics.draw(curim,xpos,ypos)
	love.graphics.setColor(0,0,0)
	love.graphics.draw(vigim)
	love.graphics.setColor(255,255,255)
end

return state