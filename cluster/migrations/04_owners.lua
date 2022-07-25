return {
    up = function()
        local utils = require('migrator.utils')

        local owners = box.schema.space.create("owners", { if_not_exists = true })
        owners:format({
            { name = "id", type = "uuid" },
            { name = "first_name", type = "string" },
            { name = "last_name", type = "string" },
            { name = "address", type = "string" },
            { name = "city", type = "string" },
            { name = "telephone", type = "string" },
            { name = "bucket_id", type = "unsigned" },
            { name = "pets", type = "map", is_nullable = true }
        })
        owners:create_index("primary", { parts = { { field = "id" } },
                                         if_not_exists = true })
        owners:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                           unique = false,
                                           if_not_exists = true })
        owners:create_index("last_name", { parts = { { field = "last_name" } },
                                           unique = false,
                                           if_not_exists = true })

        utils.register_sharding_key('owners', {'id'})
        return true
    end
}
