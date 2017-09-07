--Diablo 3 Resource Globe

function Start()
	scene=Scene()
	scene:CreateComponent("Octree")
	
	cameraNode = scene:CreateChild("Camera")
    local camera=cameraNode:CreateComponent("Camera")
    cameraNode.position = Vector3(0.0, 5.0, 0.0)
	local viewport = Viewport:new(scene, cameraNode:GetComponent("Camera"))
    renderer:SetViewport(0, viewport)
	
	camera:SetOrthographic(true)
	camera:SetOrthoSize(100)
	cameraNode:LookAt(Vector3(0,0,0), Vector3(0,1,0))
	
	local planeNode = scene:CreateChild("Plane")
    planeNode.scale = Vector3(100.0, 1.0, 100.0)
    local planeObject = planeNode:CreateComponent("StaticModel")
    planeObject.model = cache:GetResource("Model", "Models/health.mdl")
    planeObject.material = cache:GetResource("Material", "Materials/health.xml")
	
	planeNode = scene:CreateChild("Plane")
    planeNode.scale = Vector3(100.0, 1.0, 100.0)
    local planeObject = planeNode:CreateComponent("StaticModel")
    planeObject.model = cache:GetResource("Model", "Models/mana.mdl")
    planeObject.material = cache:GetResource("Material", "Materials/mana.xml")
	
	--mat=cache:GetResource("Material", "Materials/resourcebubble.xml")
	--mat:SetShaderParameter("Level", Variant(0.5))
	
	health=cache:GetResource("Material", "Materials/health.xml")
	mana=cache:GetResource("Material", "Materials/mana.xml")
	
	level=0.5
	hlevel=0.5
	dir=1
	hdir=1
	
	SubscribeToEvent("Update", "HandleUpdate")
	SubscribeToEvent("KeyDown", "HandleKeyDown")
	
	input.mouseVisible=true
end

function Stop()

end

function Update(dt)
	level=level+0.1*dt*dir
	if level>1 then dir=-1
	elseif level<0 then dir=1
	end
	
	hlevel=hlevel+0.18*dt*hdir
	if hlevel>1 then hdir=-1
	elseif hlevel<0 then hdir=1
	end
	
	print(level)
	health:SetShaderParameter("Level", Variant(hlevel))
	mana:SetShaderParameter("Level", Variant(1-level))
end

function HandleUpdate(eventType, eventData)
    -- Take the frame time step, which is stored as a float
    local timeStep = eventData["TimeStep"]:GetFloat()

    -- Move the camera, scale movement with time step
    Update(timeStep)
end

function HandleKeyDown(eventType, eventData)
	local key = eventData["Key"]:Get()
	local vm=VariantMap()
	-- Close console (if open) or exit when ESC is pressed
	if key==KEY_P then
		local t=os.date("*t")
		local filename="screen_"..tostring(t.year).."_"..tostring(t.month).."_"..tostring(t.day).."_"..tostring(t.hour).."_"..tostring(t.min).."_"..tostring(t.sec)..".png"
		local img=Image()
		graphics:TakeScreenShot(img)
		img:SavePNG(filename)
		return

	elseif key == KEY_ESCAPE then
        engine:Exit()
	end
end