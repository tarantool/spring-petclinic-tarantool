local crud = require("crud")

local function find_visits_by_pet_id(pet_id)
    return crud.select("visits", {{"=", "pet_id", pet_id}})
end

return {
    find_visits_by_pet_id = find_visits_by_pet_id
}
