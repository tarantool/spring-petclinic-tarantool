local crud = require("crud")
local utils = require('app.utils')

local function find_visits_by_pet_id(pet_id)
    -- Example of pagination implementation
    local visits, err= crud.select("visits", {{"=", "pet_id", pet_id}}, { first = 1000 })
    if err then
        return nil, err
    end

    local visits_butch
    local need_more_requests = #visits.rows >= 1000
    while need_more_requests do
        visits_butch, err = crud.select("visits", {{"=", "pet_id", pet_id}}, { after = visits.rows[#visits.rows], first = 1000 })
        if err then
            return nil, err
        end

        if #visits_butch.rows == 0 then
            break
        end

        visits.rows = utils.merge_tables(visits.rows, visits_butch.rows)
    end

    return visits
end

return {
    find_visits_by_pet_id = find_visits_by_pet_id
}
