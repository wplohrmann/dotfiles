-- EditInGhostty: route file opens to nvim in the active Ghostty/tmux session.
-- If Ghostty is the frontmost app, the front window's title (set to the tmux
-- session name by tmux-session/launch.sh) tells us which nvim socket to talk
-- to. Otherwise we hand the file off to whatever app was the default before
-- we hijacked the file type.

property ghosttyBundleId : "com.mitchellh.ghostty"
property nvimBin : "/opt/homebrew/bin/nvim"
property tmuxBin : "/opt/homebrew/bin/tmux"
property fallbackMap : (POSIX path of (path to home folder)) & ".config/edit-in-ghostty/fallbacks.txt"

on open theFiles
	set frontBundle to my frontmostBundle()
	repeat with f in theFiles
		set p to POSIX path of f
		if frontBundle is ghosttyBundleId then
			my routeToNvim(p)
		else
			my fallback(p)
		end if
	end repeat
end open

on frontmostBundle()
	try
		tell application "System Events"
			return bundle identifier of (first process whose frontmost is true)
		end tell
	on error
		return ""
	end try
end frontmostBundle

on ghosttyWindowTitle()
	try
		tell application "System Events"
			set p to first process whose bundle identifier is ghosttyBundleId
			return name of front window of p
		end tell
	on error
		return ""
	end try
end ghosttyWindowTitle

on routeToNvim(thePath)
	set sessionName to my ghosttyWindowTitle()
	if sessionName is "" then
		my fallback(thePath)
		return
	end if
	set sockPath to "/tmp/nvim-" & sessionName & ".sock"
	try
		do shell script "test -S " & quoted form of sockPath
	on error
		my fallback(thePath)
		return
	end try
	try
		do shell script quoted form of nvimBin & " --server " & quoted form of sockPath & " --remote " & quoted form of thePath
	on error
		my fallback(thePath)
		return
	end try
	-- Focus the nvim pane so the user sees the file they just clicked
	try
		do shell script quoted form of tmuxBin & " list-panes -t " & quoted form of sessionName & " -F '#{pane_id} #{pane_current_command}' | awk '$2 ~ /n?vim/ {print $1; exit}' | xargs -I{} " & quoted form of tmuxBin & " select-pane -t {}"
	end try
end routeToNvim

on fallback(thePath)
	set ext to my pathExtension(thePath)
	set bundleId to my fallbackBundleFor(ext)
	if bundleId is "" then
		do shell script "/usr/bin/open " & quoted form of thePath
	else
		try
			do shell script "/usr/bin/open -b " & quoted form of bundleId & " " & quoted form of thePath
		on error
			do shell script "/usr/bin/open " & quoted form of thePath
		end try
	end if
end fallback

on pathExtension(thePath)
	try
		return do shell script "f=" & quoted form of thePath & "; ext=${f##*.}; [ \"$ext\" = \"$f\" ] && echo \"\" || echo \"$ext\" | tr 'A-Z' 'a-z'"
	on error
		return ""
	end try
end pathExtension

on fallbackBundleFor(ext)
	if ext is "" then return ""
	try
		return do shell script "awk -F= -v e=" & quoted form of ext & " '$1==e {print $2; exit}' " & quoted form of fallbackMap
	on error
		return ""
	end try
end fallbackBundleFor
