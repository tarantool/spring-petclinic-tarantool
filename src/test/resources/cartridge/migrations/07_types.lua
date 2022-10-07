return {
    up = function()
        local utils = require('migrator.utils')

        local types = box.schema.space.create("types", { if_not_exists = true })
        types:format({
            { name = "id", type = "uuid" },
            { name = "name", type = "string" },
            { name = "bucket_id", type = "unsigned" },
        })
        types:create_index("primary", { parts = { { field = "id" } },
                                        if_not_exists = true })
        types:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                          unique = false,
                                          if_not_exists = true })

        utils.register_sharding_key('types', { 'id' })
        return true
    end
}
