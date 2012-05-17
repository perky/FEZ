Input = Attribute('Input')

function Input:onInit()
	self.mouseIsOver = false
	self.mouseIsDown = false
	self.mouseIsDownAndOver = false
	self.isInputDisabled = false
end

function Input:setMouseIsOver( mouseIsOver )
	self.mouseIsOver = mouseIsOver
end

function Input:getMouseIsOver()
	return self.mouseIsOver
end

function Input:setMouseIsDown( mouseIsDown )
	self.mouseIsDown = mouseIsDown
end

function Input:getMouseIsDown()
	return self.mouseIsDown
end

function Input:setMouseIsDownAndOver( mouseIsDownAndOver )
	self.mouseIsDownAndOver = mouseIsDownAndOver
end

function Input:getMouseIsDownAndOver()
	return self.mouseIsDownAndOver
end

function Input:setIsInputDisabled( isInputDisabled )
	self.isInputDisabled = isInputDisabled
end

function Input:getIsInputDisabled()
	return self.isInputDisabled
end