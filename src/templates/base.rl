doctype html
  head
    meta charset: "utf-8"
    meta name: "viewport" content: "initial-scale=1"

    block head

    style
      !"#{stylesheet}"

  body
    main
      section
        block content
