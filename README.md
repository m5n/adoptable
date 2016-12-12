Adoptable
---------
Auto-searches animal adoption sites for your companion of choice
Built on top of http://shopify.github.com/dashing 

Usage
-----
0. Complete the developer setup below
1. Configure a custom search via the `settings.yml` file
2. Run `dashing start` to start the server
3. Point your browser at http://localhost:3030/adoptable
4. Wait for the search results to appear

Developer setup
---------------
If you don't have Ruby installed:

    $ \curl -sSL https://get.rvm.io | bash -s stable --ruby

This will install the latest RVM and Ruby. Follow all instructions the RVM installer gives you. (This should include sourcing the rvm script.)

If you use gnome-terminal or screen on certain Linux flavors (e.g. Mint), make sure you follow the instructions here: https://rvm.io/integration/gnome-terminal

Determine the Ruby installed by running the following and grabbing the ruby listed (e.g. ruby-2.3.0):

    $ rvm list

Now configure a compartmentalized independent Ruby setup for this project (replace ruby-2.3.0 with whatever version of Ruby got installed earlier):

    $ rvm --create --ruby-version use ruby-2.3.0@adoptable

Install the gems this project relies on:

    $ gem install bundler
    $ bundle install

You can easily add custom search jobs--look in the `jobs` dir for inspiration
