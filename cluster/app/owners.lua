local crud = require('crud')

local pet_filed_number = 8

-- OneToMany pattern, the owner can have multiple pets
local function find_owners_by_last_name(last_name)
    local owners, pets, err

    -- return all if the last_name is not specified
    if last_name == nil or last_name == "" then
        owners, err = crud.select("owners")
    else
        owners, err = crud.select("owners", {{'=', 'last_name', last_name}})
    end
    if err ~= nil then
        return nil, err
    end

    for _, owner in pairs(owners.rows) do
        pets, err = crud.select("pets", {{'=', 'owner_id', owner[1]}})
        if err ~= nil then
            return nil, err
        end

        pets = crud.unflatten_rows(pets.rows, pets.metadata)
        for _, pet in pairs(pets) do
            -- this is necessary for correct processing of the nested entity pet_type
            -- for this Query we don't need pet_type name
            pet.type_id = { id=pet.type_id }
        end
        owner = owner:transform(pet_filed_number, 1, pets)
    end

    return owners
end

-- OneToMany = Owners -> Pets
-- OneToOne  = Pets -> PetType
local function find_owner_by_id(id)
    local owner, pets, pet_type, err

    owner, err= crud.select("owners", {{'=', 'id', id}})
    if err ~= nil then
        return nil, err
    end

    pets, err = crud.select("pets", {{'=', 'owner_id', owner.rows[1][1]}})
    if err ~= nil then
        return nil, err
    end

    pets = crud.unflatten_rows(pets.rows, pets.metadata)
    for _, pet in pairs(pets) do
        -- in this case we should know full pet_type
        pet_type, err = crud.get("types", pet.type_id)
        if err ~= nil then
            return nil, err
        end
        pet.type_id = crud.unflatten_rows(pet_type.rows, pet_type.metadata)[1]
    end

    owner.rows[1] = owner.rows[1]:transform(pet_filed_number, 1, pets)

    return owner
end
return {
    find_owners_by_last_name = find_owners_by_last_name,
    find_owner_by_id = find_owner_by_id
}
