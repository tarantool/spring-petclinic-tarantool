local crud = require('crud')

-- OneToMany pattern, the owner can have multiple pets
local function find_owners_by_last_name(last_name)
    local owners
    -- return all if the last_name is not specified
    if last_name == nil or last_name == "" then
        owners = crud.select("owners")
    else
        owners = crud.select("owners", {{'=', 'last_name', last_name}})
    end
    for _, owner in pairs(owners.rows) do
        local pets = crud.select("pets", {{'=', 'owner_id', owner[1]}})
        pets = crud.unflatten_rows(pets.rows, pets.metadata)
        for _, pet in pairs(pets) do
            -- this is necessary for correct processing of the nested entity pet_type
            -- for this Query we don't need pet_type name
            pet.type_id = { id=pet.type_id }
        end
        owner[8] = pets
    end
    return owners
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
        pet.type_id = crud.unflatten_rows(type.rows, type.metadata)[1]
    end
    owner.rows[1][8] = pets
    return owner
end

return {
    find_owners_by_last_name = find_owners_by_last_name,
    find_owner_by_id = find_owner_by_id
}
