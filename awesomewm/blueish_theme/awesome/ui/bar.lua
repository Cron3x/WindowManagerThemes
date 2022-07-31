local gfs = require("gears.filesystem")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local rubato = require "lib.rubato"

----- Bar -----

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	-- Remove wibar on full screen
	local function remove_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = false
		else
			c.screen.mywibar.visible = true
		end
	end

	-- Remove wibar on full screen
	local function add_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = true
		end
	end

	----- Making Variables -----
	-- Time

	local hour = wibox.widget {
		widget = wibox.widget.textbox,
	}

	local icon = wibox.widget {
		markup = "<span foreground='" .. beautiful.magenta .. "'></span>",
		widget = wibox.widget.textbox,
	}

	local time = wibox.widget {
		{
			{
				hour,
				spacing = dpi(4),
				layout = wibox.layout.fixed.horizontal, -- horizontal
			},
			margins = {top=dpi(4), bottom=dpi(4), left=dpi(9), right=dpi(9)},
			widget = wibox.container.margin,
		},
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = beautiful.bar_alt,
		widget = wibox.container.background,
	}

	local set_clock = function() -- Update the value of the clock
		_ = os.date("%H:%M")
		hour.markup = "<span foreground='" .. beautiful.fg_normal .. "'>" .. _ .. "</span>"
	end

	local update_clock = gears.timer { -- Timer every 5 sec
		timeout = 5,
		autostart = true,
		call_now = true,
		callback = function()
			set_clock()
		end
	}

	-- layoutBox 
	
	local laybuttons = {
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
      		awful.button({ }, 3, function () awful.layout.inc(-1) end),
    		awful.button({ }, 4, function () awful.layout.inc( 1) end),
        	awful.button({ }, 5, function () awful.layout.inc(-1) end),
	}
	
	local layoutbox = wibox.widget {
		{
			{
				buttons = laybuttons,
				widget = awful.widget.layoutbox,
			},
			margins = { top = dpi(6), bottom = dpi(6), right = dpi(4), left = dpi(4) },
			widget = wibox.container.margin,
		},
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	-- Volume's arc
	
	local vol_arc = wibox.widget {
		{
			{
				id = 'value',
				min_value = 0,
				max_value = 100,
				rounded_edge = false,
				thickness = dpi(5),
				start_angle = math.pi,
				value = 60,
				colors = {beautiful.orange},
				widget = wibox.container.arcchart,
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	local vol_slide = rubato.timed {
                intro = 0.2,
                duration = 0.5,
                subscribed = function(pos)
                        vol_arc:get_children_by_id("value")[1].value = pos
                end
        }

	awesome.connect_signal("signal::volume", function(vol, mute)

		if mute or vol == 0 then
			vol_slide.target = 0 
		else
			vol_slide.target = vol or 0
		end
	end)

	-- Brightness's arc
	
	local bri_arc = wibox.widget {
		{
			{
				id = 'value',
                                min_value = 0,
                                max_value = 60,
                                rounded_edge = false,
                                thickness = dpi(5),
                                start_angle = math.pi,
                                value = 60,
                                colors = {beautiful.yellow},
                                widget = wibox.container.arcchart,
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	local bri_slide = rubato.timed {
                intro = 0.2,
                duration = 0.5,
                subscribed = function(pos)
                        bri_arc:get_children_by_id("value")[1].value = pos
                end
        }

	awesome.connect_signal("signal::brightness", function(bri)
		bri_slide.target = bri
	end)

	-- Network
	
	local wifi = wibox.widget {
		{
			{
				id = "icon",
				markup = "",
				widget = wibox.widget.textbox,
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	awesome.connect_signal("signal::wifi", function(stat, ssid)
		if stat then
			wifi:get_children_by_id("icon")[1].markup = "<span foreground='" .. beautiful.green .. "'></span>"
		else
			wifi:get_children_by_id("icon")[1].markup = "<span foreground='" .. beautiful.green .. "'></span>"
		end

	end)

	-- Battery
	local bat_arcchart = wibox.widget {
  widget = wibox.container.arcchart,
  start_angle = math.pi / 2,
  thickness = 4,
  value = 100,
  min_value = 0,
  max_value = 100,
  colors = { beautiful.taglist_fg_focus },
  bg = beautiful.bg_focus,
}

local battery_percent = wibox.widget {
  widget = wibox.widget.textbox,
  font = beautiful.font_name .. " Bold 10",
  valign = "center",
  align = "center",
  text = ":-)",
}

local battery_circle = wibox.widget {
  value = 0,
  border_width = 6,
  forced_width = 100,
  forced_height = 100,
  widget = wibox.container.radialprogressbar,
  color = beautiful.fg_normal,
  border_color = beautiful.bg_focus,
  {
    battery_percent,
    widget = wibox.container.margin,
    margins = 20,
  },
}

local battery = wibox.widget {
  bg = beautiful.bg_subtle,
  widget = wibox.container.background,
  {
    bat_arcchart,
    widget = wibox.container.margin,
    margins = 7,
    bottom = 8,
  },
}

awesome.connect_signal("squeal::battery", function(capacity, status)
  local fill_color = "#a9b665"

  if capacity >= 11 and capacity <= 35 then
    fill_color = beautiful.warn
  elseif capacity <= 10 then
    fill_color = beautiful.critical
  end

  if status == "Charging\n" then
    fill_color = beautiful.green
  end

  bat_arcchart.value = capacity
  bat_arcchart.colors = { fill_color }
  battery_percent.text = "\xf0\x9f\x94\x8b " .. tostring(capacity) .. "% "
	battery_percent.color = fill_color
  battery_circle.value = capacity / 100
  battery_circle.color = fill_color
end)


	-- Info
	local info = wibox.widget {
		{
			{
				battery_percent,
				--vol_arc,
				wifi,
				time,
				layout = wibox.layout.fixed.horizontal, -- horizontal
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

local info_bat = wibox.widget {
		{
			{
				battery_percent,
				--vol_arc,
				layout = wibox.layout.fixed.horizontal, -- horizontal
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	-- Tasklist
	
	local tasklist = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		layout = {
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal, -- horizontal
		},
		widget_template = {
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				widget = wibox.container.margin,
			},
			forced_width = dpi(30),
			shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
			bg = beautiful.bar,
			widget = wibox.container.background,
		},
	}

	local task = wibox.widget {
		{
			{
				tasklist,
				layout = wibox.layout.align.horizontal, -- horizontal
			},
			margins = {left = dpi(6), right = dpi(6)},
			widget = wibox.container.margin,
		},
		forced_height = dpi(30),
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = beautiful.bar .. "00",
		widget = wibox.container.background,
	}

	-- Taglist/Workspaces
	
	local taglist_buttons = gears.table.join(
        	awful.button({ }, 1, function(t) t:view_only() end),
        	awful.button({ modkey }, 1, function(t)
                      	            	if client.focus then
                      	                	client.focus:move_to_tag(t)
                      	            	end
			    	end),
        	awful.button({ }, 3, awful.tag.viewtoggle),
        	awful.button({ modkey }, 3, function(t)
                                  	if client.focus then
                                      		client.focus:toggle_tag(t)
                                  	end
                              	end),
		awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
		awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    	)
	
	local tags = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			spacing = dpi(0),
			layout = wibox.layout.fixed.horizontal, -- horizontal
		},
		style = {
			font = beautiful.font_name .. " " .. beautiful.font_size,
		},
		buttons = taglist_buttons,
		widget_template = {
			{
				{
					{
						id = 'text_role',
						forced_width = dpi(25),
						align = 'center',
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.align.horizontal, -- horizontal
				},
				margins = dpi(4),
				widget = wibox.container.margin,
			},
			id = 'bg',
			widget = wibox.container.background,

			-- Just ignore these things below...

			--create_callback = function(self, c3, _, _)
			--	if c3.selected then
			--		self:get_children_by_id("bg")[1].bg = beautiful.bar_alt
			--	else
			--		self:get_children_by_id("bg")[1].bg = beautiful.bar
			--	end
			--end,

			--update_callback = function(self, c3, _)
			--	if c3.selected then
                        --                self:get_children_by_id("bg")[1].bg = beautiful.bar_alt
                        --        else
                        --                self:get_children_by_id("bg")[1].bg = beautiful.bar
                        --        end
                        --end,
		},

	}

	local tag = wibox.widget {
		{
			{
				tags,
				layout = wibox.layout.fixed.horizontal, -- horizontal
			},
			widget = wibox.container.margin,
		},
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = beautiful.bar,
		widget = wibox.container.background,
	}

	----- Set up the BAR -----
	
	s.bar = awful.wibar {
		position = 'bottom', -- bottom
		width = s.geometry.width, -- dpi(200),
		height = dpi(53),
		screen = s,
		bg = beautiful.bar .. "00",
		visible = true,
		-- shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,50) end,
	}


	s.bar:setup {
		{
			{
				tag,
				layout = wibox.layout.fixed.horizontal, -- horizontal
			},
			--{
			--	{
			--		 task,
			--		layout = wibox.layout.align.horizontal, -- horizontal
			--	},
			--	halign = 'center',
			--	widget = wibox.container.place,
			--},
			nil,	
			{
				info,
				layout = wibox.layout.fixed.horizontal, -- horitontal
			},
			layout = wibox.layout.align.horizontal, -- horizontal
		},
	margins = dpi(8),
	widget = wibox.container.margin,
	} -- Tips: Read/Write the codes from bottom for :setup or widget_template

end)
