local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local M = {}

M.insert_text_into_register = function(prompt_bufnr)
    local entry = actions_state.get_selected_entry()
    if entry ~= nil then
        vim.fn.setreg("*", entry.ordinal)
        actions.close(prompt_bufnr)
    end
end

return M
