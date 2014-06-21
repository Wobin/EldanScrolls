-----------------------------------------------------------------------------------------------
-- Client Lua Script for EldanScrolls
-- Copyright (c) Wobin. All rights reserved
--
--
-- Have mercy upon me, O Jacob; but thou hast kept the word of the LORD was not yet gone back, 
-- he said, Go and utterly destroy them; namely, the Hittites, and the Girgashites, and the 
-- Amorites, and the Perizzites, and the Hivites, and the Jebusites, which were not defiled 
-- with women; for they are not very good for implementing high-performance floating-point 
-- calculations or calculations that intensively manipulate bit vectors.
--
--                      A reading from the Book of Markov - Chapter 6 Verses 1-14 
--                      Structure and Interpretation of Computer Programs - King James Version
--                                                                  http://tinyurl.com/plbvsdh
-----------------------------------------------------------------------------------------------
 
require "Window"
 

-----------------------------------------------------------------------------------------------
-- EldanScrolls Module Definition
-----------------------------------------------------------------------------------------------
local bHasConfigureFunction = false	
local tDependencies = {"BuildMap", "Gemini:GUI-1.0", "PathSettlerContent", "PathSoldierContent","PathScientistContent","PathExplorerContent"}	

EldanScrolls = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("EldanScrolls", bHasConfigureFunction, tDependencies, "Gemini:Hook-1.0")

EldanScrolls:SetDefaultModulePackages("Gemini:Hook-1.0", "Gemini:Event-1.0")
EldanScrolls:SetDefaultModulePrototype({
	Connect = function(self, parent) self.Parent = parent  return self end,
})

local MonitoredFrames = {}

-----------------------------------------------------------------------------------------------
-- EldanScrolls OnLoad
-----------------------------------------------------------------------------------------------
function EldanScrolls:OnInitialize()  	
	local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
  	self.glog = GeminiLogging:GetLogger({ level = GeminiLogging.DEBUG, pattern = "%d %n %c %l - %m", appender = "GeminiConsole" })
	self.MonitoredFrames = MonitoredFrames
	self.SettlerBuildScroll = self:GetModule("SettlerBuildScroll"):Connect(self)
	self.PathScroll = self:GetModule("PathScroll"):Connect(self)
end

function EldanScrolls:MouseWheel(...)
	local nane, wndHandler, wndControl, nLastRelativeMouseX, nLastRelativeMouseY, fScrollAmount, bConsumeMouseWheel = ...

	local Details = MonitoredFrames[wndControl:GetName()]

	if not Details then return end

	local Entries = Details.Parent:GetChildren()

	if not Entries then return end
	local Delta = Details.Max(Details.Parent) / (#Entries * 2)

	if fScrollAmount < 0 then 
		-- scroll to the left to the left
		Details.Set(Details.Parent, Details.Get(Details.Parent) + Delta)
	else
		-- scroll to the right
		Details.Set(Details.Parent, Details.Get(Details.Parent) - Delta)
	end
end



