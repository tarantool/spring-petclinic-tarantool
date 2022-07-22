local cartridge_pool = require('cartridge.pool')
local cartridge_rpc = require('cartridge.rpc')
local crud = require('crud')

local specialties_fild_number = 5

-- get all storages URIs for map reduce
local function get_uriList()
    local uriLieder, err = cartridge_rpc.get_candidates('app.roles.api_storage', { leader_only=true})
    if err ~= nil then
        return nil, err
    end
    return uriLieder
end

-- ManyToMany join is not a trivial task for clustered data storage
-- we have 3 spaces: vets, specialties, and a merging vet_specialties
--      vet_specialties
--     /                \
-- vets                  specialties
-- we cannot combine all 3 spaces on the storages, cause we need to choose by which key will be for sharding
-- E.g.:
-- primary-indexes:
-- vets = (id)
-- vet_specialties = (vet_id, specialty_id)
-- specialties = (id)
--
--                       (2, 1)
--                      /      \
-- (2, 'Helen', 'Leary')        (1, 'radiology')
-- we not able guarantee to place all three items in one storage
-- we can only choose to store together:
--    1) vets and vet_specialties (sharding_key = vet_id)
-- or 2) specialties and vet_specialties (sharding_key = specialty_id)
-- was chosen the first option, therefore we collect vets and vet_specialties on storages
-- that is, we add specialty_id as a separate field in the response, i.e. storage return:
-- (2, 'Helen', 'Leary', 1)
-- further in the code below, we use crud.get to quickly get the name of the specialty
-- (2, 'Helen', 'Leary', 'radiology')
local function get_vets_with_specialties()
    local vets_by_storage, specialties, specialty, err
    local vets_list = {}

    vets_by_storage, err =
        cartridge_pool.map_call('get_vets_with_specialties_id', {}, { uri_list = get_uriList() })
    if err then
        return nil, err
    end

    for _, vets in pairs(vets_by_storage) do
        for _, vet in pairs(vets) do
            specialties = {}
            -- one vet may has many specialties
            for _, specialty_id in pairs(vet[#vet]) do
                specialty, err = crud.get("specialties", specialty_id)
                if err ~= nil then
                    return nil, err
                end
                table.insert(specialties, crud.unflatten_rows(specialty.rows, specialty.metadata)[1])
            end

            -- replace specialty id by specialty name
            vet[specialties_fild_number] = specialties
            table.insert(vets_list, vet)
        end
    end

    return vets_list
end

local function get_vets_with_specialties_id()
    local specialties_ids, specialties, err
    local vets = {}

    for _, vet in box.space.vets:pairs() do
        specialties, err = box.space.vet_specialties.index.vet_id:select(vet[1])
        if err ~= nil then
            return nil, err
        end

        specialties_ids = {}
        for _, specialty in pairs(specialties) do
            local specialty_id = specialty[2]
            table.insert(specialties_ids, specialty_id)
        end

        vet = vet:totable()
        table.insert(vet, specialties_ids)
        table.insert(vets, vet)
    end

    return vets
end

return {
    get_vets_with_specialties = get_vets_with_specialties,
    get_vets_with_specialties_id = get_vets_with_specialties_id
}
