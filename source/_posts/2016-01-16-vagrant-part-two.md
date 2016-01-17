---
layout: post
title: "Vagrant Part Two: Why Is It So Hard?"
date: 2016-01-16
introduction: "I worked out a nicer way of using Vagrant compared to last time. Naturally, it was a palaver to implement the changes, because that's just how technology works. Or doesn't."
---

I've been a little busy and never got around to working on further projects after this blog in order to try out Vagrant and work with things. However, I didn't completely ignore it, and occasionally found myself thinking about it and how what I had come up with previously wasn't correct. Bundling the Vagrant configuration with the application code just wasn't the right thing to be doing. It meant that anyone using the repository would be forced to have it there whether they needed it or not. The actual application code was buried further in, inside a `code` directory. That's just daft.

The obvious solution was to break out the Vagrant provisioning into its own repository. So, today, that's what I did.

Of course, this being web development, things didn't work out very smoothly.

The first problem I encountered was that Vagrant was no longer able to start up a virtual machine in VirtualBox using a Vagrantfile that had previously worked flawlessly. This wasn't Vagrant's fault, however. The issue was with VirtualBox and a driver for its host-only network adapter. After some googling I found plenty of other people with the same issue. Most of them either dropped back to VirtualBox 4.x from 5.x. Some others managed to install the drivers correctly using a reinstall with some command line flags. However, one person had presented a much more pleasant solution that involved a simple checkbox in Windows.

On Windows 10 I had to go to the adapter settings, find the host-only network adapter and open its properties. In there, I had to check `VirtualBox NDIS6 Bridged Networking Driver`. After that, everything worked as expected.

So with that problem out of the way, I proceeded to extract the Vagrant configuration from the application repository and move it to another. I started by setting up a base repository on GitHub that I can clone wherever I want. Then I made a [new one](https://github.com/dljfield/wordstwo-vagrant) specific to the application, changed the cloned base repository's remote to point to this new one, and made my changes to the provisioners.

At this point, things should have worked as expected, but, of course, they didn't. Stuff doesn't work perfectly after an entire 2 months of not touching it. Don't be ridiculous.

The first issue was probably my fault, though it wasn't expected at all. I decided to try using Node 4.x rather than 5.x, because in theory it is an LTS version of node and will be stable for a little while. Unfortunately, for whatever reason, doing this meant that npm was no longer able to install things in the application directory. Maybe the npm setup script needed to be adjusted for node 4.x, or maybe node is just rubbish. I couldn't say. I switched back to 5.x and it worked again.

The second issue was that I couldn't connect to the nginx site using the internal IP that had been set up. This was definitely baffling. The configuration for this hadn't changed at all, and I could ssh into the virtual machine just fine. I also tried forwarding port 80 on the guest to port 8080 on the host, and found that I could connect to nginx like that. I have no idea what was wrong with this. Not a single clue. In the end I just changed the IP address that the virtual machine was assigned and it worked again.

So at this point I have two repositories: `wordstwo` for the actual blog code and `wordstwo-vagrant` for the Vagrant configuration. As it should be, I feel.

My only concern with this approach is that, should I make changes to the Vagrant configuration in one repository that would benefit all repositories, I have no way of getting those changes out to all of them except manually adjusting each one. For now, that'd be just this blog and the base repository. However, add a few more applications onto that and things get a little bit rubbish.

In conclusion, this was actually really annoying. I'll admit that I am still nothing more than a novice at environment setup, but given that I hadn't actually changed anything except which repositories various parts were stored in, I can't say I'm impressed with how much extra time I had to spend to get it working.
