-- LML Glossary Extension
-- Reads from glossary.yml and provides hover definitions

local glossary = {}
local glossary_loaded = false

-- Function to read and parse YAML glossary
local function load_glossary()
  if glossary_loaded then
    return
  end

  -- Get the project root directory from Quarto
  local project_dir = quarto.project.directory or "."

  -- Try to find glossary.yml in project root
  local glossary_path = project_dir .. "/glossary.yml"
  local file = io.open(glossary_path, "r")

  if not file then
    -- Try alternate location
    glossary_path = project_dir .. "/_glossary.yml"
    file = io.open(glossary_path, "r")
  end

  if not file then
    -- Try current directory as fallback
    glossary_path = "glossary.yml"
    file = io.open(glossary_path, "r")
  end

  if not file then
    quarto.log.warning("Glossary file not found. Tried: " .. project_dir .. "/glossary.yml")
    glossary_loaded = true
    return
  end

  local content = file:read("*all")
  file:close()

  -- Simple YAML parsing for our specific format
  local current_key = nil
  local current_entry = {}

  for line in content:gmatch("[^\r\n]+") do
    -- Skip comments and empty lines
    if not line:match("^%s*#") and not line:match("^%s*$") then
      -- Check for top-level key (no leading whitespace, ends with :)
      local top_key = line:match("^([%w_]+):%s*$")
      if top_key then
        -- Save previous entry if exists
        if current_key and current_entry.term then
          glossary[current_key] = current_entry
        end
        current_key = top_key
        current_entry = {}
      else
        -- Parse nested properties
        local key, value = line:match("^%s+([%w_]+):%s*\"?([^\"]*)\"?%s*$")
        if key and value then
          -- Clean up the value
          value = value:gsub("^\"", ""):gsub("\"$", "")
          current_entry[key] = value
        end
      end
    end
  end

  -- Don't forget the last entry
  if current_key and current_entry.term then
    glossary[current_key] = current_entry
  end

  glossary_loaded = true
  quarto.log.info("Loaded " .. #(pandoc.List(glossary)) .. " glossary terms")
end

-- Shortcode handler for {{< term key >}} or {{< term key "display text" >}}
return {
  ["term"] = function(args, kwargs, meta)
    load_glossary()

    local key = pandoc.utils.stringify(args[1])
    local display = args[2] and pandoc.utils.stringify(args[2]) or nil

    local entry = glossary[key]

    if not entry then
      quarto.log.warning("Glossary term not found: " .. key)
      return pandoc.Str("[" .. key .. "?]")
    end

    -- Use custom display text or the term name
    local term_text = display or entry.term
    local definition = entry.definition or ""

    -- Escape quotes in definition for HTML attribute
    definition = definition:gsub('"', '&quot;')

    -- Create the HTML span with tooltip
    local html = string.format(
      '<span class="glossary-term" data-definition="%s">%s</span>',
      definition,
      term_text
    )

    return pandoc.RawInline("html", html)
  end
}
