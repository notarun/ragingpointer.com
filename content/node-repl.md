---
title: Custom Node.js REPL
description: Creating custom REPL to a node.js project for easy REPL driven development.
date: 2023-04-13
---

I have been doing most of my development in node.js nowadays.
Previously I used to use Laravel and it had a neat package called Tinker.
Which was a cool REPL and made development process really fast.

Since most of the applications where node and laravel is used are to write APIs
and to test them usually you have to use some GUI HTTP client like Postman or even curl.
Offcouse you can write test cases aswell but for rapid development tescases are
often ignored.

REPL can be really helpful to invoke a single function to test it's output/behaviour.

> NOTE: If you are using Nest.js they already have a much better solution.
https://docs.nestjs.com/recipes/repl. It already handles the dependency tree
and you can pull any service by using `$(ServiceName)` (jquery style selector 😎)

This post is geared more toward the simple node.js projects with no dependency
injection.

Let's start by writing a `repl.js`.
Node.js already have a `repl` module which we will be making use of.

here is the content of repl.js

```
const repl = require('repl');

const r = repl.start({
  useColors: true // colors are cool arent they?
});
// i hate retyping, ctrl-<r> works here
r.setupHistory('.node_repl_history', () => {});
```

our basic repl is complete. we can start it by doing `node repl.js`

and you can start typing javscript.

so how do we invoke a function??

let's assume we have a file `lib/hello.js` with following content

```js
exports.sayHello = () => {
  console.log('Hello world 👋');
}
```

no in our repl we can simply do 
```
h = require('lib/hello.js')`
h.sayHello()
```

and this should execute the function.

But doing `require('lib/hello.js')` is no fun. Let's make it short.

we can add contexts to the repl, which simply means we
can have some functions which we can call only inside our repl.
let's add a shorthand function for require. we will use `$` yes just like jquery selector

```
const repl = require('repl');

const r = repl.start({
  useColors: true // colors are cool arent they?
});
// i hate retyping, ctrl-<r> works here
r.setupHistory('.node_repl_history', () => {});

// create an alias for require
r.context.$ = require;
```

now in the repl we can

```
s = $('./lib/hello.js')
s.sayHello();
```

a little shorter.

Now while in the repl try to change the code inside sayHello function
and run s.sayHello again, the output will be the old output
becuse node have already loaded that in the memory
what we can do is exit the repl and start again.
but that is no fun
let's write modify the working of require to 


```js
const repl = require('repl');
const path = require('path');

// Imaginary modules
const { setupMongoose } = require('./db/mongoose');
const { setupSequelize } = require('./db/sequelize');

// Helpful function, so that we do not have to close the repl 
// every time we update the code
const requireUncached = (p) => {
  const module = path.join(path.dirname(__dirname), p);
  delete require.cache[require.resolve(module)];
  return require(module);
};

(async () => {
  // make connection to database,
  // ideally you should connect to all the service
  // you connect to before starting the repl
  const mysql = await setupSequelize();
  const mongo = await setupMongoose();

  const shutdown = async () => {
    console.log('Bye 👋');

    if (mongo) await mongo.disconnect();
    if (mysql) await mysql.close();

    process.exit();
  };

  const r = repl.start({ useColors: true });
  r.setupHistory('.node_repl_history', () => {});
  r.on('exit', shutdown);
  // shortand to for require uncached
  r.context.$ = requireUncached;
})();
```
