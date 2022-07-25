local crud = require("crud")

local function find_visits_by_pet_id(pet_id)
    return crud.select("visits", {{"=", "pet_id", pet_id}}, { batch_size = 1000, prefer_replica = true })
end

return {
    find_visits_by_pet_id = find_visits_by_pet_id
}
