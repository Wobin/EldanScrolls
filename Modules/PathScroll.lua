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
end
local setup 

function PathScroll:OnPathUpdate()			
    local Scroll = self.Build.wndMain:FindChild("MissionList")    
    local scrollContainer = Apollo.GetPackage("Gemini:GUI-1.0").tPackage:Create(Container):GetInstance(self, Scroll:GetParent())    
    Parent.MonitoredFrames[scrollContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetVScrollPos, Get = Scroll.GetVScrollPos, Max= Scroll.GetVScrollRange}
    scrollContainer:Show(true)
    self:Unhook(self.Build, "OnPathUpdate")
end