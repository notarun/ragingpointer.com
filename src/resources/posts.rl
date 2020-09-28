extends base

append head
  meta name: "title" content: "posts - #{siteName}"
  meta name: "description" content: "Random thoughts, notes and trash"

  title "posts - #{siteName}"

append content
  h1 "random thoughts, notes and trash"

  for post of data.posts
    div class: "article"
      a href: "#{post.uri}"
        "#{post.frontmatter.attributes.title}"

      time
        "#{post.frontmatter.attributes.createdAt}"
