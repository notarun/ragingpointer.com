extends base

append head
  if data.attributes.title
    title "#{data.attributes.title} - ragingpointer"

  elif data.attributes.isHomepage
    title "home - ragingpointer"

  else
    title "ragingpointer"

append body
  if data.attributes.title
    h1 "#{data.attributes.title}"

  !"#{data.body}"
