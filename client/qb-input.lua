-- ### QB-INPUT TO OX_LIB COMPAT ### --
if not Config.Modules['qb-input'].active then return end
local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(Config.Modules['qb-input'].resource_name, exportName), function(setCB)
        setCB(func)
    end)
end

local function convertToOx(data)
    local name = data.header
    local oxData = {}
    local names = {}
    local i = 1
    for k, v in ipairs(data.inputs) do
        if v.type == 'text' then
            oxData[#oxData + 1] = {
                type = 'input',
                placeholder = ConvertText(v.text),
                -- default = ConvertText(v.default),
                label = ConvertText(v.text),
                required = v.isRequired
            }
            names[#oxData] = v.name
        elseif v.type == 'number' then
            oxData[#oxData + 1] = {
                type = 'number',
                placeholder = ConvertText(v.text),
                -- default = ConvertText(v.default),
                label = ConvertText(v.text),
                required = v.isRequired
            }
            names[#oxData] = v.name
        elseif v.type == 'password' then
            oxData[#oxData + 1] = {
                type = 'input',
                placeholder = ConvertText(v.text),
                icon = 'lock',
                password = true,
                label = ConvertText(v.text),
                required = v.isRequired
            }
            names[#oxData] = v.name
        elseif v.type == 'radio' then
            if v.default ~= nil then
                oxData[#oxData + 1] = {
                    type = 'multi-select',
                    label = ConvertText(v.text),
                    maxSelectedValues = 1,
                    default = ConvertText(v.default),
                    required = v.isRequired,
                    placeholder = ConvertText(v.default)
                }
                for _, option in ipairs(v.options) do
                    oxData[#oxData].options = oxData[#oxData].options or {}
                    oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                        label = ConvertText(option.text),
                        value = option.value,
                    }
                end
                names[#oxData] = v.name
            else
                oxData[#oxData + 1] = {
                    type = 'select',
                    label = ConvertText(v.text),
                    required = v.isRequired,
                }
                for _, option in ipairs(v.options) do
                    oxData[#oxData].options = oxData[#oxData].options or {}
                    oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                        label = ConvertText(option.text),
                        value = option.value,
                    }
                end
                names[#oxData] = v.name
            end
        elseif v.type == 'checkbox' then
            if #v.options == 1 then
                oxData[#oxData + 1] = {
                    type = 'checkbox',
                    label = ConvertText(v.options[1].text),
                    -- default = ConvertText(v.default),
                    checked = ConvertText(v.options[1].checked),
                    required = v.options[1].isRequired
                }
                names[k] = v.options[1].value
            elseif #v.options == 0 then
                -- I would sometimes do this to make a subheader - Mkeefeus
                goto continue
            else
                local retval = #oxData
                for __, b  in ipairs(v.options) do
                    oxData[#oxData + 1] = {
                        type = 'checkbox',
                        label = ConvertText(b.text),
                        -- default = ConvertText(v.default),
                        checked = ConvertText(b.checked),
                        required = b.isRequired
                    }
                    names[retval + i] = b.value
                    i = i + 1
                end
                i = 1
            end
        elseif v.type == 'select' then
            if v.default ~= nil then
                oxData[#oxData + 1] = {
                    type = 'multi-select',
                    label = ConvertText(v.text),
                    maxSelectedValues = 1,
                    default = ConvertText(v.default),
                    required = v.isRequired,
                    placeholder = ConvertText(v.default)
                }
                for _, option in ipairs(v.options) do
                    oxData[#oxData].options = oxData[#oxData].options or {}
                    oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                        label = ConvertText(option.text),
                        value = ConvertText(option.value),
                    }
                end
                names[#oxData] = v.name
            else
                oxData[#oxData + 1] = {
                    type = 'select',
                    label = ConvertText(v.text),
                    required = v.isRequired
                }
                for _, option in ipairs(v.options) do
                    oxData[#oxData].options = oxData[#oxData].options or {}
                    oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                        label = ConvertText(option.text),
                        value = option.value,
                    }
                end
                names[#oxData] = v.name
            end
        elseif v.type == 'color' then
            oxData[#oxData + 1] = {
                type = 'color',
                placeholder = ConvertText(v.text),
                default = (v.default),
                label = ConvertText(v.text),
                required = v.isRequired
            }
            names[#oxData] = v.name
        end
        :: continue ::
    end
    return name, oxData, names
end

exportHandler('ShowInput', function(data)
    local name, oxData, names = convertToOx(data)
    local selections = lib.inputDialog(name, oxData)
    if not selections then return end
    if Config.Debug then print(json.encode(selections)) end
    local returnData = {}
    for k, v in pairs(selections) do
        if table.type(v) == 'array'then
            returnData[names[k]] = tostring(v[1])
        else
            returnData[names[k]] = tostring(v)
        end
    end
    if Config.Debug then print(json.encode(returnData)) end
    return returnData
end)