local SettlerBuildScroll = EldanScrolls:NewModule("SettlerBuildScroll")
local Parent

local Container = {
					AnchorOffsets = { 224, 18, -30, -29 },
					AnchorPoints = { 0, 0, 1, 1 },
					RelativeToClient = true, 
					Template = "Control", 
					Name = "SelectionItemContainerCover", 					
					VScroll = true,				-- We don't want to be able to zoom camera at the same time	
					IgnoreMouse = true, 		-- Or block the buttons			
					Events = {
						MouseWheel = function(...) EldanScrolls:MouseWheel(...) end
					},
				}

function SettlerBuildScroll:OnEnable()
	Parent = self.Parent
    self.Build = Apollo.GetAddon("BuildMap")
    self:PostHook(self.Build, "OnInvokeSettlerBuild")
end

function SettlerBuildScroll:OnInvokeSettlerBuild(...)
    local Scroll = self.Build.wndMain:FindChild("SelectionItemContainer")    
    local scrollContainer = Apollo.GetPackage("Gemini:GUI-1.0").tPackage:Create(Container):GetInstance(self, Scroll:GetParent())    
    Parent.MonitoredFrames[scrollContainer:GetName()] = { Parent = Scroll, Set = Scroll.SetHScrollPos, Get = Scroll.GetHScrollPos, Max= Scroll.GetHScrollRange}
    scrollContainer:Show(true)
end