extends base

append head
  title "posts - ragingpointer"

append body
  h1 "random thoughts, notes and trash"

  nav
    ul
      for post of data.posts
        li
          a href: "#{post.uri}"
            "#{post.frontmatter.attributes.title}"
