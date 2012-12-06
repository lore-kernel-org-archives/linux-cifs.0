From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] cifs-utils: new plugin architecture for ID mapping code
Date: Thu, 6 Dec 2012 10:16:33 -0500
Message-ID: <CAFB9KM1rtd+uxzDWadU3bU2Uxhw5VhOvKoQBsmae4mucgno7XQ@mail.gmail.com>
References: <1354797458-5170-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354797458-5170-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 6, 2012 at 7:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 1/ Should we switch this code to use a config file of some sort instead
> of this symlink? The symlink would probably be more efficient, but it
> is a little odd and might confuse people. It also might make it hard to
> expand the idmapping interfaces later.

Please no symlinks.  We could end up with something like alternatives
(/etc/alternatives) where you need a utility to track and change
symlinks pointing to symlinks.  I don't even know where java is on my
machine or which JVM I'm running.  Symlinks have a tendency to turn
into symlink farms.  Look at your PAM install, it's a bunch of links
to a single file on most installs.  That way lies madness and dragons.

I think most people are comfortable with config files and they're
intuitive.  Also, is anyone at any time going to be using more than
one mapping interface?

-- 
Peace and Blessings,
-Scott.
