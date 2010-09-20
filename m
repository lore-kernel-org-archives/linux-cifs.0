From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Mon, 20 Sep 2010 08:51:40 -0700
Message-ID: <20100920085140.4b844270@corrin.poochiereds.net>
References: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8@mail.gmail.com>
	<20100919150427.16ab30d9@corrin.poochiereds.net>
	<AANLkTik04e_d9HPeGsB8Adcm2tpGh-qEOwcQvu6ScP3D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik04e_d9HPeGsB8Adcm2tpGh-qEOwcQvu6ScP3D-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 20 Sep 2010 09:29:38 +0200
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/20 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Sun, 19 Sep 2010 21:28:41 +0200
> > Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Hello,
> >>
> >>
> >> It's causing some unwanted behaviour.
> >> How can I change that, or is this not changeable?
> >> Stef
> >
> > I think it's just a matter of setting the inode->i_size on the
> > directory. I *think* that when you do a QPathInfo call to a directory
> > via cifs the size comes back 0. Setting this to something else probably
> > means an extra call to the server to get the "real" size (whatever that
> > means). The question is, what should this be set to?
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
> 
> Yes that's a good question. But a share mounted with cifs should
> behave like it is's just a local harddrive partition right? So these
> values are obligatory...
> 

No, not necessarily.

>  In my construction - so I'm speaking only for my own here -
> it's also set the size (and the blocks) in the FUSE fs. Remember, I'm
> using the FUSE fs fuse-workspace
> as the one which is used, and the various mounts to resources like smb
> shares (mounted with cifs of course, managed with autofs) are the
> underlying backend.
> 
> My FUSE can correct things, like this.
> 
> I wonder, it can correct things, but is it also a must?
> My fuse fs takes these values just from the underlying fs, and this
> can result in
> a size of directories of 4096 when the underlying fs is a mounted
> partition (of for example an USB disk) and zero
> when it's a cifs mounted smb share. Is it a bad thing that these
> values differ in the same fs (in my case thus fuse-workspace)??
> 
> Maybe you know this, else I'll try at the fsdevel list.
> 

It really comes down to this question:

    What is the size on a directory supposed to signify?

It's certainly possible for us to fake up a size and stuff it into the
i_size field, but what should go there? Why 4096 and not 4097 or 4095?
What if the directory is bigger or smaller than a page?

Also, what sort of application is having problems with a directory of 0
size?

Asking this on fsdevel would probably be a good idea.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
