# Yes Slash No

Use Yes Slash No to, quickly, knock up a website that answers a question in the form of [Is It Christmas](http://isitchristmas.com/), [Is It Thanksgiving Yet?](http://www.isitthanksgivingyet.com/), [Yes, Margaret Thatcher is dead](http://www.isthatcherdeadyet.co.uk/), and [Is Julia Gillard Still Prime Minister?](http://isjuliagillardstillpm.com/). Classy.

## Installation

Firstly, make sure you've [installed Ruby](http://www.ruby-lang.org/en/). Also, install the [Heroku Toolbelt](https://toolbelt.heroku.com/) as it includes [Foreman](https://github.com/ddollar/foreman) for running Procfile-based applications.

Then in terminal, clone me:

```
$ git clone git@github.com:/kripy/yes-slash-no yes-slash-no
$ cd yes-slash-no
```

You'll need to create an ```.env``` file in the root directory of the project for storing environment variables (more about this later). The file should look like this:

```
YSN_ROUTE=switch
WEBSITE_NAME='Is it friday yet?'
```

Now fire it up:

```
$ foreman start
```

Open up a browser at ```http://localhost:5000/```: now you're cooking! Visit ```http://localhost:5000/switch``` to change the website from YES to NO. Visit ```http://localhost:5000/``` to see your change.

The reason for this switch is simple: it allows you to flick it over without having to redeploy. But please, do not leave the route as ```switch``` else users will be able to switch the website back and forth. My suggestion is to [generate](http://www.famkruithof.net/uuid/uuidgen) a UUID, update your ```.env``` file (as well as the Heroku envoironment variable below), and email the URL to yourself for safe keeping. That way you can switch the website over from the comfort of your favourite email client.

## Deployment

If you don't already have one, sign up for a [Heroku](https://www.heroku.com/) account. Everything you need to know and do to deploy is in [Getting Started with Ruby on Heroku](https://devcenter.heroku.com/articles/ruby).

In terminal, cd into your app:

```
$ cd yes-slash-no
$ git init
$ git add .
$ git commit -m "init"
$ heroku create
$ git push heroku master
```

You'll need to add the environment variables. I've left it as ```switch``` for the purpose of my documentation.

```
$ heroku config:set YSN_ROUTE=switch WEBSITE_NAME='Does this site answer a question?'
$ heroku open
```

Say hello yes / no. Now all you need is to set up a [custom domain](https://devcenter.heroku.com/articles/custom-domains) and away you go.

## MIT LICENSE

Copyright (c) 2013 Arturo Escartin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
