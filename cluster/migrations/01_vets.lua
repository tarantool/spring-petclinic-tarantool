return {
    up = function()
        local utils = require('migrator.utils')

        local vets = box.schema.space.create('vets', { if_not_exists = true })
        vets:format({
            { name = "id", type = "uuid" },
            { name = "first_name", type = "string" },
            { name = "last_name", type = "string" },
            { name = "bucket_id", type = "unsigned" },
            { name = "specialties", type = "map", is_nullable = true }
        })
        vets:create_index("primary", { parts = { { field = "id" } },
                                       if_not_exists = true })
        vets:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                         unique = false,
                                         if_not_exists = true })

        utils.register_sharding_key('vets', {'bucket_id'})
        return true
    end
}
