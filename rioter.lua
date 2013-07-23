local rioter_mt = {}
rioter = {}
rioter.all = {}

rioter.image = love.graphics.newImage("images/character.png")
rioter.selectim = love.graphics.newImage("images/selector.png")
rioter.anim = {}
rioter.anim.stand = {}
rioter.anim.run = {}
for i=1,6 do
	rioter.anim.stand[i] = love.graphics.newQuad((i-1)*12,0,12,12,72,48)
	rioter.anim.run[i] = love.graphics.newQuad((i-1)*12,12,12,12,72,48)
end

function rioter.new(x,y)
	local self = setmetatable({},{__index=rioter_mt})
	self.r,self.g,self.b = useful.hsv(math.random(0,30),25,50)
	self.x = x
	self.y = y
	self.goto = true
	self.dx = 0
	self.dy = 0
	self.tx = (1+math.random()*4)*10
	self.ty = self.y-12+math.random()*24
	self.selected = false
	self.acc = 75
	self.fric = 4
	self.push = true
	self.anim = rioter.anim.run
	self.animperframe = 0.05
	self.animtime=math.random()*self.animperframe
	self.frame = math.random(1,6)

	return self
end

function rioter.track(r)
	table.insert(rioter.all,r)
end

function rioter.spawn()
	if #rioter.all<=20 then
		rioter.track(rioter.new(-1,math.random(3,14)*6))
	end
end

function rioter.update(dt)
	local i = 1
	while i<=#rioter.all do
		local v = rioter.all[i]
		if v.purge then
			table.remove(rioter.all,i)
		else
			v:update(dt)
			if i>1 and v.y<rioter.all[i-1].y then
				rioter.all[i],rioter.all[i-1] = rioter.all[i-1],rioter.all[i]
			end
			i = i + 1
		end
	end
end

function rioter.draw()
	for i,v in ipairs(rioter.all) do
		v:draw()
	end
	love.graphics.setColor(255,255,255)
end

function rioter_mt:update( dt )
	self.ty = math.min(14*6,math.max(3*6,self.ty))
	self.animtime = self.animtime+dt
	if self.animtime>self.animperframe then
		self.animtime = self.animtime-self.animperframe
		self.frame = (self.frame%6)+1
	end
	local dx = (self.tx-self.x)
	local dy = (self.ty-self.y)
	local d = math.sqrt(dx*dx+dy*dy)
	if d>useful.tri(self.push,15,5) then
		local nx = dx/d
		local ny = dy/d
		if self.push then
			self.dx = self.dx+nx*self.acc*dt*0.1
			self.dy = self.dy+ny*self.acc*dt*0.1
		else
			self.dx = self.dx+nx*self.acc*dt
			self.dy = self.dy+ny*self.acc*dt
		end
	end
	for i,v in ipairs(rioter.all) do
		local x = 1
		local dx = self.x-v.x
		local dy = self.y-v.y
		local d = math.sqrt(dx*dx+dy*dy)
		local nx = dx/d
		local ny = dy/d
		self.push = false
		if d<4 and self~=v then
			self.push = true
			self.dx = self.dx+nx*20*(4-d)
			self.dy = self.dy+ny*20*(4-d)
		end
	end
	self.dx = self.dx-self.dx*self.fric*dt
	self.dy = self.dy-self.dy*self.fric*dt
	if self.dx<0 and self.dx>3 then self.dx=1 end
	local speed2 = self.dx*self.dx+self.dy*self.dy
	if speed2<(7*7) then
		self.anim = rioter.anim.stand
		self.animperframe = 1
	else
		self.anim = rioter.anim.run
		self.animperframe = 0.05
	end
	self.x = self.x+self.dx*dt
	self.y = self.y+self.dy*dt
	if love.mouse.isDown("l") and seletime>0.2 and math.abs(xpos-selx)>5 and math.abs(ypos-sely)>5 then
		if self.x>math.min(selx,xpos) and self.x<math.max(selx,xpos) and self.y>math.min(sely,ypos) and self.y<math.max(sely,ypos) then
			self.selected = true
		else
			self.selected = false
		end
	end
end

function rioter_mt:draw()
	
	love.graphics.setColor(0,0,0,32)
	love.graphics.drawq(rioter.image,self.anim[self.frame],self.x,self.y,0,useful.sign(self.dx)*2/3,1/3,6,12,useful.sign(self.dx)*(-self.x+xsize/2)/(xsize*0.7),0)
	if self.selected then
		love.graphics.setColor(30,180,30,255)
		love.graphics.draw(rioter.selectim,self.x,self.y,0,1,1,3,2)
	end
	love.graphics.setColor(self.r,self.g,self.b)
	love.graphics.drawq(rioter.image,self.anim[self.frame],self.x,self.y,0,useful.sign(self.dx)*2/3,2/3,6,12)
end
