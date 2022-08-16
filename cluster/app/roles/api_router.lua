local cartridge_pool = require('cartridge.pool')
local cartridge_rpc = require('cartridge.rpc')
local vets = require('app.vets')
local owners = require('app.owners')
local pets = require('app.pets')
local visits = require('app.visits')

-- function to get cluster schema
local function get_schema()
    for _, instance_uri in -- luacheck: ignore 512
    pairs(cartridge_rpc.get_candidates('app.roles.api_storage', { leader_only = true })) do
        local conn = cartridge_pool.connect(instance_uri)
        return conn:call('ddl.get_schema', {})
    end
end


local function init(opts) -- luacheck: no unused args
    -- some clutches for Spring Data
    rawset(_G, 'ddl', { get_schema = get_schema })
    rawset(_G, 'get_vets_with_specialties', vets.get_vets_with_specialties)
    rawset(_G, 'find_owners_by_last_name', owners.find_owners_by_last_name)
    rawset(_G, 'find_owner_by_id', owners.find_owner_by_id)
    rawset(_G, 'find_pet_by_id', pets.find_pet_by_id)
    rawset(_G, 'find_visits_by_pet_id', visits.find_visits_by_pet_id)
    rawset(_G, 'save_pet', pets.save_pet)


    return true
end

local function stop()
end

local function validate_config(conf_new, conf_old) -- luacheck: no unused args
    return true
end

local function apply_config(conf, opts) -- luacheck: no unused args
    return true
end

return {
    role_name = 'app.roles.api_router',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    dependencies = { 'cartridge.roles.crud-router' },
}
