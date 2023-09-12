local LuaVersion = 1.7
require("PKDamageLib")
if not _G.DynastyOrb then
	require("DynastyOrb")
end
if not _G.DreamPred then
	require("DreamPred")
end
  
--Ensuring that the library is downloaded:
local file_name = "VectorMath.lua"
if not file_manager:file_exists(file_name) then
   local url = "https://raw.githubusercontent.com/stoneb2/Bruhwalker/main/VectorMath/VectorMath.lua"
   http:download_file(url, file_name)
   console:log("VectorMath Library Downloaded")
   console:log("Please Reload with F5")
end

local Prints = function(str, level)
	if xCore_X then 
		if xCore_X.debug then
			xCore_X.debug:Print(str, level)
		end
	else
		console:log("scoob?")
	end
end

e_spell_slot = {
	q = SLOT_Q,
	w = SLOT_W,
	e = SLOT_E,
	r = SLOT_R
	}



XVisMenuCat = nil
XTSMenuCat = nil
XPermashowMenuCat = nil



local std_math = math
local g_local = game.local_player
-- --------------------------------------------------------------------------------

-- local font = 'corbel'

-- --------------------------------------------------------------------------------

-- --- @alias Color table<string, table<string, table<number, number, number, number>>>
-- --- @alias Vec3 table<string, table<number, number, number>>
-- --- @alias Vec2 table<string, table<number, number>>
-- --- @alias Screen table<string, table<number, number>>

-- --------------------------------------------------------------------------------

local Res = {x = game.screen_size.width, y = game.screen_size.height}


local e_key = {
	lbutton = 1,
	rbutton = 2,
	cancel = 3,
	mbutton = 4,
	xbutton1 = 5,
	xbutton2 = 6,
	back = 8,
	tab = 9,
	clear = 12,
	return_key = 13,
	shift = 16,
	control = 17,
	menu = 18,
	pause = 19,
	capital = 20,
	kana = 21,
	hanguel = 22,
	hangul = 23,
	escape = 27,
	convert = 28,
	nonconvert = 29,
	accept = 30,
	modechange = 31,
	space = 32,
	prior = 33,
	next = 34,
	end_key = 35,
	home = 36,
	left = 37,
	up = 38,
	right = 39,
	down = 40,
	select = 41,
	print = 42,
	execute = 43,
	snapshot = 44,
	insert = 45,
	delete_key = 46,
	help = 47,
	_0 = 48,
	_1 = 49,
	_2 = 50,
	_3 = 51,
	_4 = 52,
	_5 = 53,
	_6 = 54,
	_7 = 55,
	_8 = 56,
	_9 = 57,
	A = 65,
	B = 66,
	C = 67,
	D = 68,
	E = 69,
	F = 70,
	G = 71,
	H = 72,
	I = 73,
	J = 74,
	K = 75,
	L = 76,
	M = 77,
	N = 78,
	O = 79,
	P = 80,
	Q = 81,
	R = 82,
	S = 83,
	T = 84,
	U = 85,
	V = 86,
	W = 87,
	X = 88,
	Y = 89,
	Z = 90,
	n0 = 96,
	n1 = 97,
	n2 = 98,
	n3 = 99,
	n4 = 100,
	n5 = 101,
	n6 = 102,
	n7 = 103,
	n8 = 104,
	n9 = 105,
	f1 = 112,
 }


local mode = {
	Combo_key = 1,
	Harass_key = 2,
	Clear_key = 3,
	Lasthit = 4,
	Freeze = 5,
	Flee = 6,
	Idle_key = 0,
	Recalling = 0
}

local chance_strings = {
	[0] = "low",
	[1] = "medium",
	[2] = "high",
	[3] = "very_high",
	[4] = "immobile"
}

 local buff_type = {
	Internal = 0,
	Aura = 1,
	CombatEnchancer = 2,
	CombatDehancer = 3,
	SpellShield = 4,
	Stun = 5,
	Invisibility = 6,
	Silence = 7,
	Taunt = 8,
	Berserk = 9,
	Polymorph = 10,
	Slow = 11,
	Snare = 12,
	Damage = 13,
	Heal = 14,
	Haste = 15,
	SpellImmunity = 16,
	PhysicalImmunity = 17,
	Invulnerability = 18,
	AttackSpeedSlow = 19,
	NearSight = 20,
	Currency = 21,
	Fear = 22,
	Charm = 23,
	Poison = 24,
	Suppression = 25,
	Blind = 26,
	Counter = 27,
	Shred = 28,
	Flee = 29,
	Knockup = 30,
	Knockback = 31,
	Disarm = 32,
	Grounded = 33,
	Drowsy = 34,
	Asleep = 35,
	Obscured = 36,
	ClickProofToEnemies = 37,
	Unkillable = 38
 }
 local rates = { "slow", "instant", "very slow" }

dancing = false
state = "atMiddle" -- can be "atTop", "atMiddle", or "atBottom"
top, mid, bot = nil, nil, nil


 --bw doesnt evaluate there menu cfgs to a number T_T
 function get_menu_val(cfg)
	if menu:get_value(cfg) == 1 then
	  return true
	else
	  return false
	end
  end

 local function class(properties, ...)
    local cls = {}
    cls.__index = cls

    for k, v in pairs(properties) do
        cls[k] = v
    end

    for _, property in ipairs({ ... }) do
        for k, v in pairs(property) do
            cls[k] = v
        end
    end

    function cls:new(...)
        local instance = setmetatable({}, cls)
        if instance.init then
            instance:init(...)
        end
        return instance
    end

    return cls
end



--------------------------------------------------------------------------------
-- vec2
--------------------------------------------------------------------------------

--- @class vec2
local vec2 = class({
	x = 0,
	y = 0,

	init = function(self,x,y)
		self.x = x
		self.y = y
	end,
})

--------------------------------------------------------------------------------
-- vec3
--------------------------------------------------------------------------------

-- --- @class vec3
-- local vec3 = class({
-- 	x = 0,
-- 	y = 0,
-- 	z = 0,

-- 	init = function(self,x,y,z)
-- 		self.x = x
-- 		self.y = y
-- 		self.z = z
-- 	end,
-- })



--------------------------------------------------------------------------------

-- Vec3 Utility

--------------------------------------------------------------------------------




--- @class vec3Util
--- @field print fun(self:vec3Util, point:Vec3):nil
--- @field rotate fun(self:vec3Util, origin:Vec3, point:Vec3, angle:number):Vec3
--- @field translate fun(self:vec3Util, origin:Vec3, offsetX:number, offsetZ:number):Vec3
--- @field translateX fun(self:vec3Util, origin:Vec3, offsetX:number):Vec3
--- @field translateZ fun(self:vec3Util, origin:Vec3, offsetZ:number):Vec3
--- @field drawCircle fun(self:vec3Util, origin:Vec3, color:Color, radius:number):nil
--- @field drawCircleFull fun(self:vec3Util, origin:Vec3, color:Color, radius:number):nil
--- @field drawLine fun(self:vec3Util, origin:Vec3, destination:Vec3, color:Color):nil
--- @field drawBox fun(self:vec3Util, start_pos:Vec3, end_pos:Vec3, width:number, color:Color, thickness:number):nil
local vec3Util = class({
	print = function(self, point)
		print("x: " .. point.x .. " y: " .. point.y .. " z: " .. point.z)
	end,
	extend = function (self, v1, v2, dist)
		local dx = v2.x - v1.x
		local dy = v2.y - v1.y
		local dz = v2.z - v1.z
		local length = std_math.sqrt(dx * dx + dy * dy + dz * dz)
		

		-- Check if length is zero to avoid division by zero
		if length == 0 then
			return vec3.new(v1.x,v1.y,v1.z)
		end
		local scale = dist / length
		local _x = v1.x + dx * scale
		local _y = v1.y + dy * scale
		local _z = v1.z + dz * scale
		local ret = vec3.new(_x, _y, _z)

		return ret
		
	end,
	subtract = function(self, v1, v2)
		local x = v1.x - v2.x
		local y = v1.y - v2.y
		local z = v1.z - v2.z
		return vec3.new(x, y, z)
	end,
	rotate = function(self, origin, point, angle)
		local angle = angle * (std_math.pi / 180)
		local rotatedX = std_math.cos(angle) * (point.x - origin.x) - std_math.sin(angle) * (point.z - origin.z) + origin.x
		local rotatedZ = std_math.sin(angle) * (point.x - origin.x) + std_math.cos(angle) * (point.z - origin.z) + origin.z
		return vec3.new(rotatedX, point.y, rotatedZ)
	end,
	normalize = function(self, v)
		local dx = v.x
		local dy = v.y
		local dz = v.z
		local length = math.sqrt(dx * dx + dy * dy + dz * dz)
		
		-- Check if length is zero to avoid division by zero
		if length == 0 then
			return {
				x = 0,
				y = 0,
				z = 0
			}
		end
		local x = dx / length
		local y = dy / length
		local z =  dz / length
		return vec3.new(x, y, z)
	end,
	distance = function(self, start_point, end_point)
		--print all types
		-- console:log("start_point: " .. type(start_point))
		-- console:log("end_point: " .. type(end_point) .. "x: " .. end_point.x .. " y: " .. end_point.y)

		local dx = start_point.x - end_point.x
		local dy = start_point.y - end_point.y
		local dz = start_point.z - end_point.z
		
		local distance_squared = dx*dx + dy*dy + dz*dz
		return std_math.sqrt(distance_squared)
	end,

	translate = function(self, origin, offsetX, offsetZ)
		local translatedX = origin.x + offsetX
		local translatedZ = origin.z + offsetZ
		return vec3.new(translatedX, origin.y, translatedZ)
	end,

	translateX = function(self, origin, offsetX)
		local translatedX = origin.x + offsetX
		return vec3.new(translatedX, origin.y, origin.z)
	end,

	translateZ = function(self, origin, offsetZ)
		local translatedZ = origin.z + offsetZ
		return vec3.new(origin.x, origin.y, translatedZ)
	end,
	project_vector_on_segment = function(self, v1, v2, v)
		local cx, cy, ax, ay, bx, by = v.x, v.z, v1.x, v1.z, v2.x, v2.z
		local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
		local pointLine = vec3.new(ax + rL * (bx - ax), 0, ay + rL * (by - ay))
		local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
		local isOnSegment = rS == rL
		local pointSegment = isOnSegment and pointLine or vec3.new(ax + rS * (bx - ax), 0, ay + rS * (by - ay))

		return {PointSegment = pointSegment, PointLine = pointLine, IsOnSegment = isOnSegment}
	end,

	is_colliding = function(self, start_pos, end_pos, target, width)
		for i, enemy in pairs(game.players) do
			if  enemy and enemy.is_enemy and enemy.is_alive and target.champ_name ~= enemy.champ_name then       
				local ProjectionInfo = self:project_vector_on_segment(start_pos, end_pos, enemy.origin)								
				local DistSegToEnemy = vec3Util.distance(ProjectionInfo.PointSegment, enemy.origin)
				local DistToBase = vec3Util:distance(start_pos,end_pos)
				local EnemyDistToBase = vec3Util:distance(start_pos, enemy.origin)
				if ProjectionInfo.IsOnSegment and DistSegToEnemy < width + 65 and DistToBase > EnemyDistToBase then             
					return true
				end
			end
		end
		return false
	end,
	drawCircle = function(self, origin, color, radius)
		renderer:draw_circle(origin.x, origin.y, origin.z, radius, color.r, color.g, color.b, color.a)
	end,

	drawCircleFull = function(self, origin, color, radius)
		renderer:draw_circle_filled(origin.x, origin.y, origin.z, radius, color.r, color.g, color.b, color.a)
	end,

	drawLine = function(self, origin, destination, color, width)
		local width = width or 5
		local oxy = game:world_to_screen_2(origin.x, origin.y, origin.z)
		local dxy = game:world_to_screen_2(destination.x, destination.y, destination.z) 
		renderer:draw_line(oxy.x, oxy.y, dxy.x, dxy.y, width, color.r, color.g, color.b, color.a)
	end,

	drawBox = function(self, start_pos, end_pos, width, color, thickness)
		-- Calculate the direction vector
		local dir = vec3.new(end_pos.x - start_pos.x, 0, end_pos.z - start_pos.z)
		dir = dir:normalized()

		-- Calculate the half width vector
		local half_width_vec = vec3.new(-dir.z * (width), 0, dir.x * (width))

		-- Calculate the corner points of the box
		local p1 = vec3.new(start_pos.x + half_width_vec.x, start_pos.y, start_pos.z + half_width_vec.z)
		local p1xy = game:world_to_screen_2(p1.x, p1.y, p1.z)
		local p2 = vec3.new(start_pos.x - half_width_vec.x, start_pos.y, start_pos.z - half_width_vec.z)
		local p2xy = game:world_to_screen_2(p2.x, p2.y, p2.z)
		local p3 = vec3.new(end_pos.x + half_width_vec.x, end_pos.y, end_pos.z + half_width_vec.z)
		local p3xy = game:world_to_screen_2(p3.x, p3.y, p3.z)
		local p4 = vec3.new(end_pos.x - half_width_vec.x, end_pos.y, end_pos.z - half_width_vec.z)
		local p4xy = game:world_to_screen_2(p4.x, p4.y, p4.z)

		-- Draw lines connecting the corner points
		renderer:draw_line(p1xy.x, p1xy.y, p2xy.x, p2xy.y, color.r, color.g, color.b, color.a)
		renderer:draw_line(p2xy.x, p2xy.y, p3xy.x, p3xy.y, color.r, color.g, color.b, color.a)
		renderer:draw_line(p3xy.x, p3xy.y, p4xy.x, p4xy.y, color.r, color.g, color.b, color.a)
		renderer:draw_line(p4xy.x, p4xy.y, p4xy.x, p4xy.y, color.r, color.g, color.b, color.a)

		-- Draw lines connecting start and end points (vertical edges)
		renderer:draw_line(p1xy.x, p1xy.y, p3xy.x, p3xy.y, color.r, color.g, color.b, color.a)
		renderer:draw_line(p2xy.x, p2xy.y, p4xy.x, p4xy.y, color.r, color.g, color.b, color.a)
	end,
	drawText = function (self, text, pos, color, size)
		local toscreen = game:world_to_screen_2(pos.x, pos.y, pos.z)
		local size = size or 15
		renderer:draw_text_size(toscreen.x , toscreen.y, text, size, color.r, color.g, color.b, color.a)
	end
})

--------------------------------------------------------------------------------
-- Vec2 Utility
--------------------------------------------------------------------------------

--- @class vec2Util
--- @field print fun(self:vec2Util, point:Vec2):nil
--- @field rotate fun(self:vec2Util, origin:Vec2, point:Vec2, angle:number):Vec2
--- @field translate fun(self:vec2Util, origin:Vec2, offsetX:number, offsetY:number):Vec2
--- @field translateX fun(self:vec2Util, origin:Vec2, offsetX:number):Vec2
--- @field translateY fun(self:vec2Util, origin:Vec2, offsetY:number):Vec2
--- @field drawCircle fun(self:vec2Util, origin:Vec2, color:Color, radius:number):nil
--- @field drawLine fun(self:vec2Util, origin:Vec2, destination:Vec2, color:Color):nil
--- @field drawBox fun(self:vec2Util, start_pos:Vec2, end_pos:Vec2, width:number, color:Color, thickness:number):nil
local vec2Util = class({
	print = function(self, point)
		print("x: " .. point.x .. " y: " .. point.y)
	end,

	rotate = function(self, origin, point, angle)
		local angle = angle * (math.pi / 180)
		local rotatedX = math.cos(angle) * (point.x - origin.x) - math.sin(angle) * (point.y - origin.y) + origin.x
		local rotatedY = math.sin(angle) * (point.x - origin.x) + math.cos(angle) * (point.y - origin.y) + origin.y
		return vec3.new(rotatedX, rotatedY)
	end,

	translate = function(self, origin, offsetX, offsetY)
		local translatedX = origin.x + offsetX
		local translatedY = origin.y + offsetY
		return vec2:new(translatedX, translatedY)
	end,

	translateX = function(self, origin, offsetX)
		local translatedX = origin.x + offsetX
		return vec2:new(translatedX, origin.y)
	end,

	translateY = function(self, origin, offsetY)
		local translatedY = origin.y + offsetY
		return vec2:new(origin.x, translatedY)
	end,

	drawCircle = function(self, origin, color, radius)
		g_render:circle(origin, color, radius, 100)
	end,

	drawFullCircle = function(self, origin, color, radius)
		g_render:filled_circle(origin, color, radius, 100)
	end,

	drawLine = function(self, origin, destination, color)
		g_render:line(origin, destination, color, 2)
	end,

	drawBox = function(self, start, size, color)
		g_render:box(start, size, color, 0, 2)
	end,
})

--- @class color
--- @field r red
--- @field g green
--- @field b blue
--- @field a alpha
local color = class({
	r = nil,
	g = nil,
	b = nil,
	a = nil,
	name = nil,
	init = function(self, r0,g0,b0,a0)
		self.r = r0 or 0
		self.g = g0 or 0
		self.b = b0 or 0
		self.a = a0 or 0
	end,
})

--------------------------------------------------------------------------------
-- Utility
--------------------------------------------------------------------------------

--- @class util
--- @field screen Screen
--- @field screenX number
--- @field screenY number
--- @field font string
--- @field fontSize number
--- @field Colors table<string, table<string,Color>>
--- @field textAt fun(self:util, pos:Vec2, color:Color, text:string):nil
--- @field new fun(self:util):util
local util = class({
	screen = nil,
	screenX = nil,
	screenY = nil,
	font = font,
	fontSize = 30,

	Colors = {
		solid = {
			white = color:new(255, 255, 255, 255),
			black = color:new(0, 0, 0, 255),
			gray = color:new(128, 128, 128, 255),
			lightGray = color:new(192, 192, 192, 255),
			darkGray = color:new(64, 64, 64, 255),
			red = color:new(255, 0, 0, 255),
			lightRed = color:new(255, 128, 128, 255),
			darkRed = color:new(128, 0, 0, 255),
			orange = color:new(255, 127, 0, 255),
			lightOrange = color:new(255, 180, 128, 255),
			darkOrange = color:new(191, 95, 0, 255),
			yellow = color:new(255, 255, 0, 255),
			lightYellow = color:new(255, 255, 128, 255),
			darkYellow = color:new(191, 191, 0, 255),
			green = color:new(0, 255, 0, 255),
			lightGreen = color:new(128, 255, 128, 255),
			darkGreen = color:new(0, 128, 0, 255),
			cyan = color:new(0, 255, 255, 255),
			lightCyan = color:new(128, 255, 255, 255),
			darkCyan = color:new(0, 128, 128, 255),
			blue = color:new(0, 0, 255, 255),
			lightBlue = color:new(128, 128, 255, 255),
			darkBlue = color:new(0, 0, 128, 255),
			purple = color:new(143, 0, 255, 255),
			lightPurple = color:new(191, 128, 255, 255),
			darkPurple = color:new(95, 0, 191, 255),
			magenta = color:new(255, 0, 255, 255),
			lightMagenta = color:new(255, 128, 255, 255),
			darkMagenta = color:new(128, 0, 128, 255),
		},
		transparent = {
			white = color:new(255, 255, 255, 130),
			black = color:new(0, 0, 0, 130),
			gray = color:new(128, 128, 128, 130),
			lightGray = color:new(192, 192, 192, 130),
			darkGray = color:new(64, 64, 64, 130),
			red = color:new(255, 0, 0, 200),
			lightRed = color:new(255, 128, 128, 130),
			darkRed = color:new(128, 0, 0, 130),
			orange = color:new(255, 127, 0, 130),
			lightOrange = color:new(255, 180, 128, 130),
			darkOrange = color:new(191, 95, 0, 130),
			yellow = color:new(255, 255, 0, 130),
			lightYellow = color:new(255, 255, 128, 130),
			darkYellow = color:new(191, 191, 0, 130),
			green = color:new(0, 255, 0, 150),
			lightGreen = color:new(128, 255, 128, 130),
			darkGreen = color:new(0, 128, 0, 130),
			cyan = color:new(0, 255, 255, 130),
			lightCyan = color:new(128, 255, 255, 130),
			darkCyan = color:new(0, 128, 128, 130),
			blue = color:new(63, 72, 204, 200),
			lightBlue = color:new(128, 128, 255, 130),
			darkBlue = color:new(0, 0, 128, 130),
			purple = color:new(143, 0, 255, 100),
			lightPurple = color:new(191, 128, 255, 130),
			darkPurple = color:new(95, 0, 191, 130),
			magenta = color:new(255, 0, 255, 130),
			lightMagenta = color:new(255, 128, 255, 130),
			darkMagenta = color:new(128, 0, 128, 130),
		}
	},
	rift_locations = {
		["Blue_Base"] = {x = 1184, y = 95, z = 1176},
		["Red_Base"] = {x = 13500, y = 91, z = 13592},
		["Red_Recall"] = {x = 14312, y = 171, z = 14348},
		["Blue_Recall"] = {x = 420, y = 183, z = 410},
		["Blue_Bot_Tier_1"] = {x = 10452, y = 50, z = 1328},
		["Blue_Bot_Tier_2"] = {x = 7024, y = 49, z = 1282},
		["Blue_Bot_Tier_3"] = {x = 3868, y = 95, z = 880},
		["Red_Bot_Tier_1"] = {x = 13732, y = 91, z = 10426},
		["Red_Bot_Tier_2"] = {x = 13550, y = 52, z = 7848},
		["Red_Bot_Tier_3"] = {x = 13670, y = 52, z = 4282},
		["Blue_Mid_Tier_1"] = {x = 5974, y = 51, z = 6054},
		["Blue_Mid_Tier_2"] = {x = 5048, y = 50, z = 4606},
		["Blue_Mid_Tier_3"] = {x = 3880, y = 95, z = 3676},
		["Red_Mid_Tier_1"] = {x = 11218, y = 91, z = 10952},
		["Red_Mid_Tier_2"] = {x = 9810, y = 51, z = 9818},
		["Red_Mid_Tier_3"] = {x = 8814, y = 53, z = 8362},
		["Blue_Top_Tier_1"] = {x = 1130, y = 52, z = 10368},
		["Blue_Top_Tier_2"] = {x = 1164, y = 52, z = 6726},
		["Blue_Top_Tier_3"] = {x = 10022, y = -72, z = 4614},
		["Red_Top_Tier_1"] = {x = 4434, y = -67, z = 9660},
		["Red_Top_Tier_2"] = {x = 7600, y = 52, z = 13559},
		["Red_Top_Tier_3"] =  {x = 10734, y = 91, z = 13464},
		["Dragon"] = {x = 10226, y = -72, z = 4712},
		["Baron"] = {x = 5014, y = -72, z = 10096},
		["Blue_Red_Buff"] = {x = 7354, y = 51, z = 3792},
		["Blue_Blue_Buff"] = {x = 3804, y = 51, z = 7692},
		["Red_Red_Buff"] = {x = 7442, y = 56, z = 10978},
		["Red_Blue_Buff"] = {x = 11228, y = 51, z = 6624},
		["Blue_Gromp"] = {x = 2434, y = 51, z = 8272},
		["Blue_Wolves"] = {x = 3658, y = 52, z = 6174},
		["Blue_Raptors"] =  {x = 7102, y = 48, z = 4942},
		["Blue_Krugs"] = {x = 8176, y = 51, z = 2392},
		["Red_Gromp"] = {x = 12300, y = 52, z = 6360},
		["Red_Wolves"] = {x = 11206, y = 58, z = 8438},
		["Red_Raptors"] = {x = 7618, y = 51, z = 9872},
		["Red_Krugs"] = {x = 6496, y = 56, z = 12336},
		["Bot_Tri_Bush"] = {x = 10414, y = 50, z = 3048},
		["Top_Tri_Bush"] = {x = 4444, y = 56, z = 11736},
		["Top_River_Bush"] = {x = 2954, y = -73, z = 10888},
		["Bot_River_Bush"] = {x = 11838, y = -68, z = 3792},
		["Mid_Lane"] = {x = 7352, y = 54, z = 7202},
		["Bot_Lane"] = {x = 12492, y = 51, z = 2306},
		["Top_Lane"] = {x = 2161, y = 52, z = 12369},
	},


	init = function(self)
		self.screen = game.screen_size
		self.screenX = self.screen.height
		self.screenY = self.screen.width
	end,

	textAt = function(self, pos, color, text)
		renderer:draw_text(pos.x, pos.y, text, color.r, color.g, color.b, color.a)
	end,
	GetClosestRiftLocation = function(self, x, y, z)
		-- Prints("My hero position: x=" .. tostring(g_local.origin.x) .. ", y=" .. tostring(g_local.origin.y) .. ", z=" .. tostring(g_local.origin.z))
		
		local closestLocation = ""
		local shortestDistance = std_math.huge
		
		for location, coords in pairs(self.rift_locations) do
			local distance = std_math.sqrt((coords.x - x)^2 + (coords.y - y)^2 + (coords.z - z)^2)
			if distance < shortestDistance then
				closestLocation = location
				shortestDistance = distance
			end
		end
		 
		return closestLocation,std_math.floor(shortestDistance)
	end,

})

--------------------------------------------------------------------------------

-- Math

--------------------------------------------------------------------------------

local math = class({
	xHelper = nil,
	buffcache = nil,

	init = function(self, xHelper, buff_cache)
		self.xHelper = xHelper
		self.buffcache = buff_cache
	end,

	dis = function(self, p1, p2)
		return std_math.sqrt(self:DistanceSqr(p1, p2))
	end,

	dis_sq = function(self, p1, p2)
		local dx, dy = p2.x - p1.x, p2.z - p1.z
		return dx * dx + dy * dy
	end,

	angle_between = function(self, p1, p2, p3)
		local angle = std_math.deg(
			std_math.atan(p3.z - p1.z, p3.x - p1.x) -
			std_math.atan(p2.z - p1.z, p2.x - p1.x))
		if angle < 0 then angle = angle + 360 end
		return angle > 180 and 360 - angle or angle
	end,

	is_facing = function(self, source, unit)
		local dir = source.direction
		local angle = self:angle_between(source, unit, dir)
		return angle < 90
	end,

	in_aa_range = function(self, unit, raw)
		local range = unit.attack_range
		local hitbox = unit.bounding_radius or 80

		if unit.champ_name == "Aphelios" and unit.is_hero and unit:has_buff("aphelioscalibrumbonusrangedebuff") then
			range, hitbox = 1800, 0
		elseif unit.champ_name == "Caitlyn" and (unit:has_buff("caitlynwsight") or unit:has_buff("CaitlynEMissile")) then
			range = range + 650
		elseif unit.champ_name == "Zeri" and spellbook:can_cast(e_spell_slot.q) then
			range, hitbox = 825, 0
		elseif unit.champ_name == "Samira" and not unit.character_state.can_move then
			range = std_math.min(650 + 77.5 * (g_local.level - 1), 960)
		elseif unit.champ_name == "Karthus" then
			range = 1035
		end
		if raw and not self.xHelper:is_melee(g_local) then
			hitbox = 0
		end
		local dist = self:dis_sq(g_local.origin, unit.origin)
		return dist <= (range + hitbox) ^ 2
	end,

})

--------------------------------------------------------------------------------

-- Objects

--------------------------------------------------------------------------------


local objects = class({
	xHelper = nil,
	math = nil,
	database = nil,
	util = nil,

	init = function(self, xHelper, math, database, util)
		self.xHelper = xHelper
		self.math = math
		self.database = database
		self.util = util
	end,
	get_team_color = function(self, unit)
		unit = unit or g_local
		local team = unit.team
		if team == 200 then
			return 200, "red"
		elseif team == 100 then
			return 100, "blue"
		else
			return 0, nil
		end
	end,
	get_baseult_pos = function(self, unit)
		if not unit then return nil end
		local team, color = self:get_team_color(unit)


		local baseult_pos = nil
		if color == "red" then
			-- console:log("get tea1m: " .. team .. " color: " .. color)
			-- console:debug_log("get tea1m: " .. team .. " color: " .. color)
			local rift_locale = self.util.rift_locations["Red_Recall"]
			local pos = vec3.new(rift_locale.x, rift_locale.y, rift_locale.z)
			baseult_pos = pos
		elseif color == "blue" then
			baseult_pos = vec3.new(self.util.rift_locations["Blue_Recall"].x, self.util.rift_locations["Blue_Recall"].y, self.util.rift_locations["Blue_Recall"].z)
		end
		-- console:log("baseult_pos: " .. tostring(baseult_pos.x) .. " " .. tostring(baseult_pos.y) .. " " .. tostring(baseult_pos.z))
		return baseult_pos
	end,
	get_ordered_turret_targets = function(self, turret, minions)
		local turret_prio_list = {}
		local priority = {
			[3] = 1,  -- Siege Minions
			[2] = 2,  -- Melee Minions
			[1] = 3   -- Ranged Minions
			-- If Super Minions have a different priority, adjust here.
			-- Currently, Super Minions (4) will be at the end due to the default sorting mechanism.
		}
	
		for i, unit in ipairs(minions) do
			local dist = vec3Util:distance(turret.origin, unit.origin)
			table.insert(turret_prio_list, {
				minion = unit,
				distance = dist,
				prio = priority[unit.minion_type] or 4  -- defaults to 4 (lowest priority) if minion_type not in priority table
			})
		end
	
		-- Custom sort function
		table.sort(turret_prio_list, function(a, b)
			if a.prio == b.prio then
				return a.distance < b.distance
			end
			return a.prio < b.prio
		end)
	
		-- Extracting the sorted minions from the list
		local sorted_minions = {}
		for _, entry in ipairs(turret_prio_list) do
			table.insert(sorted_minions, entry.minion)
		end
	
		return sorted_minions
	end
	,
	get_bounding_radius = function(self, unit)
		return unit.bounding_radius or 45
	end,
	is_enemy_near = function(self, range, position)
		position = position or g_local.origin
		for _, entity in pairs(game.players) do
			local bounding_radius = self:get_bounding_radius(entity)
			if entity and entity.is_enemy and entity:distance_to(position) <= range + bounding_radius then
				return true
			end
		end
		return false
	end,
	get_enemy_champs = function(self, range, position)

		position = position or g_local.origin
		local enemy_champs = {}
		for i, unit in ipairs(game.players) do
			if  unit and unit.is_enemy then
				if self.xHelper:is_alive(unit) and self.xHelper:is_valid(unit)and not self.xHelper:is_invincible(unit) then
					if (range and self.math:dis_sq(position, unit.origin) <= range ^ 2 or self.math:in_aa_range(unit, true)) then
						table.insert(enemy_champs, unit)
					end
				end
			end
		end

		return enemy_champs
	end,
	get_ally_champs = function(self, range, position)
		position = position or g_local.origin
		local ally_champs = {}
		for i, unit in ipairs(game.players) do
			if unit and not unit.is_enemy and self.xHelper:is_alive(unit) and self.xHelper:is_valid(unit) and not self.xHelper:is_invincible(unit) and (range and self.math:dis_sq(position, unit.origin) <= range ^ 2 or self.math:in_aa_range(unit, true)) then
				table.insert(ally_champs, unit)
			end
		end
		return ally_champs
	end,
	get_aa_travel_time = function(self, target, unit, speed)
		unit = unit or g_local
		speed = speed or nil
		if not speed then
			local champion_name = unit.champ_name -- adjust the variable name as needed

			-- default missile speed
			speed = 1000

			-- Find the champion in the table
			local champion_data = self.database.DMG_LIST[champion_name]
			if champion_data then
				for _, ability_data in ipairs(champion_data) do
					if ability_data.slot == "AA" then
						speed = ability_data.missile_speed
						break
					end
				end
			end
		end

		local distance = unit:distance_to(target.origin)
		return distance / speed
	end,
	count_enemy_champs = function(self, range, position)
		position = position or g_local.origin
		local num = #self:get_enemy_champs(range, position) or 0
		return num
	end,
	
	get_enemy_minions = function(self, range, pos)
		pos = pos or g_local.origin
		range = range or 99999
		local enemies = {}

		for _, entity in ipairs(game.minions) do
			if entity and entity.is_enemy then
				if entity.origin and entity:distance_to(pos) <= range then
					if self.xHelper:is_alive(entity) and entity.health > 0 then
						local object_name = entity.object_name:lower()
						if string.find(object_name, "scrab") or string.find(object_name, "dragon") or string.find(object_name, "riftherald") or string.find(object_name, "baron")
							or string.find(object_name, "gromp") or string.find(object_name, "blue") or string.find(object_name, "murkwolf")
							or string.find(object_name, "razorbeak") or string.find(object_name, "red") or string.find(object_name, "krug")
							or string.find(object_name, "minion") or string.find(object_name, "minion") then 
							table.insert(enemies, entity) 
						end
					end
				end
			end



			-- end
		end
		return enemies
	end,
	count_enemy_minions = function(self, range, position)
		position = position or g_local.origin
		local mins = self:get_enemy_minions(range, position) or 0
		local count = #mins
		return count -- num
	end,
	is_big_jungle = function(self, object)
		local name = object.object_name:lower()		
		local bigJungleMonsters = {
			"sru_gromp",
			"sru_blue",
			"sru_murkwolf",
			"sru_razorbeak",
			"sru_red",
			"sru_krug",
			"sru_crab",
			"sru_dragon",
			"sru_riftherald",
			"sru_baron",
		}
	
		for _, monsterName in pairs(bigJungleMonsters) do
			if name == monsterName then
				return true
			end
		end
	
		return false
	end,
	is_ready = function(self, slot, unit)
		unit = unit or g_local
		return spellbook:can_cast(slot)
	end,
	has_enough_mana = function(self, slot, unit)
		unit = unit or g_local
		local spell = unit:get_spell_slot(slot)
		local data = spell.spell_data
		local level = spell.level or 0
		local cost = data.mana_cost or 0

		if unit and spell and cost then
			if unit.mana >= cost then
				return true
			else
				return false
			end
		end
	end,
	can_cast = function(self, slot, unit)
		unit = unit or g_local
		if self:is_ready(slot, unit) and self:has_enough_mana(slot, unit) then
			return true
		end
		return false
	end,
	get_spell_level = function(self, slot, unit)
		unit = unit or g_local
		local level = spellbook:get_spell_slot(slot).level or 0
		return level
	end,

})

--------------------------------------------------------------------------------

-- Buffs

--------------------------------------------------------------------------------
local buffcache = class({
	get_buff = function(self, unit, name)
		return unit:get_buff(name)
	end,

	get_amount = function(self, unit, name)
		return unit:get_buff(name).stacks
	end,

	get_duration = function(self, unit, name)
		local buff = unit:get_buff(name)
		return buff.duration
	end,

	has_buff = function(self, unit, name)
		return unit:has_buff(name)
	end,

})

--------------------------------------------------------------------------------

-- Helper

--------------------------------------------------------------------------------

local xHelper = class({
	HYBRID_RANGED = { "Elise", "Gnar", "Jayce", "Kayle", "Nidalee", "Zeri" },
	INVINCIBILITY_BUFFS = {
		["aatroxpassivedeath"] = true,
		["FioraW"] = true,
		["JaxCounterStrike"] = true,
		["JudicatorIntervention"] = true,
		["KarthusDeathDefiedBuff"] = true,
		["kindredrnodeathbuff"] = false,
		["KogMawIcathianSurprise"] = true,
		["SamiraW"] = true,
		["ShenWBuff"] = true,
		["TaricR"] = true,
		["UndyingRage"] = false,
		["VladimirSanguinePool"] = true,
		["ChronoShift"] = false,
		["chronorevive"] = true,
		["zhonyasringshield"] = true
	},

	buffcache = nil,

	init = function(self, buffcache)
		self.buffcache = buffcache
	end,

	is_melee = function(self, unit)
		return unit.attack_range < 300
			and self.HYBRID_RANGED[unit.champ_name] ~= nil
	end,

	get_aa_range = function(self, unit)
		local unit = unit or g_local
		if (unit.champ_name == "Karthus") then
			return 1035 + unit:get_bounding_radius()
		end
		return unit.attack_range + unit:get_bounding_radius()
	end,

	is_invincible = function(self, unit)
		for _, buff in ipairs(unit.buffs) do
			if buff and buff.duration > 0 and buff.count > 0 then
				local invincibility_buff = self.INVINCIBILITY_BUFFS[buff.name]
				if invincibility_buff ~= nil then
					if invincibility_buff == false and unit.health / unit.max_health < 0.05 then
						return true
					elseif invincibility_buff == true then
						return true
					end
				end
			end
		end
		return false
	end,

	get_percent_hp = function(self, unit)
		return 100 * unit.health / unit.max_health
	end,

	get_percent_missing_hp = function(self, unit)
		return (1 - (unit.health / unit.max_health)) * 100
	end,

	get_missing_hp = function(self, unit)
		return (unit.max_health - unit.health)
	end,

	is_alive = function(self, unit)
		local alive = unit and unit.is_valid and
			unit.is_targetable
			and not unit:has_buff("sionpassivezombie")
			and unit.origin ~= nil

		-- Prints("checking alive: " .. tostring(unit.object_name))
		-- Prints("valid: " ..tostring( unit.is_valid))
		-- Prints("visible: " .. tostring(unit.is_visible))
		-- Prints("alive: " .. tostring(unit.is_alive))
		-- Prints("targetable: " .. tostring(unit.is_targetable))
		-- print("sion: " .. tostring(self.buffcache:has_buff(unit, "sionpassivezombie")))
		-- Prints("corpse: " .. tostring(unit.object_name:lower():find("corpse")))
		-- Prints("pos: " .. tostring(unit.origin ~= nil))
		-- Prints("we will return: " .. tostring(alive))
		return alive
	end,
	is_immobile = function(self, unit)
		local ret = false
		if unit:has_buff_type(buff_type.Stun) then ret = true end
		if unit:has_buff_type(buff_type.Suppression) then ret = true end
		if unit:has_buff_type(buff_type.Snare) then ret = true end
		if unit:has_buff_type(buff_type.Knockback) then ret = true end
		if unit:has_buff_type(buff_type.Grounded) then ret = true end
		if unit:has_buff_type(buff_type.Asleep) then ret = true end

	end,
	has_hard_cc = function(self, unit)
		if not unit then console:log("has_hard_cc check died, please report to jay") return false end
		local ccd = false
		if unit:has_buff_type(buff_type.Stun) then ccd = true end
		if unit:has_buff_type(buff_type.Suppression) then ccd = true end
		if unit:has_buff_type(buff_type.Knockup) then ccd = true end
		if unit:has_buff_type(buff_type.Charm) then ccd = true end
		if unit:has_buff_type(buff_type.Fear) then ccd = true end
		if unit:has_buff_type(buff_type.Taunt) then ccd = true end
		if unit:has_buff_type(buff_type.Polymorph) then ccd = true end
		if unit:has_buff_type(buff_type.Flee) then ccd = true end
		if unit:has_buff_type(buff_type.Asleep) then ccd = true end
		if unit:has_buff_type(buff_type.Snare) then ccd = true end
		return ccd
	end,
	is_under_turret = function(self,pos,check_ally)
		check_ally = check_ally or false

		local range = 905
		local turret = nil
		
		if check_ally then
			for _, unit in ipairs(game.turrets) do
				if unit  and not unit.is_enemy and not unit.is_dead then
					local dist_away = vec3Util:distance(unit.origin, pos)
					if dist_away < range then return true, unit end
				end
			end
		else
			for _, unit in ipairs(game.turrets) do
			if unit  and unit.is_enemy and not unit.is_dead then
				local dist_away = vec3Util:distance(unit.origin, pos)
				if dist_away < range then return true, unit end
			end
			end
		end

		return false, nil
	  end,
	is_valid = function(self, unit)
		return unit and unit.is_valid and unit.is_targetable
	end,

	get_latency = function(self)
		return game.ping / 1000
	end
	
})

--------------------------------------------------------------------------------

-- Damage Library

--------------------------------------------------------------------------------

local damagelib = class({
	xHelper = nil,
	math = nil,
	database = nil,
	buffcache = nil,

	CHAMP_PASSIVES = {
		Jinx = function(self, args)
			local source = args.source -- 13.7
			if not self.buffcache:has_buff(source, "JinxQ") then return end
			args.raw_physical = args.raw_physical
				+ source.total_attack_damage * 0.1
		end,
	},
	ITEM_PASSIVES = {
		-- TODO: wait for inventory api to be added.
		[3153] = function(self, args)
			local source = args.source -- Blade of the Ruined King
			local mod = self.functions.xHelper:is_melee(source) and 0.12 or 0.08
			args.raw_physical = args.raw_physical + std_math.min(
				60, std_math.max(15, mod * args.unit.health))
		end,
		[3742] = function(self, args)
			local source = args.source -- Dead Man's Plate
			local stacks = std_math.min(100, 0) -- TODO
			args.raw_physical = args.raw_physical + 0.4 * stacks
				+ 0.01 * stacks * source.total_attack_damage
		end,
		[1056] = function(self, args) -- Doran's Ring
			args.raw_physical = args.raw_physical + 5
		end,
		[1054] = function(self, args) -- Doran's Shield
			args.raw_physical = args.raw_physical + 5
		end,
		[3124] = function(self, args)
			local source = args.source -- Guinsoo's Rageblade
			args.raw_physical = args.raw_physical +
				std_math.min(200, source.crit_chance * 200)
		end,
		[3004] = function(self, args) -- Manamune
			args.raw_physical = args.raw_physical
				+ args.source.max_mana * 0.025
		end,
		[3042] = function(self, args) -- Muramana
			args.raw_physical = args.raw_physical
				+ args.source.max_mana * 0.025
		end,
		[3115] = function(self, args) -- Nashor's Tooth_se
			args.raw_magical = args.raw_magical + 15
				+ 0.2 * args.source.ability_power
		end,
		[6670] = function(self, args) -- Noonquiver
			args.raw_physical = args.raw_physical + 20
		end,
		[6677] = function(self, args)
			local source = args.source -- Rageknife
			args.raw_physical = args.raw_physical +
				std_math.min(175, 175 * source.crit_chance)
		end,
		[1043] = function(self, args) -- Recurve Bow
			args.raw_physical = args.raw_physical + 15
		end,
		[3070] = function(self, args) -- Tear of the Goddess
			args.raw_physical = args.raw_physical + 5
		end,
		[3748] = function(self, args)
			local source = args.source -- Titanic Hydra
			local mod = self.functions.xHelper:is_melee(args.source) and { 4, 0.015 } or { 3, 0.01125 }
			local damage = mod[1] + mod[2] * args.source.max_health
			args.raw_physical = args.raw_physical + damage
		end,
		[3091] = function(self, args)
			local source = args.source -- Wit's End
			local damage = ({ 15, 15, 15, 15, 15, 15, 15, 15, 25, 35,
				45, 55, 65, 75, 76.25, 77.5, 78.75, 80 })[source.level]
			args.raw_magical = args.raw_magical + damage
		end
	},


	init = function(self, xHelper, math, database, buffcache)
		self.xHelper = xHelper
		self.math = math
		self.database = database
		self.buffcache = buffcache
	end,

	check_for_passives = function(self, args)
		local source = args.source
		local buff = self.buffcache:get_buff(source, "6672buff") -- Kraken Slayer
		if buff and buff.stacks == 3 then
			args.true_damage = args.true_damage + 50 +
				0.4 * source:get_bonus_attack_damage()
		end
		if self.buffcache:has_buff(source, "3504Buff") then -- Ardent Censer
			args.raw_magical = args.raw_magical + 4.12 + 0.88 * args.unit.level
		end
		if self.buffcache:has_buff(source, "6632buff") then -- Divine Sunderer
			args.raw_physical = args.raw_physical + 1.25 *
				source.total_attack_damage + (self.functions.xHelper:is_melee(source)
					and 0.06 or 0.03) * args.unit.max_health
		end

		if self.buffcache:has_buff(source, "3508buff") then -- Essence Reaver
			args.raw_physical = args.raw_physical + 0.4 *
				source:get_bonus_attack_damage() + source.total_attack_damage
		end

		if self.buffcache:has_buff(source, "lichbane") then -- Lich Bane
			args.raw_magical = args.raw_magical + 0.75 *
				source.total_attack_damage + 0.5 * source.ability_power
		end

		if self.buffcache:has_buff(source, "sheen") then
			args.raw_physical = args.raw_physical + source.total_attack_damage
		end

		if self.buffcache:has_buff(source, "3078trinityforce") then -- Trinity Force
			args.raw_physical = args.raw_physical + 2 * source.total_attack_damage
		end

		if self.buffcache:get_buff(source, "item6664counter") then
			if self.buffcache:get_buff(source, "item6664counter").stacks == 100 then -- Turbo Chemtank -- line 350
				local damage = 35.29 + 4.71 * source.level + 0.01 *
					source.max_health + 0.03 * source.movement_speed
				args.raw_magical = args.raw_magical + damage * 1.3
			end
		end

		local buff = self.buffcache:get_buff(source, "itemstatikshankcharge")
		local damage = buff and buff.stacks == 100 and 0 or 0

		if buff then -- Kircheis Shard, Rapid Firecannon, Stormrazor
			damage = buff.stacks == 100 and 80 or 0
		end

		args.raw_magical = args.raw_magical + damage
	end,

	calc_aa_dmg = function(self, source, target)
		local idx = target.object_id
		local name = source.champ_name
		local physical = source.total_attack_damage
		local args = {
			raw_magical = 0,
			raw_physical = physical,
			true_damage = 0,
			source = source,
			unit = game:get_object(idx)
		}
		if name == "Corki" and physical > 0 then
			return
				self:calc_mixed_dmg(source, game:get_object(idx), physical)
		end
		local items = {}
		for i = 6, 12 do
			local slot = i
			local item = spellbook:get_spell_slot(slot)
			items[#items + 1] = item
		end

		self:check_for_passives(args) -- TODO: check if this is correct
		if self.CHAMP_PASSIVES[name] then self.CHAMP_PASSIVES[name](self, args) end

		local magical = self:calc_ap_dmg(source, game:get_object(idx), args.raw_magical)
		local physical = self:calc_ad_dmg(source, game:get_object(idx), args.raw_physical)

		return magical + physical + args.true_damage
	end,

	calc_dmg = function(self, source, target, amount)
		return source.ability_power > source.total_attack_damage

			and self:calc_ap_dmg(source, target, amount)
			or self:calc_ad_dmg(source, target, amount)
	end,

	calc_ap_dmg = function(self, source, target, amount)
		-- local dmg = getdmg("spell", target, source, stage)
		-- local Dmg = getdmg("Q", target, self.myHero, 1)

		return target:calculate_magic_damage(amount)
	end,

	calc_ad_dmg = function(self, source, target, amount)
				-- return 0
		return target:calculate_phys_damage(amount)
	end,

	calc_spell_dmg = function(self, spell, source, target, stage, level)

		local source = source or g_local
		local stage = stage or 1
		local cache = {}

		if stage > 4 then stage = 4 end

		if spell == "Q" or spell == "W" or spell == "E" or spell == "R" or spell == "QM" or spell == "WM" or spell == "EM" then
			local level = level or source:get_spell_book():get_spell_slot((
				{ ["Q"] = e_spell_slot.q, ["QM"] = e_spell_slot.q, ["W"] = e_spell_slot.w, ["WM"] = e_spell_slot.w,
					["E"] = e_spell_slot.e, ["EM"] = e_spell_slot.e, ["R"] = e_spell_slot.r }
			)[spell]).level

			if level <= 0 then return 0 end
			if level > 5 then level = 5 end

			if self.database.DMG_LIST[source.champ_name:lower()] then


				for _, spells in ipairs(self.database.DMG_LIST[source.champ_name:lower()]) do
					if spells.slot == spell then
						table.insert(cache, spells)
					end
				end

				if stage > #cache then stage = #cache end

				for v = #cache, 1, -1 do
					local spells = cache[v]
					if spells.stage == stage then
						local dmg = spells.damage(self, source, target, level)
						
						return self:calc_dmg(source, target, dmg)
					end
				end
			else
				return 0
			end

		end

		if spell == "AA" then
			return self:calc_aa_dmg(source, target)
		end

		if spell == "IGNITE" then
			return 50 + 20 * source.level - (target.total_health_regen * 3)
		end

		if spell == "SMITE" then
			if stage == 1 then
				if target:is_hero() then
					return 0
				end
				return 600 -- Smite
			end

			if stage == 2 then
				if target:is_hero() then
					return 80 + 80 / 17 * (source.level - 1)
				end
				return 900
			end

			if stage == 3 then
				if target:is_hero() then
					return 80 + 80 / 17 * (source.level - 1)
				end
				return 1200
			end
		end

		return 0
	end,

})

--------------------------------------------------------------------------------

-- Database

--------------------------------------------------------------------------------

local database = class({
	xHelper = nil,

	init = function(self, xHelper)
		self.xHelper = xHelper
	end,

	DASH_LIST = {
		Rakan        = { e_spell_slot.w, e_spell_slot.e },
		Renekton     = { e_spell_slot.e },
		Nocturne     = { e_spell_slot.r },
		Caitlyn      = { e_spell_slot.e },
		Poppy        = { e_spell_slot.e },
		Zeri         = { e_spell_slot.e },
		Samira       = { e_spell_slot.e },
		Talon        = { e_spell_slot.q, e_spell_slot.e },
		Thresh       = { e_spell_slot.q },
		Tristana     = { e_spell_slot.w },
		Tryndamere   = { e_spell_slot.e },
		Riven        = { e_spell_slot.q1, e_spell_slot.q2, e_spell_slot.q3, e_spell_slot.e },
		Urgot        = { e_spell_slot.e },
		Shaco        = { e_spell_slot.q },
		Xinzhao      = { e_spell_slot.e },
		Yasuo        = { e_spell_slot.e },
		Gnar         = { e_spell_slot.e },
		Jayce        = { e_spell_slot.q },
		Shen         = { e_spell_slot.e },
		Aatrox       = { e_spell_slot.e },
		Shyvana      = { e_spell_slot.r },
		Akali        = { e_spell_slot.e, e_spell_slot.r },
		Sylas        = { e_spell_slot.e },
		Monkeyking   = { e_spell_slot.w, e_spell_slot.e },
		Vayne        = { e_spell_slot.q },
		Vex          = { e_spell_slot.r },
		Vi           = { e_spell_slot.q },
		Viego        = { e_spell_slot.w },
		Zac          = { e_spell_slot.e },
		Volibear     = { e_spell_slot.r },
		Diana        = { e_spell_slot.e },
		Warwick      = { e_spell_slot.q, e_spell_slot.r },
		Rell         = { e_spell_slot.w },
		Elise        = { e_spell_slot.q },
		Ekko         = { e_spell_slot.e },
		Corki        = { e_spell_slot.w },
		Yone         = { e_spell_slot.q, e_spell_slot.r },
		Fiddlesticks = { e_spell_slot.r },
		Camille      = { e_spell_slot.e },
		Zed          = { e_spell_slot.w, e_spell_slot.r },
		Fizz         = { e_spell_slot.q },
		Galio        = { e_spell_slot.e },
		Amumu        = { e_spell_slot.q },
		Garen        = { e_spell_slot.q },
		Alistar      = { e_spell_slot.w },
		Malphite     = { e_spell_slot.r },
		Gragas       = { e_spell_slot.e },
		Ahri         = { e_spell_slot.r },
		Gwen         = { e_spell_slot.e },
		Illaoi       = { e_spell_slot.w },
		Sejuani      = { e_spell_slot.q },
		Irelia       = { e_spell_slot.q },
		Ziggs        = { e_spell_slot.w },
		Azir         = { e_spell_slot.e },
		Belveth      = { e_spell_slot.q },
		Jax          = { e_spell_slot.q },
		Yuumi        = { e_spell_slot.w },
		Evelynn      = { e_spell_slot.e },
		Ezreal       = { e_spell_slot.e },
		Nidalee      = { e_spell_slot.w },
		Fiora        = { e_spell_slot.q },
		Quinn        = { e_spell_slot.e },
		Jarvaniv     = { e_spell_slot.q, e_spell_slot.r },
		Kaisa        = { e_spell_slot.r },
		Ksante       = { e_spell_slot.w, e_spell_slot.e, e_spell_slot.r },
		Ivern        = { e_spell_slot.q },
		Kassadin     = { e_spell_slot.r },
		Kalista      = { e_spell_slot.q },
		Braum        = { e_spell_slot.w },
		Katarina     = { e_spell_slot.e },
		Kayn         = { e_spell_slot.q },
		KhaZix       = { e_spell_slot.e },
		Kindred      = { e_spell_slot.q },
		Leona        = { e_spell_slot.e },
		MasterYi     = { e_spell_slot.q },
		Leblanc      = { e_spell_slot.w, e_spell_slot.r },
		LeeSin       = { e_spell_slot.q, e_spell_slot.w },
		Lillia       = { e_spell_slot.w },
		Lissandra    = { e_spell_slot.e },
		Lucian       = { e_spell_slot.e },
		Graves       = { e_spell_slot.e },
		Pyke         = { e_spell_slot.e },
		Maokai       = { e_spell_slot.w },
		Kled         = { e_spell_slot.e },
		Hecarim      = { e_spell_slot.e, e_spell_slot.r },
		Nilah        = { e_spell_slot.e },
		RekSai       = { e_spell_slot.e, e_spell_slot.r },
		-- Rengar? passive TODO
		Orrn         = { e_spell_slot.e },
		Pantheon     = { e_spell_slot.w },
		Nautilus     = { e_spell_slot.q },
		Qiyana       = { e_spell_slot.w, e_spell_slot.e },
		Sion         = { e_spell_slot.e },
	},

	DMG_LIST = {
		jinx = { -- 13.6
			{
				slot = "AA",
				stage = 1,
				damage_type = 1,
				missile_speed = 1700
			},
			{
				slot = "Q",
				stage = 1,
				damage_type = 1,
				damage = function(self, source, target, level) return 0.1 * g_local.total_attack_damage end
			},
			{
				slot = "W",
				stage = 1,
				damage_type = 1,
				damage = function(self, source, target, level)
					return ({ 10, 60, 110, 160, 210 })[level] +
						1.6 * g_local.total_attack_damage
				end
			},
			{
				slot = "E",
				stage = 1,
				damage_type = 2,
				damage = function(self, source, target, level)
					return ({ 70, 120, 170, 220, 270 })[level] +
						g_local.ability_power
				end
			},
			{
				slot = "R",
				stage = 1,
				damage_type = 1,
				damage = function(self, source, target, level)
					local distance = source:distance_to(target.origin)
					local jinx_multiplier

					if distance >= 1500 then
						jinx_multiplier = 1
					elseif distance <= 100 then
						jinx_multiplier = 0.1
					else
						local dist = distance
						if dist > 1500 then dist = 1500 end
						jinx_multiplier = ((distance) / (1500))
					end

					local lvldmg = ({ 300, 450, 600 })[level]
					local ad_bonus = (1.5 * g_local.bonus_attack_damage)
					local missing_hp_bonus = ({ 25, 30, 35 })[level] / 100 * self.xHelper:get_missing_hp(target)

					local dmg = (lvldmg + ad_bonus + missing_hp_bonus) * jinx_multiplier
					return dmg
				end
			},
		},
		sion = { -- 13.6
			{
				slot = "Q",
				stage = 1,
				damage_type = 1,
				damage = function(self, source, target, level)
					return 0
				end
			},
			{
				slot = "W",
				stage = 1,
				damage_type = 2,
				damage = function(self, source, target, level)
					return 0
				end
			},
			{
				slot = "E",
				stage = 1,
				damage_type = 2,
				damage = function(self, source, target, level)
					return 0
				end
			},
			{
				slot = "R",
				stage = 1,
				damage_type = 1,
				damage = function(self, source, target, level)
					return 0
				end
			},
		},
	},
	add_champion_data = function(self, new_dmg_data)
		for champ_name, dmg_data in pairs(new_dmg_data) do
			print(champ_name)
			print(dmg_data)
			if self.DMG_LIST[champ_name] then
				for _, new_dmg_entry in ipairs(dmg_data) do
					table.insert(self.DMG_LIST[champ_name], new_dmg_entry)
				end
			else
				self.DMG_LIST[champ_name] = dmg_data
			end
		end
	end,
	has_dash = function(self, unit)
		if self.DASH_LIST[unit.champ_name] == nil then return false end
		return true
	end,

	has_dash_available = function(self, unit)
		local champion = unit.champ_name
		local dash_spells = self.DASH_LIST[champion]

		if not dash_spells then
			return false
		end

		for _, slot in ipairs(dash_spells) do
			if unit:get_spell_book():get_spell_slot(slot):is_ready() then
				return true
			end
		end

		return false
	end,

})

--------------------------------------------------------------------------------

-- Target Selector // very experimental and wip. needs to be improved.

--------------------------------------------------------------------------------

local Weight = {}
Weight.__index = Weight

function Weight.new(distance, damage, priority, health)
	local self = setmetatable({}, Weight)
	self.distance = distance
	self.damage = damage
	self.priority = priority
	self.health = health
	self.total = 0
	return self
end

local Target = {}
Target.__index = Target

function Target.new(unit, weight)
	local self = setmetatable({}, Target)
	self.unit = unit
	self.weight = weight
	return self
end

local target_selector = class({
	xHelper = nil,
	math = nil,
	objects = nil,
	damagelib = nil,

	
	nav = XTSMenuCat,

	ts_sec = nil,
	ts_enabled = false,
	drawings_sec = nil,
	debug_sec = nil,
	weight_sec = nil,

	focus_target = true,
	draw_target = true,
	draw_weight = false,
	weight_mode = true,

	weight_dis = 0,
	weight_dmg = 0,
	weight_prio = 0,
	weight_hp = 0,

	lastForceChange = 0,
	forceTargetMaxDistance = 240,

	init = function(self, xHelper, math, objects, damagelib)

		
		self.xHelper = xHelper
		self.math = math
		self.objects = objects
		self.damagelib = damagelib

		
		if XTSMenuCat == nil then XTSMenuCat = menu:add_category("xTarget Selector")  end
		self.nav = XTSMenuCat
	

		self.ts_sec = menu:add_subcategory("target selector", self.nav)
		self.drawings_sec = menu:add_subcategory("drawings", self.nav)
		self.debug_sec = menu:add_subcategory("debug", self.nav)
		self.weight_sec = menu:add_subcategory("weight", self.nav)
		
		self.ts_enabled= menu:add_checkbox("enabled", self.ts_sec, 1)
		
		self.focus_target = menu:add_checkbox("click to focus", self.ts_sec, 1)
		
		self.forceTargetMaxDistance = menu:add_slider("max distance", self.ts_sec, 50, 500, 240)
		
		self.draw_target = menu:add_checkbox("visualize targets", self.drawings_sec, 1)
		
		self.draw_weight = menu:add_checkbox("draw weight", self.debug_sec, 0)
		
		self.weight_mode = menu:add_checkbox("use weight mode", self.weight_sec, 1)
		
		-- Assuming the callback function needs to remain empty
		self.debug_sec_button = menu:add_button("made w/ love by ampx", self.debug_sec, function() end)
		
		self.weight_dis = menu:add_slider("distance", self.weight_sec, 0, 100, 10)
		self.weight_dmg = menu:add_slider("damage", self.weight_sec, 0, 100, 10)
		self.weight_prio = menu:add_slider("priority", self.weight_sec, 0, 100, 10)
		self.weight_hp = menu:add_slider("health", self.weight_sec, 0, 100, 15)
		
		self.lastForceChange = game.game_time
	end,

	GET_STATUS = function(self,new_state)
		return get_menu_val(self.ts_enabled)
	end,
	TOGGLE_STATUS = function(self,new_state)
		new_state = new_state or nil
		local control_id = self.ts_enabled
		local was_enabled = self:GET_STATUS()

		-- Prints("was_enabled1: " .. tostring(new_state))
		if new_state == nil then
			if was_enabled  
				then new_state = 1

				else new_state = 0
			end
		end
		local invis_menu = menu:is_sub_category_hidden(self.nav)
		if new_state == 0 then 
			if not invis_menu then menu:hide_sub_category(self.nav) end
		elseif new_state == 1 then
			if invis_menu then menu:show_sub_category(self.nav)end
		end
				-- body


		-- print("swapping toooo " .. new_state)
		-- local new_status = not status
		menu:set_value(control_id, new_state)
		return new_state
	end,

	FORCED_TARGET = nil,
	PRIORITY_LIST = {
		Aatrox = 3,
		Ahri = 4,
		Akali = 4,
		Akshan = 5,
		Alistar = 1,
		Amumu = 1,
		Anivia = 4,
		Annie = 4,
		Aphelios = 5,
		Ashe = 5,
		AurelionSol = 4,
		Azir = 4,
		Bard = 3,
		Belveth = 3,
		Blitzcrank = 1,
		Brand = 4,
		Braum = 1,
		Caitlyn = 5,
		Camille = 4,
		Cassiopeia = 4,
		Chogath = 1,
		Corki = 5,
		Darius = 2,
		Diana = 4,
		DrMundo = 1,
		Draven = 5,
		Ekko = 4,
		Elise = 3,
		Evelynn = 4,
		Ezreal = 5,
		FiddleSticks = 3,
		Fiora = 4,
		Fizz = 4,
		Galio = 1,
		Gangplank = 4,
		Garen = 1,
		Gnar = 1,
		Gragas = 2,
		Graves = 4,
		Gwen = 3,
		Hecarim = 2,
		Heimerdinger = 3,
		Illaoi = 3,
		Irelia = 3,
		Ivern = 1,
		Janna = 2,
		JarvanIV = 3,
		Jax = 3,
		Jayce = 4,
		Jhin = 5,
		Jinx = 5,
		Kaisa = 5,
		Kalista = 5,
		Karma = 4,
		Karthus = 4,
		Kassadin = 4,
		Katarina = 4,
		Kayle = 4,
		Kayn = 4,
		Kennen = 4,
		Khazix = 4,
		Kindred = 4,
		Kled = 2,
		KogMaw = 5,
		KSante = 2,
		Leblanc = 4,
		LeeSin = 3,
		Leona = 1,
		Lillia = 4,
		Lissandra = 4,
		Lucian = 5,
		Lulu = 3,
		Lux = 4,
		Malphite = 1,
		Malzahar = 3,
		Maokai = 2,
		MasterYi = 5,
		Milio = 3,
		MissFortune = 5,
		MonkeyKing = 3,
		Mordekaiser = 4,
		Morgana = 3,
		Nami = 3,
		Nasus = 2,
		Nautilus = 1,
		Neeko = 4,
		Nidalee = 4,
		Nilah = 5,
		Nocturne = 4,
		Nunu = 2,
		Olaf = 2,
		Orianna = 4,
		Ornn = 2,
		Pantheon = 3,
		Poppy = 2,
		Pyke = 4,
		Qiyana = 4,
		Quinn = 5,
		Rakan = 3,
		Rammus = 1,
		RekSai = 2,
		Rell = 5,
		Renata = 3,
		Renekton = 2,
		Rengar = 4,
		Riven = 4,
		Rumble = 4,
		Ryze = 4,
		Samira = 5,
		Sejuani = 2,
		Senna = 5,
		Seraphine = 4,
		Sett = 2,
		Shaco = 4,
		Shen = 1,
		Shyvana = 2,
		Singed = 1,
		Sion = 1,
		Sivir = 5,
		Skarner = 2,
		Sona = 3,
		Soraka = 4,
		Swain = 3,
		Sylas = 4,
		Syndra = 4,
		TahmKench = 1,
		Taliyah = 4,
		Talon = 4,
		Taric = 1,
		Teemo = 4,
		Thresh = 1,
		Tristana = 5,
		Trundle = 2,
		Tryndamere = 4,
		TwistedFate = 4,
		Twitch = 5,
		Udyr = 2,
		Urgot = 2,
		Varus = 5,
		Vayne = 5,
		Veigar = 4,
		Velkoz = 4,
		Vex = 4,
		Vi = 2,
		Viego = 4,
		Viktor = 4,
		Vladimir = 3,
		Volibear = 2,
		Warwick = 2,
		Xayah = 5,
		Xerath = 4,
		Xinzhao = 3,
		Yasuo = 4,
		Yone = 4,
		Yorick = 2,
		Yuumi = 2,
		Zac = 1,
		Zed = 4,
		Zeri = 5,
		Ziggs = 4,
		Zilean = 3,
		Zoe = 4,
		Zyra = 3
	},
	TARGET_CACHE = {},
	WEIGHT_CACHE = {
		function(self, a, b)
			return b.health / a.health
		end
	},

	get_cache = function(self, range)
		return self.TARGET_CACHE[range]
	end,

	refresh_targets = function(self, range)
		if not self.TARGET_CACHE[range] then
			self.TARGET_CACHE[range] = { enemies = {} }
		end
		

		local all_enemies = self.objects:get_enemy_champs(range)

		local enemies = {}

		for _, enemy in ipairs(all_enemies) do
			if not self.xHelper:is_invincible(enemy) then
				table.insert(enemies, enemy)
			end
		end

		for i = 1, #enemies do
			local weight = { total = 0 }
			for j = 1, #enemies do
				if i ~= j then
					for k, func in ipairs(self.WEIGHT_CACHE) do
						weight[k] = (weight[k] or 0) + func(self, enemies[i], enemies[j])
					end
				end
			end

			local target = self.TARGET_CACHE[range].enemies[i] or {}
			local new_weight = {}

			local d = self.math:dis_sq(g_local.origin, enemies[i].origin)
			local w = 10000 / (1 + std_math.sqrt(d))
			if not self.xHelper:is_melee(enemies[i]) then
				w = w * menu:get_value(self.weight_dis) / 10
			else
				w = w *
					(menu:get_value(self.weight_dis) / 10 + 1)
			end

			local factor = {
				damage = menu:get_value(self.weight_dmg),
				prio = menu:get_value(self.weight_prio) / 10,
				health = menu:get_value(self.weight_hp) / 10
			}

			local _dmg = getdmg("AA", enemies[i], g_local, 1)
			new_weight.damage = (_dmg / (1 + enemies[i].health) * 20) * factor.damage
			local mod = { 1, 1.5, 1.75, 2, 2.5 }
			new_weight.priority = mod[self.PRIORITY_LIST[enemies[i].champ_name] or 3] * factor.prio
			new_weight.health = (weight[2] or 0) * factor.health * factor.health
			new_weight.total = w + new_weight.damage + new_weight.priority + new_weight.health
			if not target.target or new_weight.total ~= target.weight.total then
				target.target = enemies[i]
				target.weight = new_weight
				self.TARGET_CACHE[range].enemies[i] = target
			end
		end

		table.sort(self.TARGET_CACHE[range].enemies, function(a, b) return a.weight.total > b.weight.total end)
	end,

	get_main_target = function(self, range)


		range = range or 9999999
		self:refresh_targets(range)

		if #self.TARGET_CACHE[range].enemies == 0 then return nil end
		local target = game:get_object(self.TARGET_CACHE[range].enemies[1].target.object_id)
		local good_target = target and not xHelper:is_invincible(target) and tostring(xHelper:is_alive(target)) and
		xHelper:is_valid(target)

		
		if target and good_target then return target end
		return nil
	end,

	get_second_target = function(self, range)
		range = range or 9999999
		self:refresh_targets(range)
		if #self.TARGET_CACHE[range].enemies < 2 then return nil end
		return game:get_object(self.TARGET_CACHE[range].enemies[2].target.object_id)
	end,

	get_forced_target = function(self)
		return self.FORCED_TARGET
	end,

	update_forced_target = function(self)
		if self.FORCED_TARGET then
			local enemy = game:get_object(self.FORCED_TARGET.object_id)
			if enemy and self.xHelper:is_alive(enemy) and self.xHelper:is_valid(enemy) and not self.xHelper:is_invincible(enemy) then
				self.FORCED_TARGET = enemy
			else
				self.FORCED_TARGET = nil
			end
		end
	end,

	get_targets = function(self, range)
		self:refresh_targets(range)
		return self.TARGET_CACHE[range].enemies
	end,

	force_target = function(self)

		if menu:get_value(self.focus_target) and self:GET_STATUS() and game:is_key_down(e_key.lbutton) and game.game_time - self.lastForceChange >= 0.3 then
			local target = nil
			local mousePos = game.mouse_2d
			local lowestDistance = std_math.huge
			local maxDistance = menu:get_value(self.forceTargetMaxDistance) or 240
			for i, enemy in ipairs(game.players) do
				if enemy and enemy.is_enemy and xHelper:is_alive(enemy) and xHelper:is_valid(enemy) and not xHelper:is_invincible(enemy) then
					local eorgin = game:world_to_screen_2(enemy.origin.x, enemy.origin.y, enemy.origin.z)
					local dist = vec3Util:distance(mousePos, eorgin)
					if dist < maxDistance and dist < lowestDistance then
						target = enemy
						lowestDistance = dist
					end
				end
			end


			if not target or (target and self.FORCED_TARGET and self.FORCED_TARGET.object_id == target.object_id) then
				self.FORCED_TARGET = nil
				self.lastForceChange = game.game_time
			else
				self.FORCED_TARGET = target
				self.lastForceChange = game.game_time
			end
		end

	end,

	draw = function(self)
		if not self:GET_STATUS() then return end
		local cache = self:get_cache(9999999)
		local forced = self:get_forced_target()

		if forced and menu:get_value(self.focus_target) and menu:get_value(self.draw_target) then
			-- local targetHpBarPos = forced:get_hpbar_position()
			-- local left = vec2Util:translate(targetHpBarPos, util.screenX * -0.02, util.screenY * -0.15)
			-- local right = vec2Util:translate(targetHpBarPos, util.screenX * 0.02, util.screenY * -0.15)
			-- local center = vec2Util:translate(targetHpBarPos, 0, util.screenY * -0.1)

			-- local textSize = g_render:get_text_size("FORCED", util.font, util.fontSize + 5)
			-- local boxPaddingX = util.screenX * 0.01
			-- local boxPaddingY = util.screenY * 0.01
			-- local boxSize = vec2:new(textSize.x + boxPaddingX, textSize.y + boxPaddingY)
			-- local textPos = vec2Util:translate(targetHpBarPos, textSize.x * -0.5, util.screenY * 0.125)
			-- local boxPos = vec2Util:translate(textPos, boxPaddingX * -0.5, boxPaddingY * -0.5)
			-- g_render:filled_box(boxPos, boxSize, util.Colors.solid.gray, 5)
			-- g_render:text(textPos, util.Colors.solid.cyan, "FORCED", util.font, util.fontSize + 5)
			-- g_render:filled_triangle(left, right, center, util.Colors.solid.yellow)

			-- vec3Util:drawCircle(forced.origin, util.Colors.solid.magenta, 100)

			vec3Util:drawCircleFull(forced.origin, util.Colors.transparent.magenta, objects:get_bounding_radius(forced) or 100)
		end
		if cache and cache.enemies then
			for i, data in ipairs(cache.enemies) do
				local target = game:get_object(data.target.object_id)
				if menu:get_value(self.draw_target) and target.is_visible then
					if i == 1 and not forced then
						vec3Util:drawCircleFull(target.origin, color:new(255, 0, 0, 55), target.get_bounding_radius or 100)
					end
				end

				if menu:get_value(self.draw_weight) then
					local toscreen = game:world_to_screen_2(target.origin.x, target.origin.y, target.origin.z)
					if toscreen ~= nil then
						renderer:draw_text_size(toscreen.x + 60, toscreen.y - 10, data.weight.total .. "", 15, 255, 255, 255, 255)
					end
				end
			end
		end
	end,

	tick = function(self)
		if not menu:get_value(self.ts_enabled) then return end
		self:force_target() 
		self:update_forced_target()
		self:get_main_target()
	end

})


-- ------------------------------------------------------------------------------

-- Permashow

-- ------------------------------------------------------------------------------

local permashow = class({
	hotkeys_ordered = {},
	hotkeys_id = {},
	title = "PERMASHOW",
	width = 100,
	height = 100,
	dragging = false,
	drag_x = 0,
	drag_y = 0,

	nav = nil,

	ps_sec = nil,
	draw_sec = nil,

	ps_enable = false,

	x = 0,
	y = 0,

	ps_color_bg_r = 0,
	ps_color_bg_g = 0,
	ps_color_bg_b = 0,
	ps_color_bg_a = 0,

	ps_color_text_r = 0,
	ps_color_text_g = 0,
	ps_color_text_b = 0,
	ps_color_text_a = 0,

	init = function(self)
		if XPermashowMenuCat == nil then 
			XPermashowMenuCat = menu:add_category("permashow")
		end
		
		self.nav = XPermashowMenuCat

		self.ps_sec = menu:add_subcategory("permashow", self.nav)
		self.draw_sec = menu:add_subcategory("color settings", self.nav)
	
		self.ps_enable = menu:add_checkbox("enabled", self.ps_sec, 1)
	
		self.x = menu:add_slider("x", self.ps_sec, 0, game.screen_size.width, 0)
		self.y = menu:add_slider("y", self.ps_sec, 0, game.screen_size.height, 0)
	
		self.ps_color_bg_r = menu:add_slider("bg r", self.draw_sec, 0, 255, 0)
		self.ps_color_bg_g = menu:add_slider("bg g", self.draw_sec, 0, 255, 0)
		self.ps_color_bg_b = menu:add_slider("bg b", self.draw_sec, 0, 255, 0)
		self.ps_color_bg_a = menu:add_slider("bg a", self.draw_sec, 0, 255, 180)
	
		self.ps_color_text_r = menu:add_slider("text r", self.draw_sec, 0, 255, 255)
		self.ps_color_text_g = menu:add_slider("text g", self.draw_sec, 0, 255, 255)
		self.ps_color_text_b = menu:add_slider("text b", self.draw_sec, 0, 255, 255)
		self.ps_color_text_a = menu:add_slider("text a", self.draw_sec, 0, 255, 255)
	end,

	rect = function(self, x, y, width, height)
		return {
			x = x,
			y = y,
			width = width,
			height = height
		}
	end,

	update_keys = function(self)
		local key = -1
		for _, hotkey in ipairs(self.hotkeys_ordered) do
			if #hotkey.key == 1 then
				key = e_key[string.upper(hotkey.key)]
			else
				key = e_key[hotkey.key]
			end
			local key_pressed = game:is_key_down(key)

			if hotkey.isToggle then
				if key_pressed ~= hotkey.prev_key_pressed and key_pressed then
					local time_diff = game.game_time - hotkey.last_update
					if time_diff >= 0.3 then
						hotkey.last_update = game.game_time

						-- Toggle the associated config_var
						if hotkey.config_var then	
							local currentValue = menu:get_value(hotkey.config_var)
							if currentValue == 0 then
								menu:set_value(hotkey.config_var, 1)
								hotkey.state = true
							elseif currentValue == 1 then
								menu:set_value(hotkey.config_var, 0)
								hotkey.state = false
							end				
						end
						--print curretn state
						-- console:log("toggled too hotkey: " .. hotkey.name .. " state: " .. tostring(hotkey.state))
					end
				end
			else
				hotkey.state = key_pressed
			end
			hotkey.prev_key_pressed = key_pressed
		end
	end,

	get_state_text_and_color = function(self, hotkey)
		local state_text, state_color
	
		-- Determine the on state: 
		-- - It's true if hotkey.state is explicitly true
		-- - It's true if hotkey.state is 1
		-- - Otherwise, it's false
		local isOn = hotkey.state == true or hotkey.state == 1
	
		if isOn then
			state_text = "[ON]"
			state_color = color:new(55, 255, 55, 255)
		else
			state_text = "[OFF]"
			state_color = color:new(255, 55, 55, 255)
		end
	
		-- console:log(hotkey.name  .. " will get state: " .. state_text)
		-- console:log(hotkey.name  .. " has state: " .. tostring(isOn))
	
		return state_text, state_color
	end,
	
	

	draw = function(self)
		if menu:get_value(self.ps_enable) == 0 then return false end

		if self.dragging then
			-- console:log("dragging...")
			local pos = game.mouse_2d
			local newX = pos.x - self.drag_x
			local newY = pos.y - self.drag_y
		
			menu:set_value(self.x, newX)
			menu:set_value(self.y, newY)
		end
		

		-- console:log("before coords " .. menu:get_value(self.x) .. " " .. menu:get_value(self.y))

		local x = menu:get_value(self.x)
		local y = menu:get_value(self.y)

		-- console:log(" after coords " .. x .. " " .. y)


		local text_size = 80 -- controls the title text position -- seems to bee offset from the right
		local text_width = text_size + 20
		local tx = x + (self.width - text_width) / 2

		local count, height = 0, 0

		for _, hotkey in pairs(self.hotkeys_ordered) do
			if hotkey.name then
				count = count + 1
				local text = hotkey.name .. " [" .. hotkey.key .. "] "
				local size =  {x=200,y=15} -- g_render:get_text_size(text, font, 15)
				local state_size = vec2:new(40, 20)

				renderer:draw_text_size(x + 15, y+30+(count - 1) *20, text, 15, menu:get_value(self.ps_color_text_r), menu:get_value(self.ps_color_text_g), menu:get_value(self.ps_color_text_b), menu:get_value(self.ps_color_text_a))

				hotkey.state_rect = self:rect(x + 10 + size.x, y + 28 + (height - 1) * 20, state_size.x, state_size.y)

				local state_text, state_color = self:get_state_text_and_color(hotkey)
				local state_x = x + 100 + size.x + (state_size.x - size.x) / 2
				local state_y = y + 28 + (count - 1) * 20 + (state_size.y - size.y) / 2

				renderer:draw_text_size(state_x, state_y, state_text, 15, state_color.r, state_color.g, state_color.b, state_color.a)

				height = std_math.max(height, size.x + state_size.x)
			end
		end

		local content_height = count * 20 + 30
		if content_height > self.height then self.height = height end

		self.width = std_math.max(text_width, height + 20)

		renderer:draw_rect(x, y, self.width, self.height, menu:get_value(self.ps_color_bg_r), menu:get_value(self.ps_color_bg_g), menu:get_value(self.ps_color_bg_b), menu:get_value(self.ps_color_bg_a)) -- bg box
		renderer:draw_rect(x, y, self.width, 25,          menu:get_value(self.ps_color_bg_r), menu:get_value(self.ps_color_bg_g), menu:get_value(self.ps_color_bg_b), menu:get_value(self.ps_color_bg_a)) -- title box

		renderer:draw_text_size(tx + 10, y + 5, self.title, 15,   menu:get_value(self.ps_color_text_r), menu:get_value(self.ps_color_text_g), menu:get_value(self.ps_color_text_b), menu:get_value(self.ps_color_text_a))

	end,

	set_title = function(self, title)
		self.title = title 
	end,

	tick = function(self)
		if not menu:get_value(self.ps_enable) then
			return
		end
		local pos = game.mouse_2d
		if game:is_key_down(e_key.lbutton) then
			
			if self:is_point_inside(pos) then			
				self.dragging = true
				self.drag_x = pos.x - menu:get_value(self.x)
				self.drag_y = pos.y - menu:get_value(self.y)
				return true
			end
			
			-- for i, hotkey in ipairs(self.hotkeys_ordered) do
			-- 	local state_text, _ = self:get_state_text_and_color(hotkey)
			-- 	local state_x = hotkey.state_rect.x + 55
			-- 	local state_y = hotkey.state_rect.y + 55
			-- 	if self:is_cursor_inside_text(pos, state_text, state_x, state_y, font, 15) then
			-- 		hotkey.state = not hotkey.state -- todo fix
			-- 		-- g_input:send_mouse_key_event(e_mouse_button.left, e_key_state.key_up)
			-- 		break
			-- 	end
			-- end
		else
			self.dragging = false
		end
		for _, hotkey in ipairs(self.hotkeys_ordered) do
			if hotkey.config_var then 
				hotkey.state = menu:get_value(hotkey.config_var) -- hotkey.config_var:get_bool()
			end
		end

		 self:update_keys()
	end,

	is_point_inside = function(self, point)
		return point.x >= menu:get_value(self.x) and point.x <= menu:get_value(self.x) + self.width and point.y >= menu:get_value(self.y)and
			point.y <= menu:get_value(self.y) + 25
	end,

	is_cursor_inside_text = function(self, cursorPos, text, x, y, font, fontSize)
		return false
		-- local textSize = 180 --g_render:get_text_size(text, font, fontSize)
		-- return cursorPos.x >= x and cursorPos.x <= x + textSize.x and cursorPos.y >= y and cursorPos.y <= y + textSize.y
	end,

	register = function(self, identifier, name, key, is_toggle, cfg)
		local cfg = cfg or nil
		local is_toggle = is_toggle or false

		if self.hotkeys_id[identifier] then
			-- console:log("we already have identifier " .. identifier)
			self.hotkeys_id[identifier].name = name
			self.hotkeys_id[identifier].key = key
			self.hotkeys_id[identifier].isToggle = true
			self.hotkeys_id[identifier].config_var = cfg
		else
			console:log("registering " .. identifier)
			local newHotkey = {
				identifier = identifier,
				name = name,
				key = key,
				state = false,
				labels = {},
				isToggle = is_toggle,
				config_var = cfg, -- todo fix go back to cfg
				last_update = game.game_time
			}
			-- console:log("inserting " .. identifier)
			table.insert(self.hotkeys_ordered, newHotkey)
			-- console:log("setting " .. identifier)
			self.hotkeys_id[identifier] = newHotkey
		end
	end,

	update = function(self, identifier, options)
		print("updating " .. identifier)
		if self.hotkeys_id[identifier] then
			if options.name then
				self.hotkeys_id[identifier].name = options.name
			end
			if options.key then
				self.hotkeys_id[identifier].key = options.key
			end
		end
	end,

})

--------------------------------------------------------------------------------
-- visualizer
--------------------------------------------------------------------------------
local visualizer = class({
	Last_cast_time = game.game_time,
	util = nil,
	xHelper = nil,
	math = nil,
	objects = nil,
	damagelib = nil,
	add = XVisMenuCat,
	visualizer_split_colors = nil,
	visualizer_show_combined_bars = nil,
	visualizer_show_stacked_bars = nil,
	visualizer_visualize_autos = nil,
	visualizer_autos_slider = nil,
	visualizer_visualize_q = nil,
	visualizer_visualize_w = nil,
	visualizer_visualize_e = nil,
	visualizer_visualize_r = nil,
	visualizer_show_text = nil,

	init = function(self, util, xHelper, math, objects, damagelib)
		self.Last_cast_time = game.game_time
		self.xHelper = xHelper
		self.math = math
		self.util = util
		self.damagelib = damagelib
		self.objects = objects
		-- -- Menus
		if XVisMenuCat == nil then XVisMenuCat = menu:add_category("xVisuals") end
		self.nav = XVisMenuCat
		self.vis_sect = menu:add_subcategory("visualizer", self.nav)
		self.min_sect = menu:add_subcategory("Minions", self.nav)
		self.checkboxMinionDmg = menu:add_checkbox("draw Minions", self.min_sect, 1)
		self.checkboxVisualDmg = menu:add_checkbox("damage visual", self.vis_sect, 1)
		self.visualizer_split_colors = menu:add_checkbox("^ Split colors", self.vis_sect, 0)
		self.visualizer_killable_colors = menu:add_checkbox("^ killable colors", self.vis_sect, 1)

		self.visualizer_show_combined_bars = menu:add_checkbox("Show combined bars", self.vis_sect, 1)
		self.visualizer_show_stacked_bars = menu:add_checkbox("Show stacked bars", self.vis_sect, 0)
		self.visualizer_visualize_autos = menu:add_checkbox("Visualize Autos", self.vis_sect, 1)
		
		self.visualizer_autos_slider = menu:add_slider("^x number of autos", self.vis_sect, 1, 5, 3)
		self.visualizer_dynamic_autos = menu:add_checkbox("dynamic mode", self.vis_sect, 1)
		self.visualizer_visualize_q = menu:add_checkbox("Visualize Q", self.vis_sect, 0)
		self.visualizer_visualize_w = menu:add_checkbox("Visualize W", self.vis_sect, 1)
		self.visualizer_visualize_e = menu:add_checkbox("Visualize E", self.vis_sect, 0)
		self.visualizer_visualize_r = menu:add_checkbox("Visualize R", self.vis_sect, 1)
		self.visualizer_show_text = menu:add_checkbox("Show text", self.vis_sect, 1)
	end,
	render_damage_bar = function(self, enemy, combodmg, aadmg, qdmg, wdmg, edmg, rdmg, bar_height, yOffset)
		yOffset = yOffset or 0
		local screen = game.screen_size
		local width_offset = 0.055
		local base_x_offset = 0.43
		local base_y_offset_ratio = 0.002
		local bar_width = (screen.width * width_offset)
		local hpbar = enemy.health_bar
		local base_position = hpbar.pos

		local base_y_offset = screen.height * base_y_offset_ratio

		base_position.x = base_position.x - bar_width * base_x_offset
		
		-- console:log(" offset value:".. yOffset .. " Base Position before offset:".. base_position.y)
		base_position.y = (base_position.y - bar_height * base_y_offset) + (yOffset)
		local base_y_with_offset = (base_position.y - bar_height * base_y_offset) + (yOffset)
		-- console:log(" offset value:".. yOffset .. " Base Position after offset:".. base_y_with_offset)
		

		local function DrawDamageSection(color, damage, remaining_health)
			local damage_mod = damage / enemy.max_health
			local box_start_x = base_position.x + bar_width * remaining_health
			local box_size_x = (bar_width * damage_mod) * -1

			-- Prevent the damage bar from going beyond the left bound of the enemy HP bar
			if box_start_x + box_size_x < base_position.x then
				box_size_x = base_position.x - box_start_x
			end

			local box_start = vec2:new(box_start_x -46 , base_y_with_offset)
			local box_size = vec2:new(box_size_x, bar_height)

			-- Rectangle corners coordinates
			local x1 = box_start.x  -- Bottom-left
			local y1 = box_start.y
			local x2 = box_start.x + box_size.x  -- Bottom-right
			local y2 = box_start.y
			local x3 = box_start.x  -- Top-left
			local y3 = box_start.y + box_size.y
			local x4 = box_start.x + box_size.x  -- Top-right
			local y4 = box_start.y + box_size.y
			

			-- check every variable
			renderer:draw_rect_fill(x1, y1, x2, y2, x3, y3, x4, y4, color.r, color.g, color.b, color.a)

				
			return remaining_health - damage_mod
		end

		local remaining_health = enemy.health / enemy.max_health
		if combodmg > 0 then
			-- if kill colors
			if get_menu_val(self.visualizer_killable_colors) then
				if enemy.health < combodmg  then
					remaining_health = DrawDamageSection(self.util.Colors.transparent.red, combodmg, remaining_health)
				else
					remaining_health = DrawDamageSection(self.util.Colors.transparent.darkGreen, combodmg, remaining_health)
				end
			else	
				remaining_health = DrawDamageSection(self.util.Colors.transparent.purple, combodmg, remaining_health)
			end
		end
		if aadmg > 0 then
			remaining_health = DrawDamageSection(self.util.Colors.transparent.green, aadmg, remaining_health)
		end
		if qdmg > 0 then
			remaining_health = DrawDamageSection(self.util.Colors.transparent.lightMagenta, qdmg, remaining_health)
		end
		if wdmg > 0 then
			remaining_health = DrawDamageSection(self.util.Colors.transparent.blue, wdmg, remaining_health)
		end
		if edmg > 0 then
			remaining_health = DrawDamageSection(self.util.Colors.transparent.orange, edmg, remaining_health)
		end
		if rdmg > 0 then
			remaining_health = DrawDamageSection(self.util.Colors.transparent.red, rdmg, remaining_health)
		end
	end,
	render_stacked_bars = function(self, enemy, aadmg, qdmg, wdmg, edmg, rdmg)
		local screen = game.screen_size
		local height_offset = 0.010
		local bar_height = (screen.height * height_offset)
		local last_offset_top = -15
		local last_offset_bottom = 15

		if get_menu_val(self.visualizer_visualize_w) then
			self:render_damage_bar(enemy, 0, 0, 0, wdmg, 0, 0, bar_height, last_offset_top)
			last_offset_top = last_offset_top - 15
		end
		if get_menu_val(self.visualizer_visualize_q) then
			self:render_damage_bar(enemy, 0, 0, qdmg, 0, 0, 0, bar_height, last_offset_top)
			last_offset_top = last_offset_top - 15
		end
		if get_menu_val(self.visualizer_visualize_autos) then
			self:render_damage_bar(enemy, 0, aadmg, 0, 0, 0, 0, bar_height, 0)
		end
		if get_menu_val(self.visualizer_visualize_e) then
			self:render_damage_bar(enemy, 0, 0, 0, 0, edmg, 0, bar_height, last_offset_bottom)
			last_offset_bottom = last_offset_bottom + 15
		end
		if get_menu_val(self.visualizer_visualize_r) then
			self:render_damage_bar(enemy, 0, 0, 0, 0, 0, rdmg, bar_height, last_offset_bottom)
			last_offset_bottom = last_offset_bottom + 15
		end
	end,

	render_combined_bars = function(self, enemy, aadmg, qdmg, wdmg, edmg, rdmg)
		local screen = game.screen_size
		local height_offset = 0.010
		local bar_height = (screen.height * height_offset)
		if not get_menu_val(self.visualizer_visualize_autos) then
			aadmg = 0
		end
		if not get_menu_val(self.visualizer_visualize_q) then
			qdmg = 0
		end
		if not get_menu_val(self.visualizer_visualize_w) then
			wdmg = 0
		end
		if not get_menu_val(self.visualizer_visualize_e) then
			edmg = 0
		end
		if not get_menu_val(self.visualizer_visualize_r) then
			rdmg = 0
		end
		local combodmg = aadmg + qdmg + wdmg + edmg + rdmg


		if get_menu_val(self.visualizer_split_colors) then
			self:render_damage_bar(enemy, 0, aadmg, qdmg, wdmg, edmg, rdmg, bar_height, 0)
		else
			self:render_damage_bar(enemy, combodmg, 0, 0, 0, 0, 0, bar_height, 0)
		end
	end,
	display_killable_text = function(self, enemy, nmehp, aadmg, qdmg, wdmg, edmg, rdmg)
		local pos = enemy.origin
		if pos.is_on_screen then
			local spells_text = ""
			local killable_text = ""

			local autos_to_kill = std_math.ceil(nmehp / aadmg)
			if nmehp <= aadmg then
				killable_text = "AA Kill"
			elseif nmehp <= qdmg then
				killable_text = "Q Kill"
			elseif nmehp <= wdmg then
				killable_text = "W Kill"
			elseif nmehp <= edmg then
				killable_text = "E Kill"
			elseif nmehp <= rdmg then
				killable_text = "R Kill"
			elseif nmehp <= qdmg + wdmg + edmg + rdmg then
				killable_text = "Combo Kill"
				if get_menu_val(self.visualizer_visualize_q) then
					spells_text = "Q"
				end
				if get_menu_val(self.visualizer_visualize_w) then
					spells_text = spells_text .. (spells_text ~= "" and " + " or "") .. "W"
				end
				if get_menu_val(self.visualizer_visualize_e) then
					spells_text = spells_text .. (spells_text ~= "" and " + " or "") .. "E"
				end
				if get_menu_val(self.visualizer_visualize_r) then
					spells_text = spells_text .. (spells_text ~= "" and " + " or "") .. "R"
				end
			else
				if self.objects:can_cast(e_spell_slot.q) and get_menu_val(self.visualizer_visualize_q) then
					autos_to_kill = std_math.ceil((nmehp - qdmg) / aadmg)
					spells_text = "Q"
				end
				if self.objects:can_cast(e_spell_slot.w) and get_menu_val(self.visualizer_visualize_w) then
					autos_to_kill = std_math.ceil((nmehp - wdmg) / aadmg)
					spells_text = (spells_text ~= "" and " + " or "") .. "W"
				end
				if self.objects:can_cast(e_spell_slot.e) and get_menu_val(self.visualizer_visualize_e) then
					autos_to_kill = std_math.ceil((nmehp - edmg) / aadmg)
					spells_text = (spells_text ~= "" and " + " or "") .. "E"
				end
				if self.objects:can_cast(e_spell_slot.r) and get_menu_val(self.visualizer_visualize_r) then
					autos_to_kill = std_math.ceil((nmehp - rdmg) / aadmg)
					spells_text = (spells_text ~= "" and " + " or "") .. "R"
				end
				killable_text = spells_text ..
				(spells_text ~= "" and " + " or "") .. tostring(autos_to_kill) .. " AA to kill"
			end
			if killable_text ~= "" then
				killable_text = killable_text:gsub("^%s*+", "")
				local clr = color:new(255, 255, 255, 255)
				local size = 30

				local killable_pos = game:world_to_screen_2(pos.x-150, pos.y - 80, pos.z)
				renderer:draw_text_size(killable_pos.x, killable_pos.y, killable_text, size, clr.r, clr.g, clr.b, clr.a)
			end
		end
	end,
	get_damage_array = function(self, enemy)
		
		local base_auto_dmg = self.damagelib:calc_aa_dmg(g_local, enemy)
		local aadmg = 0
		local qdmg = 0
		local wdmg = 0
		local edmg = 0
		local rdmg = 0

		local num_autos = menu:get_value(self.visualizer_autos_slider)
		if get_menu_val(self.visualizer_dynamic_autos) then 
			local distance = vec3Util:distance(g_local.origin, enemy.origin)
			local slope = 0.001538
			num_autos = 3 + slope * (distance - 850)
		end
		
		local aadmg = base_auto_dmg * num_autos
		-- if is
		if self.objects:can_cast(e_spell_slot.q) then
			qdmg = self.damagelib:calc_spell_dmg("Q", g_local, enemy, 1, self.objects:get_spell_level(e_spell_slot.q))
		end
		if self.objects:can_cast(e_spell_slot.w) then
			wdmg = self.damagelib:calc_spell_dmg("W", g_local, enemy, 1, self.objects:get_spell_level(e_spell_slot.w))
		end
		if self.objects:can_cast(e_spell_slot.e) then
			edmg = self.damagelib:calc_spell_dmg("E", g_local, enemy, 1, self.objects:get_spell_level(e_spell_slot.e))
		end
		if self.objects:can_cast(e_spell_slot.r) then
			rdmg = self.damagelib:calc_spell_dmg("R", g_local, enemy, 1, self.objects:get_spell_level(e_spell_slot.r))
			-- Prints("R Damage: " .. rdmg)
		end
		return aadmg, qdmg, wdmg, edmg, rdmg
	end,
	Visualize_damage = function(self, enemy)
		local nmehp = enemy.health
		local aadmg, qdmg, wdmg, edmg, rdmg = self:get_damage_array(enemy)

		-- combined bars		
		if get_menu_val(self.visualizer_show_combined_bars) then
			self:render_combined_bars(enemy, aadmg, qdmg, wdmg, edmg, rdmg)
		end
		-- stacked bars
		if get_menu_val(self.visualizer_show_stacked_bars) then
			self:render_stacked_bars(enemy, aadmg, qdmg, wdmg, edmg, rdmg)
		end
		-- -- killable text
		if get_menu_val(self.visualizer_show_text) then
			self:display_killable_text(enemy, nmehp, self.damagelib:calc_aa_dmg(g_local, enemy), qdmg, wdmg, edmg, rdmg)
		end
	end,
	drawMins = function(self)
		local MinionInRange = self.objects:get_enemy_minions(1500)
		for _, obj_min in pairs(MinionInRange) do
			if obj_min and obj_min:is_minion() then
				local color = nil
				local aa = self.damagelib:calc_aa_dmg(g_local, obj_min)
				local real_hp = obj_min.health
				local delay = self.objects:get_aa_travel_time(obj_min) + 0.35
				local pred_hp = features.prediction:predict_health(obj_min, delay, true)
				local dying = pred_hp < 1
				local has_damage_incoming = pred_hp == real_hp
				local can_kill = pred_hp <= aa
				local soon_kill = pred_hp <= aa + aa and has_damage_incoming and pred_hp > aa

				if can_kill then
					if has_damage_incoming then
						if dying then
							color = self.util.Colors.solid.red
						else
							color = self.util.Colors.solid.green
						end
					else
						color = self.util.Colors.solid.blue
					end
				elseif soon_kill then
					if has_damage_incoming then
						color = self.util.Colors.solid.red
					else
						color = self.util.Colors.solid.yellow
					end
				else
					color = self.util.Colors.solid.white
				end
				-- draw 3d circl of color on minion
				if color then
					renderer:draw_circle(obj_min.origin.x, obj_min.origin.y, obj_min.origin.z, radius, color.r, color.g, color.b, color.a)
				end
			end
		end
	end,
	draw = function(self)
		if get_menu_val(self.checkboxVisualDmg) then
			for i, enemy in pairs(game.players) do
				if enemy and enemy.is_enemy and self.xHelper:is_alive(enemy) and enemy.is_visible and g_local:distance_to(enemy.origin) < 3000 then
					self:Visualize_damage(enemy)
				end
			end
		end
		if get_menu_val(self.checkboxMinionDmg) then
			-- self:drawMins()
		end
	end,
	register = function(self, identifier, name, key, is_toggle, cfg)
		-- Implementation goes here
	end,
})

--------------------------------------------------------------------------------

-- debug

--------------------------------------------------------------------------------

local debug = class({
	nav = XVisMenuCat,
	util = nil,
	Colors = nil,


	init = function(self, util)
		self.util = util
		self.Colors = util.Colors
		self.Last_dbg_msg_time = game.game_time
		self.LastMsg = "init"
		self.LastMsg1 = "init"
		self.LastMsg2 = "init"

		if XVisMenuCat == nil then XVisMenuCat = menu:add_category("xVisuals")  end
		self.nav = XVisMenuCat
		self.dbg_sec = menu:add_subcategory("debug", self.nav)

		self.dbg_enable = menu:add_checkbox("enabled", self.dbg_sec, 1)

		local dbg_lvl = 0
		local posX = (game.screen_size.width / 2) - 100
		local posY = game.screen_size.height - 260

		self.Debug_level = 0

		self.Debug_level_slider = menu:add_slider("Debuglvl", self.dbg_sec, 0, 6, self.Debug_level)
		self.dbg_sec_x = menu:add_slider("x", self.dbg_sec, 0, Res.x, posX)
		self.dbg_sec_y = menu:add_slider("y", self.dbg_sec, 0, Res.y, posY)
		
	end,

	Print = function(self, str, level)
		level = level or 1
		str = tostring(str)
		-- console:log("printss?" .. str .. level .. " / " .. menu:get_value(self.Debug_level_slider)) 

		console:debug_log("xCore: " .. " " .. str)

		if level <= menu:get_value(self.Debug_level_slider) then
			if str ~= self.LastMsg  then
				console:log(level .. "/" ..menu:get_value(self.Debug_level_slider) .. "log: " .. " " .. str)
				self.Last_dbg_msg_time = game.game_time
				self.LastMsg2 = self.LastMsg1
				self.LastMsg1 = self.LastMsg
				self.LastMsg = str
			end
		end
		if game.game_time == -1 then
			self.Last_dbg_msg_time = game.game_time - 15
			self.LastMsg2 = ""
			self.LastMsg1 = ""
			self.LastMsg1 = "bad game.game_time"
		end
	end,

	draw = function(self)
		
		local pos =  vec2:new((menu:get_value(self.dbg_sec_x)) - 100, menu:get_value(self.dbg_sec_y) - 260)
		local pos1 = vec2:new((menu:get_value(self.dbg_sec_x)) - 100, menu:get_value(self.dbg_sec_y) - 290)
		local pos2 = vec2:new((menu:get_value(self.dbg_sec_x)) - 100, menu:get_value(self.dbg_sec_y) - 320)
		if self.Last_dbg_msg_time == -1 then
			renderer:draw_text_size(pos.x, pos.y, "bad game.game_time", 30, self.Colors.solid.white.r, self.Colors.solid.white.g, self.Colors.solid.white.b, self.Colors.solid.white.a)

			return false
		end                                                -- skip bad time

		if game.game_time - self.Last_dbg_msg_time >= 10 then return end -- fade out

		renderer:draw_text_size(pos.x, Res.y - 260, self.LastMsg, 30, 255, 255, 255, 255)
		renderer:draw_text_size(pos1.x, Res.y - 290, self.LastMsg1, 30, 255, 255, 255, 255)
		renderer:draw_text_size(pos2.x, Res.y - 320, self.LastMsg2, 30, 255, 255, 255, 255)
		-- console:log("x: " .. pos2.x .. " y:" .. Res.y)
	end

})

--------------------------------------------------------------------------------

-- Utils
--------------------------------------------------------------------------------



local utils = class({
	nav = nil,
	XutilMenuCat = nil,
	dancing = true,
	top = nil,
	mid = nil,
	bot = nil,

	init = function(self,vec3_util, util, xHelper, math, objects, damagelib, debug, permashow, target_selector)
		self.helper = xHelper
		self.math = math
		self.util = util
		self.damagelib = damagelib
		self.objects = objects
		self.debug = debug
		self.permashow = permashow
		self.vec3_util = vec3_util
		self.target_selector = target_selector
		-- -- Menus
		if XutilMenuCat == nil then XutilMenuCat = menu:add_category("xUtils") end
		self.nav = XutilMenuCat

		self.anti_turret = menu:add_subcategory("anti turret walker", self.nav)

		self.checkboxAntiTurretTechGlobal = menu:add_checkbox("deny turret walking in turret aggro (always)", self.anti_turret, 1)
		self.checkboxAntiTurretTechHarass = menu:add_checkbox("^ in harass", self.anti_turret, 1)
		self.checkboxAntiTurretTechCombo = menu:add_checkbox("^ in combo", self.anti_turret, 0)
	
		self.anti_turret = menu:add_subcategory("Auto Dance (auto spacing)", self.nav)
		self.checkboxAutoSpace = menu:add_checkbox("try auto dance(spacing beta)", self.anti_turret, 1)

		-- draw turret prio
		self.checkboxDrawTurretPrio = menu:add_checkbox("draw turret prio", self.nav, 1)

	end,
	clear = function(self)
		if self.dancing then
			self.dancing = false
			self.state = "" -- can be "atTop", "atMiddle", or "atBottom"
			self.top = nil
			self.mid = nil
			self.bot = nil
			orbwalker:enable_move()
			orbwalker:enable_auto_attacks()
		end
	end,
	deny_turret_harass= function(self, pos)
		Prints("DennyTurretInHarass", 4)
		if not get_menu_val(self.checkboxAntiTurretTechGlobal) then  
			return false 
		end
	  
		local should_deny_turret =
		  (get_menu_val(self.checkboxAntiTurretTechGlobal) and not get_menu_val(self.checkboxAntiTurretTechHarass) and not get_menu_val(self.checkboxAntiTurretTechCombo)) or
		  (get_menu_val(self.checkboxAntiTurretTechHarass) and combo:get_mode() == mode.Harass_key) or
		  (get_menu_val(self.checkboxAntiTurretTechCombo) and combo:get_mode() == mode.Combo_key)
	  
	  
	  -- if pos is under turret and mode is harass redirect click outside of turret range using exttend 
		if pos and should_deny_turret then
		  local isunder, turret = self.helper:is_under_turret(pos)
		  if isunder then
			Prints("is under turret yeah " .. type(pos),4)
			local new_click = self.vec3_util:extend(turret.origin, pos, 950)
			_G.DynastyOrb:ForceMovePosition(new_click)-- Can be used here or other callbacks, will force the next orb movement to that position
			_G.DynastyOrb:BlockMovement()
			Prints("attmept to force move",3)
			issueorder:move(new_click)-- Can be used here or other callbacks, will force the next orb movement to that position
			Prints("attmepted to force move off turret", 3)
			
	  
			self.dancing = true
			self.top = new_click
			self.mid = new_click
			self.bot = new_click
			return true
		  end
		  return false
		end

	end,
	should_stop_dancing = function(self)
		if g_local.is_auto_attacking then return false end
		self.dancing = false
		orbwalker:disable_move()
		local should_dance = false

		-- we only dance in combo mode
		if g_local.is_auto_attacking or g_local.is_winding_up or (combo:get_mode() ~= mode.Combo_key) then self.dancing = false orbwalker:enable_move() orbwalker:enable_auto_attacks() return should_dance end

		-- and obv only if we have a target who we out speed and outrange
		local enemy = self.target_selector:get_main_target()
		if enemy == nil or (enemy.attack_range >= g_local.attack_range) or (enemy.move_speed > g_local.move_speed * 1.15 ) or (self.vec3_util:distance(g_local.origin, enemy.origin) > g_local.attack_range + 350) then 
			self.dancing = false 
			orbwalker:enable_move()
			orbwalker:enable_auto_attacks()
			return should_dance, enemy
		end

		-- and only then if we are 1v1
		local aa_threat_count = 0
		local enemies =  self.objects:get_enemy_champs(g_local.attack_range + 100)
		for i, enemy in ipairs(enemies) do
			local nme_pos = enemy.origin
			local AA = {
				-- ignore below here its for prediction
				type = "linear",
				range = 99999,
				delay = 0.15,
				width = 15,
				speed = 1700,
				collision = {
					["Wall"] = false,
					["Hero"] = false,
					["Minion"] = false
				}
			}
			local nme_pred =  _G.DreamPred.GetPrediction(enemy, AA, g_local)
			if nme_pred then
				nme_pos = nme_pred.castPosition
			end
			-- get distnace
			if self.vec3_util:distance(nme_pos, g_local.origin) < enemy.attack_range + 120 then
				aa_threat_count = aa_threat_count + 1
			end
		end
		
		if aa_threat_count > 1 then
			self.dancing = false 
			orbwalker:enable_move()
			return should_dance, enemy
		end

		should_dance = true
		return should_dance, enemy
	end,
	position_optimally = function(self)
		if not get_menu_val(self.checkboxAutoSpace) then self:clear() return false end

		local should_dance, enemy = self:should_stop_dancing()
		if not enemy or not should_dance then return false end
		self.dancing = should_dance 
		if not g_local.is_auto_attacking then
			orbwalker:disable_auto_attacks()
		end
		_G.DynastyOrb:BlockMovement()

		
		Prints("dancin on " .. enemy.object_name, 4)
		local nme_pos = enemy.origin
		local AA = {
			-- ignore below here its for prediction
			type = "linear",
			range = 99999,
			delay = 0.15,
			width = 15,
			speed = 1700,
			collision = {
				["Wall"] = false,
				["Hero"] = false,
				["Minion"] = false
			}
		}
		local nme_pred =  _G.DreamPred.GetPrediction(enemy, AA, g_local)
		if nme_pred then
			nme_pos = nme_pred.castPosition
		end

		local enemy_theat_range = enemy.attack_range + enemy.bounding_radius + g_local.bounding_radius
		local my_theat_range = g_local.attack_range + enemy.bounding_radius + g_local.bounding_radius - 30

		-- Calculate the point where the enemy is exactly at the edge of Jinx's attack range
		local move_to_point = self.vec3_util:extend(nme_pos, game.mouse_pos, my_theat_range)

		-- Adjust the position to be outside of the threat range
		local distance_from_enemy_to_point = self.vec3_util:distance(enemy.origin, move_to_point)

		if distance_from_enemy_to_point < enemy_theat_range then
			move_to_point = self.vec3_util:extend(enemy.origin, g_local.origin, enemy_theat_range +55)
			--Prints("shoved")
		else
			--Prints("not shoved")
		end
		local war_path = g_local.path.current_waypoints -- table of vec3
		local gets_to_close = false
		-- lets loop these then decide if these are too close to the enemy
		for i, point in ipairs(war_path) do
			if self.vec3_util:distance(point, enemy.origin) < enemy_theat_range then
			gets_to_close = true
			else
			end
		end

		if gets_to_close then
			move_to_point = self.vec3_util:extend(enemy.origin, g_local.origin, enemy_theat_range +100)
			-- Prints("bad path shove")
		else
			--Prints("no  path shove")
		end



		self.top = self.vec3_util:extend(enemy.origin, g_local.origin, my_theat_range)
		self.mid = move_to_point
		self.bot = self.vec3_util:extend(enemy.origin, g_local.origin, enemy_theat_range)
		self.dancing = true


		-- Execute the movement
		orbwalker:enable_move()
		-- console:log("attempt move")
		_G.DynastyOrb:ForceMovePosition(move_to_point)-- Can be used here or other callbacks, will force the next orb movement to that position
		issueorder:move(move_to_point)-- Can be used here or other callbacks, will force the next orb movement to that position

		if self.vec3_util:distance(g_local.origin, enemy.origin) > enemy_theat_range then
			orbwalker:enable_auto_attacks()
		end


		return false
		end,

	draw = function (self)		
		if self.top and self.mid and self.bot and self.dancing then
			self.vec3_util:drawCircleFull(self.top, self.util.Colors.solid.red, 35)
			self.vec3_util:drawCircleFull(self.mid, self.util.Colors.solid.green, 35)
			self.vec3_util:drawCircleFull(self.bot, self.util.Colors.solid.blue, 35)
			--draw a line from me to mid
			self.vec3_util:drawLine(g_local.origin, self.mid, self.util.Colors.solid.green, 2)
			self:clear()

	  	end
		-- if turret prio
		if get_menu_val(self.checkboxDrawTurretPrio) then
			for _, v in ipairs(game.turrets) do
				local turret = v
				if turret and not turret.is_enemy and self.vec3_util:distance(turret.origin, g_local.origin) < g_local.attack_range+350 then
				  local minions = self.objects:get_enemy_minions(860, turret.origin)
				  if #minions > 0 then 
					local sorted = self.objects:get_ordered_turret_targets(turret, minions)
					for i, minion in ipairs(sorted) do
					  self.vec3_util:drawCircle(minion.origin, util.Colors.transparent.lightCyan, 50)
					  self.vec3_util:drawText(i, minion.origin, util.Colors.solid.lightCyan, 30)
					end
				  end
				end
			  end
		end
		
	end



})


--------------------------------------------------------------------------------

-- Callbacks

--------------------------------------------------------------------------------
local function init_alone(xCore_X)
	console:log("xCore: init_alone")
	xCore_X:init()
end


	

xCore_X = class({
	VERSION = "0.5",
	util = nil,
	permashow = nil,
	buffcache = nil,
	helper = nil,
	math = nil,
	database = nil,
	objects = nil,
	damagelib = nil,
	visualizer = nil,	
	debug = nil,
	target_selector = nil,
	vec2_util = vec2Util,
	vec3_util = vec3Util,
	color = color,
	e_key = e_key,
	e_spell_slot = e_spell_slot,
	mode = mode,
	chance_strings = chance_strings,
	rates = rates,


	init = function(self)
		if coreAlone then if not menu:is_control_hidden(coreAlone) then menu:hide_control(coreAlone) end end
		
		local LuaName = "xCore"
		local lua_file_name = "xCore.lua"
		local lua_url = "https://raw.githubusercontent.com/JayBuckley7/BruhwalkerLua/main/xCore.lua"
		local version_url = "https://raw.githubusercontent.com/JayBuckley7/BruhwalkerLua/main/versions/xCore.lua.version.txt"
	
		do
			local function AutoUpdate()
				http:get_async(version_url, function(success, web_version)
					console:log(LuaName .. ".lua Vers: "..LuaVersion)
					console:log(LuaName .. ".Web Vers: "..tonumber(web_version))
					if tonumber(web_version) <= LuaVersion then
						console:log(LuaName .. " Successfully Loaded..")
					else
						http:download_file_async(lua_url, lua_file_name, function(success)
							if success then
								console:log(LuaName .. " Update available..")
								console:log("Please Reload via F5!..")
							end
						end)
					end
				end)
			end
			AutoUpdate()
		end
		print("=-=--=-=-=-=-==-=--==-=-=--=-==--==-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-")
		self.util = util:new()
		self.Colors = util.Colors
		self.permashow = permashow:new()
		self.buffcache = buffcache:new()
		self.helper = xHelper:new(self.buffcache)
		self.math = math:new(self.helper, self.buffcache)
		self.database = database:new(self.helper)
		self.objects = objects:new(self.helper, self.math, self.database, self.util)
		self.damagelib = damagelib:new(self.helper, self.math, self.database, self.buffcache)
		self.visualizer = visualizer:new(self.util, self.helper, self.math, self.objects, self.damagelib)
		self.debug = debug:new(self.util)
		self.target_selector = target_selector:new(self.helper, self.math, self.objects, self.damagelib)
		self.utils = utils:new(self.vec3_util, self.util, self.helper, self.math, self.objects, self.damagelib,self.debug, self.permashow, self.target_selector)


		client:set_event_callback("on_tick_always",function() self.target_selector:tick() end)
		client:set_event_callback("on_draw", function() self.permashow:draw() self.debug:draw() self.target_selector:draw() self.visualizer:draw() self.utils:draw() end)
		client:set_event_callback("on_tick_always",function() self.permashow:tick() end)
	    self.permashow:register("Anti turret walker", "Anti turret walker", "N", true, self.utils.checkboxAntiTurretTechGlobal)
		self.permashow:register("Use AutoSpace [Beta]", "Use AutoSpace [Beta]", "control", true, self.utils.checkboxAutoSpace)


		_G.DynastyOrb:AddCallback("OnMovement", function(...) self.utils:deny_turret_harass(...) end)
		client:set_event_callback("on_tick_always", function(...) self.utils:position_optimally() end)
		


	end,

})


if coreAlone == nil then 
	if XutilMenuCat == nil then XutilMenuCat = menu:add_category("xUtils") end
	coreAlone = menu:add_button("load xCore", XutilMenuCat, function() init_alone(xCore_X) end, "tool_tip")  
end



return xCore_X
