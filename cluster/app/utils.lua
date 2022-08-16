local M = {}

function M.concat_tables(table_to_append, second_table)
    table.move(second_table, 1, #second_table, #table_to_append + 1, table_to_append)
    return table_to_append
end

return M
