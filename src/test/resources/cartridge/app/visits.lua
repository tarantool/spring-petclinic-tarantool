local crud = require("crud")

local function find_visits_by_pet_id(pet_id, cursor, batch_size)
    batch_size = batch_size or 100
    -- Example of pagination implementation
    return crud.select("visits", {{"=", "pet_id", pet_id}}, { first=batch_size, after=cursor })
end

return {
    find_visits_by_pet_id = find_visits_by_pet_id
}
