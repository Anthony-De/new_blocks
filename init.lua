-- stripped wood

local function register_stripped_tree(blockname)
    local lower_case_blockname = blockname:lower()
    minetest.register_node("new_blocks:stripped_" .. lower_case_blockname .. "_tree", {
        description = blockname .. " Tree",
        tiles = {
            "new_blocks_stripped_".. lower_case_blockname .."_tree_top.png", -- top
            "new_blocks_stripped_".. lower_case_blockname .."_tree_top.png", -- bottom
            "new_blocks_stripped_".. lower_case_blockname .."_tree.png", -- sides
        },
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
        paramtype2 = "facedir",
        sounds = default.node_sound_wood_defaults()
    })
end

register_stripped_tree("Apple")
register_stripped_tree("Pine")
register_stripped_tree("Aspen")
register_stripped_tree("Jungle")
register_stripped_tree("Acacia")

-------------------------------------------------------
--            STONE REGISTERING FUNCTIONS            --
-------------------------------------------------------

local function register_stone(blockname)
    local lower_case_blockname = blockname:lower()
    minetest.register_node("new_blocks:" .. lower_case_blockname, {
        description = blockname,
        tiles = {"new_blocks_".. lower_case_blockname ..".png"},
        groups = {cracky = 3, stone = 1},
        sounds = default.node_sound_stone_defaults()
    })
end

local function register_stone_smooth(blockname)
    local lower_case_blockname = blockname:lower() .. "_smooth"
    minetest.register_node("new_blocks:" .. lower_case_blockname, {
        description = "Smooth " .. blockname,
        tiles = {"new_blocks_".. lower_case_blockname ..".png"},
        groups = {cracky = 3, stone = 1},
        sounds = default.node_sound_stone_defaults()
    })
end

local function register_stone_brick(blockname)
    local lower_case_blockname = blockname:lower() .. "_brick"
    minetest.register_node("new_blocks:" .. lower_case_blockname, {
        description = blockname .. " Brick",
        tiles = {
            "new_blocks_".. lower_case_blockname .."_top.png",  -- top texture
            "new_blocks_".. lower_case_blockname .."_top.png",  -- bottom texture
            "new_blocks_".. lower_case_blockname .."_side.png", -- remaining sides use the same texture
            "new_blocks_".. lower_case_blockname .."_side.png",
            "new_blocks_".. lower_case_blockname .."_side.png",
            "new_blocks_".. lower_case_blockname .."_side.png"
        },
        groups = {cracky = 3, stone = 1},
        sounds = default.node_sound_stone_defaults()
    })
end

local function register_stone_crystal(blockname)
    local lower_case_blockname = blockname:lower()
    minetest.register_node("new_blocks:" .. lower_case_blockname, {
        description = blockname,
        drawtype = "glasslike",
        tiles = {"new_blocks_" .. lower_case_blockname .. ".png"},
        use_texture_alpha = "blend",
        sunlight_propagates = true,
        groups = {cracky = 3, stone = 1},
        sounds = default.node_sound_glass_defaults()
    })
end

-------------------------------------------------------
--             REGISTER STONE VARIANTS               --
-------------------------------------------------------

register_stone_crystal("Gypsum")
register_stone("Chert")

register_stone("Gneiss")
register_stone_smooth("Gneiss")
register_stone_brick("Gneiss")

register_stone("Granite")
register_stone_smooth("Granite")
register_stone_brick("Granite")

register_stone("Marble")
register_stone_smooth("Marble")
register_stone_brick("Marble")

register_stone("Schist")
register_stone_smooth("Schist")
register_stone_brick("Schist")

register_stone("Shale")
register_stone_smooth("Shale")
register_stone_brick("Shale")

register_stone("Slate")
register_stone_smooth("Slate")
register_stone_brick("Slate")

-------------------------------------------------------
--                      VINES                        --
-------------------------------------------------------

minetest.register_node("new_blocks:vines", {
    description = "Vines",
    drawtype = "signlike",
    tiles = {"new_blocks_vines.png"},
    inventory_image = "new_blocks_vines.png",
    wield_image = "new_blocks_vines.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    climbable = true,
    is_ground_content = false,
    selection_box = {
	type = "wallmounted",
    },
    groups = {snappy = 3, flammable = 2},
    legacy_wallmounted = true,
    sounds = default.node_sound_leaves_defaults()
})

-------------------------------------------------------
--                    DIRT PATH                      --
-------------------------------------------------------

minetest.register_node("new_blocks:dirt_path", {
	description = "Dirt Path",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, (0.5/16)*14, 0.5},  -- Defines the dimensions of the block
		},
	},
	tiles = {
        "new_blocks_dirt_path.png",
        "default_dirt.png",
        "default_dirt.png",
        "default_dirt.png",
        "default_dirt.png",
        "default_dirt.png"
    },
	groups = {crumbly = 3, soil = 1},
    sounds = default.node_sound_dirt_defaults()
})

-------------------------------------------------------
--                 SHOVEL/AXE LOGIC                  --
-------------------------------------------------------

local function is_shovel(itemname)
    return string.find(itemname, "shovel") ~= nil
end

local function is_axe(itemname)
    return string.find(itemname, "axe") ~= nil
end

local function shovel_on_place(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "node" then
        -- Do nothing if not right-clicking on a node
        return
    end

    local node_name = minetest.get_node(pointed_thing.under).name
    if  node_name == "default:dirt" or
        node_name == "default:dirt_with_grass" or
        node_name == "default:dry_dirt_with_dry_grass" or
        node_name == "default:dirt_with_dry_grass" then
        -- Replace the node with dirt_path if it's a dirt node
        minetest.set_node(pointed_thing.under, {name="new_blocks:dirt_path"})
    else
        -- Otherwise, carry out the default on_place action
        return minetest.item_place(itemstack, user, pointed_thing)
    end
end

local function axe_on_place(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "node" then
        -- Do nothing if not right-clicking on a node
        return
    end

    local old_node = minetest.get_node(pointed_thing.under)
    local node_name = old_node.name

    if node_name == "default:tree" then
        minetest.set_node(pointed_thing.under, {name="new_blocks:stripped_apple_tree", param2=old_node.param2})
    elseif node_name == "default:pine_tree" then
        minetest.set_node(pointed_thing.under, {name="new_blocks:stripped_pine_tree", param2=old_node.param2})
    elseif node_name == "default:aspen_tree" then
        minetest.set_node(pointed_thing.under, {name="new_blocks:stripped_aspen_tree", param2=old_node.param2})
    elseif node_name == "default:jungletree" then
        minetest.set_node(pointed_thing.under, {name="new_blocks:stripped_jungle_tree", param2=old_node.param2})
    elseif node_name == "default:acacia_tree" then
        minetest.set_node(pointed_thing.under, {name="new_blocks:stripped_acacia_tree", param2=old_node.param2})
    end

    -- Otherwise, carry out the default on_place action
    return minetest.item_place(itemstack, user, pointed_thing)
end

minetest.after(1, function ()

    local shovel_list = {}
    local axe_list = {}

    local function get_all_tools()
        local tools = {}
        for name, def in pairs(minetest.registered_items) do
            if def.type == "tool" then
                table.insert(tools, name)
            end
        end
        return tools
    end

    for _, name in pairs(get_all_tools()) do

        if is_shovel(name) then
            table.insert(shovel_list, name)
        end

        if is_axe(name) then
            table.insert(axe_list, name)
        end
    end


    for _, shovel in pairs(shovel_list) do
        minetest.override_item(shovel, {
            on_place = shovel_on_place,
        })
    end

    for _, axe in pairs(axe_list) do
        minetest.override_item(axe, {
            on_place = axe_on_place,
        })
    end

end)
