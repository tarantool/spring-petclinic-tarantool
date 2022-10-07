local crud = require('crud')
local uuid = require('uuid')

local PET_TYPE_FIELD_NUMBER = 4

--- OneToOne = Pet -> PetType
local function find_pet_by_id(id)
    local pet, pet_type, err
    pet, err = crud.get("pets", id)
    if err ~= nil then
        return nil, err
    end

    pet_type, err = crud.get("types", pet.rows[1][PET_TYPE_FIELD_NUMBER])
    if err ~= nil then
        return nil, err
    end

    pet_type = crud.unflatten_rows(pet_type.rows, pet_type.metadata)[1]
    pet.rows[1][PET_TYPE_FIELD_NUMBER] = pet_type

    return pet
end

local function save_pet(pet)
    pet.visits = nil
    pet.type_id = pet.type_id.id
    if pet.id == nil then
        pet.id = uuid()
    end

    crud.replace_object("pets", pet)
end

return {
    find_pet_by_id = find_pet_by_id,
    save_pet = save_pet
}
