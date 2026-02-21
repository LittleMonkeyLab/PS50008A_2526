-- highlight-spans.lua
-- Converts [text]{.hl-*} spans to Typst functions for PDF output.
-- HTML output uses highlights.css directly (no conversion needed).
--
-- Place in project root or assets/ and reference in _quarto.yml:
--   filters:
--     - assets/highlight-spans.lua

local highlight_map = {
  -- Semantic highlights
  ["hl-term"]     = "hlTerm",
  ["hl-emphasis"] = "hlEmphasis",
  ["hl-stat"]     = "hlStat",
  ["hl-warning"]  = "hlWarning",
  ["hl-example"]  = "hlExample",
  ["hl-cite"]     = "hlCite",
  ["hl-new"]      = "hlNew",
  ["hl-removed"]  = "hlRemoved",
  -- Colour highlights
  ["hl-yellow"]   = "hlYellow",
  ["hl-blue"]     = "hlBlue",
  ["hl-green"]    = "hlGreen",
  ["hl-red"]      = "hlRed",
  ["hl-purple"]   = "hlPurple",
  ["hl-orange"]   = "hlOrange",
  ["hl-gray"]     = "hlGray",
  -- Style variants
  ["hl-marker"]      = "hlMarker",
  ["hl-marker-blue"] = "hlMarkerBlue",
  ["hl-marker-red"]  = "hlMarkerRed",
  ["hl-underline"]= "hlUnderline",
  ["hl-box"]      = "hlBox",
}

local function get_highlight_func(classes)
  for _, class in ipairs(classes) do
    if highlight_map[class] then
      return highlight_map[class]
    end
  end
  return nil
end

function Span(el)
  local func_name = get_highlight_func(el.classes)

  if func_name and FORMAT:match('typst') then
    local content = pandoc.utils.stringify(el.content)
    return pandoc.RawInline('typst', '#' .. func_name .. '[' .. content .. ']')
  end

  -- HTML/RevealJS: return unchanged, CSS handles styling
  return el
end
