local U = {}

function U.merge_tables(first_table, second_table)
    for _,element in ipairs(second_table) do
        table.insert(first_table, element)
    end
    return first_table
end

return U
