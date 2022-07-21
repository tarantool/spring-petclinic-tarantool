local crud = require('crud')

-- OneToMany pattern, the owner can have multiple pets
local function find_owners_by_last_name(last_name)
    local join_result, owners, err
    -- return all if the last_name is not specified
    if last_name == nil or last_name == "" then
        owners, err = crud.select("owners")
    else
        owners, err = crud.select("owners", {{'=', 'last_name', last_name}})
    end

    if err ~= nil then
        return nil, err
    end

    join_result = { metadata = owners.metadata, rows = {} }

    for _, owner in pairs(owners.rows) do
        local pets, err = crud.select("pets", {{'=', 'owner_id', owner[1]}})
        if err ~= nil then
            return nil, err
        end
        pets = crud.unflatten_rows(pets.rows, pets.metadata)
        for _, pet in pairs(pets) do
            -- this is necessary for correct processing of the nested entity pet_type
            -- for this Query we don't need pet_type name
            pet.type_id = { id=pet.type_id }
        end
        local owner_with_pets = owner:totable()
        owner_with_pets[8] = pets
        join_result.rows[#join_result.rows+1] = owner_with_pets
    end
    return join_result
end

-- OneToMany = Owners -> Pets
-- OneToOne  = Pets -> PetType
local function find_owner_by_id(id)
    local owner = crud.select("owners", {{'=', 'id', id}})
    local pets = crud.select("pets", {{'=', 'owner_id', owner.rows[1][1]}})
    pets = crud.unflatten_rows(pets.rows, pets.metadata)
    for _, pet in pairs(pets) do
        -- in this case we should know full pet_type
        local type = crud.get("types", pet.type_id)
        if type ~= nil and #type.rows >= 1 then
            pet.type_id = crud.unflatten_rows(type.rows, type.metadata)[1]
        end
    end
    owner.rows[1]:transform(8, 1, pets)
    require('log').info('owner: %s', require('json').encode(owner))
    require('log').info('owner.rows[1]: %s', require('json').encode(type(owner.rows[1])))
    return owner
end

return {
    find_owners_by_last_name = find_owners_by_last_name,
    find_owner_by_id = find_owner_by_id
}
