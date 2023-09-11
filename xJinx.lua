
if not _G.DreamPred then
  require("DreamPred")
end

local DreamTS = require("DreamTS")

if not _G.DynastyOrb then
  require("DynastyOrb")
end

require("PKDamageLib")
core = require("xCore")

if game.local_player.champ_name ~= "Jinx" then return end
g_local = game.local_player

local Jinx = {}
Jinx.__index = Jinx

e_spell_slot = core.e_spell_slot
Modes = core.mode
chance_strings = core.chance_strings
Rates = core.rates

local name = "xAIO - Jinx"
local std_math = math

-- MinionsUnkillable = {}
MinionInrange = {}
MinionToHarass = {}
SplashableTargetIndex = nil
SplashableMinionIndex = nil
MinionTable = {}
Last_Q_swap_time = game.game_time
Last_cast_time = game.game_time

function Prints(str, level)
    core.debug:Print(str, level)
end

function get_menu_val(cfg)
  if menu:get_value(cfg) == 1 then
    return true
  else
    return false
  end
end


 -- fix data
  local Data = {
      Q = {
        manaCost = { 20, 20, 20, 20, 20 },
        source = myHero,
        spell = spellbook:get_spell_slot(e_spell_slot.q),
        spellSlot = e_spell_slot.q,
        range = { 80, 110, 140, 170, 200 },
        Level = 0,
      },
      W = {
        manaCost = { 40, 45, 50, 55, 60 },
        spell = spellbook:get_spell_slot(e_spell_slot.w),
        spellSlot = e_spell_slot.w,
        source = myHero,
        type = "linear",
        delay = 0.4,
        speed = 3300,
        range = 1450,
        width = 120,
        collision = {
          ["Wall"] = false,
          ["Hero"] = true,
          ["Minion"] = true
        },
        Damage = 0,
        Level = 0,
      },
      E = {
        source = myHero,
        manaCost = { 90, 90, 90, 90, 90 },
        spell = spellbook:get_spell_slot(e_spell_slot.e),
        spellSlot = e_spell_slot.e,
        range = 925,
        Damage = g_local.total_attack_damage,
        delay = 0.9,
        type = "circular",
        collision = { ["Wall"] = false, ["Hero"] = true, ["Minion"] = false},
        radius = 50,
        width = 100,
        speed = 1700,
        Level = 0,
      },
      R = {
        source = myHero,
        manaCost = { 100, 100, 100, 100, 100 },
        spell = spellbook:get_spell_slot(e_spell_slot.r),
        spellSlot = e_spell_slot.r,
        range = 3000,
        width = 280,
        type = "linear",
        collision = {
          ["Wall"] = false,
          ["Hero"] = true,
          ["Minion"] = false
        },
        delay = 0.6,
        Damage = 0,
        speed = 1700,
        Level = 0,
      },
      AA = {
        Damage = g_local.total_attack_damage,
        short_range = 0,
        long_range = 0,
        rocket_launcher = false,
        enemy_close = false,
        enemy_far = false,
        -- ignore below here its for prediction
        type = "linear",
        range = 99999,
        delay = 0.15,
        width = 1000,
        speed = 1700,
        collision = {
            ["Wall"] = false,
            ["Hero"] = false,
            ["Minion"] = false
        }
      },
  }

  function Data:refresh_data()
    -- Prints("refreshing", 3)
    self['AA'].Damage = g_local.total_attack_damage
    self['AA'].rocket_launcher = self:has_rocket_launcher()
    local range = g_local.attack_range + g_local.bounding_radius
    -- Prints("aa: " .. g_local.attack_range, 3)
    -- Prints("bound: " .. g_local:get_bounding_radius() + 15, 3)
    -- Prints("Q_level: " .. Data['Q'].Level,3)
    -- Prints("Long range:" .. range + (50 + (30 * Data['Q'].Level)),3)
    local long_range = range
    if Data['AA'].rocket_launcher then
      range = range - (50 + 30 * Data['Q'].Level)
    else
      long_range = range + (50 + 30 * Data['Q'].Level)
      -- 80 / 110 / 140 / 170 / 200
    end
  
    self['AA'].short_range = range
  
    self['AA'].long_range = long_range
    self['AA'].enemy_close = core.objects:is_enemy_near(range)
    self['AA'].enemy_far = core.objects:is_enemy_near(long_range)
  
    self['Q'].Level = spellbook:get_spell_slot(e_spell_slot.q).level
    self['Q'].spell = spellbook:get_spell_slot(e_spell_slot.q)
    self['Q'].spellSlot = e_spell_slot.q
  
    self['W'].Level = spellbook:get_spell_slot(e_spell_slot.w).level
    self['W'].spell = spellbook:get_spell_slot(e_spell_slot.w)
    self['W'].castTime = std_math.max(0.6 - 0.02 * std_math.floor(g_local.bonus_attack_speed / 0.25), 0.4)
  
    self['E'].Level = spellbook:get_spell_slot(e_spell_slot.e).level
    self['E'].spell = spellbook:get_spell_slot(e_spell_slot.e)
    self['E'].spellSlot = e_spell_slot.e
  
    self['R'].Level = spellbook:get_spell_slot(e_spell_slot.r).level
    self['R'].spell = spellbook:get_spell_slot(e_spell_slot.r)
    self['R'].spellSlot = e_spell_slot.r
  
    -- Prints("refreshed", 3)
  end
  
  function Data:has_rocket_launcher()
    return g_local:has_buff("JinxQ")
  end
  
  function Data:in_range(spell, target)
    if target ~= nil and core.vec3_util:distance(g_local.origin, target.origin) <= self[spell].range then
      return true
    else
      return false
    end
  end

function Jinx:new()
    local obj = {}
    setmetatable(obj, Jinx)
    obj:init()
    return obj
end

function Jinx:ToggleTS()
  local currVal = core.target_selector:TOGGLE_STATUS()
  if currVal == 0 then
    Prints("swapping to xTS",1)
    core.target_selector:TOGGLE_STATUS(1)
    menu:hide_sub_category(self.sections.Taget_Selector)
  else
    Prints("swapping to dreamPred",1)
    core.target_selector:TOGGLE_STATUS(0)
    if menu:is_sub_category_hidden(self.sections.Taget_Selector) then
      menu:show_sub_category(self.sections.Taget_Selector)
    end

  end
end

function Jinx:add_jmenus()
    self.navigation = menu:add_category("xJinx")


    
    self.Jinx_enabled = menu:add_checkbox("Enabled", self.navigation, 1)

    menu:add_label("xJinx",  self.navigation)
    self.TS_to_use = menu:add_combobox("Taget Selector to use", self.navigation, {"xTarget Selector", "DreamPred"}, 1)


    local sections = {
      Taget_Selector = menu:add_subcategory("DreamTS --->", self.navigation),
      combo = menu:add_subcategory("combo", self.navigation),
      harass = menu:add_subcategory("harass", self.navigation),
      clear = menu:add_subcategory("farm", self.navigation),
      agc = menu:add_subcategory("gap close", self.navigation),
      auto = menu:add_subcategory("auto", self.navigation),
      misc = menu:add_subcategory("misc", self.navigation),
      draw = menu:add_subcategory("drawings", self.navigation),
      }
      self.sections = sections
      -- self.TS = DreamTS(sections.Taget_Selector, {Damage = DreamTS.Damages.AD})
      menu:hide_sub_category(sections.Taget_Selector)


    menu:set_callback(self.TS_to_use, function() self:ToggleTS() end)

  -- Combo
    self.q_combo = menu:add_checkbox("use Q ", sections.combo, 1)
    self.q_combo_aoe = menu:add_checkbox("^ try AOE", sections.combo, 1)
    self.q_combo_aoe_count = menu:add_slider("^ if x enemies", sections.combo, 0, 5, 3)


    self.w_combo = menu:add_checkbox("use W", sections.combo, 1)
    self.w_combo_not_in_range = menu:add_checkbox("^ if outside of aa range", sections.combo, 1)
    self.w_combo_hitChance = menu:add_slider("W hitChance", sections.combo, 1, 100, 70)
    self.w_combo_castrate = { "Slow Cast Rate", "Fast Cast Rate", "Very Slow" }
    self.w_combo_rate = menu:add_dropdown("W in Combo CastRate", sections.combo, self.w_combo_castrate, 1)
    
 
    self.e_combo = menu:add_checkbox("use E", sections.combo, 1)
    self.e_combo_castrate = { "Slow Cast Rate", "Fast Cast Rate", "Very Slow" }
    self.e_combo_rate = menu:add_dropdown("E in Combo CastRate", sections.combo, self.e_combo_castrate, 1)




    -- Clear
    self.q_clear = menu:add_checkbox("use Q (minion of range)", sections.clear, 1)
    self.q_clear_aoe = menu:add_checkbox("Q AOE (fast Lane Clear mode)", sections.clear, 1)
    self.q_clear_aoe_count = menu:add_slider("^ if x enemies", sections.clear, 0, 5, 3)


    -- Harass
    self.q_harass = menu:add_checkbox("use Q", sections.harass, 1)
    -- Q harass mana slider
    self.q_harass_mana = menu:add_slider("Q harass Mana %", sections.harass, 1, 100, 40)
    self.checkboxJinxSplashHarass = menu:add_checkbox("extend aa range with Q splash", sections.harass, 1)
    self.w_harass = menu:add_checkbox("use W", sections.harass, 1)
    self.w_harass_not_in_range = menu:add_checkbox("^ if outside of aa range", sections.harass, 1)
    self.w_harass_hitChance = menu:add_slider("[W] Hit Chance %", sections.harass, 1, 100, 40)
    self.w_harass_castrate = { "Slow Cast Rate", "Fast Cast Rate", "Very Slow" }
    self.w_harass_rate = menu:add_dropdown("[W] in Harass CastRate", sections.harass, self.w_harass_castrate, 1)


    -- slider for mana usage default at 25%
    self.w_harass_mana = menu:add_slider("[W] harass Mana %", sections.harass, 1, 100, 40)
    self.e_harass = menu:add_checkbox("use E", sections.harass, 1)


    -- Auto
    self.q_auto = menu:add_checkbox("Autonomous auto Q  minion splash harass", sections.auto, 1)
    self.w_auto = menu:add_checkbox("auto W Stasis/cc/immobile", sections.auto, 1)
    self.e_auto = menu:add_checkbox("auto E Stasis/cc/immobile", sections.auto, 1)

    self.w_KS = menu:add_checkbox("W KS", sections.auto, 1)
    self.w_KS_hitChance = menu:add_slider("[W] KS Hit Chance %", sections.auto, 1, 100, 60)
    self.w_KS_castrate = { "Slow Cast Rate", "Fast Cast Rate", "Very Slow" }
    self.w_KS_rate = menu:add_dropdown("[W] in KS CastRate", sections.auto, self.w_KS_castrate, 1)

    self.r_KS = menu:add_checkbox("R KS", sections.auto, 1)

    self.r_auto_base_ult_vision = menu:add_checkbox("Base Ult in vision", sections.auto, 1)
    self.r_combo_multihit = menu:add_checkbox("R Multihit combo", sections.auto, 1)

    self.r_KS_hitChance = menu:add_slider("[R] KS Hit Chance %", sections.auto, 1, 100, 60)
    self.r_KS_castrate = { "Slow Cast Rate", "Fast Cast Rate", "Very Slow" }
    self.r_KS_rate = menu:add_dropdown("[R] in KS CastRate", sections.auto, self.r_KS_castrate, 1)

    self.r_KS_dashless = menu:add_checkbox("^ only if no dash", sections.auto, 1)


    -- AntiGapClose
    self.w_agc = menu:add_checkbox("W on AntiGapClose", sections.agc, 1)
    self.e_agc = menu:add_checkbox("E on AntiGapClose", sections.agc, 1)

    -- Misc
    self.checkboxManR = menu:add_checkbox("manual ult", sections.misc, 1)

    self.checkboxAntiTurretTechGlobal = menu:add_checkbox("deny turret walking in turret aggro (always)", sections.misc, 1)
    self.checkboxAntiTurretTechHarass = menu:add_checkbox("^ in harass", sections.misc, 1)
    self.checkboxAntiTurretTechCombo = menu:add_checkbox("^ in combo", sections.misc, 0)


    self.checkboxAutoSpace = menu:add_checkbox("try auto dance(spacing beta)", sections.misc, 1)

    -- Draw
    self.checkboxLanePressure = menu:add_checkbox("draw Lane pressure",  sections.draw, 0)
    self.checkboxDrawQCurrent = menu:add_checkbox("Draw Current Q range",  sections.draw, 0)
    self.checkboxDrawQAlt = menu:add_checkbox("Draw alternate Q range",  sections.draw, 1)
    self.checkboxDrawW = menu:add_checkbox("Draw W range",  sections.draw, 1)

    self.label = menu:add_label("version "..(tostring(self.LuaVersion)), self.navigation)
    -- console:log("val: " .. get_menu_val(self.Jinx_enabled))
    
    return self.jmenu
end  

function Jinx:registerPS()
  core.permashow:set_title(name)
  console:log("registering permashow q farm")
  core.permashow:register("farm", "farm", "A", true, self.q_clear_aoe)
  core.permashow:register("Fast W", "Fast W", "shift")
  
  core.permashow:register("Semi-Auto Ult", "Semi-Auto Ult", "U")
  core.permashow:register("Extend AA To Harass", "Extend AA To Harass", "I", true, self.q_harass)
end


-- function dance()
--   Prints("state: " .. state, 2)
--   Prints("dancing: " .. tostring(dancing), 2)
--     if not dancing then
--       Prints("dance ONE set!", 2)
--         -- Initialize positions if they haven't been set
--         mid = g_local.origin
--         top = Vec3_Rotate(mid, {x = mid.x, y = mid.y, z = mid.z + 100}, 90)
--         bot = core.vec3_util:extend(mid, top, -100)
--         dancing = true
--     end

--     local currentPos = g_local.origin

--     if state == "atMiddle" and core.vec3_util:distance(currentPos, mid) < 5 then
--         Prints("move to top from middle", 2)
--         -- move to top from middle
--         orbwalker:move_to(top.x, top.y, top.z)
--         state = "atTop"
--     elseif state == "atTop" and core.vec3_util:distance(currentPos, top) < 5 then
--         Prints("move to bottom from top", 2)
--         -- move to bottom from top
--         orbwalker:move_to(bot.x, bot.y, bot.z)
--         state = "atBottom"
--     elseif state == "atBottom" and core.vec3_util:distance(currentPos, bot) < 5 then
--         Prints("move to middle from bottom", 2)
--         -- move to middle from bottom
--         orbwalker:move_to(top.x, top.y, top.z)
--         state = "atMiddle"
--     end
-- end


function Jinx:init()
  local LuaVersion = 1.1
  self.luaversion = LuaVersion

	local LuaName = "xJinx"
	local lua_file_name = "xJinx.lua"
	local lua_url = "https://raw.githubusercontent.com/JayBuckley7/BruhwalkerLua/main/xJinx.lua"
	local version_url = "https://raw.githubusercontent.com/JayBuckley7/BruhwalkerLua/main/versions/xJinx.lua.version.txt"


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

    
    self:add_jmenus()
    self:registerPS()
    client:set_event_callback("on_tick_always", function() Data:refresh_data()  end)
    client:set_event_callback("on_tick_always", function() self:on_tick_always() end)
    client:set_event_callback("on_pre_attack", function() self:exit_rocket_logic() end)
    client:set_event_callback("on_post_attack", function() self:weave_auto_w() end)
    client:set_event_callback("on_draw", function() self:on_draw() end)

    client:set_event_callback("on_teleport", function(...) self:ProcessRecall(...) end)
    client:set_event_callback("on_dash", function(...) self:on_dash(...) end)
    


end

function Jinx:ready(spell)
  if 1==1 then return spellbook:can_cast(spell) end
  local slot = spellbook:get_spell_slot(spell)
  -- Prints("slot: " .. tostring(slot.level), 2)
  if slot.level == 0 then
    Prints(spell .. " lvl not ready", 2)
    return false
  end

  if slot.cooldown > 0 then
    Prints(spell .. " not ready for: " .. slot.cooldown , 2)
    return false
  end

  Prints(spell .. " ready", 2)
  return true
end

function Jinx:enemyHeroes()
	local _EnemyHeroes = {}
	for i, enemy in ipairs(game.players) do
		if enemy and enemy.is_valid and enemy.is_enemy and enemy.is_targetable then
			table.insert(_EnemyHeroes, enemy)
		end
	end
	return _EnemyHeroes
end

function Jinx:VectorPointProjectionOnLineSegment(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
    local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

function Jinx:GetLineTargetCount(source, pos, radius)
    local count = 0
    for _, target in ipairs(self:enemyHeroes()) do
        local range = 1000 * 1000
        if core.vec3_util:distance(target.origin, self.myHero.origin) <= range then
            local pointSegment, pointLine, isOnSegment = self:VectorPointProjectionOnLineSegment(source.origin, pos.origin, target.origin)
            if pointSegment and isOnSegment and (core.vec3_util:distance(target.origin, pointSegment) <= (target.bounding_radius + radius) * (target.bounding_radius + radius)) then
                count = count + 1
            end
        end
    end
    return count
end

function Jinx:validTarget(unit, distance)
    return unit and unit.is_valid and unit.is_enemy and
    not unit:has_buff("SionPassiveZombie") and
    not unit:has_buff("FioraW") and
    not unit:has_buff("sivire") and
    not unit:has_buff("MorganaE") and
    not unit:has_buff("nocturneshroudofdarkness") and
    unit.is_alive and not unit:has_buff_type(18) and
    (not distance or core.vec3_util:distance(unit.origin,  self.myHero.origin) <= distance)
end

function Jinx:inList(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function Jinx:mergeAllTables(minions, jungle_minions)
    local mergedTable = {}

    for _, minion in ipairs(minions) do
        if minion.is_valid and minion.is_enemy and minion.is_alive then
            local grabrange = self.W.range + minion.bounding_radius
            if core.vec3_util:distance(minion.origin,  self.myHero.origin) <= grabrange then
                table.insert(mergedTable, minion)
            end
        end
    end

    for _, jungle in ipairs(jungle_minions) do
        if jungle.is_valid and jungle.is_alive then
            local grabrange = self.W.range + jungle.bounding_radius
            if core.vec3_util:distance(jungle.origin,  self.myHero.origin) <= grabrange then
                table.insert(mergedTable, jungle)
            end
        end
    end

    return mergedTable
end

function Jinx:get_sorted_targets(enemies, damage_function, spell_data, delay)

  local targets = {}
  if #enemies == 0 then return targets end
  
  Prints("sort target ipairs", 4)
  for i, enemy in ipairs(enemies) do
    if enemy and core.helper:is_alive(enemy) then
      local hpPred = DynastyOrb:GetPredictedHealth(enemy, delay)
      local dmg = damage_function(enemy)

      -- console:log("we doin dmg " .. tostring(dmg) .. " to " .. tostring(enemy.object_name))
      local w_hit =  _G.DreamPred.GetPrediction(enemy, Data['W'], g_local)

      -- console:log("we got a live one: " .. tostring(w_hit))
      if w_hit ~= nil then
          table.insert(targets, { target = enemy, hp = hpPred, hitChance = w_hit.hitChance*100, damage = dmg })
      end
    end
    Prints("sort target exit with " .. #targets, 4)
  end

  table.sort(targets, function(a, b)
    if a.hp == b.hp then
      return a.hitChance > b.hitChance
    else
      return a.hp < b.hp
    end
  end)
  
  return targets
end
  
function Jinx:get_sorted_w_targets(enemies)
    return self:get_sorted_targets( enemies, function(enemy) return core.damagelib:calc_spell_dmg("W", g_local, enemy, 1, Data['W'].Level)  end, Data['W'], 0.4)
end

function Jinx:get_sorted_r_targets(enemies, delay)
  Prints("get_sorted_r_targets from: " .. #enemies, 4)
  return self:get_sorted_targets(
     enemies,
     function(enemy) return core.damagelib:calc_spell_dmg("R", g_local, enemy, 1, Data['R'].Level)  end, 
     Data['R'], 
     0.55
    )
end

function Jinx:Get_target(spell_data)
    Prints("gettgt", 4)
    local pred = nil

    if core.target_selector:GET_STATUS() then 
      -- print("ts: true") 
    else 
      -- print("ts: false") 
    end

    local target = core.target_selector:get_main_target()


    -- if target ~= nil then Prints("target: " .. tostring(target.object_name), 4) end
  
    -- if we are on core ts return core ts else return get_default_target
    if core.target_selector:GET_STATUS() then
      target = core.target_selector:get_main_target()
      -- try even harder to find a target

      if target == nil or (target and core.vec3_util:distance(g_local.origin, target.origin) > 2000) then
        if core.objects:count_enemy_champs(2000) > 0 then
          -- print("get second try")
          target = core.target_selector:get_second_target(2000)
          -- print("get thirds try")
          
          if target == nil or (target and core.vec3_util:distance(g_local.origin, target.origin) > 2000) then
            local enemies = core.objects:get_enemy_champs(2000)
            local sorted = self:get_sorted_w_targets(enemies)
            if sorted and #sorted > 0 then
              if sorted[1] and sorted[1].origin then
                target = sorted[1]
              end
            end
          end
        end
      end
    else 
      -- print("nabbing targets and pred")
      local dream_target,dream_pred = nil,nil
      if self.TS then 
        dream_target,dream_pred = self.TS:GetTarget(spell_data, g_local) 
      end
      -- print("nabbed")
      target = dream_target
      pred = dream_pred

      -- if w_targets and #w_targets > 0 then
      --   target = w_targets[0]
      -- end
      
    end--   target = features.target_selector:get_default_target() 
  
    if target == nil then
      Prints("no target", 4)
    end
    --set orbwalker target
    Prints("attemtp set orb tgt ", 4)
    if target then 
      DynastyOrb:SetTarget(target)
    end
    Prints("attemted set orb tgt ", 4)

    return target,pred
  end

-- -=-=-=--==-=-=-==--==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=-=-
--   LOGIC
-- -=-=-=--==-=-=-==--==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=-=-

local function Get_minions(range)
  local minions_in_range = {}

  for _, minion in ipairs(game.minions) do
    if minion ~= nil and minion.is_enemy and core.helper:is_alive(minion) and minion.is_visible and minion.is_minion and minion.is_targetable then
      
      if core.vec3_util:distance(g_local.origin, minion.origin) <= range then
        table.insert(minions_in_range, minion)
      end
    end
  end

  return minions_in_range
end

function Jinx:exit_rocket_logic()
    Prints("exit rocket logic", 4)
    local mode = combo:get_mode()

    if Data['AA'].rocket_launcher and not g_local.is_auto_attacking and mode ~= Modes.Combo_key and mode ~= Modes.Idle_key and get_menu_val(self.q_clear) then
      if mode == Modes.Harass_key and Data['AA'].enemy_far then
        return false
      end
      if game.game_time - Last_Q_swap_time > 3.5 then
        Prints("exit rocket mode, bored", 2)
        spellbook:cast_spell(e_spell_slot.q)
        Last_Q_swap_time = game.game_time
        return true
      end
    end

    --if orbawalker target is minion and mode is clear or harass and target is in range of aa and we are in rocket mode then swap q to minigun
    local target = orbwalker:get_orbwalker_target()
    if target and target.is_minion and core.helper:is_alive(target) and (mode == Modes.Clear_key or mode == Modes.Harass_key) and core.vec3_util:distance(g_local.origin, target.origin) < Data['AA'].long_range and Data['AA'].rocket_launcher then
      Prints("exit rocket mode, bcuz minion in aa range", 2)
      spellbook:cast_spell(e_spell_slot.q)
      Last_Q_swap_time = game.game_time
      return true
    end
    return false
  end

 function Jinx:fast_clear_aoe_Logic()
    -- local jinx_aa_slots = { 64, 65, 70, 71 }
    local target = orbwalker:get_orbwalker_target()
    if target and core.helper:is_alive(target) then
      -- Prints("target is: " .. tostring(target.object_name), 3)
      Prints("fast clear aoe logic", 4)
      local nearby = core.objects:count_enemy_minions(250, target.origin)
      Prints("count q for aoe splash would be: " .. tostring(nearby), 4)

      if nearby >= menu:get_value(self.q_clear_aoe_count) then
        if not Data['AA'].rocket_launcher then
          Prints("q AOE to hit " .. tostring(nearby) .. "minions", 2)
          spellbook:cast_spell(e_spell_slot.q)
          Last_Q_swap_time = game.game_time
          return true
        end
      else
        if Data['AA'].rocket_launcher then
          Prints("q AOE only hits " .. tostring(nearby) .. "minion[s]", 2)
          spellbook:cast_spell(e_spell_slot.q)
          Last_Q_swap_time = game.game_time
          return true
        end
        end
      end
    
  
    return false
  end

local function save_minion_with_q()
  Prints("save min q?", 4)
    if not Data['AA'].rocket_launcher and orbwalker:can_attack() then
      local minions_in_range = Get_minions((Data['AA'].long_range + 35))
      Prints("got mins in long range: " .. tostring(#minions_in_range), 4)
      
      for _, minion in ipairs(minions_in_range) do
        if core.vec3_util:distance(g_local.origin, minion.origin) > Data['AA'].short_range + 35 then

          local delay = core.objects:get_aa_travel_time(minion, g_local, 1700) + 0.35       
          local hpPred = DynastyOrb:GetPredictedHealth(minion, delay)

          if hpPred ~= minion.health then
            local aa_dmg = core.damagelib:calc_aa_dmg(g_local, minion)
            if hpPred < aa_dmg * 1.1 and hpPred > 5 then
              Prints("Forcing target for q clear save", 2)
              spellbook:cast_spell(e_spell_slot.q)
              -- Last_Q_swap_time = game.game_time
              DynastyOrb:SetTarget(minion)
              orbwalker:attack_target(minion)
              spellbook:cast_spell(e_spell_slot.q)

              
              -- g_input:issue_order_attack(minion.network_id)
              return true
            end
          end
        end
      end
    end
  end

function Jinx:combo_harass_q()
    local target = self:Get_target(Data['AA'])
   

    -- Prints("enemy count: " ..core.objects:count_enemy_champs(250, target.origin)  .. " / " .. get_menu_val(self.q_combo_aoe_count) , 3)
    
    -- aoe splash logic
    if get_menu_val(self.q_combo_aoe) and target and core.objects:count_enemy_champs(250, target.origin) >= menu:get_value(self.q_combo_aoe_count) then
      if not Data['AA'].rocket_launcher then
        Prints("q cast aoe", 3)
        spellbook:cast_spell(e_spell_slot.q)
        Last_Q_swap_time = game.game_time
        return true
      end
      -- we need more range...
    else 
      if (not Data['AA'].rocket_launcher and Data['AA'].enemy_far and not Data['AA'].enemy_close) then
        spellbook:cast_spell(e_spell_slot.q)
        Last_Q_swap_time = game.game_time
      else
        if (Data['AA'].rocket_launcher and Data['AA'].enemy_far and Data['AA'].enemy_close) then
          -- we need more attack speed...
          spellbook:cast_spell(e_spell_slot.q)
          Last_Q_swap_time = game.game_time
          return true
        end
      end
    end
  end

function Jinx:spell_q()
    Prints("q spell in", 4)
    local mode = combo:get_mode()
    local mana_req = menu:get_value(self.q_harass_mana)
    local mana_perc = g_local.mana / g_local.max_mana * 100 
    
    -- Prints("mode: " .. tostring(mode), 3)
    -- Combo logic
    if mode == Modes.Combo_key and get_menu_val(self.q_combo) and self:combo_harass_q() then return true end

    -- Harass logic
    if mode == Modes.Harass_key and get_menu_val(self.q_harass) and mana_req <= mana_perc  and self:combo_harass_q() then return true end

    -- Farm logic -- extends auto range to hit dying minions if in minigun form
    if (mode == Modes.Clear_key or mode == Modes.Harass_key or mode == Modes.Lasthit) and get_menu_val(self.q_clear) and save_minion_with_q() then return true end

    -- Clear logic -- AoE minions
    if (mode == Modes.Clear_key or mode == Modes.Harass_key) and  get_menu_val(self.q_clear_aoe) and g_local.is_auto_attacking and self:fast_clear_aoe_Logic() then return true end

    -- Exit rocket logic
     if Data['AA'].rocket_launcher and not g_local.is_auto_attacking and mode ~= Modes.Combo_key and mode ~= Modes.Idle_key and get_menu_val(self.q_clear) and game.game_time - Last_Q_swap_time > 0.5 and self:exit_rocket_logic() then return true end

    return false
end

 function Jinx:should_skip_w_cast()
  local target = self:Get_target(Data['W'])
  local in_Q_range = core.vec3_util:distance(g_local.origin, target.origin) <= Data['AA'].long_range + 15
  if not in_Q_range then return false end

  local mode = combo:get_mode()
  local full_combo = game:is_key_down(core.e_key.shift)
  local should_w_in_aa_range = get_menu_val(self.w_combo_not_in_range)
  if mode == Modes.Harass_key then should_w_in_aa_range = get_menu_val(self.w_harass_not_in_range) end

  local aadmg = core.damagelib:calc_aa_dmg(g_local, target)
  local aa_to_kill = std_math.ceil(target.health / aadmg)
  local near_death = aa_to_kill <= 2
  if full_combo and mode == Modes.Combo_key then should_w_in_aa_range = true end


  if in_Q_range then
      -- console:log("skip: can_weave: " .. tostring(can_weave) .. " allowed in aa range?: " .. tostring(should_w_in_aa_range) .. " overkill: " .. tostring(near_death))
      return true 
  end
  return false
end

function Jinx:should_try_w_hit_pred(w_hit)
  if pred == nil then return false end
  local should_cast = false
 

  local mode = combo:get_mode()
  local w_rate = menu:get_value(self.w_combo_rate) + 1

  -- if we're in harass mode, use the harass hitChance setting
  if mode == Modes.Harass_key then
    w_rate = menu:get_value(self.w_harass_rate) + 1
  end

  --local
  should_cast = w_hit.rates[Rates[w_rate]]
  
  if game:is_key_down(core.e_key.shift) then
    should_cast = true
  end


  return should_cast
end

 function Jinx:weave_auto_w()
  Prints("weave auto w", 3)
  --if ready w
  if not self:ready(e_spell_slot.w) then return false end
  local mode = combo:get_mode()
  local should_w_combo = (mode == Modes.Combo_key and get_menu_val(self.w_combo))
  local prev_target = orbwalker:get_orbwalker_target()
  local should_w_Jungle_clear = (mode == Modes.Clear_key and get_menu_val(self.q_clear_aoe) and prev_target.is_jungle_minion)

  --if not should then false
  if not should_w_combo and not should_w_Jungle_clear  then return false end

  local target = self:Get_target(Data['W'])

  if should_w_combo and target then
    local in_Q_range = core.vec3_util:distance(g_local.origin, target.origin) <= Data['AA'].long_range + 15
    if not in_Q_range then return false end

    local full_combo = game:is_key_down(17)
    local should_w_in_aa_range = get_menu_val(self.w_combo_not_in_range)
    if mode == Modes.Harass_key then should_w_in_aa_range = get_menu_val(self.w_harass_not_in_range) end

    local aadmg = core.damagelib:calc_aa_dmg(g_local, target)
    local aa_to_kill = std_math.ceil(target.health / aadmg)
    local near_death = aa_to_kill <= 2
    if full_combo and mode == Modes.Combo_key then should_w_in_aa_range = true end

    if in_Q_range then
      if should_w_in_aa_range and not near_death then
        Prints("weave auto w", 2)
        local w_hit =  _G.DreamPred.GetPrediction(target, Data['W'], g_local)

        if w_hit and self:should_try_w_hit_pred(w_hit) then
          -- Prints("combo: casting w hitChance is " .. chance_strings[w_hit.hitChance], 2)
          local castPos = w_hit.castPosition
          spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)
    
          return true
        end
      end
    end
    return false
  end

  if should_w_Jungle_clear then
    local in_Q_range = core.vec3_util:distance(g_local.origin, prev_target.origin) <= Data['AA'].long_range + 15
    if not in_Q_range then return false end

    local aadmg = core.damagelib:calc_aa_dmg(g_local, prev_target)
    local aa_to_kill = std_math.ceil(prev_target.health / aadmg)
    local near_death = aa_to_kill <= 2

    if in_Q_range then
      if not near_death then
        Prints("farm: casting w hitChance is ", 2)
        local castPos = prev_target.origin
        spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)
      end
    end

  end

 end

 function Jinx:w_combo_harass_logic()
  Prints("w combo/harass logic", 4)
  local target = self:Get_target(Data['W'])
  if target == nil then return false end

  if self:should_skip_w_cast() then return false end

  Prints("get chance" , 4)

  local w_hit =  _G.DreamPred.GetPrediction(target, Data['W'], g_local)
  if w_hit and self:should_try_w_hit_pred(w_hit) then
    Prints("combo: casting w hitChance is " .. w_hit.hitChance*100)
    local castPos = w_hit.castPosition
    spellbook:cast_spell(SLOT_W, 0, castPos.x, castPos.y, castPos.z)
    Last_cast_time = game.game_time
    return true
  end


  return false
end

function Jinx:w_ks_logic()
  Prints("w ks logic", 4)
  local enemies = core.objects:get_enemy_champs(Data['W'].range)

  local sorted_targets = self:get_sorted_w_targets(enemies)     -- adjust delay as needed
  local ks_w_hitChance = 65

  for _, target_info in ipairs(sorted_targets) do
    -- Prints("target: " .. tostring(target_info.target.object_name) .. " hp: " .. tostring(target_info.hp) .. " dmg: " .. tostring(target_info.damage) .. " hitChance: " .. tostring(target_info.hitChance), 2)
    if target_info.damage > target_info.hp + 15 and target_info.hp > 1 and target_info.hitChance*100 > ks_w_hitChance then

      local w_hit =  _G.DreamPred.GetPrediction(target_info.target, Data['W'], g_local)
      local w_KS_rate = menu:get_value(self.w_KS_rate) + 1


      if w_hit and w_hit.rates[Rates[w_KS_rate]] then
        Prints("KS: casting w hitChance is " .. tostring(w_hit.hitChance*100), 4)
        local castPos = w_hit.castPosition
        spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)
        Last_cast_time = game.game_time
        return true
      end
    end
  end
end


function Jinx:spell_w()
  Prints("w spell in", 4)

  local target = self:Get_target(Data['W'])
  local mode = combo:get_mode()

  local should_w_combo = (mode == Modes.Combo_key and get_menu_val(self.w_combo))
  local curr_mana_perc =  g_local.mana / g_local.max_mana * 100 
  local should_w_harass = (mode == Modes.Harass_key and get_menu_val(self.w_harass) and menu:get_value(self.w_harass_mana) <= curr_mana_perc)
  local should_w_ks = (get_menu_val(self.w_KS))

  -- not evade:is_evading() and
  if  target and core.vec3_util:distance(g_local.origin, target.origin) <= Data['W'].range then
    -- w Combo / harss logic
  if (should_w_combo or should_w_harass) and self:w_combo_harass_logic() then return true end
    --W KS logic
    if should_w_ks and self:w_ks_logic() then return true end
  end

  return false
end


local function get_e_vecs(start)
  local left = nil
  local right = nil
  if start then
    -- Prints("start: " .. tostring(start.x) .. " " .. tostring(start.y) .. " " .. tostring(start.z), 4)
    local offset = 180

    local dist = core.vec3_util:distance(start, g_local.origin) + offset
    Prints("dist: " .. tostring(dist), 4)
    
    local rotater = core.vec3_util:extend(g_local.origin, start, dist)
    Prints("rotater: " .. tostring(rotater.x) .. " " .. tostring(rotater.y) .. " " .. tostring(rotater.z), 4)


    --then we can rotate around the rotater pos
    left = core.vec3_util:rotate(start, rotater, 90)
    Prints("left: " .. tostring(left.x) .. " " .. tostring(left.y) .. " " .. tostring(left.z), 4)
    right = core.vec3_util:rotate(start, rotater, -90)
    Prints("right: " .. tostring(right.x) .. " " .. tostring(right.y) .. " " .. tostring(right.z), 4)

  end
  return left, start, right
end

function Jinx:count_hit_by_traps(center, enemies)
  Prints("count_hit_by_traps", 4)
  local hit_count = 0
  local left, _, right = get_e_vecs(center)
  Prints("left: " .. tostring(left.x) .. " " .. tostring(left.y) .. " " .. tostring(left.z), 4)
  Prints("center: " .. tostring(center.x) .. " " .. tostring(center.y) .. " " .. tostring(center.z), 4)
  Prints("right: " .. tostring(right.x) .. " " .. tostring(right.y) .. " " .. tostring(right.z), 4)

  for i, enemy in pairs(enemies) do
    if enemy and core.helper:is_alive(enemy) then

      local e_hit =  _G.DreamPred.GetPrediction(enemy, Data['E'], g_local)
      local e_hit_chance = menu:get_value(self.e_combo_rate) + 1

      if e_hit and e_hit.rates[Rates[e_hit_chance]] then
        local dist_to_center = core.vec3_util:distance(e_hit.castPosition, center)
        Prints("dist_to_center: " .. tostring(dist_to_center), 5)
        local dist_to_left = core.vec3_util:distance(e_hit.castPosition, left)
        Prints("dist_to_left: " .. tostring(dist_to_left), 5)
        local dist_to_right = core.vec3_util:distance(e_hit.castPosition, right)
        Prints("dist_to_right: " .. tostring(dist_to_right), 5)

        if dist_to_center < Data['E'].width or dist_to_left < Data['E'].width or dist_to_right < Data['E'].width then
          hit_count = hit_count + 1
        end
      end
    end
  end

  return hit_count
end
 -- 
function Jinx:should_e_multihit()
  local enemies = core.objects:get_enemy_champs(Data['E'].range - 50)

  for _, enemy in ipairs(enemies) do
    if enemy and core.helper:is_alive(enemy) then
      local e_hit =  _G.DreamPred.GetPrediction(enemy, Data['E'], g_local)

      local e_rate = menu:get_value(self.e_combo_rate) + 1
          
      if e_hit and e_hit.rates[Rates[e_rate]] then
        local hit_count = self:count_hit_by_traps(e_hit.castPosition, enemies)

        if hit_count > 1 then
          Prints("Casting E to hit " .. hit_count .. " enemies", 2)
          local castPos = e_hit.castPosition
          spellbook:cast_spell(e_spell_slot.e, Data['E'].delay, castPos.x, castPos.y, castPos.z)
          Last_cast_time = game.game_time
          return true
        end
      end
    end
  end

  return false
end


function Jinx:should_e_slowed()
  Prints("e spell slow check", 4)

  local target = self:Get_target(Data['E'])
  if target and core.helper:is_alive(target) then
    local e_hit =  _G.DreamPred.GetPrediction(target, Data['E'], g_local)
    
    -- 11 is slow
    if e_hit and e_hit.hitChance*100 >= 65 and target:has_buff_type(11) then
      Prints("Casting E on slowed target", 2)
      local castPos = e_hit.castPosition
      spellbook:cast_spell(e_spell_slot.e, Data['E'].delay, castPos.x, castPos.y, castPos.z)
      Last_cast_time = game.game_time
      -- 
      return true
    end
  end

  return false
end

function Jinx:spell_e()
  Prints("e spell in", 4)
  local mode = combo:get_mode()
  local should_e_combo = (mode == Modes.Combo_key and get_menu_val(self.e_combo))

  if should_e_combo and self:should_e_multihit() then
    return true     
  end
  if should_e_combo and self:should_e_slowed() then
    return true
  end

  return false
end

function Jinx:should_r_ks(sorted_targets)
  local rks_chance = menu:get_value(self.r_KS_hitChance)
  
  for _, target_info in ipairs(sorted_targets) do
    --                                                                                                menu:get_value(self.w_harass_hitChance)
    -- Prints("vals: " .. tostring(target_info.damage) .. " " .. tostring(target_info.hp) .. " " .. tostring(target_info.hitChance), 4)
    if target_info.damage > target_info.hp + 15 and target_info.hp > 1 and target_info.hitChance > rks_chance then
      -- Prints("rks get pred", 4)
      
      local r_hit =  _G.DreamPred.GetPrediction(target_info.target, Data['R'], g_local)
      local r_KS_castrate = menu:get_value(self.r_KS_rate) + 1

      if r_hit and r_hit.rates[Rates[r_KS_castrate]] then
        Prints("KS: casting r hitchance is " ..  r_hit.hitChance*100, 2)
        spellbook:cast_spell(e_spell_slot.r, Data["R"].delay, r_hit.castPosition.x, r_hit.castPosition.y, r_hit.castPosition.z)
        Last_cast_time = game.game_time
        return true
      end
    end
  end
  return false
end

function Jinx:get_semi_auto_r_target(sorted_targets)
  if #sorted_targets > 0 then
    return sorted_targets[1].target
  else
    return nil
  end
end

function Jinx:try_semi_auto_r(sorted_targets)
  Prints("r spell manual ", 2)

  local semi_auto_r_target = self:get_semi_auto_r_target(sorted_targets)
  if semi_auto_r_target then
    local r_hit =  _G.DreamPred.GetPrediction(semi_auto_r_target, Data['R'], g_local)
    -- local r_KS_rate = menu:get_value(self.r_KS_rate) + 1

    if r_hit then
      Prints("Casting R semi auto", 2)
      spellbook:cast_spell(e_spell_slot.r, Data["R"].delay, r_hit.castPosition.x, r_hit.castPosition.y, r_hit.castPosition.z)
      Last_cast_time = game.game_time
      return true
    end
  end
  return false
end

function Jinx:try_r_multihit(sorted_targets)
  if not core.objects:can_cast(e_spell_slot.r) then
    return false
  end
  Prints("in r multihit", 4)
  for i, enemy in pairs(sorted_targets) do
    local r_hit =  _G.DreamPred.GetPrediction(enemy.target, Data['R'], g_local)
    if r_hit then 
      local allies_to_follow = core.objects:get_ally_champs(800, enemy.target.origin) or 0
      local splashable_targets = core.objects:get_enemy_champs(400, enemy.target.origin)
      Prints("allies_to_follow: " .. #allies_to_follow .. " splashable_targets: " .. #splashable_targets, 4)
      local good_splashables = 0
      
      for _, splash_target in pairs(splashable_targets) do
        local perc_hp = core.helper:get_percent_hp(splash_target)
        Prints("perc_hp: " .. perc_hp, 4)
        if  perc_hp <= 65 then 
          good_splashables = good_splashables + 1
        end
      end

      local r_KS_rate = menu:get_value(self.r_KS_rate) + 1

      local do_multihit = #allies_to_follow >= 2 and good_splashables >= 2 and core.helper:get_percent_hp(enemy.target) <= 65 and r_hit.rates[Rates[r_KS_rate]]
      if do_multihit then
        Prints("Casting R to multihit with " .. allies_to_follow .. " allies and " .. good_splashables .. " enemies < 65%", 4)
        local castPos = r_hit.castPosition
        spellbook:cast_spell(e_spell_slot.r, Data['R'].delay, castPos.x, castPos.y, castPos.z)      
        Last_cast_time = game.game_time
        return true
      end
    end
  end

  return false
end

function Jinx:spell_r()
  Prints("r spell in", 4)

  -- if features.evade:is_active() or features.orbwalker:is_in_attack() or g_local.is_recalling then return false end

  -- get enemies in 3000 range
  local enemies = core.objects:get_enemy_champs(3000)
  
  Prints("spell_r -> get tgts from " .. #enemies, 4)
  
  -- get sorted targets from enemies
  local sorted_targets = self:get_sorted_r_targets(enemies)
  
  Prints("spell_r -> get tgts got: " .. #sorted_targets, 4)
  if #sorted_targets == 0 then return false end

  Prints("back with non 0 r targets",4)
  local should_SemiManualR = get_menu_val(self.checkboxManR)  and game:is_key_down(core.e_key.U)
  local should_r_multihit = combo:get_mode() == Modes.Combo_key and get_menu_val(self.r_combo_multihit)
  Prints("checking should r ks",4)

  -- r ks logic
  if get_menu_val(self.r_KS) and self:should_r_ks(sorted_targets) then return true end

  -- -- semi auto r logic
  if should_SemiManualR and self:try_semi_auto_r(sorted_targets) then return true end
  
  Prints("should semi auto: ", 4)
  if should_r_multihit and self:try_r_multihit(sorted_targets) then return true end
  return false
end

---==---==
function Jinx:Has_stasis(enemy)
  local stasis_end_time = 0
  local has_stasis = false

  for _, buff in ipairs(enemy.buffs) do
    if buff.name == "ChronoRevive" or buff.name == "ZhonyasRingShield" then
      stasis_end_time = buff.end_time
      Prints(
      "found stasis of type" ..
      buff.name .. " ending at " .. tostring(stasis_end_time) .. " on " .. enemy.champion_name.text, 3)
      has_stasis = true
    end
  end

  return has_stasis, stasis_end_time
end

function Jinx:On_stasis_special_channel(index)
  Prints("on special channel", 4)
  local enemy = game:get_object(index)
  if enemy then
    local has_stasis_buff, stasis_end_time = self:Has_stasis(enemy)
    if has_stasis_buff then
      local should_cast_w = false
      local should_cast_e = false

      if get_menu_val(self.w_auto) and core.objects:can_cast(e_spell_slot.w) and Data:in_range('W', enemy) then
        should_cast_w = true
      end

      if get_menu_val(self.e_auto) and core.objects:can_cast(e_spell_slot.e) and Data:in_range('E', enemy) then
        should_cast_e = true
      end
      if should_cast_e == false and should_cast_w == false then return end
      local remaining_stasis_time = stasis_end_time - game.game_time

      if should_cast_e or should_cast_w then
        Prints("okay lets try hand stasis", 3)
        if should_cast_e then
          local time_to_cast_e = 0.9
          Prints("E stasis cast: " .. tostring(remaining_stasis_time), 2)
          if remaining_stasis_time <= time_to_cast_e then
            local e_hit = _G.DreamPred.GetPrediction(enemy, Data['E'], g_local)
            local e_rate = menu:get_value(self.e_combo_rate) + 1


            if e_hit and e_hit.rates[Rates[e_rate]] then
              local castPos = e_hit.castPosition
              spellbook:cast_spell(e_spell_slot.e, Data['E'].delay, castPos.x, castPos.y, castPos.z)
    
              Last_cast_time = game.game_time
              return true
            end
          end
        end

        if should_cast_w then
          Prints("okay lets try hand w stasis", 2)

          local time_to_cast_w = game.game_time + remaining_stasis_time - Data['W'].castTime
          Prints("we want to cast at: " .. tostring(time_to_cast_w) .. "now it's: " .. tostring(game.game_time), 2)

          if game.game_time >= time_to_cast_w and game.game_time <= time_to_cast_w + 0.25 then
            Prints("Stasis: casting w for stasis game.game_time:" .. tostring(game.game_time), 2)
            local w_hit = _G.DreamPred.GetPrediction(enemy, Data['W'], g_local)
            
            if w_hit and self:should_try_w_hit_pred(w_hit) then
              local castPos = w_hit.castPosition
              Prints("stasis: casting w hitchance is " .. w_hit.hitchance*100, 2)
              spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)   
              Last_cast_time = game.game_time
              return true
            end
          end
        end
      end
    end
  end
end

function Jinx:On_cc_special_channel(index)
  Prints("On_cc_special_channel", 4)
  if g_local.is_recalling then return false end
  local enemy = game:get_object(index)
  if enemy then
    -- w_auto
    -- w_auto_cc  w_auto_channel w_auto_special
    if core.helper:is_alive(enemy) and not enemy.is_invisible then
      local should_cast_w = false
      local should_cast_e = false

      local is_immobile = false
      local is_ccd = false
      --local is_channeling = false 
      Prints("checking if " .. enemy.object_name .. " is ccd or immobile or stasis", 4)
      if core.helper:is_immobile(enemy) then is_immobile = true end
      if core.helper:has_hard_cc(enemy) then is_ccd = true end
      Prints("is ccd: " .. tostring(is_ccd) .. " is immobile: " .. tostring(is_immobile), 4)
      -- if self:Has_stasis(enemy) then return self:On_stasis_special_channel(index) end

      if is_immobile or is_ccd then

        Prints("is ccd or immobile looking to cast .. immobile: " .. tostring(is_immobile) .. " ccd: " .. tostring(is_ccd) , 2)

        if get_menu_val(self.w_auto) and core.objects:can_cast(e_spell_slot.w) and Data:in_range('W', enemy) then
          should_cast_w = true
        end
        -- please dont laser under enemy tower lol -- if in combo mode and not holding control key
        Prints("is under turret? ", 4)
        if (core.helper:is_under_turret(g_local.origin) and not combo:get_mode() == Modes.Combo_key) then
          should_cast_w = false
        end
        Prints("should cast w? ", 4)
        if get_menu_val(self.e_auto) and core.objects:can_cast(e_spell_slot.e) and Data:in_range('E', enemy) then
          should_cast_e = true
        end
      end
      Prints("should cast w? " .. tostring(should_cast_w) .. " should cast e? " .. tostring(should_cast_e), 4)
      if should_cast_e or should_cast_w then
        Prints("lets cast something e: " .. tostring(should_cast_e) .. " w: " .. tostring(should_cast_w), 2)
        
        if get_menu_val(self.e_auto) and core.objects:can_cast(e_spell_slot.e) and Data:in_range('E', enemy) then
          local e_hit =  _G.DreamPred.GetPrediction(enemy, Data['E'], g_local)
          local e_rate = menu:get_value(self.e_combo_rate) + 1
          
          if e_hit and e_hit.rates[Rates[e_rate]] then

          local castPos = e_hit.castPosition
          spellbook:cast_spell(e_spell_slot.e, Data['E'].delay, castPos.x, castPos.y, castPos.z)
          end
          
          Last_cast_time = game.game_time
        end
        Prints("lets cast something 2", 2)
        if get_menu_val(self.w_auto) and core.objects:can_cast(e_spell_slot.w) and Data:in_range('W', enemy) then

          local w_hit =  _G.DreamPred.GetPrediction(enemy, Data['W'], g_local)
          if w_hit and self:should_try_w_hit_pred(w_hit) then
            local castPos = w_hit.castPosition
            spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)
            Last_cast_time = game.game_time
          end
        end
      end
    end
  end
end

Recalling = {}

function Jinx:ProcessRecall(obj, tp_duration, tp_name, status)
  Prints("process recall", 4)
  for i, recall in ipairs(Recalling) do
    local target = game:get_object(recall.champ)

    if game.game_time > recall.end_time or (target.is_visible and not target.is_recalling or target.is_dead) then
      Prints("removing recall: " .. target.object_name, 2)
      table.remove(Recalling, i)
    end
  end
  
  local hero_Table = core.objects:get_enemy_champs(99999)
  for i, obj_hero in ipairs(hero_Table) do
    if obj_hero and core.helper:is_alive(obj_hero) and not obj_hero.is_invisible then

      -- local spell_book = obj_hero:get_spell_book()
      -- local cast_info = spell_book:get_spell_cast_info()
      if obj_hero.is_recalling then
        local recallIndex = nil
        for ii, recall in ipairs(Recalling) do
          if recall.champ == obj_hero.object_id then
            recallIndex = ii
            break
          end
        end
        if obj and tp_name == "Recall"  then
          local end_time = game.game_time + tp_duration -- calculate recall end time
          local recallData = { champ = obj_hero.object_id, origin = obj_hero.origin, start = game.game_time, end_time = end_time}
          if recallIndex then
            -- Update existing recall
            Recalling[recallIndex] = recallData
          else
            -- Add new recall
            Prints("adding recall: " .. obj_hero.object_name .. " end time: " .. tostring(end_time), 2)
            table.insert(Recalling, recallData)
          end
        end
      end
    end
  end
end


function Jinx:calculate_projectile_travel_time(distance)
  local r_speed_1 = 1700  -- Initial speed
  local r_speed_2 = 2200  -- Speed after 1350 units
  local r_acceleration_distance = 1350  -- Distance at which speed changes

  local time = 0
  
  if distance <= r_acceleration_distance then
    -- If distance is less than or equal to 1350, use the first speed
    time = distance / r_speed_1
  else
    -- If distance is more than 1350, calculate the time for the first 1350 units, then add the time for the remaining distance with the second speed
    local time_1 = r_acceleration_distance / r_speed_1
    local time_2 = (distance - r_acceleration_distance) / r_speed_2
    time = time_1 + time_2
  end

  return time
end
function Jinx:baseult()
  Prints("baseult in", 4)
  if Recalling and #Recalling == 0 then  Prints("baseult no", 4) return end
  Prints("entering baseult check", 4)
  local should_baseUlt = get_menu_val(self.r_auto_base_ult_vision) 
  Prints("should_baseUlt: " .. tostring(should_baseUlt), 4)
  local too_close = core.objects:is_enemy_near(Data['AA'].short_range)
  Prints("too_close: " .. tostring(too_close), 4)
  local controldown = game:is_key_down(core.e_key.control)
  Prints("controldown: " .. tostring(controldown), 4)
  local can_cast = core.objects:can_cast(e_spell_slot.r)
  Prints("can_cast: " .. tostring(can_cast), 4)


  
  if not should_baseUlt then Prints("shoudnt baseult", 2) return false end
  if too_close or controldown or not can_cast then Prints("cant cast/tooclose/holding contorl", 2) return false end
  Prints("look for recall ult: " .. tostring(should_baseUlt), 4)
  self:ProcessRecall()
  if #Recalling == 0 then return end
  -- Prints("still baseult check", 3)

  local delay = 0.015
  for i, recall in pairs(Recalling) do
    local enemy = game:get_object(recall.champ)
    if not enemy then return end
    local rdmg = core.damagelib:calc_spell_dmg("R", g_local, enemy, 1, core.objects:get_spell_level(e_spell_slot.r))
    -- local rdmg = 50000000

    if enemy.health + 30 > rdmg then
      Prints("should recall ult but they are not low :(", 3)
      return false
    end

    Prints("should ult and they are low", 3)
    local remainingTime = (recall.end_time - game.game_time)
    local enemy_dist = core.vec3_util:distance(g_local.origin, recall.origin)
    
    Prints("getting enemy base pos", 3)
    local enemy_base_position = core.objects:get_baseult_pos(enemy)
    Prints("getting dist to enemy base pos", 3)

    local base_dist = core.vec3_util:distance(g_local.origin, enemy_base_position)

    Prints("calculate_projectile_travel_time", 3)
    local time_To_hit_enemy = 0.692 + self:calculate_projectile_travel_time(enemy_dist) + delay
    local time_To_hit_base = 0.5 + self:calculate_projectile_travel_time(base_dist) + delay

    if (remainingTime >= time_To_hit_enemy) or (remainingTime >= time_To_hit_base) then
      Prints("looking for a recall ult... " .. tostring(remainingTime),2)
      -- start with try to hit enemy
      Prints("is collide check ...", 2)
      local is_colliding = core.vec3_util:is_colliding(g_local.origin, recall.origin, enemy, Data['R'].Width)
      Prints("is collide check done", 2)
      if not is_colliding then
        Prints("trying to hit enemy with recall ulti hold control to cancel .. " .. time_To_hit_enemy, 2)
        if remainingTime >= time_To_hit_enemy and remainingTime <= 6 then
          Prints("-=--==-=--= RECALL ULT =--=-==-=--=", 2)
          local castPosition = recall.origin
          spellbook:cast_spell(e_spell_slot.r, Data['R'].delay, castPosition.x, castPosition.y, castPosition.z)
          return true
        end
      end
      local base_colliding = core.vec3_util:is_colliding(g_local.origin, enemy_base_position, enemy, Data['R'].Width)
      if not base_colliding then
        Prints("trying to hit base with recall ulti hold control to cancel .. " .. tostring(time_To_hit_base), 2)
        if math.abs(remainingTime - time_To_hit_base) <= 0.05 then

          print("-=--==-=--= BASE ULT =--=-==-=--=", 2)
          local castPosition = enemy_base_position
          spellbook:cast_spell(e_spell_slot.r, Data['R'].delay, castPosition.x, castPosition.y, castPosition.z)
          return true
        end
      end
    end
  end
  -- Prints("baseult out", 2)

  return false
end

function Jinx:chainCC()
  Prints("chainCC in...", 4)

  if game.game_time - Last_cast_time <= 0.05 then return end
  Prints("tick after last cast check", 4)
  if g_local.is_recalling then return false end
  Prints("tick after recall check", 4)
  for i, enemy in pairs(core.objects:get_enemy_champs(2000)) do
    if core.helper:is_alive(enemy) and enemy.is_visible and core.vec3_util:distance(g_local.origin, enemy.origin) < 3000 then
      Prints("tick enemy check is_invincible", 4)
      if not DynastyOrb:IsAttacking() and not core.helper:is_invincible(enemy) then -- and not evade:is_evading() 
        Prints("check chain cc", 4)
        self:On_cc_special_channel(enemy.object_id)
      end
    end
  end
  Prints("tick exit", 4)
end

function Jinx:time_remaining_for_dash(cai)
  local dx = cai.path_end.x - cai.path_start.x
  local dy = cai.path_end.y - cai.path_start.y
  local dz = cai.path_end.z - cai.path_start.z

  local distance = std_math.sqrt(dx * dx + dy * dy + dz * dz)
  local time_remaining = distance / cai.dash_speed

  return time_remaining
end

function Jinx:on_dash(enemy, dash_info)
  if enemy.is_enemy and enemy.is_hero and core.vec3_util:distance(g_local.origin, enemy.origin) < 1600 then
    Prints("dash in...", 4)

      local cai = {
        path_end = dash_info.end_pos,
        path_start = enemy.origin,
        velocity = dash_info.dash_speed,
        dash_speed = dash_info.dash_speed,
        is_dashing = true,
        is_moving = enemy.is_moving,
      }

      if (get_menu_val(self.w_agc) or get_menu_val(self.e_agc)) then
        Prints("checking for dashes", 4) 
        if core.vec3_util:distance(g_local.origin, cai.path_end) > Data['W'].range then
          Prints("is dashing out of range of w :(", 2)
          return false
        end
        Prints("is dashing...", 4)

        local time_remaining = self:time_remaining_for_dash(cai)
        Prints("Time Remaining: " .. tostring(time_remaining), 4)
        -- e delay is
        -- w delay is
        Prints("e delay: " .. tostring(Data['E'].delay) .. " w delay: " .. tostring((time_remaining > Data['E'].delay - 0.5)), 4)
        Prints("w delay: " .. tostring(Data['W'].delay) .. " w delay: " .. tostring((time_remaining > Data['W'].delay - 0.5)), 4)


        if get_menu_val(self.e_agc) and (time_remaining > Data['E'].delay - 0.5) and core.vec3_util:distance(g_local.origin, cai.path_end) < Data['E'].range and core.objects:can_cast(e_spell_slot.e) then
          local e_hit =  _G.DreamPred.GetPrediction(enemy, Data['E'], g_local)
          if e_hit and e_hit.hitChance*100 >= 65 then
            Prints("e cast on dash ", 2)
            local castPos = e_hit.castPosition
            spellbook:cast_spell(e_spell_slot.e, Data['E'].delay, castPos.x, castPos.y, castPos.z)
            Last_cast_time = game.game_time
            return true
          end
        end
    
        -- dont w under tower unless already in combo mode
        if (core.helper:is_under_turret(g_local.origin) and not combo:get_mode() == Modes.Combo_key) then return false end
          if get_menu_val(self.w_agc) and time_remaining > (Data['W'].delay - 0.5) and core.objects:can_cast(e_spell_slot.w) then
            if core.vec3_util:distance(g_local.origin, cai.path_end) > 300 then
              Prints("attempted to cast W", 4)
              local w_hit =  _G.DreamPred.GetPrediction(enemy, Data['W'], g_local)
              if w_hit and self:should_try_w_hit_pred(w_hit) then
                Prints("cast w on dash " .. w_hit.hitChance*100, 2)
                local castPos = w_hit.castPosition
                spellbook:cast_spell(e_spell_slot.w, Data['W'].delay, castPos.x, castPos.y, castPos.z)
                return true
              end
            end
          end
    
        return false
      end
      Prints("dash exit", 2)
    end
    return false
end

function Jinx:get_harass_minions_near(obj_hero_idx, range)
  -- Prints("get harass min near enter", 3)
  local obj_hero = game:get_object(obj_hero_idx)
  local minions = core.objects:get_enemy_minions(1500)
  -- Prints("getting harass minions in range of " .. tostring(obj_hero.object_name) .. " x= " .. tostring(range) )
  -- Prints("getting harass minions out of " .. tostring(#minions))
  for i, obj_minion in ipairs(minions) do
    if obj_hero and obj_minion then
      if obj_hero and obj_minion and core.helper:is_alive(obj_minion) and obj_minion.is_visible and obj_minion.is_minion and obj_minion.is_targetable then
        if true then -- (obj_minion.object_name == "SRU_ChaosMinionRanged" or obj_minion.object_name == "SRU_ChaosMinionMelee" or obj_minion.object_name == "SRU_ChaosMinionSiege")
          local exists = 0
          -- Prints(" i can see and is alive: " .. tostring(obj_minion.object_name))
          if core.vec3_util:distance(obj_hero.origin, obj_minion.origin) < range then
            -- Prints("i see one " .. tostring(core.vec3_util:distance(obj_hero.origin, obj_minion.origin)))
            if MinionTable and #MinionTable > 0 then
              -- Prints("checking if our list already has " .. obj_minion.object_id)
              for ii, alive in ipairs(MinionTable) do
                -- Prints("have: " .. alive.idx .. " check: " .. obj_minion.object_id)
                if alive.idx == obj_minion.object_id then
                  -- Prints("we do!", 1)
                  exists = 1
                end
              end
            end
          end
          if exists == 0 then
            table.insert(MinionTable, { idx = obj_minion.object_id })
          end
        end
        if MinionTable and #MinionTable > 0 then
          for ii, alive_idx in ipairs(MinionTable) do
            local remove = false
            local alive = game:get_object(alive_idx.idx)
            if alive then
              if core.vec3_util:distance(obj_hero.origin, alive.origin) > range then remove = true end
              if core.helper:is_alive(alive) == false then remove = true end
              if alive.is_visible == false then remove = true end
            else
              remove = true
            end
            if remove then
              table.remove(MinionTable, ii)
            end
          end
        end
      end
    end
  end
  Prints("after a full loop ive got... " .. tostring(#MinionTable), 4)

  return true
end

function Jinx:validateSplashMinionAndtarget()
  Prints("validateSplashMinionAndtarget in", 4)

  if SplashabletargetIndex then
    local hero_obj = game:get_object(SplashabletargetIndex)
    if core.vec3_util:distance(g_local.origin, hero_obj.origin) < Data['AA'].long_range + core.objects:get_bounding_radius(hero_obj) then
      SplashabletargetIndex = nil
    elseif core.vec3_util:distance(hero_obj.origin, hero_obj.origin) > Data['AA'].long_range + 260 + core.objects:get_bounding_radius(hero_obj) then
      SplashabletargetIndex = nil
    elseif core.helper:is_alive(hero_obj) == false then
      SplashabletargetIndex = nil
    elseif hero_obj.is_visible == false then
      SplashabletargetIndex = nil
    end
    -- if SplashabletargetIndex then Prints("Splashable target valid", 1) else Prints("Splashable target removed", 1) end
    if SplashableMinionIndex then
      local min_obj = game:get_object(SplashableMinionIndex)
      if core.vec3_util:distance(g_local.origin, min_obj.origin) > Data['AA'].long_range + core.objects:get_bounding_radius(min_obj) then
        SplashableMinionIndex = nil
      elseif core.vec3_util:distance(hero_obj.origin, min_obj.origin) > 235 then
        SplashableMinionIndex = nil
      elseif core.helper:is_alive(min_obj) == false then
        SplashableMinionIndex = nil
      elseif min_obj.is_visible == false then
        SplashableMinionIndex = nil
      elseif min_obj.is_minion== false then
        SplashableMinionIndex = nil
      elseif min_obj.is_targetable== false then
        SplashableMinionIndex = nil
      end
      -- if SplashableMinionIndex then Prints("Splashable Minion valid", 1) else Prints("Splashable Minion removed", 1) end
    end
  end
  Prints("validateSplashMinionAndtarget out: ", 4)
end

function Jinx:findSplashableMinion()
  local target = self:Get_target(Data['AA'])
  if target == nil then return false end
  --update the global minion table nearby the target
  --Prints("finding splash minion", 1)
  self:get_harass_minions_near(target.object_id, 250)
  --get all the minions in AA range of me out of this table.
  if MinionTable and #MinionTable > 0 then
    for i, minionIdx in ipairs(MinionTable) do
      if SplashableMinionIndex == nil then
        
        local minion = game:get_object(minionIdx.idx)
        -- Prints("lf new splashable ... cus we dont got one rn")
        if core.vec3_util:distance(target.origin, minion.origin) < 236 then 
          -- Prints("lf new splashable ... and this looks good")

          if core.vec3_util:distance(g_local.origin, minion.origin) < Data['AA'].long_range + minion.bounding_radius then

            Prints("bing! idx is minions is at " .. core.vec3_util:distance(g_local.origin, minion.origin), 4)
            SplashableMinionIndex = minion.object_id
          end
        end
      end
    end
  end
end

function Jinx:Splash_harass()
  Prints("splash harass in", 4)
  if get_menu_val(self.checkboxJinxSplashHarass) == false then return false end
  -- if features.orbwalker:is_in_attack() or features.evade:is_active() or not core.objects:can_cast(e_spell_slot.q) then return false end
  local target = self:Get_target(Data['AA'])
  if target == nil then return false end
  SplashableTargetIndex = target.object_id
  Prints("sh obtained splash index: " .. tostring(SplashableTargetIndex), 5)
  

  self:validateSplashMinionAndtarget()

  --is target outside normal Q range?
  if core.helper:is_alive(target) and target.is_visible and core.vec3_util:distance(g_local.origin, target.origin) > Data['AA'].long_range + core.objects:get_bounding_radius(target) then
    if core.vec3_util:distance(g_local.origin, target.origin) < Data['AA'].long_range + 260 + core.objects:get_bounding_radius(target) then
      Prints("target is inside splash range.", 4)
      -- if we already have a splash minion then why are we still searching
      if SplashableMinionIndex == nil then Jinx:findSplashableMinion() end
      -- we may have found a minion so
      if SplashableMinionIndex then
        Prints("splash minion found", 5)
        local min_obj = game:get_object(SplashableMinionIndex)
        if min_obj and min_obj.is_minion then
          if combo:get_mode() == Modes.Harass_key or get_menu_val(self.q_auto) then
            Prints("about to predict onto target: " .. target.champ_name, 5)
            local nme_pred =  _G.DreamPred.GetPrediction(target, Data['AA'], g_local)
            Prints("sh back from pred", 5)
            -- local nme_pred =  _G.DreamPred.GetPrediction(target, aa_data, g_local)


            if nme_pred then 
              if core.vec3_util:distance(g_local.origin, min_obj.origin) < Data['AA'].long_range + core.objects:get_bounding_radius(min_obj) then
                  if core.vec3_util:distance(nme_pred.castPosition, min_obj.origin) < 235 then
                    if Data['AA'].rocket_launcher == false then
                      Prints("sending extendo need Q " .. min_obj.object_name, 2)
 
                      spellbook:cast_spell(e_spell_slot.q)
                      -- Last_Q_swap_time = game.game_time
                    end
                    if orbwalker:can_attack()  then
                      Prints("sending extendo attack to " .. min_obj.object_name, 5)
                      orbwalker:attack_target(min_obj)
                      Prints("back from extendo Q to " .. min_obj.object_name, 5)

                    end
                  end
              end
            end
          end
        end
      end
    end
  end

  Prints("splash harass out", 5)
end

function Jinx:show_splash_harass()
  Prints("show splash harass", 4)
  if SplashableTargetIndex then

    local tgt = game:get_object(SplashableTargetIndex)
    if tgt then
      Prints("splash champ", 4)

      -- self:get_harass_minions_near(SplashabletargetIndex, 250)
      -- -- circle the target
      core.vec3_util:drawCircle(tgt.origin, Colors.solid.red, 235)
      if MinionTable and #MinionTable > 0 then
        --Prints("splash?", 2)
        for ii, alive in ipairs(MinionTable) do
          local min = game:get_object(alive.idx)
          if min then

            local hmm = core.vec3_util:extend(min.origin, tgt.origin, core.vec3_util:distance(tgt.origin,  min.origin))
            -- print distance from tgt to min
            if tgt and min and core.vec3_util:distance(tgt.origin,  min.origin) < 260 then 
              -- Prints("drawing line", 2)
              -- renderer:draw_line(min.origin.x, min.origin.y, tgt.origin.x, tgt.origin.y, 15,255, 0, 0, 100)

              core.vec3_util:drawLine(min.origin, tgt.origin, Colors.solid.red, 2, "minToSplashLine") 
            end
          end
        end
      end
    end
  end
  if SplashableMinionIndex then
    -- Prints("draw minion", 3)

    local min = game:get_object(SplashableMinionIndex)
    if min then core.vec3_util:drawCircleFull(min.origin, Colors.transparent.green, 50) end
  else
    Prints("no splashable minion to draw lines too ", 4)
  end
  Prints("show splash harass out", 5)
end


--Visualize_spell_range
function Jinx:visualize_spell_range()
  -- Prints("draw ranges", 3)

  if get_menu_val(self.checkboxDrawQAlt) then
    if Data['AA'].rocket_launcher then
      -- Prints("draw long", 3)
      core.vec3_util:drawCircle(g_local.origin, Colors.solid.blue, Data['AA'].short_range)
    else
      -- Prints("draw short", 3)
      local col = Colors.solid.blue

      core.vec3_util:drawCircle(g_local.origin, Colors.solid.blue, Data['AA'].long_range)
    end
  end
  -- console:log("should draw current: " .. tostring(get_menu_val(self.checkboxDrawQCurrent)))
  if get_menu_val(self.checkboxDrawQCurrent) then
    local fill = core.color:new(120, 120, 255, 40)
    if not Data['AA'].rocket_launcher then
      core.vec3_util:drawCircleFull(g_local.origin, fill, Data['AA'].short_range)
      core.vec3_util:drawCircle(g_local.origin, Colors.transparent.white, Data['AA'].short_range)
    else
      core.vec3_util:drawCircleFull(g_local.origin, fill, Data['AA'].long_range)
      core.vec3_util:drawCircle(g_local.origin, Colors.transparent.white, Data['AA'].long_range)
    end
  end
  --draw w range
  if get_menu_val(self.checkboxDrawW) then
    core.vec3_util:drawCircle(g_local.origin, Colors.transparent.blue, Data['W'].range)
  end
end
-- drawLine = function(self, origin, destination, color, width)
function Jinx:on_draw()
  Prints("Draws", 4)
  -- if top and mid and bot and dancing then
  --   core.vec3_util:drawCircleFull(top, Colors.solid.red, 35)
  --   core.vec3_util:drawCircleFull(mid, Colors.solid.green, 35)
  --   core.vec3_util:drawCircleFull(bot, Colors.solid.blue, 35)
  --     --draw a line from me to mid
  --   core.vec3_util:drawLine(g_local.origin, mid, Colors.solid.green, 2)

  -- end

-- checkboxJinxSplashHarass
  if get_menu_val(self.checkboxJinxSplashHarass) then
    self:show_splash_harass()
  end
  if get_menu_val(self.checkboxDrawQCurrent) or get_menu_val(self.checkboxDrawQAlt) or get_menu_val(self.checkboxDrawW)  then
    -- Prints("draw Q", 3)
    self:visualize_spell_range()
  end

  -- draw all unkillable minions
  -- if #MinionsUnkillable > 0 then
  --   -- draw them all circles
  --   for i, minion in ipairs(MinionsUnkillable) do
  --     if minion  and core.helper:is_alive(minion) then
  --       core.vec3_util:drawCircleFull(minion.origin, Colors.solid.red, 35)
  --     else
  --       table.remove(MinionsUnkillable, i)
  --     end
  --   end
  -- end

end

-- -=-=-=--==-=-=-==--==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=-=-

--   CONFIG

-- -=-=-=--==-=-=-==--==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=-=-
function Jinx:on_tick_always()
    Prints("tick...", 4)
    if not get_menu_val(self.Jinx_enabled) then return end
    if (not g_local.is_alive) or g_local.is_recalling or (not client:is_focus())  then return false end


    if self:ready(e_spell_slot.q) then
        self:spell_q()
    end
    if self:ready(e_spell_slot.w) then
        self:spell_w()
    end
    if self:ready(e_spell_slot.e) then
        self:spell_e()
    end
    if self:ready(e_spell_slot.r) then
        self:spell_r()
    end
    -- if splash harass
    if get_menu_val(self.checkboxJinxSplashHarass) then
      self:Splash_harass()
    end

    --base_ult
    if self:ready(e_spell_slot.r) and get_menu_val(self.r_auto_base_ult_vision) then
      self:baseult()
    else
      if #Recalling > 0 then
        -- Prints("clearing recall list out ready bcus r not ready" , 2)
        -- Recalling = {}
      end
    end

    --chain cc
    self:chainCC()
end


-- check_for_prereqs()
core:init()

local JinxScript = Jinx:new()
Colors = core.Colors
