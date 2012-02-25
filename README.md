Base Sinatra App
================

> Engineers are really good at labeling and branding things. If we had named
Kentucky Fried Chicken, it would have been Hot Dead Birds.
-- *Vint Cerf*

What is it?
-----------

This is a small project that generates a base structure for spinning up new web apps based on [Sinatra](http://www.sinatrarb.com), [Haml](http://haml-lang.com), and [Sass](http://sass-lang.com).

Why?
----

I wanted to learn Ruby (in a web application context) and brush up on CSS. I didn't want to create a blog in five minutes, but rather, understand the details behind the scenes that determine why I can create a blog in five minutes.

I appear to be allergic to larger frameworks. My nose gets runny at the sight of an auto-generated directory full of more directories, dot-files, and placeholders. My eyes will water when you mention Rails. True story.  

Don't get me wrong, Rails is a wonderful project that has created some of the glue that I rely on day-to-day, but when you're trying to learn Ruby from scratch, coming across a million tutorials that tell you to run some command to generate a structure, then have you edit just one or two files out of 100 doesn't inspire confidence that I'll learn the ins-and-outs of the language anytime soon.

So, I've created a base foundation that I'm familiar with (and comfortable explaining to other people learning Ruby -- talk about the blind leading the blind).

How do I start using this thing?
--------------------------------

You'll need a few ingredients:

* Ruby
* Rubygems 1.3.6 or later
* [Bundler](http://gembundler.com)

To get started:

    git clone git://github.com/oogali/base-sinatra-app.git
    cd base-sinatra-app
    bundle install
    bundle exec rake start

Ok, how does it work?
---------------------
I'm assuming you already know how awesome Git and Sinatra are.

I've pre-defined a [bunch of dependencies](https://github.com/oogali/base-sinatra-app/blob/master/Gemfile) you need to start running. Bundler takes care of finding these dependencies (and their dependencies), and installing these gems onto your system. If you're going to add gems (which you will at some point), this is the file you'll add the dependencies to.

As part of the prep process, Bundler creates a few files and directories, but you most likely won't ever need to touch these auto-generated items:
- [.bundle/](https://github.com/oogali/base-sinatra-app/tree/master/.bundle)
- [bin/](https://github.com/oogali/base-sinatra-app/tree/master/bin)
- [Gemfile.lock](https://github.com/oogali/base-sinatra-app/blob/master/Gemfile.lock)

Chances are, you want to talk to some sort of database or datastore. So, there are some templates defined (but not activated), for the things I deal with the most: PostgreSQL and Redis.

You can find the above initialization files in the [setup/](https://github.com/oogali/base-sinatra-app/tree/master/setup) directory. Edit these to your heart's content, and then rename them so the files no longer carry a .inactive extension.

I rely on [rake](https://github.com/jimweirich/rake) to start and stop the application.  It handles preloading your datastore configurations, loading your code, and finally, starting and stopping the web server. This logic is contained in the [Rakefile](https://github.com/oogali/base-sinatra-app/blob/master/Rakefile).

[Thin](https://github.com/macournoyer/thin) is the web server used to front your web application. Its configuration, which you can also modify, is read from [config.yml](https://github.com/oogali/base-sinatra-app/blob/master/config.yml).

Thin also loads, another configuration file: [config.ru](https://github.com/oogali/base-sinatra-app/blob/master/config.ru0, which sets some more setttings that are specific to your application and/or Sinatra.

Your Sinatra directories are the standard bunch:

* [public/](https://github.com/oogali/base-sinatra-app/tree/master/public) holds your static assets (Javascript, CSS, images)
* [views/](https://github.com/oogali/base-sinatra-app/tree/master/views) holds your Haml templates

Some basic CSS and layouts are included (as Git submodules), as well as the following:

* [Eric A. Meyer's Reset CSS: get down to brass-tacks in every browser](http://meyerweb.com/eric/tools/css/reset/)
* [jQuery: the juggernaut Javascript library](http://jquery.com/)
* [jquery-tmpl: the jQuery templating plugin](http://github.com/jquery/jquery-tmpl)
* [Nathan Smith's Formalize: make consistent *and* pretty forms](http://formalize.me/)
* [ICanHaz: client-side templating Javascript library](http://icanhazjs.com/)
* [Knockout: client-side user interface framework](http://knockoutjs.com/)
* [D3: a straight-up, amazing Javascript document manipulation library that can generate crisp, clean, interactive graphs](http://mbostock.github.com/d3/)
* [gRaphaël: a library for generating clean graphs, but with less of a learning curve than D3](http://g.raphaeljs.com/)

Your application will land in [lib/](https://github.com/oogali/base-sinatra-app/tree/master/lib).

If you've been browsing the code, you'll see there's one placeholder that stands out: **appname**. Of course, your application will not be called *appname*, so run the 'init.sh' shell script from the root directory with your preferred class name:

    ./init.sh AwesomeSauce

That will replace all of *appname* placeholders with the name you've specified. And, now you're off to the races.

Any other goodies?
------------------
Why yes, yes there is.

I've included [sinatra-reloader](https://github.com/rkh/sinatra-reloader) for development. I used to write a lot of PHP, so I've gotten used to editing code, and then refreshing my browser to see the changes. But this isn't PHP, and the default behavior is to write code, find a free terminal window, restart your app, and then refresh your browser. That's a lot of clickety-clickety-click.

sinatra-reloader allows you to bypass all of that, as it intelligently reloads the app behind the scenes when your code changes. So you can relish in your write code-refresh-write code-refresh workflow.

There's also a base [Capistrano](https://github.com/capistrano/capistrano/wiki/2.x-From-The-Beginning) deployment configuration in [config/deploy.rb](https://github.com/oogali/base-sinatra-app/blob/master/config/deploy.rb). If you know Capistrano, you know what to do here.

What's left to do?
------------------
### Testing

I have absolutely no working tests in this project, primarily because I haven't learned testing within Ruby yet. Yes, everyone points me at Cucumber, Webrat, etc, but making them play nicely is something I've yet to figure out.
