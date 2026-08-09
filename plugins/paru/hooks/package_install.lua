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

local function install_command(packages)
    return "paru -S --needed --noconfirm -- " .. table.concat(package_names(packages), " ")
end

function PLUGIN:PackageInstall(ctx)
    if #ctx.packages == 0 then
        return {}
    end

    if ctx.dry_run then
        if ctx.update then
            print("paru -Sy --noconfirm")
        end
        print(install_command(ctx.packages))
        return {}
    end

    if ctx.update then
        run("paru -Sy --noconfirm")
    end
    run(install_command(ctx.packages))
    return {}
end
