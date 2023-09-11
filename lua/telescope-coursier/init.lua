local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"
local actions = require "telescope.actions"
local coursier_actions = require("telescope-coursier.actions")

local flatten = vim.tbl_flatten
local M = {}

local function starts_with(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

M.coursier = function(opts)
    local opts = opts or {}
    local current_prompt = ""
    local live_grepper = finders.new_job(function(prompt)
        if not prompt or prompt == "" or #prompt < 3 then
            return nil
        end
        current_prompt = prompt
        return flatten { "cs", "complete-dep", prompt }
    end, function(entry)
        -- When running "complete-dep" with a group coursier returns only artifact names.
        -- Since we are using a fuzzy finder, all results get filtered out if the don't match prompt string.
        -- Because of that we prepend current prompt value (up to the latest colon) to all results
        local lastColonIndex = current_prompt:match(".*():")
        local prompt_prefix = ""
        if lastColonIndex then
            prompt_prefix = current_prompt:sub(1, lastColonIndex - 1) .. ":"
        end

        local entry_value = entry
        if not starts_with(entry_value, prompt_prefix) then
            entry_value = prompt_prefix .. entry_value
        end
        return make_entry.set_default_entry_mt({
            value = entry,
            ordinal = entry_value,
            display = entry_value,
        }, opts)
    end, opts.max_results, opts.cwd)

    pickers.new(opts, {
        prompt_title = "coursier",
        finder = live_grepper,
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_buffer, _)
            actions.select_default:replace(function()
                coursier_actions.insert_text_into_register(prompt_buffer)
            end)
            return true
        end,
    }):find()
end

-- M.coursier()
