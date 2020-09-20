extends base

append head
  if data.attributes.title
    title "#{data.attributes.title} - ragingpointer"

  elif data.attributes.isHomepage
    title "home - ragingpointer"

  else
    title "ragingpointer"

append content
  if data.attributes.title
    h1 "#{data.attributes.title}"

  if (!data.attributes.isHomepage)
    time
      "#{data.attributes.createdAt}"

  div class: "main-content"
    !"#{data.body}"
