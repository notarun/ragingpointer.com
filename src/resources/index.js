const fs = require('fs');
const { Markup } = require('razorleaf');
const DirectoryLoader = require('razorleaf/directory-loader');

const globals = {
  stylesheet: Markup.unsafe(fs.readFileSync('src/resources/styles.css', {
    encoding: 'utf8'
  }))
};

const templateLoader = new DirectoryLoader(__dirname);

module.exports.template = {
  page: templateLoader.load('page', { globals }),
  posts: templateLoader.load('posts', { globals })
};
