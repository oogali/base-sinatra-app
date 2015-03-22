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

I appear to be allergic to larger frameworks. My nose gets runny at the sight of an auto-generated directory full of more directories, dot-files, and placeholders.

My eyes will water when you mention Rails. True story.  

So, I've created a base foundation that I'm familiar with (and comfortable explaining to other people learning Ruby).

### What's your beef with Rails?

Don't get me wrong, Rails is a wonderful project that has created some of the glue that I rely on day-to-day.

But when you're trying to learn Ruby from scratch, and come across numerous tutorials that tell you to:

* run some magical command to generate a structure,
* then edit just one or two magical files out of hundreds

That doesn't inspire confidence in me that I'll learn the ins-and-outs of the language or its frameworks anytime soon.

How do I start using this thing?
--------------------------------

You'll need a few ingredients:

* Ruby and Rubygems
* [Bundler](http://gembundler.com)

I highly recommend [rbenv](https://github.com/sstephenson/rbenv).

Why? Because you'll need a Ruby version manager for consistent targeting.

Chances are, you're developing on your laptop which has one Ruby version, then deploying to a server or instance that has another Ruby version.

Then one day, you may spin up a new VM on Amazon EC2, DigitalOcean, or Linode, and find out that theirs systems have a completely different Ruby version.

### Getting Started

    git clone git://github.com/oogali/base-sinatra-app.git
    cd base-sinatra-app
    bundle install
    ./init.sh YourAwesomeApp
    bundle exec rake start

Ok, how does it work?
---------------------
I'm assuming you already know how awesome [Sinatra](http://www.sinatrarb.com/) is.

I've pre-defined a [bunch of dependencies](https://github.com/oogali/base-sinatra-app/blob/master/Gemfile) you need to start running.

#### Bundler
Bundler takes care of finding these dependencies (and the dependencies' dependencies), and installing these gems onto your system.

If you're going to add gems (which you will at some point), this is the file you'll add those gems to.

(Also worth a mention here: [Gemrat](https://github.com/DruRly/gemrat))

As part of the prep process, Bundler creates a few files and directories, but you won't need to touch these auto-generated items since they're used for dependency tracking:

* [.bundle/](https://github.com/oogali/base-sinatra-app/tree/master/.bundle)
* [bin/](https://github.com/oogali/base-sinatra-app/tree/master/bin)
* [Gemfile.lock](https://github.com/oogali/base-sinatra-app/blob/master/Gemfile.lock)

#### Databases and Datastores
Chances are, you will eventually want to talk to some sort of database or datastore.

So, there are some templates defined (but not activated), for the things I deal with the most: PostgreSQL and Redis.

You can find initialization files for the above datastores in the [setup/](https://github.com/oogali/base-sinatra-app/tree/master/setup) directory. Edit these to your heart's content, and then rename them so the files no longer carry a .inactive extension.

    vi setup/redis.rb
    git mv setup/redis.rb.inactive setup/redis.rb

I've switched to the standard of using the "config/database.yml" pattern to configure ActiveRecord to talk to my PostgreSQL datastore. You can find this file in the [config/](https://github.com/oogali/base-sinatra-app/tree/master/config) directory. You can edit this and rename it to config/database.yml.

However, you should know that it is bad practice to commit database credentials into your project as anyone with access to the repository can see the prized jewels of your SQL password. So, I've configured the local Git settings so that any file named "config/database.yml" to be ignored by your Git client.

You'll want to make a copy of the example file, name it "config/database.yml", and then edit it.

    cp config/database.yml.example config/database.yml
    vi config/database.yml

#### Rake
I rely on [rake](https://github.com/jimweirich/rake) to start and stop the application.  It handles preloading your datastore configurations, loading your code, and finally, starting and stopping the web server. This logic is contained in the [Rakefile](https://github.com/oogali/base-sinatra-app/blob/master/Rakefile).

    bundle exec rake start
    bundle exec rake stop

#### Unicorn
[Unicorn](http://unicorn.bogomips.org/) is the web server used to front your web application. Its configuration, which you can also modify, is read from [unicorn-configuration.rb](https://github.com/oogali/base-sinatra-app/blob/master/unicorn-configuration.rb).

Unicorn loads Rack, and Rack loads another configuration file: [config.ru](https://github.com/oogali/base-sinatra-app/blob/master/config.ru), which sets some more setttings that are specific to your application and/or Sinatra instance.

#### Assets
Your applications' assets (images, CSS styles, Javascript files, templates, etc) are:

* [public/](https://github.com/oogali/base-sinatra-app/tree/master/public) holds your static assets (things that don't need to be compiled, e.g. Javascript, CSS, images)
* [views/](https://github.com/oogali/base-sinatra-app/tree/master/views) holds your Haml and Sass templates

Some basic CSS and layouts are included.

* [Font Awesome: a CSS and font toolkit for great icons](http://fortawesome.github.io/Font-Awesome/)
* [Yahoo's Pure: a responsive CSS framework](http://purecss.io/)
* [jquery-tmpl: the jQuery templating plugin](http://github.com/jquery/jquery-tmpl)

Your application will land in [lib/](https://github.com/oogali/base-sinatra-app/tree/master/lib).

If you've been browsing the code, you'll see there's one placeholder that stands out: **appname**. Of course, your application will not be called *appname*, so run the 'init.sh' shell script from the root directory with your preferred class name:

    ./init.sh AwesomeSauce

That will replace all of *appname* placeholders with the name you've specified. And, now you're off to the races.

Any other goodies?
------------------
Why yes, yes there are.

#### Capistrano

Capistrano is a tool used for deploying your application to remote servers in a standard fashion. It also tracks the code you've deployed (up to 5 deploys), allowing you to also rollback if a deploy gets dicey.

There's a base [Capistrano](https://github.com/capistrano/capistrano/wiki/2.x-From-The-Beginning) deployment configuration in [config/deploy.rb](https://github.com/oogali/base-sinatra-app/blob/master/config/deploy.rb).

##### Capistrano Modules

I've also included a number of Capistrano modules that have made my life easier. I won't go into too much detail here, but here's a list:

* [Capistrano::Bundler](https://github.com/capistrano/bundler)
* [Capistrano::Rails](https://github.com/capistrano/rails)
* [Capistrano::Rbenv](https://github.com/capistrano/rbenv)
* [Capistrano::Rbenv::Install](https://github.com/capistrano-plugins/capistrano-rbenv-install)
* [hipchat](https://github.com/hipchat/hipchat-rb)

What's left to do?
------------------
### Testing

I have absolutely no working tests in this project, primarily because I haven't learned testing within Ruby yet. Yes, everyone points me at Cucumber, Webrat, etc, but making them play nicely is something I've yet to figure out.
