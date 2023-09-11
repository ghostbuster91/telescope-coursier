local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("telescope_coursier.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end

-- full list of available config items and their defaults
local config = {
    mappings = {
        i = {
            ["<cr>"] = require("telescope-coursier.actions").yank_additions,
        },
        n = {
            ["y"] = require("telescope-coursier.actions").yank_additions,
        },
    },
}

local coursier = function()
    local telescope_coursier = require("telescope-coursier")
    telescope_coursier.coursier(config)
end

return telescope.register_extension({
    setup = function(extension_config, telescope_config)
        config = vim.tbl_extend("force", config, extension_config)
    end,
    exports = {
        coursier = coursier,
    },
})
