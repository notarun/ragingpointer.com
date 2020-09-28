extends base

append head
  if data.attributes.description
    meta name: "description" content: "#{data.attributes.description}"

  if data.attributes.title
    meta name: "title" content: "#{data.attributes.title} - #{siteName}"
    title "#{data.attributes.title} - #{siteName}"

  elif data.attributes.is404
    title "404 - page not found"

  elif data.attributes.isHomepage
    title "home - #{siteName}"

  else
    title "#{siteName}"

append content
  if (!data.attributes.isHomepage && data.attributes.title)
    h1 "#{data.attributes.title}"

  if data.attributes.createdAt
    time
      "#{data.attributes.createdAt}"

  div class: "main-content"
    !"#{data.body}"
