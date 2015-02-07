tell application "iPhoto"
	quit
	delay 10
	
	activate
	delay 1
	tell album "Photos"
		set thePhotos to get every photo
		repeat with aPhoto in thePhotos
			try
				-- log aPhoto's name as text
				remove aPhoto
			on error errMsg
				log "ERROR: " & errMsg
			end try
		end repeat
	end tell
	
	set iFolder to "/Users/dashboard/screenshots"
	import photo from iFolder
	
	delay 2
	
	tell me to refreshCloud("dashboard", {"sampletv"})
	
	empty trash
	delay 10
	quit
end tell

on refreshCloud(cloudName, thePhotos)
	tell application "iPhoto"
		set currentPhotos to {}
		set currentSize to 0
		set hasHold to false
		tell album cloudName
			set cloudPhotos to get every photo
			set currentSize to the count of cloudPhotos
			repeat with aPhoto in cloudPhotos
				if name of aPhoto is "hold" then
					set hasHold to true
				else
					set the end of currentPhotos to aPhoto
				end if
			end repeat
		end tell
		
		repeat with aName in thePhotos
			activate
			delay 1
			
			tell album "Last Import" to select photo aName
			delay 1
			
			tell application "System Events"
				tell process "iPhoto"
					click menu item "iCloud…" of menu "Share" of menu bar 1
					delay 1
					
					keystroke cloudName
					delay 1
					
					keystroke (ASCII character 13) -- return
					delay 1
					
					keystroke (ASCII character 13) -- return
					delay 3
				end tell
			end tell
		end repeat
		
		if not hasHold then
			-- need to let iCloud catch up
			delay 100
		end if
		
		delay 20 -- make sure all uploaded and stuff
		select album cloudName
		
		set updatedSize to the count of every photo in album cloudName
		
		if updatedSize > currentSize then
			-- for some reason, it doesn't always actually upload
			if (count of currentPhotos) > 0 then
				repeat with aPhoto in currentPhotos
					activate
					delay 1
					select aPhoto
					tell application "System Events"
						delay 1
						keystroke (ASCII character 127) -- delete
						delay 1
						keystroke "d" using command down -- yes, really
						delay 3
					end tell
				end repeat
			end if
		end if
		
	end tell
end refreshCloud
