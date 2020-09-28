#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const snarkdown = require('snarkdown');
const { Markup } = require('razorleaf');
const { template } = require('./resources');

const DIR = {
  source: 'src/content',
  output: 'site',
  indexof: 'posts'
};

function log(str, isError = false) {
  const colors = {
    red: '\x1b[31m',
    green: '\x1b[32m',
    reset: '\x1b[0m',
  };

  const outputStr = color => `${color}${str}${colors.reset}`;

  if (isError) {
    console.error(outputStr(colors.red));
    process.exit();
  }

  console.log(outputStr(colors.green));
}

function extractFrontmatter(file) {
  const content = fs.readFileSync(file, { encoding: 'utf8' });

  const re = /<!--[^>]*-->/;
  const comment = re.exec(content) || null;

  let fm = {};

  if (comment) {
    const json = comment[0]
      .replace(/<!--/, '')
      .replace(/-->/, '');

    try {
      fm = {
        attributes: JSON.parse(json),
        body: Markup.unsafe(snarkdown(content.replace(re, ''))),
      };
    } catch (e) {
      log(`${file}: Invalid frontmatter format.`, true);
    }
  }

  return fm;
}

function handleFile(file) {
  const input = path.join(DIR.source, file);

  if (!fs.existsSync(input)) log(`${input} file not found.`, true);

  const { dir, base, name, ext } = path.parse(file);

  const isMd = (ext === '.md');
  const uri = path.join('/', dir, isMd ? `${name}.html` : base);
  const output = path.join(DIR.output, uri);
  const frontmatter = isMd ? extractFrontmatter(input) : {};
  const outputdir = path.dirname(output);

  if (!fs.existsSync(outputdir)) fs.mkdirSync(outputdir, { recursive: true });

  if (isMd) {
    fs.writeFileSync(output, template.page(frontmatter));
  } else  {
    fs.copyFileSync(input, output);
  }

  log(`${input} => ${output}`);

  return { input, output, uri, wasMd: isMd, frontmatter };
}

function createIndex(indexof, posts) {
  const input = path.join(DIR.source, indexof);
  const output = path.join(DIR.output, indexof, 'index.html');

  fs.writeFileSync(output, template.posts({ posts }));
  log(`${input} => ${output}`);

  return { input, output };
}

function main() {
  fs
    .readdirSync(DIR.source, { withFileTypes: true })
    .forEach(dirent => dirent.isDirectory() ? null : handleFile(dirent.name));

  const posts = fs
    .readdirSync(path.join(DIR.source, DIR.indexof))
    .map(file => handleFile(path.join(DIR.indexof, file)))
    .filter(post => post.wasMd);

  if (posts.length) createIndex(DIR.indexof, posts);
}

main();
