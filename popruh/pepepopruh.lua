
local SETTINGS = {
    back_bone = 	11816   , --Záda = 24816
    x = -0.35, --Záda 0.28 
    y = 0.18, --Záda 0.15
    z = -0.05, --Záda 0.02
    x_rotation = 360.0, --Záda 0.0
    y_rotation = -40.0,--Záda 165.0
    z_rotation = 1.0, --Záda 0.0
    compatable_weapon_hashes = {
      
      -- Rychlopalne zbrane
       ["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
      -- Ostatní
    }
}

local attached_weapons = {}
arsling = false
RegisterCommand("pripnout", function(source, args, rawCommand)
	arsling = true
	
end, false)

RegisterCommand("odepnout", function(source, args, rawCommand)
	arsling = false
	
end, false)

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- Zbran  --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
			if arsling and not attached_weapons[wep_name]then 
				 AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation)
              
             end
			 
          end
      end
	 
      --------------------------------------------
      -- Drop zbran --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- Odstraneni ze zad při použití
          if arsling == false or GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
		 
		  
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

 
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

