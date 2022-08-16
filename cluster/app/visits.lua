local crud = require("crud")
local utils = require('app.utils')

local function find_visits_by_pet_id(pet_id, batch_size, after)
    batch_size = batch_size or 1000
    -- Example of pagination implementation
    return crud.select("visits", {{"=", "pet_id", pet_id}}, { first = batch_size, after=after })
end

return {
    find_visits_by_pet_id = find_visits_by_pet_id
}
