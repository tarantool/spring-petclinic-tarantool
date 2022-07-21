local crud = require('crud')
local uuid = require('uuid')

-- OneToOne  = Pet -> PetType
local function find_pet_by_id(id)
    local pet = crud.select("pets", {{"=", 'id', id}})
    if pet == nil then
        return nil
    end
    local type = crud.get("types", pet.rows[1][4])
    pet.rows[1][4] = crud.unflatten_rows(type.rows, type.metadata)[1]
    return pet
end

local function save_pet(pet)
    pet.visits = nil
    pet.type_id = pet.type_id.id
    if pet.id == nil then
        pet.id = uuid()
    end
    crud.replace_object("pets",
        pet
    )
end

return {
    find_pet_by_id = find_pet_by_id,
    save_pet = save_pet
}
