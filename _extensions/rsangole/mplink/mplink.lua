function Span(elem)
  if elem.classes:includes("mplink") then
    local url = elem.attributes["url"]
    local id = elem.attributes["id"] or "p2"
    local text = pandoc.utils.stringify(elem.content)
    
    return pandoc.RawInline("html", 
      string.format('<span id="%s"><a href="%s">%s</a></span>', id, url, text))
  end
end