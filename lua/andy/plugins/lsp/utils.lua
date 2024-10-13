local utils = {}

function utils.detect_project_config()
    local function find_nearest_config(file_names)
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir = vim.fn.fnamemodify(current_file, ':h')

        while current_dir ~= '/' do
            for _, file_name in ipairs(file_names) do
                local config_path = current_dir .. '/' .. file_name
                if vim.fn.filereadable(config_path) == 1 then
                    return config_path
                end
            end
            current_dir = vim.fn.fnamemodify(current_dir, ':h')
        end
        return nil
    end

    local biome_config = find_nearest_config({ 'biome.json' })
    local eslint_config = find_nearest_config({ '.eslintrc', '.eslintrc.js', '.eslintrc.json' })

    if biome_config then
        return "biome"
    elseif eslint_config then
        return "eslint"
    else
        return nil
    end
end

return utils
