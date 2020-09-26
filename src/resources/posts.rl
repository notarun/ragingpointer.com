extends base

append head
  title "posts - ragingpointer"

append content
  h1 "random thoughts, notes and trash"

  for post of data.posts
    div class: "article"
      a href: "#{post.uri}"
        "#{post.frontmatter.attributes.title}"

      time
        "#{post.frontmatter.attributes.createdAt}"
