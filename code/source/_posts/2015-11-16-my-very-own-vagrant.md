---
layout: post
title: My Very Own Vagrant
date: 2015-11-16
introduction: I've been using Homestead for a long time, but I've never actually used *Vagrant*. Magic boxes are bad practice, so I decided to figure it out.
---

Vagrant isn't actually very complicated in principle. The idea of typing a command and getting a virtual machine makes a lot of sense (at least to me), and the idea of provisioning it to do things you want it to do also makes a lot of sense. Indeed, pretty much everything about Vagrant makes sense.

But understanding the principle and putting it into practice are two very different things. Setting up working environments for web apps can be pretty complex, especially if you're coming into that world brand new. Given the option between sitting down and working out just what to install and how to get it to do so reliably, or downloading Homestead and running `homestead up`, I know which choice appealed to me.

But while solutions like Homestead are nice for getting up and running quickly, I think they miss the point in the long run. A big part of Vagrant's appeal to me is the separation of environments and the ability to more closely match what the production server is like. Homestead bundles everything into one VM, essentially just giving you the same problems you'd get running things on your host machine, except virtualised. The second issue is one that I've run into directly a couple of times, happily programming features only to find afterwards that the server doesn't run the right version of PHP, or that something just doesn't seem to work right, but—guess what—"it works on my machine."

Even the ideal of platform independence on dev machines is scuttled with Homestead, by virtue of it being far too much of a pain to get working on Windows. I've had no trouble with such things having set up Vagrant myself, because I'm using it directly instead of through custom commands that are really only tested on Macs.

Besides, let's be honest: it's always better to understand what you're working with than it is to rely on a magic box.

### Go Go Gadget Bash Script

Actually installing Vagrant and making it run is trivial; as long as you can follow the instructions, it'll work. Provisioning, however, is something that is conceptually simple but a bit of a pain in practice. I'm sure someone with a lot of devops experience would be happily bashing out Puppet scripts or handing out pre-baked boxes, but that's still a bit advanced for me. Instead, I chose to go with the humble bash script to set up my own Vagrant environments.

My own journey here was stalled before it began though, because I didn't know anything about bash scripts. However, I was aware of [Vaprobash](https://github.com/fideloper/Vaprobash) as a pre-made set of provisioning tools using bash, so I decided to take a look and see what I could learn.

My first attempts—copying what was done there—didn't end up so great. Much of what Vaprobash does is designed so you don't have to look at the scripts actually doing the provisioning, so there is extra complexity. It isn't *crazy* stuff, but it's still more than my poor brain could comprehend as a first pass.

Still, I persevered and ended up with a simple solution that works for me. I set up this blog using my own Vagrant machine in fact!

The first step was to decide on where, exactly, the provisioning scripts would live. I'm still not 100% sure about what I ended up with, because it seems odd to have an extra level to go down in an app's repository to get to the actual app. However, I couldn't think of anything better, so I went with this directory structure:

{% highlight %}
root
    - code [where the app lives]
    - provisioners [the bash scripts]
    .gitignore
    README.md
    Vagrantfile
{% endhighlight %}

Inside the `provisioners` folder, I keep the various bash scripts, separated out by their job. As an example, this blog (a static site built by Jekyll, using Gulp to compile Sass), has the following provisioners:

{% highlight %}
base.sh [basic stuff like timezone and language]
gulp.sh [installing Gulp]
nginx.sh [installing nginx]
node.sh [installing node]
npm_setup.sh [setting up npm to allow for sudoless global installs]
ruby.sh [installing ruby]
site.sh [setting up the nginx site]
{% endhighlight %}

Then, to run everything, I add at the bottom of my `Vagrantfile` the following, which get called in order:

{% highlight ruby %}
config.vm.provision :shell, path: "provisioners/base.sh"
config.vm.provision :shell, path: "provisioners/ruby.sh"
config.vm.provision :shell, path: "provisioners/nginx.sh"
config.vm.provision :shell, path: "provisioners/site.sh"
config.vm.provision :shell, path: "provisioners/npm_setup.sh"
config.vm.provision :shell, path: "provisioners/node.sh"
config.vm.provision :shell, path: "provisioners/gulp.sh"
{% endhighlight %}

There are a couple of other things set in my `Vagrantfile` as well. I set up a private network and install the hostsupdater plugin, to automatically set my hosts file and allow access to the VM in my browser through a nice url like `wordstwo.dev`. To go along with this, I set the hostname for the VM too. Finally, for the sake of nginx, I link the `code` folder to a location in `/var/www`. It looks like this:

{% highlight ruby %}
config.vm.network "private_network", ip: "192.168.56.102"
config.vm.synced_folder "code", "/var/www/wordstwo"
config.vm.hostname = "wordstwo.dev"
config.hostsupdater.remove_on_suspend = false # this isn't really necessary, but does show that hostsupdater is involved!
{% endhighlight %}

And, as it turns out, that's really all there is to it! The hardest part after this is really just knowing what commands need to be run to install the tools you want to use. Luckily, there are plenty of guides available to help with this, and if you really need something tricky done at this stage then I expect Vagrant is the least of your worries.

If you're anything like me then it's helpful to have an example to start with. Everything I used to set up this blog and learn how this provisioning stuff works can be found on my GitHub, specifically [here](https://github.com/dljfield/wordstwo/tree/master/provisioners). And my final note is to remember to escape your `$`'s when putting together the nginx site configuration. I caused myself headaches missing out just one damn `\`.

I'm sure that, as I work with Vagrant in this more direct way further, I'll come across issues with what I've done and will have to change things around and resolve them. But as a step one, this has worked pretty well and I'm glad I took the time to do it. Now to figure out the best way to deploy my apps to production…
