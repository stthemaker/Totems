local mod_name = minetest.get_current_modname()

minetest.register_craftitem("totems:totem_of_undying", {

    description = "it is going to bring you back from death",
	
	inventory_image = "totem_of_undying.png",
	
	stack_max = 1 --just like minecraft
	
})

minetest.register_craft({
	    output = "totems:totem_of_undying 1",
    recipe = {
        {"default:obsidian", "default:copper_block",
         "default:obsidian"},
        {"default:copper_block","default:obsidian",
         "default:copper_block"},
        {"default:gold_block","default:gold_block",
        "default:gold_block"},
    }
	
})

minetest.register_on_player_hpchange(function(player, hp_change,
modifier)
    -- Only trigger if the incoming damage is lethal
    local current_hp = player:get_hp()
    if current_hp + hp_change > 0 then
        return hp_change -- Damage isn't fatal, let it pass normally
    end

    -- Get the item currently held in the player's hand
    local wielded_item = player:get_wielded_item()

    -- Check if the item is our Totem
    if wielded_item:get_name() == "totems:totem_of_undying"then
        -- Remove 1 totem from the player's hand
        wielded_item:take_item()
        player:set_wielded_item(wielded_item)

        -- Save the player! Set health to 4 hearts (8 HP)
        player:set_hp(8)
		if minetest.get_modpath("stamina") then
			-- Ensure 'self' is a valid player object before grabbing the name
			if self and self.is_player and self:is_player() then
				local player_name = self:get_player_name()
				stamina.change(player_name, 200)
			end
		end

        -- Play a magic sound effect at the player's location
        minetest.sound_play("totems:jump.wav", {
            pos = player:get_pos(),
            gain = 1.0,
            max_hear_distance = 16,
        })

        -- Spawn a burst of golden particle effects
        local pos = player:get_pos()
        minetest.add_particlespawner({
            amount = 40,
            time = 0.5,
            minpos = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
            maxpos = {x = pos.x + 0.5, y = pos.y + 2, z = pos.z + 0.5
            },
            minvel = {x = -2, y = 1, z = -2},
            maxvel = {x = 2, y = 4, z = 2},
            minexptime = 1,
            maxexptime = 2,
            minsize = 1,
            maxsize = 3,
            texture = "default_item_smoke.png^[colorize:#FFD700:180",
             -- Colors standard smoke particle to gold
        })

        -- Alert the player via chat
        minetest.chat_send_player(player:get_player_name(), 
        "The Totem of Undying has saved your life!")

        -- Return 0 to completely cancel the lethal damage
        return 0
    end

    -- If they aren't holding the totem, let them die normally
    return hp_change
end, true) 
-- The 'true' modifier makes sure we intercept the absolute final 
--health calculation
