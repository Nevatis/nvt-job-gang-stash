RegisterNetEvent('nvt-drawtext:ShowUI')
AddEventHandler('nvt-drawtext:ShowUI', function(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end)

RegisterNetEvent('nvt-drawtext:HideUI')
AddEventHandler('nvt-drawtext:HideUI', function()
	SendNUIMessage({
		action = 'hide'
	})
end)