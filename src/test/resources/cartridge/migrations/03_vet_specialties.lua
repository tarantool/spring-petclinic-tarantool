return {
    up = function()
        local utils = require('migrator.utils')

        local vet_specialties = box.schema.space.create("vet_specialties", { if_not_exists = true })
        vet_specialties:format({
            { name = "vet_id", type = "uuid" },
            { name = "specialty_id", type = "uuid" },
            { name = "bucket_id", type = "unsigned" },
        })
        vet_specialties:create_index("primary", { parts = { { field = "vet_id" }, { field = "specialty_id" } },
                                                  if_not_exists = true })
        vet_specialties:create_index("bucket_id", { parts = { { field = "bucket_id" } },
                                                    unique = false,
                                                    if_not_exists = true })
        vet_specialties:create_index("vet_id", { parts = { { field = "vet_id" } },
                                                 unique = false,
                                                 if_not_exists = true })

        utils.register_sharding_key('vet_specialties', { 'vet_id' })
        return true
    end
}
