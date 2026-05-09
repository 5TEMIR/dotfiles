local mp = require('mp')
local utils = require('mp.utils')

local selected_index = 1
local playlist_visible = false
local queue_file = os.getenv("HOME") .. "/.local/state/mpv/yt-queue/youtube-queue.m3u"

local function read_playlist_file()
    local file = io.open(queue_file, "r")
    if not file then
        return {}
    end
    
    local urls = {}
    local current_title = nil
    
    for line in file:lines() do
        line = line:gsub("^%s*(.-)%s*$", "%1")  -- trim
        if line:match("^#EXTM3U") then
        elseif line:match("^#EXTINF:(%d+),(.*)$") then
            current_title = line:match("^#EXTINF:%d+,(.*)$")
        elseif line ~= "" and not line:match("^#") then
            table.insert(urls, {
                url = line,
                title = current_title or line
            })
            current_title = nil
        end
    end
    
    file:close()
    return urls
end

local function save_playlist_to_file(playlist_entries)
    local dir = queue_file:match("(.*)/")
    if dir then
        os.execute("mkdir -p " .. dir)
    end
    
    local file = io.open(queue_file, "w")
    if not file then
        mp.msg.error("Failed to open file for writing: " .. queue_file)
        return
    end
    
    file:write("#EXTM3U\n")
    
    for _, entry in ipairs(playlist_entries) do
        file:write("#EXTINF:0," .. (entry.title or "Unknown") .. "\n")
        file:write(entry.url .. "\n")
    end
    
    file:close()
    mp.msg.info("Playlist saved to " .. queue_file)
end

local function add_video(url, title)
    if not url or url == "" then
        mp.msg.error("URL not specified")
        return
    end
    
    local entries = read_playlist_file()
    
    table.insert(entries, {
        url = url,
        title = title
    })
    
    
    mp.commandv("loadfile", url, "append")
    
    mp.osd_message("Video added to queue: " .. title, 2)
    mp.msg.info("Video added: " .. title)
end

local function update_playlist_display()
    local playlist = mp.get_property_native("playlist")
    local current = mp.get_property_number("playlist-pos", 0) + 1
    
    if not playlist or #playlist == 0 then
        mp.osd_message("Playlist is empty", 3)
        playlist_visible = false
        return
    end
    
    local lines = {}
    for i, entry in ipairs(playlist) do
        marker = "○ "
        local filename = entry.title or entry.filename or "unknown"
        filename = filename:gsub("^.-([^/\\]+)$", "%1")
        
        if i == current then
            marker = "▷ "
        end
        
        if i == selected_index then
            if i == current then
                marker = "▶ "
            else
                marker = "● "
            end
        end
        
        table.insert(lines, string.format("%s%s", marker, filename))
    end
    
    mp.osd_message(table.concat(lines, "\n"), 3600)
end

local function show_playlist()
    local playlist = mp.get_property_native("playlist")
    local current = mp.get_property_number("playlist-pos", 0) + 1
    
    if not playlist or #playlist == 0 then
        mp.osd_message("Playlist is empty", 3)
        return
    end
    
    if not playlist_visible then
        selected_index = current
        playlist_visible = true
    end
    
    update_playlist_display()
end

local function hide_playlist()
    mp.osd_message("", 0)
    playlist_visible = false
end

local function select_next()
    if not playlist_visible then
        show_playlist()
        return
    end
    
    local playlist = mp.get_property_native("playlist")
    if playlist and #playlist > 0 then
        selected_index = selected_index + 1
        if selected_index > #playlist then
            selected_index = 1
        end
        update_playlist_display()
    end
end

local function select_prev()
    if not playlist_visible then
        show_playlist()
        return
    end
    
    local playlist = mp.get_property_native("playlist")
    if playlist and #playlist > 0 then
        selected_index = selected_index - 1
        if selected_index < 1 then
            selected_index = #playlist
        end
        update_playlist_display()
    end
end

local function play_selected()
    if not playlist_visible then
        show_playlist()
        return
    end
    
    local playlist = mp.get_property_native("playlist")
    if playlist and #playlist > 0 and selected_index >= 1 and selected_index <= #playlist then
        mp.set_property_number("playlist-pos", selected_index - 1)
        selected_index = mp.get_property_number("playlist-pos", 0) + 1
        update_playlist_display()
    end
end

local function remove_selected()
    if not playlist_visible then
        show_playlist()
        return
    end
    
    local playlist = mp.get_property_native("playlist")
    if playlist and #playlist > 0 and selected_index >= 1 and selected_index <= #playlist then
        local removed_url = playlist[selected_index].filename
        
        mp.commandv("playlist-remove", selected_index - 1)
        
        local file_entries = read_playlist_file()
        local new_entries = {}
        
        for _, entry in ipairs(file_entries) do
            if entry.url ~= removed_url then
                table.insert(new_entries, entry)
            end
        end
        
        save_playlist_to_file(new_entries)
        
        local new_playlist = mp.get_property_native("playlist")
        if #new_playlist == 0 then
            hide_playlist()
            return
        end
        
        if selected_index > #new_playlist then
            selected_index = #new_playlist
        end
        
        update_playlist_display()
    end
end

mp.add_key_binding("g-p", "yt-queue-show", show_playlist)
mp.add_key_binding("ctrl+[", "yt-queue-hide", hide_playlist)
mp.add_key_binding("ctrl+n", "yt-queue-next", select_next)
mp.add_key_binding("ctrl+p", "yt-queue-prev", select_prev)
mp.add_key_binding("ctrl+m", "yt-queue-play-selected", play_selected)
mp.add_key_binding("ctrl+h", "yt-queue-remove-selected", remove_selected)

mp.register_script_message("add-video", add_video)
