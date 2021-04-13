return {
    up = function()
        local utils = require('migrator.utils')

        local pets = box.schema.space.create("pets", { if_not_exists = true })
        pets:format({
            { name = "id", type = "uuid" },
            { name = "name", type = "string" },
            { name = "birth_date", type = "unsigned" },
            { name = "type_id", type = "uuid" },
            { name = "owner_id", type = "uuid" },
            { name = "bucket_id", type = "unsigned" },
        })
        pets:create_index("primary", { parts = { { field = "id" } },
                                       if_not_exists = true })
        pets:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                         unique = false,
                                         if_not_exists = true })
        pets:create_index("owner_id", { parts = {{field = "owner_id"}},
                                        unique = false,
                                        if_not_exists = true})

        utils.register_sharding_key('pets', {'bucket_id'})
        return true
    end
}
