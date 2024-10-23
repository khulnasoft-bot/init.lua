local status, err = pcall(require, "khulnasoft")
if not status then
    print("Error loading khulnasoft: " .. err)
end

status, err = pcall(require, "harpoon")
if not status then
    print("Error loading harpoon: " .. err)
end

status, err = pcall(require, "telescope")
if not status then
    print("Error loading telescope: " .. err)
end