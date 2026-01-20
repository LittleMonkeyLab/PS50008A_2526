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

-- CSS for glossary tooltips
local css_injected = false
local glossary_css = [[
<style>
.glossary-term {
  border-bottom: 1px dotted #275882;
  cursor: help;
  position: relative;
  color: inherit;
}
.glossary-term:hover {
  background-color: #CFE2FF;
}
.glossary-term::after {
  content: attr(data-definition);
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background-color: #2c3e50;
  color: #ffffff;
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  font-size: 0.875rem;
  line-height: 1.4;
  width: max-content;
  max-width: 300px;
  white-space: normal;
  text-align: left;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s ease, visibility 0.2s ease;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  pointer-events: none;
  margin-bottom: 8px;
}
.glossary-term::before {
  content: "";
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  border: 6px solid transparent;
  border-top-color: #2c3e50;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s ease, visibility 0.2s ease;
  z-index: 1001;
  margin-bottom: 2px;
}
.glossary-term:hover::after,
.glossary-term:hover::before {
  opacity: 1;
  visibility: visible;
}
</style>
]]

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

    -- Inject CSS once
    local css_block = ""
    if not css_injected then
      css_block = glossary_css
      css_injected = true
    end

    -- Create the HTML span with tooltip
    local html = string.format(
      '%s<span class="glossary-term" data-definition="%s">%s</span>',
      css_block,
      definition,
      term_text
    )

    return pandoc.RawInline("html", html)
  end
}
