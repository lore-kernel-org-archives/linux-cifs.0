From: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Tue, 3 Aug 2010 13:24:47 +0100
Message-ID: <AANLkTin-KOqanow9Xa32AU0kXQK9hDQ_5Bxjjbugk7Jj@mail.gmail.com>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
	<4C56DBDD.4070501@suse.de>
	<AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
	<4C56E564.3020508@suse.de>
	<AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW@mail.gmail.com>
	<20100802131440.5b16a86b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100802131440.5b16a86b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2 August 2010 18:14, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> On Mon, 2 Aug 2010 16:56:10 +0100
> Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> > Just checked on a colleagues machine, and uname -r reports 2.6.32-2=
4-generic
> >
> > Also checked the dmesg on the Ubuntu 10.04 box:
> >
> > [ =A0964.362027] =A0CIFS VFS: Autodisabling the use of server inode
> > numbers on \\shared.openbet\shared. This server doesn't seem to
> > support them properly. Hardlinks will not be recognized on this mou=
nt.
> > Consider mounting with the "noserverino" option to silence this
> > message.
> > [ =A0964.368470] =A0CIFS VFS: server 10.194.0.105 of type Samba 3.0=
=2E28a
> > returned unexpected error on SMB posix open, disabling posix open
> > support. Check if server update available.
> >
> > The exact same errors that I get appear, which leads me to believe
> > that this in itself is not the cause of my issue.
> >
> > Any other ideas to debug further?
> >
>
> Yes, I agree that the above warnings may have nothing to do with the
> problem. We need to understand what the problem is. The strace shows
> this:
>
> write(2, "cvs [update aborted]: cannot get"..., 78cvs [update aborted=
]: cannot get working directory: No such file or directory) =3D 78
>
> ...but I don't see any system calls that returned -ENOENT. Maybe it
> occurred in another thread or something?
>
> So I'm a little unclear as to what cvs is complaining about. It's qui=
te
> possible that it's ultimately a bug in cifs, but without more info I
> really can't guess as to what the problem is. What we really need is =
a
> description of the problem couched in terms of the system call
> interface.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I've posted the dmesg output with cifsFYI set to 7, for the failed cvs
update command here:

http://paste.org/pastebin/view/21123

One strange thing I noticed, is that at one point it seems to be doing
something with /home/jbramley/cvs_src/appserv/lib/ix86, but that
folder is not in any of my env vars (PATH, LD_LIBRARY_PATH etc.) so I
can see no reason for it to be looking there. Could this be some kind
of inode confusion on the cifs share?

Thanks,

Jon
