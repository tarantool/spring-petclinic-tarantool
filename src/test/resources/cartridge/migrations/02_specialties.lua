return {
    up = function()
        local utils = require('migrator.utils')

        local specialties = box.schema.space.create("specialties", { if_not_exists = true })
        specialties:format({
            { name = "id", type = "uuid" },
            { name = "name", type = "string" },
            { name = "bucket_id", type = "unsigned" },
        })
        specialties:create_index("primary", { parts = { { field = "id" } },
                                              if_not_exists = true })
        specialties:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                                unique = false,
                                                if_not_exists = true })

        utils.register_sharding_key('specialties', { 'id' })
        return true
    end
}
