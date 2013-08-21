# Yes Slash No

Use Yes Slash No to, quickly, knock up a website that answers a question in the form of [Is It Christmas](http://isitchristmas.com/), [Is It Thanksgiving Yet?](http://www.isitthanksgivingyet.com/), [Yes, Margaret Thatcher is dead](http://www.isthatcherdeadyet.co.uk/), and [Is Julia Gillard Still Prime Minister?](http://isjuliagillardstillpm.com/). Classy.

Fast forward a few months: as pointed out on [Reddit](http://www.reddit.com/r/ruby/comments/1hmo2b/yes_slash_no_deploy_a_yes_no_website_fast/cavtpgm), Heroku resets the file system every 24 hours so the JSON file I was using to store the YES/NO variable will be reset back to its original state. This is not really good for anyone. In order to rectify this the variable will now be pulled from the apps' config variables which complicates things a little. First off, setting up config vars on Heroku. Second, updating this via their API. Thirdly there's issues with generating the API key. I've knocked out the first two issues but the third will take longer.

## Installation

Firstly, make sure you've [installed Ruby](http://www.ruby-lang.org/en/). Also, install the [Heroku Toolbelt](https://toolbelt.heroku.com/) as it includes [Foreman](https://github.com/ddollar/foreman) for running Procfile-based applications.

Next, if you don't already have one, sign up for a [Heroku](https://www.heroku.com/) account. Everything you need to know and do to deploy is in [Getting Started with Ruby on Heroku](https://devcenter.heroku.com/articles/ruby).

Then in terminal, clone me:

```
$ git clone https://github.com/kripy/yes-slash-no yes-slash-no
$ cd yes-slash-no
$ git init
$ git add .
$ git commit -m "init"
$ heroku create
$ git push heroku master
```

Make note of the app name.

To run it locally you still need to add the YES/NO variable to Heroku as we pull it from there.

```
$ heroku config:set YSN_ANSWER=no
```

Time to generate your API key. Note, if your API key falls into the wrong hands it could cause you all sorts of issues so be careful with it.

The reason you need to generate it, as per point three above, is for some reason the base64 function returns an incorrect key than the one generated off the command line meaning you need to do it manually.

As the documentation [states](https://devcenter.heroku.com/articles/platform-api-reference#authentication), HTTP basic authentication must be constructed from email address and api token as ```{email-address}:{api-token}```, base64 encoded and passed as the Authorization header for each request.

To get your Heroku API token, run ```heroku auth:token```. Your email address is the email address you used to register with Heroku.

To generate the API key run ```echo email address : auth token | base64``` from the command line. Note the space either side of the colon. They is NOT generated correctly without it. Took me a while to figure that one out.

Now, create an ```.env``` file in the root directory of the project. The file should look like this:

```
YSN_ROUTE=switch
YSN_APP_NAME=<your app name as noted above>
YSN_APP_KEY=<the API key you generated above>
```

Now fire it up:

```
$ foreman start
```

Open up a browser at ```http://localhost:5000/```: now you're cooking! Visit ```http://localhost:5000/switch``` to change the website from YES to NO. Visit ```http://localhost:5000/``` to see your change.

The reason for this switch is simple: it allows you to flick it over without having to redeploy. But please, do not leave the route as ```switch``` else users will be able to switch the website back and forth. My suggestion is to [generate](http://www.famkruithof.net/uuid/uuidgen) a UUID, update your ```.env``` file (as well as the Heroku envoironment variable below), and email the URL to yourself for safe keeping. That way you can switch the website over from the comfort of your favourite email client. 

## Deployment

As you've already create the app on Heroku, commit your updated code and push:

```
$ git add .
$ git commit -m "Deploy time."
$ heroku create
$ git push heroku master
```

You'll need to add the environment variables. I recommend updating ```switch``` to something more solid like a [UUID](http://www.famkruithof.net/uuid/uuidgen). 

```
$ heroku config:set YSN_ROUTE=switch
$ heroku config:set YSN_APP_NAME=boiling-meadow-1520
$ heroku config:set YSN_APP_KEY=XXX
```

Say hello to yes / no. Now all you need is to set up a [custom domain](https://devcenter.heroku.com/articles/custom-domains) and away you go.

## MIT LICENSE

Copyright (c) 2013 Arturo Escartin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.