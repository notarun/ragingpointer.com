const fs = require('fs');
const { Markup } = require('razorleaf');
const DirectoryLoader = require('razorleaf/directory-loader');

const globals = {
  stylesheet: Markup.unsafe(fs.readFileSync('src/assets/styles.css', {
    encoding: 'utf8'
  }))
};

const templateLoader = new DirectoryLoader(__dirname);

exports.page = templateLoader.load('page', { globals });
exports.posts = templateLoader.load('posts', { globals });
