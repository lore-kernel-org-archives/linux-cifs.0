From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH RFC] cifs-utils: new plugin architecture for ID mapping
 code
Date: Thu, 06 Dec 2012 10:38:42 -0500
Message-ID: <1354808322.14719.31.camel@pico.ipa.ssimo.org>
References: <1354797458-5170-1-git-send-email-jlayton@samba.org>
	 <CAFB9KM1rtd+uxzDWadU3bU2Uxhw5VhOvKoQBsmae4mucgno7XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM1rtd+uxzDWadU3bU2Uxhw5VhOvKoQBsmae4mucgno7XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-12-06 at 10:16 -0500, Scott Lovenberg wrote:
> On Thu, Dec 6, 2012 at 7:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > 1/ Should we switch this code to use a config file of some sort instead
> > of this symlink? The symlink would probably be more efficient, but it
> > is a little odd and might confuse people. It also might make it hard to
> > expand the idmapping interfaces later.
> 
> Please no symlinks.  We could end up with something like alternatives
> (/etc/alternatives) where you need a utility to track and change
> symlinks pointing to symlinks.  I don't even know where java is on my
> machine or which JVM I'm running.  Symlinks have a tendency to turn
> into symlink farms.  Look at your PAM install, it's a bunch of links
> to a single file on most installs.  That way lies madness and dragons.
> 
> I think most people are comfortable with config files and they're
> intuitive.  Also, is anyone at any time going to be using more than
> one mapping interface?

Probably not, which is why a symlink is all we need.
I think starting with a symlink is fine, I do not particularly love it,
but makes a lot of stuff simpler for starter.
Having to parse a config file at each program invocation (for utilities)
adds up in latency and also requires YACF (Yet Another Config File)
where all you do is say: use plugin X, or a very complex version of a
symlink.

Now if you need to actually configure something then yes we could move
to use a config file eventually.

But unless you already know there is something the cifs utils (*not* the
plugins) need to configure then it seem a lot of overhead both in terms
of coding that needs to be done, file formats to choose and associated
bikeshed, and runtime churn.

Simo.


-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
