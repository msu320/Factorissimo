if not factorissimo then factorissimo = {} end
if not factorissimo.config then factorissimo.config = {} end

require("config")

-- GLOBALS --

function glob_init()
	global["factory-surface"] = global["factory-surface"] or {}
	global["surface-structure"] = global["surface-structure"] or {}
	global["surface-layout"] = global["surface-layout"] or {}
	global["surface-exit"] = global["surface-exit"] or {}
	global["health-data"] = global["health-data"] or {}
end

script.on_init(function()
	glob_init()
end)

-- BELT SCONN CONFIGURATION

script.on_configuration_changed(function(configuration)
	--post 0.1.6 configuration changes, for belt mechanics (added by msu320)
		script.on_event(defines.events.on_tick, function(event) belt_scheduler_configuration(event) end)
end)

-- handle the data changes after 0.1.6 for the belt handler scheduling 
function belt_scheduler_configuration(event)
	--needs to run once the game has started
	for surface_name, structure in pairs(get_all_structures()) do
		for id, sconn in pairs(structure.connections) do
			--sconn = structure.connections[id]
			if sconn then
				if sconn.outside.valid and sconn.inside.valid and sconn.conn_type == "belt" then
					sconn.l1_next_tick = sconn.l1_next_tick or 0
					sconn.l2_next_tick =sconn.l2_next_tick or  0
					sconn.l1_tick_delta = sconn.l1_tick_delta or 1
					sconn.l2_tick_delta = sconn.l2_tick_delta or 1
				end
			end
		end
	end
	--return to the regular on_tick function
	script.on_event(defines.events.on_tick, function(event) on_tick_handler(event) end)
end

-- SETTINGS --

DEBUG = false

LAYOUT = {
	["small-factory"] = {
		chunk_radius = 1,
		is_power_plant = false,
		entrance_x = 0,
		entrance_y = 19,
		exit_x = 0,
		exit_y = 3,
		provider_x = -4,
		provider_y = 20,
		distributor_x = 4,
		distributor_y = 20,
		rectangles = {
			{x1 = -19, x2 = 19, y1 = -19, y2 = 19, tile = "factory-wall"},
			{x1 = -6, x2 = 6, y1 = 18, y2 = 22, tile = "factory-wall"},
			{x1 = -18, x2 = 18, y1 = -18, y2 = 18, tile = "factory-floor"},
			{x1 = -2, x2 = 2, y1 = 18, y2 = 22, tile = "factory-entrance"},
		},
		possible_connections = {
			l1 = {
				outside_x = -4,
				outside_y = -2,
				inside_x = -19,
				inside_y = -14,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l2 = {
				outside_x = -4,
				outside_y = -1,
				inside_x = -19,
				inside_y = -5,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l3 = {
				outside_x = -4,
				outside_y = 0,
				inside_x = -19,
				inside_y = 4,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l4 = {
				outside_x = -4,
				outside_y = 1,
				inside_x = -19,
				inside_y = 13,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			t1 = {
				outside_x = -2,
				outside_y = -4,
				inside_x = -14,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t2 = {
				outside_x = -1,
				outside_y = -4,
				inside_x = -5,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t3 = {
				outside_x = 0,
				outside_y = -4,
				inside_x = 4,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t4 = {
				outside_x = 1,
				outside_y = -4,
				inside_x = 13,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			r1 = {
				outside_x = 3,
				outside_y = -2,
				inside_x = 18,
				inside_y = -14,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r2 = {
				outside_x = 3,
				outside_y = -1,
				inside_x = 18,
				inside_y = -5,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r3 = {
				outside_x = 3,
				outside_y = 0,
				inside_x = 18,
				inside_y = 4,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r4 = {
				outside_x = 3,
				outside_y = 1,
				inside_x = 18,
				inside_y = 13,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
		}
	},
	["small-power-plant"] = {
		chunk_radius = 1,
		is_power_plant = true,
		entrance_x = 0,
		entrance_y = 19,
		exit_x = 0,
		exit_y = 3,
		provider_x = -4,
		provider_y = 20,
		distributor_x = 4,
		distributor_y = 20,
		rectangles = {
			{x1 = -19, x2 = 19, y1 = -19, y2 = 19, tile = "factory-wall"},
			{x1 = -6, x2 = 6, y1 = 18, y2 = 22, tile = "factory-wall"},
			{x1 = -18, x2 = 18, y1 = -18, y2 = 18, tile = "factory-floor"},
			{x1 = -2, x2 = 2, y1 = 18, y2 = 22, tile = "factory-entrance"},
		},
		possible_connections = {
			l1 = {
				outside_x = -4,
				outside_y = -2,
				inside_x = -19,
				inside_y = -14,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l2 = {
				outside_x = -4,
				outside_y = -1,
				inside_x = -19,
				inside_y = -5,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l3 = {
				outside_x = -4,
				outside_y = 0,
				inside_x = -19,
				inside_y = 4,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			l4 = {
				outside_x = -4,
				outside_y = 1,
				inside_x = -19,
				inside_y = 13,
				direction_in = defines.direction.east,
				direction_out = defines.direction.west,
			},
			t1 = {
				outside_x = -2,
				outside_y = -4,
				inside_x = -14,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t2 = {
				outside_x = -1,
				outside_y = -4,
				inside_x = -5,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t3 = {
				outside_x = 0,
				outside_y = -4,
				inside_x = 4,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			t4 = {
				outside_x = 1,
				outside_y = -4,
				inside_x = 13,
				inside_y = -19,
				direction_in = defines.direction.south,
				direction_out = defines.direction.north,
			},
			r1 = {
				outside_x = 3,
				outside_y = -2,
				inside_x = 18,
				inside_y = -14,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r2 = {
				outside_x = 3,
				outside_y = -1,
				inside_x = 18,
				inside_y = -5,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r3 = {
				outside_x = 3,
				outside_y = 0,
				inside_x = 18,
				inside_y = 4,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
			r4 = {
				outside_x = 3,
				outside_y = 1,
				inside_x = 18,
				inside_y = 13,
				direction_in = defines.direction.west,
				direction_out = defines.direction.east,
			},
		}
	}
}

-- FACTORY WORLD ASSIGNMENT --

function create_surface(factory, layout)
	local surface_name = "Inside factory " .. factory.unit_number
	local surface = game.create_surface(surface_name, {width = 64*layout.chunk_radius-62, height = 64*layout.chunk_radius-62})
	reset_daytime(surface)
	surface.request_to_generate_chunks({0, 0}, layout.chunk_radius)
	global["factory-surface"][factory.unit_number] = surface -- surface_name
	global["surface-structure"][surface_name] = {parent = factory, ticks = 0, connections = {}, chunks_generated = 0, chunks_required = 4*layout.chunk_radius*layout.chunk_radius, finished = false}
	global["surface-layout"][surface_name] = layout
	global["surface-exit"][surface_name] = {x = factory.position.x+layout.exit_x, y = factory.position.y+layout.exit_y, surface = factory.surface}
end

function connect_factory_to_existing_surface(factory, surface)
	global["factory-surface"][factory.unit_number] = surface
	global["surface-structure"][surface.name].parent = factory
	local layout = get_layout(surface)
	global["surface-exit"][surface.name] = {x = factory.position.x+layout.exit_x, y = factory.position.y+layout.exit_y, surface = factory.surface}
end

function has_surface(factory)
	return global["factory-surface"][factory.unit_number] ~= nil
end

function get_surface(factory)
	if global["factory-surface"][factory.unit_number] then
		return global["factory-surface"][factory.unit_number]
	else
		return nil
	end
end

function is_factory(surface)
	return global["surface-structure"][surface.name] ~= nil
end

function get_structure(surface)
	return global["surface-structure"][surface.name]
end

function set_structure(surface, structure_id, entity)
	global["surface-structure"][surface.name][structure_id] = entity
end

function get_all_structures()
	return global["surface-structure"]
end

function get_layout(surface)
	return global["surface-layout"][surface.name]
end

function get_layout_by_name(surface_name)
	return global["surface-layout"][surface_name]
end

function get_exit(surface)
	return global["surface-exit"][surface.name]
end

function save_health_data(factory)
	i = 1
	while global["health-data"][i] do
	i = i + 1
	end
	if i > factory.prototype.max_health-1 then
		for _, player in pairs(game.players) do
			player.print("You have picked up too many factories at once. Tell the dev about this, he'll be impressed and slightly worried.")
		end
	else
		if i > factory.prototype.max_health-100 then
			for _, player in pairs(game.players) do
				player.print("Approaching factory pickup limit. What are you doing with all these factories in your inventory?")
			end
		end
		global["health-data"][i] = {
			surface = get_surface(factory),
			health = factory.health,
			backer_name = factory.backer_name,
			energy = factory.energy,
		}
		factory.health = i
		dbg("Saved factory to health value " .. i)
	end
end

function get_and_delete_health_data(health)
	local health_int = math.floor(health+0.5)
	local data = global["health-data"][health_int]
	global["health-data"][health_int] = nil
	return data
end

-- FACTORY INTERIOR GENERATION --

-- Daytime values: 0 is eternal night, 1 is regular, 2 is eternal day
function reset_daytime(surface)
	local daytime = 0
	local layout = get_layout(surface)
	if not layout then return end
	if layout.is_power_plant then
		daytime = factorissimo.config.power_plant_daytime
	else
		daytime = factorissimo.config.factory_daytime
	end
	if daytime == 2 then
		surface.daytime = 0 -- Midday
		surface.freeze_daytime(true)
	elseif daytime == 0 then
		surface.daytime = 0.5 -- Midnight
		surface.freeze_daytime(true)
	else
		surface.daytime = game.surfaces["nauvis"].daytime
		surface.freeze_daytime(false)
	end
end

function delete_entities(surface)
	for _, entity in pairs(surface.find_entities({{-1000, -1000},{1000, 1000}})) do
		entity.destroy()
	end
end

function add_tile_rect(tiles, tile_name, xmin, ymin, xmax, ymax) -- tiles is rw
	local i = #tiles
	for x = xmin, xmax-1 do
		for y = ymin, ymax-1 do
			i = i + 1
			tiles[i] = {name = tile_name, position={x, y}}
		end
	end
end

function place_entity(surface, entity_name, x, y, force, direction)
	entity = surface.create_entity{name = entity_name, position = {x, y}, force = force, direction = direction}
	if entity then
		entity.minable = false
		entity.rotatable = false
		entity.destructible = false
	end
	return entity
end


-- TODO merge with place_entity?
function place_entity_generated(surface, entity_name, x, y, structure_id)
	entity = surface.create_entity{name = entity_name, position = {x, y}, force = get_structure(surface).parent.force}
	if entity then
		entity.minable = false
		entity.rotatable = false
		entity.destructible = false
		if structure_id and entity then
			dbg("Placed and registered " .. structure_id)
			set_structure(surface, structure_id, entity)
		end
	end
end

function build_factory_interior(factory, surface, layout, structure)
	delete_entities(surface)
	tiles = {}
	for _, pconn in pairs(layout.possible_connections) do
		add_tile_rect(tiles, "factory-wall", pconn.inside_x-1, pconn.inside_y-1, pconn.inside_x+2, pconn.inside_y+2)
	end
	for _, rect in pairs(layout.rectangles) do
		add_tile_rect(tiles, rect.tile, rect.x1, rect.y1, rect.x2, rect.y2)
	end
	surface.set_tiles(tiles)
	if layout.is_power_plant then
		place_entity_generated(surface, "factory-power-receiver", layout.provider_x, layout.provider_y, "power_provider")
	else
		place_entity_generated(surface, "factory-power-provider", layout.provider_x, layout.provider_y, "power_provider")
	end
	place_entity_generated(surface, "factory-power-distributor", layout.distributor_x, layout.distributor_y)
	structure.finished = true
end

script.on_event(defines.events.on_chunk_generated, function(event)
	if is_factory(event.surface) then
		local structure = get_structure(event.surface)
		structure.chunks_generated = structure.chunks_generated + 1 -- Wait until all chunks are generated and then some, to avoid other mods' worldgen interfering
	end
end)


-- PLACING, PICKING UP FACTORIES

function on_built_factory(factory)
	factory.rotatable = false
	health_data = get_and_delete_health_data(factory.health)
	if health_data then
		connect_factory_to_existing_surface(factory, health_data.surface)
		for k, v in pairs(health_data) do
			if k ~= "surface" then
				factory[k] = v
			end
		end

	elseif not has_surface(factory) then -- Should always be the case, but just in case
		dbg("Generating new factory interior")
		local layout = LAYOUT[factory.name]
		create_surface(factory, layout)
		factory.energy = 0
	end
end

 -- Workaround to not really being able to store information in a deconstructed entity:
 -- I store the factory information in the factory item by modifying its health value right before it is picked up, and storing all relevant
 -- information in a global table indexed by the new unique health value (including the factory's actual health). When the damaged factory item is
 -- placed down again, I look for its health value in the table and retrieve the information from there, restoring its name, health,
 -- stored energy, and most importantly the link to the surface acting as its interior.
 -- This has the neat side effect of making initialized factories non-stackable.
 -- However things may break a little if some other mod has the bright idea of changing health values of my items,
 -- or aborting factory deconstruction, or, well, you get the point.


function on_picked_up_factory(factory)
	save_health_data(factory)
	local structure = get_structure(get_surface(factory))
	for _, sconn in pairs(structure.connections) do
		if sconn.inside.valid then sconn.inside.destroy() end
	end
	structure.connections = {}
end

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
	local factory = event.created_entity
	if LAYOUT[factory.name] then
		on_built_factory(factory)
	end
end)

script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined}, function(event)
	local factory = event.entity
	if LAYOUT[factory.name] then
		on_picked_up_factory(factory)
	end
end)

-- FACTORY MECHANICS

function transfer_items_chest(from, to) -- from, to are inventories
	for t, c in pairs(from.get_contents()) do
		from.remove{name = t, count = to.insert{name = t, count = c}}
	end
end

--possible alternative to transfer_items_chest; try and grab one stack per tick 
--untested but should work in theory
function iterate_items_chest(from,to) -- from, to are lua::inventories
	itemstack = { name = next(from.get_contents()), count = 500 }
	if itemstack.name ~= nil then 
		itemstack.count = to.insert(itemstack)
		if itemstack.count > 0 then
			from.remove_item(itemstack)
		end
	end
end

--transfer up to 4 items between luaTransportLine's
--returns the no. of items actually transferred
function bulk_transfer_belt_line(from, to) -- from, to are lines
	itemstack = nil
	count = 0
	--local list = from.get_contents()
	--unrolled loop for 'speed' 
	itemstack = {name = next(from.get_contents()),count=1 }
	if itemstack.name ~= nil and to.insert_at(0.0155,itemstack) then --0.578
		from.remove_item(itemstack)
		count=count+1
		itemstack = {name = next(from.get_contents()),count=1 }
	end
	if itemstack.name ~= nil and to.insert_at(0.29675,itemstack) then --0.578
		from.remove_item(itemstack)
		count=count+1
		itemstack = {name = next(from.get_contents()),count=1 }
	end
	if itemstack.name ~= nil and to.insert_at(0.578,itemstack) then --0.578
		from.remove_item(itemstack)
		count=count+1
		itemstack = {name = next(from.get_contents()),count=1 }
	end
	if itemstack.name ~= nil and to.insert_at(0.85925,itemstack) then -- 0.85925
		from.remove_item(itemstack)
		count=count+1
	end
	return count
end

function balance_fluids_pipe(from, to) -- from, to are pipes
	fluid1 = from.fluidbox[1]
	fluid2 = to.fluidbox[1]
	if fluid1 and fluid2 then
		if fluid1.type == fluid2.type then
			local amount = fluid1.amount + fluid2.amount
			local temperature = (fluid1.amount*fluid1.temperature+fluid2.amount*fluid2.temperature)/amount -- Total temperature balance
			from.fluidbox[1] = {type = fluid1.type, amount=amount/2, temperature=temperature}
			to.fluidbox[1] = {type = fluid1.type, amount=amount/2, temperature=temperature}
		end
	elseif fluid1 or fluid2 then
		fluid = fluid1 or fluid2
		fluid.amount = fluid.amount/2
		from.fluidbox[1] = fluid
		to.fluidbox[1] = fluid
	end
end

function balance_power(from, to, multiplier)
	local max_transfer_energy = math.min(from.energy, to.electric_buffer_size - to.energy)
	from.energy = from.energy - max_transfer_energy
	to.energy = to.energy + max_transfer_energy * multiplier
end

script.on_event(defines.events.on_tick, function(event) on_tick_handler(event) end)

--deanonymized on_tick function so it can be returned to from the on configuration_changed handler for the new belt handling
function on_tick_handler(event)

	-- PLAYER TRANSFER
	if (game.tick%2 <1 ) then
		for _, player in pairs(game.players) do
			if player.vehicle == nil and player.walking_state.walking == true then
				try_enter_factory(player)
				try_leave_factory(player)
			end
		end
	end
	
	-- FACTORY INVENTORY TRANSFER
	for surface_name, structure in pairs(get_all_structures()) do
		if structure.parent and structure.parent.valid and structure.finished then -- Don't do anything before the interior has finished generating
		
			structure.ticks = (structure.ticks or 0) + 1
		
			local surface = get_surface(structure.parent) --game.surfaces[surface_name]
			local parent_surface = structure.parent.surface
			local layout = get_layout(surface)
			
			-- TRANSFER POWER
			if structure.power_provider and structure.power_provider.valid then
				if layout.is_power_plant then
					balance_power(structure.power_provider, structure.parent, factorissimo.config.power_output_multiplier)
				else
					balance_power(structure.parent, structure.power_provider, factorissimo.config.power_input_multiplier)
				end
			end
			
			-- TRANSFER ITEMS
			
			for id, pconn in pairs(layout.possible_connections) do
				sconn = structure.connections[id]
				if sconn then
					if sconn.outside.valid and sconn.inside.valid then
						-- TRANSFER ITEMS
						-- This takes up a lot of CPU, but there isn't really a better way to do it :(
						if sconn.conn_type == "chest" then
							transfer_items_chest(
								sconn.from.get_inventory(defines.inventory.chest),
								sconn.to.get_inventory(defines.inventory.chest)
							)
						elseif sconn.conn_type == "belt" then
							--process the belt pair on a per lua::transportLine basis
							if (sconn.l1_next_tick <= game.tick
								and sconn.to.get_transport_line(1).get_item_count() == 0) then	--side '1'
								count = bulk_transfer_belt_line(--process belt, and get count of items passed
								sconn.from.get_transport_line(1), 
								sconn.to.get_transport_line(1))
								if count==4 then --if we can place all 4 items, assume we need smaller tick delta
									sconn.l1_tick_delta = sconn.l1_tick_delta *0.95
								else --otherwise increase speed
									sconn.l1_tick_delta = sconn.l1_tick_delta *1.05
								end 
								--boundry checking
								if (sconn.l1_tick_delta < 1) then sconn.l1_tick_delta = 1 end
								if (sconn.l1_tick_delta > 60) then sconn.l1_tick_delta = 60 end
								--assign next tick
								sconn.l1_next_tick = math.floor(game.tick + sconn.l1_tick_delta)
							end						
							if (sconn.l2_next_tick <= game.tick) then   --side '2'
								count = bulk_transfer_belt_line(--process belt, and get count of items passed
								sconn.from.get_transport_line(2), 
								sconn.to.get_transport_line(2))
								if count==4 then 
									sconn.l2_tick_delta = sconn.l2_tick_delta *0.95
								else
									sconn.l2_tick_delta = sconn.l2_tick_delta *1.05
								end 
								--boundry checking
								if (sconn.l2_tick_delta < 1) then sconn.l2_tick_delta = 1 end
								if (sconn.l2_tick_delta > 60) then sconn.l2_tick_delta = 60 end
								--assign next tick
								sconn.l2_next_tick = math.floor(game.tick + sconn.l2_tick_delta)
							end
						elseif sconn.conn_type == "pipe" then
							balance_fluids_pipe(
								sconn.from,
								sconn.to
							)
						end
					else
						-- DELETE CONNECTION
						if sconn.inside.valid then sconn.inside.destroy() end
						structure.connections[id] = nil
					end
					
				elseif structure.ticks % 60 < 1 then
					-- CREATE CONNECTION
					
					local px = pconn.outside_x + structure.parent.position.x+0.5
					local py = pconn.outside_y + structure.parent.position.y+0.5
					
					local e3 = parent_surface.find_entities_filtered{area = {{px-0.2, py-0.2},{px+0.2, py+0.2}}, type="transport-belt"}[1]
					local e4 = parent_surface.find_entities_filtered{area = {{px-0.2, py-0.2},{px+0.2, py+0.2}}, type="pipe"}[1]
					local e5 = parent_surface.find_entities_filtered{area = {{px-0.2, py-0.2},{px+0.2, py+0.2}}, type="pipe-to-ground"}[1]
					
					if e3 then
						if e3.direction == pconn.direction_in then
							dbg("Connecting inwards belt")
							local e = place_entity(surface, e3.name, pconn.inside_x, pconn.inside_y, structure.parent.force)
							if e then
								e.direction = e3.direction
								e3.rotatable = false
								structure.connections[id] = {from = e3, to = e, inside = e, outside = e3, conn_type = "belt", l1_next_tick = 0, l2_next_tick = 0, l1_tick_delta = 1, l2_tick_delta=1}
							end
						elseif e3.direction == pconn.direction_out then
							dbg("Connecting outwards belt")
							local e = place_entity(surface, e3.name, pconn.inside_x, pconn.inside_y, structure.parent.force)
							if e then
								e.direction = e3.direction
								e3.rotatable = false
								structure.connections[id] = {from = e, to = e3, inside = e, outside = e3, conn_type = "belt", l1_next_tick = 0, l2_next_tick = 0, l1_tick_delta = 1, l2_tick_delta=1}
							end
						end
					elseif e4 then
						dbg("Connecting pipe")
						local e = place_entity(surface, e4.name, pconn.inside_x, pconn.inside_y, structure.parent.force, pconn.direction_in)
						if e then
							structure.connections[id] = {from = e, to = e4, inside = e, outside = e4, conn_type = "pipe"}
						end
					elseif e5 then
						if e5.direction == pconn.direction_in then
							dbg("Connecting pipe to ground")
							local e = place_entity(surface, e5.name, pconn.inside_x, pconn.inside_y, structure.parent.force, pconn.direction_in)
							if e then
								e5.rotatable = false
								structure.connections[id] = {from = e, to = e5, inside = e, outside = e5, conn_type = "pipe"}
							end
						end
					end
				end
			end
			
			-- TRANSFER POLLUTION
			if structure.ticks % 60 < 1 then
				local exit_pos = get_exit(surface) 
				for y = -1,1,2 do
					for x = -1,1,2 do
						local pollution = surface.get_pollution({x, y})
						surface.pollute({x, y}, -pollution/2)
						parent_surface.pollute({exit_pos.x, exit_pos.y}, (pollution/2) * factorissimo.config.pollution_multiplier)
					end
				end
			end
		elseif structure.parent and structure.parent.valid and structure.chunks_generated == structure.chunks_required then
			-- We need to wait until the factory interior surface is generated with default worldgen, then replace it with our own interior
			local surface = game.surfaces[surface_name]
			local layout = get_layout(surface)
			build_factory_interior(structure.parent, surface, layout, structure)
			-- This can theoretically be called repeatedly each tick until the factory is marked finished
		end
	end
end

-- ENTERING/LEAVING FACTORIES

function get_factory_beneath(player)
	local entities = player.surface.find_entities_filtered{area = {{player.position.x-0.2, player.position.y-0.3},{player.position.x+0.2, player.position.y}}, type = "roboport"}
	for _, entity in pairs(entities) do
		if LAYOUT[entity.name] then
			return entity
		end
	end
	return nil
end

function get_exit_beneath(player)
	-- Depends on location of power distributor!
	local entities = player.surface.find_entities_filtered{area={{player.position.x+2, player.position.y-3},{player.position.x+6, player.position.y-2}}, name="factory-power-distributor"}
	return entities[1]
end

function try_enter_factory(player)
	local factory = get_factory_beneath(player)
	if factory and math.abs(factory.position.x-player.position.x) < 0.6 then
		local new_surface = get_surface(factory)
		if new_surface then
			local structure = get_structure(new_surface)
				if structure.finished then
					local layout = get_layout(new_surface)
					reset_daytime(new_surface)
					player.teleport({layout.entrance_x, layout.entrance_y}, new_surface)
					return true
				end
		end
	end
	return false
end

function try_leave_factory(player)
	local exit_building = get_exit_beneath(player)
	if exit_building then
		local exit_pos = get_exit(player.surface)
		if exit_pos then
			player.teleport({exit_pos.x, exit_pos.y}, exit_pos.surface)
			return true
		end
	end
	return false
end

-- DEBUGGING

if DEBUG then
	script.on_event(defines.events.on_player_created, function(event)
		local player = game.players[event.player_index]
		player.insert{name="small-factory", count=10}
		player.insert{name="express-transport-belt", count=200}
		player.insert{name="steel-axe", count=10}
		player.insert{name="medium-electric-pole", count=100}
		player.cheat_mode = true
		--player.gui.top.add{type="button", name="enter-factory", caption="Enter Factory"}
		--player.gui.top.add{type="button", name="leave-factory", caption="Leave Factory"}
		player.gui.top.add{type="button", name="debug", caption="Debug"}
		player.force.research_all_technologies()
	end)
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.player_index]
	if event.element.name == "enter-factory" then
		try_enter_factory(player)
	end
	if event.element.name == "leave-factory" then
		try_leave_factory(player)
	end
	if event.element.name == "debug" then
		debug_this(player)
	end
end)

function dbg(text)
	if DEBUG then
		game.players[1].print(text)
	end
end

function debug_this(player)
	local i = 0
	for surface_name, structure in pairs(get_all_structures()) do
		i = i+1
		player.print("(" .. i .. ") Found structure " .. surface_name)
		for id, entity in pairs(structure) do
			i = i+1
			player.print("(" .. i .. ") Found entity " .. (entity.name or "-") .. " as " .. id)
			if entity.valid then
				player.print("(" .. i .. ") Entity is valid")
			else
				player.print("(" .. i .. ") Entity is invalid")
			end
		end
		
	end
	local entities = player.surface.find_entities_filtered{area = {{player.position.x-3, player.position.y-3},{player.position.x+3, player.position.y+3}}}
	for _, entity in pairs(entities) do
		if entity.electric_buffer_size or true then
			i = i + 1
			player.print("(" .. i .. ") Entity: " .. entity.name)
			player.print("(" .. i .. ") Buffer size: " .. (entity.electric_buffer_size or "-"))
			player.print("(" .. i .. ") Energy: " .. (entity.energy or "-"))
			player.print("(" .. i .. ") Health: " .. (entity.health or "-"))
		end
	end
end
