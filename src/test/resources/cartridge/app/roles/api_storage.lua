local vets = require('app.vets')

local function init(opts) -- luacheck: no unused args

    rawset(_G, "ddl", { get_schema = require("ddl").get_schema })
    rawset(_G, "get_vets_with_specialties_id", vets.get_vets_with_specialties_id)

    return true
end

local function stop()
end

local function validate_config(conf_new, conf_old)  -- luacheck: no unused args
    return true
end

local function apply_config(conf, opts)  -- luacheck: no unused args
    return true
end

return {
    role_name = "app.roles.api_storage",
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    dependencies = { "cartridge.roles.crud-storage" },
}
