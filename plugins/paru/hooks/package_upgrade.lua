local cmd = require("cmd")

local function validate_package_name(name)
    if type(name) ~= "string" or name == "" or not name:match("^[%w%+%._@%-]+$") then
        error("invalid paru package name: " .. tostring(name))
    end
    return name
end

local function package_names(packages)
    local names = {}
    for _, package in ipairs(packages) do
        table.insert(names, validate_package_name(package.name))
    end
    return names
end

local function run(command)
    local ok, output = pcall(cmd.exec, command)
    if not ok then
        error("paru command failed: " .. tostring(output))
    end
    if output ~= nil and output ~= "" then
        print(output)
    end
end

local function upgrade_command(packages)
    return "paru -S --needed --noconfirm -- " .. table.concat(package_names(packages), " ")
end

function PLUGIN:PackageUpgrade(ctx)
    if #ctx.packages == 0 then
        return {}
    end

    if ctx.dry_run then
        print("paru -Sy --noconfirm")
        print(upgrade_command(ctx.packages))
        return {}
    end

    run("paru -Sy --noconfirm")
    run(upgrade_command(ctx.packages))
    return {}
end
