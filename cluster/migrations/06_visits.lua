return {
    up = function()
        local utils = require('migrator.utils')

        local visits = box.schema.space.create("visits", { if_not_exists = true })
        visits:format({
            { name = "id", type = "uuid" },
            { name = "pet_id", type = "uuid" },
            { name = "visit_date", type = "any" },
            { name = "description", type = "string" },
            { name = "bucket_id", type = "unsigned" },
        })
        visits:create_index("primary", { parts = { { field = "id" } },
                                         if_not_exists = true })
        visits:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                           unique = false,
                                           if_not_exists = true })
        visits:create_index("pet_id", { parts = { { field = "pet_id" } },
                                        unique = false,
                                        if_not_exists = true })

        utils.register_sharding_key('visits', {'id'})
        return true
    end
}
