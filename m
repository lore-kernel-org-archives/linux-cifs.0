From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Tue, 28 May 2013 14:23:32 -0400
Message-ID: <20130528142332.32393fc6@tlielax.poochiereds.net>
References: <51A32117.5030908@steve-ss.com>
	<20130528063525.1baeac8c@corrin.poochiereds.net>
	<1369744796.2769.8.camel@hh16.hh3.site>
	<20130528090142.36d5076e@corrin.poochiereds.net>
	<1369748536.4537.4.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369748536.4537.4.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 28 May 2013 15:42:16 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On Tue, 2013-05-28 at 09:01 -0400, Jeff Layton wrote:
> 
> > > 
> > 
> > That sounds reasonable. Assuming that you don't actually do anything on
> > the mount as root, then you can give "cifsuser" very limited privileges
> > here too, essentially acting as a "squashed" user like under NFS.
> > 
> > Also, there's no need to do this crontab stuff either. If you mount
> > with "-o sec=krb5,username=cifsuser" then cifs.upcall will be able to
> > just use /etc/krb5.keytab without you needing to do anything special.
> > 
> 
> So cifsuser doesn't need loginShell nor unixHomeDirectory or any of the
> gecos stuff? I just tried with just posixAccount and uidNumber and
> gidNumber. It works under test but am I missing something? We just need
> cifsuser to be able to mount the share. He'll never need to do anything
> else.
> Cheers
> 

Again, better question for the samba lists, but I'd assume that the
login shell and homedir don't matter since samba just needs to be able
to "become" that user when accessing files, not do a full login.

Note too that unless you add "-o multiuser" then all accesses to that
mount will be done with the credentials used to do the mount. Really,
with kerberos auth there's little reason to use single-user mounts.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
