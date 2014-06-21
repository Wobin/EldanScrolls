local PathScroll = EldanScrolls:NewModule("PathScroll")
local Parent

local Container =
		{
			AnchorPoints = { 0, 0, 1, 1 },
			Template = "Control", 
			Name = "MissionListCover", 
			VScroll = true, 
			NewControlDepth = 1,
			IgnoreMouse = true, 
			Visible = false, 
			Border = true, 
			UseTemplateBG = true, 
					Events = {
						MouseWheel = function(...) EldanScrolls:MouseWheel(...) end
					},
		}


function PathScroll:OnEnable()
	local Paths = {
		[PlayerPathLib.PlayerPathType_Settler] = "PathSettlerContent",
		[PlayerPathLib.PlayerPathType_Soldier] = "PathSoldierContent",
		[PlayerPathLib.PlayerPathType_Scientist] = "PathScientistContent",
		[PlayerPathLib.PlayerPathType_Explorer] = "PathExplorerContent",
	 }

	Parent = self.Parent
	local unitPlayer = GameLib:GetPlayerUnit()
 	
    self.Build = Apollo.GetAddon(Paths[unitPlayer:GetPlayerPathType()])
    self:PostHook(self.Build, "OnPathUpdate")	          
    -- Settler specific subscrolling
    self:RegisterEvent("LoadSettlerMission", function(name, pMission) self:ScheduleTimer(function() self:LoadMission(pMission) end, 0.5) end)
end

local scrollContainer, missionDetails, Scroll, clickedButton 

function PathScroll:OnPathUpdate()				
	if Parent.missionDetails and Parent.missionDetails:IsValid() then return end
    Scroll = self.Build.wndMain:FindChild("MissionList")    
    scrollContainer = Apollo.GetPackage("Gemini:GUI-1.0").tPackage:Create(Container):GetInstance(self, Scroll:GetParent())    
    Parent.MonitoredFrames[scrollContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetVScrollPos, Get = Scroll.GetVScrollPos, Max= Scroll.GetVScrollRange, Module = self}
    scrollContainer:Show(true)
    self:Unhook(self.Build, "OnPathUpdate")
end

function PathScroll:LoadMission(pmMission)	
	scrollContainer:Destroy()
	Parent.missionDetails =  g_wndDatachron:FindChild("PathContainer"):FindChild("SettlerMissionContainer"):FindChildByUserData(pmMission)	
	self:PostHook(self.Build, "OnPathUpdate")	
end