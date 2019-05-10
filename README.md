![Screenshot](/screenshot.png?raw=true)

# Joomlatools Vagrant

[Joomlatools Vagrant] automates the setup of a Joomla development environment. It is capable of running a full featured LAMP stack with a single command so that you can start working on your Joomla projects quickly.

## Requirements

* [Vagrant](http://www.vagrantup.com/) 2.0 and up
* [VirtualBox](http://www.virtualbox.org/) 5.1 and up

## Installation

1. Install [VirtualBox](http://www.virtualbox.org/)

1. Install [Vagrant](http://www.vagrantup.com/)

1. Run the following commands in a folder of your choice:

    ```
    vagrant init joomlatools/box
    vagrant up
    ```

    This will download the Vagrant box and get it running.

1. Add the following line into your ***hosts file*** (/etc/hosts on Linux and MacOS, for other operating systems see [here](http://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system))

    ```
    33.33.33.58 joomla.box webgrind.joomla.box phpmyadmin.joomla.box
    ```

1. The dashboard is now available at [joomla.box](http://joomla.box)

There will be two new folders created called `www` and `Projects`. These folders act as shared folders between your host computer and the box.

## Usage

1. Once you have installed the box as described above, SSH into the box:

    ```
    vagrant ssh
    ```

1. Create your first Joomla website with this command:

    ```
    joomla site:create mysite
    ```

1. Your new site is available at [joomla.box/mysite](http://joomla.box/mysite). You can login using the credentials  `admin` / `admin`.

1. You can now symlink and install your custom extensions into the site, manage PHP versions and much more. Head over to our [documentation pages][Joomlatools Vagrant] to learn more about the box and its possibilities.

## Updating to the latest version

When new versions of the box are released you can update your local machine by executing:

```
vagrant box update
```

Note that updating the box will not update an already-running Vagrant machine. To reflect the changes in the box, you will have to destroy (`vagrant destroy`) and bring back up the Vagrant machine (`vagrant up`).

For more details refer to our [FAQ](https://www.joomlatools.com/developer/tools/vagrant/faq/#how-can-i-update-the-box-to-the-latest-version).

## Sharing access to the box

### HTTP

Open source is all about collaboration, so there will be times you will want to share your work with others. In order to achieve this you will need [ngrok](https://ngrok.com/). We recommend you follow these set up steps first:

1. Upgrade Vagrant to the latest version.
1. Create your (free) [account](https://dashboard.ngrok.com/signup) on ngrok.
1. [Download](https://ngrok.com/download) and install ngrok.
1. Set up the authentication token on your machine as described in the [ngrok documentation](https://ngrok.com/docs/2#authtoken).

Now you're ready to start sharing access. Run this command and share the resulting ngrok HTTP URL:

```
ngrok http joomla.box:80
```

### Terminal

You can also share access to the terminal via SSH. There are two methods:

1. With [tmate](https://tmate.io/): run the `tmate` command on the box and share the resulting ssh connection string. 
1. Using Vagrant's built-in [SSH sharing](https://www.vagrantup.com/docs/share/ssh.html) feature.

## Hacking on the box

### Set up

If you want to make changes to the box's infrastructure, you can do so by building the box from scratch. Follow these steps to get started:

1. Clone this repository:

    ```
    git clone https://github.com/joomlatools/joomlatools-vagrant.git
    ```

1. Install required Vagrant plugins

    ```
    vagrant plugin install vagrant-puppet-install
    vagrant plugin install vagrant-vbguest
    ```

1. Install dependencies with [bundler](http://bundler.io/):

    ```
    bundle install
    ```

1. Go to the repository folder and build the box:

    ```
    cd joomlatools-vagrant
    vagrant up
    ```

1. You can now edit the Puppet configuration. To apply your changes, provision the box again:

    ```
    vagrant provision
    ```

### Building and releasing using Packer

We use [Packer](https://www.packer.io/) to automatically build the box. To start a build, follow these steps:

1. Clone this repository:

    ```
    git clone https://github.com/joomlatools/joomlatools-vagrant.git
    ```

1. Install dependencies with [bundler](http://bundler.io/):

    ```
    bundle install
    ```
   
1. Download the required Puppet modules using `librarian-puppet:`

   ```
   cd puppet
   librarian-puppet install --path modules/common/
   ```
   
1. Install [Packer](https://www.packer.io/)
1. Now edit the `packer.json` file. Look for the current version and increase the version number.
The version number is defined in the variables section and can be found at the top of the file. It looks like this:
1. Also increase the `$box_version` variable in `puppet/manifests/default.pp` and update the changelog.
1. Commit the change and push back to GitHub.
1. Instruct packer to start the build:

    ```
    packer build -on-error=ask packer.json
    ```
    
1. Once finished a `joomlatools-0.0.0.box` file will be created with the correct version number. Upload it to [Vagrant Cloud](https://app.vagrantup.com/) to make it available to everyone else.

### Run ServerSpec tests

1. Go to the `tests` directory: `cd tests/`
1. Install `serverspec` with `bundle install`
2. Run the tests: `bundle exec rake spec`

Note: to run _on_ the box, run `BACKEND=exec bundle exec rake spec`

## Reporting issues

The box is a very complex piece of technology, based on many different open source tools and libraries many of which are far beyond our capabilities and understanding.

We therefore deliberately keep the Issues section on this specific Github repo closed for such questions as we want to encourage people to submit code to add features or fix bugs by opening up Pull Requests instead of report bug or problems through Issues.

If you do have a problem running the box please use either our [forum](https://groups.google.com/forum/#!forum/joomlatools-dev) or [chat room](http://gitter.im/joomlatools/dev) to get in touch with us and we are most happy to try and help you.

## Contributing

Joomlatools Box is an open source, community-driven project. Contributions are welcome from everyone.
We have [contributing guidelines](CONTRIBUTING.md) to help you get started.

## Contributors

See the list of [contributors](https://github.com/joomlatools/joomlatools-vagrant/contributors).

## License

Joomlatools Vagrant box is free and open-source software licensed under the [MPLv2 license](LICENSE.txt).

## Community

Keep track of development and community news.

* Follow [@joomlatoolsdev on Twitter](https://twitter.com/joomlatoolsdev)
* Join [joomlatools/dev on Gitter](http://gitter.im/joomlatools/dev)
* Read the [Joomlatools Developer Blog](https://www.joomlatools.com/developer/blog/)
* Subscribe to the [Joomlatools Developer Newsletter](https://www.joomlatools.com/developer/newsletter/)

[Joomlatools Vagrant]: https://www.joomlatools.com/developer/tools/vagrant/
