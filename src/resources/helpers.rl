do
  const sortPostsByDate = arr =>
    arr.sort((a, b) => (
      Date.parse(b.frontmatter.attributes.createdAt) - Date.parse(a.frontmatter.attributes.createdAt)
    ));
