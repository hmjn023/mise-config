local cmd = require("cmd")

local function validate_package_name(name)
    if type(name) ~= "string" or name == "" or not name:match("^[%w%+%._@%-]+$") then
        error("invalid paru package name: " .. tostring(name))
    end
    return name
end

local function package_status(name)
    name = validate_package_name(name)

    local ok, output = pcall(cmd.exec, "paru -Q -- " .. name)
    if not ok then
        return {
            name = name,
            state = "missing",
        }
    end

    local installed_name, version = output:match("^%s*([^%s]+)%s+([^%s]+)")
    if installed_name ~= name or version == nil then
        return {
            name = name,
            state = "missing",
        }
    end

    return {
        name = name,
        state = "installed",
        version = version,
    }
end

function PLUGIN:PackageInstalled(ctx)
    local packages = {}
    for _, package in ipairs(ctx.packages) do
        table.insert(packages, package_status(package.name))
    end

    return {
        packages = packages,
    }
end
