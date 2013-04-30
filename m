From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: multiuser kerberised cifs via autofs needs root ticket cache
Date: Tue, 30 Apr 2013 09:22:12 -0400
Message-ID: <20130430092212.53254831@tlielax.poochiereds.net>
References: <51723F74.3010807@steve-ss.com>
	<20130426101410.1754c9ab@tlielax.poochiereds.net>
	<517B0C3A.80809@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517B0C3A.80809-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Apr 2013 01:22:34 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On 26/04/13 16:14, Jeff Layton wrote:
> > On Sat, 20 Apr 2013 09:10:44 +0200
> > steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> >
> >> Hi
> >> one of my automount files is:
> >> * -fstype=cifs,sec=krb5,multiuser ://doloresdc/users/&
> >>
> >> It works fine but only if the krb5cc_0 cache is available under /tmp.
> >> When a user logs in, he gets his own cache. With multiuser, why isn't
> >> that good enough to be able to mount his share?
> >>
> > Because you haven't specified the cruid= that should be used to mount
> > the share and act as the root credentials for the mount.
> >
> > I don't think you really want "multiuser" in the above situation. It
> > sounds like you're trying to set up each autofs-mounted cifs filesystem
> > for a single user.
> >
> > In that case, you probably want to do something like:
> >
> >      * -fstype=cifs,sec=krb5,uid=&,gid=&,cruid=& ://doloresdc/users/&
> No, it doesn't work. We'd need one & for the uid and another for the 
> gid. We can only have one wild card I think. It's important that even 
> though it's a singe user mount, that the files created in it are owned 
> by the uid:gid of the user. multiuser gives us this, plus it's essential 
> for mounts where many users have group rw to the files in the share.

Yeah, you'd need to figure out what should be added into there if you
really think you need a separate mount per user directory. Note too
that there's a catch with the above configuration -- there's nothing
that prevents an entirely unrelated user from getting into the
directory that's been mounted and accessing it with the mount
credentials.

None of that's an issue however if you use a proper multiuser mount.

> >
> > ...assuming of course that the directory names under that filesystem
> > match the usernames of your users.
> >
> >> Question, if we really must have the root cache then how do I get that
> >> on boot? I need to run this as root:
> >> kinit -k steve2 to get the cache with my key in /etc/krb5.keytab. I
> >> can't find a way to be able to do that on either Ubuntu 12.10 nor
> >> openSUSE 12.3.
> >>
> > I think you're confused as to what "multiuser" does. It allows users to
> > access the *same* mounted filesystem with their own krb5 creds. IOW,
> > instead of trying to use autofs like you are here, you could simply
> > do this:
> >
> >      mount -t cifs //doloresdc/users /cifsusers -o sec=krb5,multiuser
> >
> > ...assuming that you have a credcache for uid=0 or proper credentials
> > in /etc/krb5.keytab, then it should mount and users can access
> > everything under /cifsusers with their own credentials.
> >
> Hi
> Yes, the permanent mount works but it's slow when the lan is busy. The 
> automounter speeds things up quite a bit. Maybe our hardware isn't up to 
> maintaining the permanent mount. But, in anycase, what you are saying is 
> that I have to keep a root cache alive under /tmp to make any mount at 
> all.

No, that's not what I'm saying at all. You can get the same effect by
setting up credentials for root in /etc/krb5.keytab. Just pass in the
correct username= mount option for the principal that you want root to
be.

> That's what we're finding. How do we go about that? A cron to do 
> kinit -k MACHINE$ every few hours for example? k5start looks ok too.
> Cheers, Steve
> 

Erm...I'm not sure how to respond to this since it doesn't make much
sense. Perhaps you can outline what you mean? What exactly, is "slow"
when you use a "permanent" multiuser mount? None of this should be
terribly taxing on a modern computer...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
