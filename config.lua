application = {
	content =
	{           
		fps = 60,
		width = 720,
		height = 720+300,
		scale = "zoomStretch",
		xAlign = "center",
		yAlign = "center",
		imageSuffix = 
		{
			["@2x"] = 1.5,
			["@4x"] = 3.0,
		},
--		UIApplicationExitsOnSuspend = false,
	},

    --[[
    -- Push notifications
 
    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
