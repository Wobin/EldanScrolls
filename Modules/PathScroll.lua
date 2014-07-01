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

    -- Ignore any paths that don't have anything to scroll
    if not self.Build then return end
    
    self:PostHook(self.Build, "OnPathUpdate")	          
    -- Settler specific subscrolling
    self:RegisterEvent("LoadSettlerMission", function(name, pMission) self:ScheduleTimer(function() self:LoadMission(pMission) end, 0.1) end)
    self:RegisterEvent("LoadExplorerMission", function(name, pMission) self:ScheduleTimer(function() self:LoadMission(pMission) end, 0.1) end)
end

local scrollContainer, scavengerContainer, GUIContainer

function PathScroll:OnPathUpdate()					
    local Scroll = self.Build.tWndRefs.wndMissionList    
    GUIContainer = Apollo.GetPackage("Gemini:GUI-1.0").tPackage:Create(Container)
    GUIContainer:SetOption("Name", "MissionListCover")
    scrollContainer = GUIContainer:GetInstance(self, Scroll:GetParent())    
    Parent.MonitoredFrames[scrollContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetVScrollPos, Get = Scroll.GetVScrollPos, Max= Scroll.GetVScrollRange}
    scrollContainer:Show(true)
    self:Unhook(self.Build, "OnPathUpdate")
end

function PathScroll:LoadMission(pmMission)	
	scrollContainer:Show(false)

	local missionDetails =  Apollo.GetAddon("PathSettlerMissions") or Apollo.GetAddon("PathExplorerMissions")
	
	if missionDetails.wndExplorerHuntNotice then
		GUIContainer:SetOption("Name", "ScavengerCover")
		local Scroll = missionDetails.wndMain:FindChild("ScavClueContainer")
		scavengerContainer = GUIContainer:GetInstance(self, Scroll:GetParent())    
		Parent.MonitoredFrames[scavengerContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetVScrollPos, Get = Scroll.GetVScrollPos, Max= Scroll.GetVScrollRange}
		scavengerContainer:Show(true)		
	end

	self:PostHook(missionDetails, "HelperResetUI", function() self:ToggleScreen(scrollContainer) self:ToggleScreen(scavengerContainer) end)		
	self:PostHook(missionDetails, "LoadFromList", function()  self:ToggleScreen(scrollContainer) self:ToggleScreen(scavengerContainer) end)

	self:UnregisterEvent("LoadSettlerMission")
	self:UnregisterEvent("LoadExplorerMission")
end

function PathScroll:ToggleScreen(wndScreen)
	if not wndScreen then return end
	wndScreen:Show(not wndScreen:IsShown())
end