local PathScroll = EldanScrolls:NewModule("PathScroll")
local Parent, unitPlayer, Paths, SubWindows = {}

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
	Paths = {
		[PlayerPathLib.PlayerPathType_Settler] = "PathSettlerContent",
		[PlayerPathLib.PlayerPathType_Soldier] = "PathSoldierContent",
		[PlayerPathLib.PlayerPathType_Scientist] = "PathScientistContent",
		[PlayerPathLib.PlayerPathType_Explorer] = "PathExplorerContent",
	 }
	 SubWindows = {
	 	[PlayerPathLib.PlayerPathType_Settler] = "SettlerMissionContainer",
		[PlayerPathLib.PlayerPathType_Soldier] = "PathSoldierContent",
		[PlayerPathLib.PlayerPathType_Scientist] = "PathScientistContent",
		[PlayerPathLib.PlayerPathType_Explorer] = "ExpMissionsMainContainer",	
	}
	Parent = self.Parent
	unitPlayer = GameLib:GetPlayerUnit()
 	
    self.Build = Apollo.GetAddon(Paths[unitPlayer:GetPlayerPathType()])
    self:PostHook(self.Build, "OnPathUpdate")	          
    -- Settler specific subscrolling
    self:RegisterEvent("LoadSettlerMission", function(name, pMission) self:ScheduleTimer(function() self:LoadMission(pMission) end, 0.1) end)
    self:RegisterEvent("LoadExplorerMission", function(name, pMission) self:ScheduleTimer(function() self:LoadMission(pMission) end, 0.1) end)
end

local scrollContainer

function PathScroll:OnPathUpdate()					
    local Scroll = self.Build.wndMain:FindChild("MissionList")    
    scrollContainer = Apollo.GetPackage("Gemini:GUI-1.0").tPackage:Create(Container):GetInstance(self, Scroll:GetParent())    
    Parent.MonitoredFrames[scrollContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetVScrollPos, Get = Scroll.GetVScrollPos, Max= Scroll.GetVScrollRange}
    scrollContainer:Show(true)
    self:Unhook(self.Build, "OnPathUpdate")
end

function PathScroll:LoadMission(pmMission)	
	scrollContainer:Show(false)
	local missionDetails =  Apollo.GetAddon("PathSettlerMissions") or Apollo.GetAddon("PathExplorerMissions")
	self:PostHook(missionDetails, "HelperResetUI", function() scrollContainer:Show(false) end)		
	self:PostHook(missionDetails, "LoadFromList", function() scrollContainer:Show(true) end)
	self:UnregisterEvent("LoadSettlerMission")
	self:UnregisterEvent("LoadExplorerMission")
end