From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Mon, 27 Sep 2010 08:59:17 -0400
Message-ID: <20100927085917.1ab8500a@tlielax.poochiereds.net>
References: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8@mail.gmail.com>
	<20100919150427.16ab30d9@corrin.poochiereds.net>
	<AANLkTik04e_d9HPeGsB8Adcm2tpGh-qEOwcQvu6ScP3D@mail.gmail.com>
	<20100920085140.4b844270@corrin.poochiereds.net>
	<4CA093D4.4060708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA093D4.4060708-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 27 Sep 2010 18:23:40 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 09/20/2010 09:21 PM, Jeff Layton wrote:
> >>>>
> >>>> It's causing some unwanted behaviour.
> >>>> How can I change that, or is this not changeable?
> >>>> Stef
> >>>
> >>> I think it's just a matter of setting the inode->i_size on the
> >>> directory. I *think* that when you do a QPathInfo call to a directory
> >>> via cifs the size comes back 0. Setting this to something else probably
> >>> means an extra call to the server to get the "real" size (whatever that
> >>> means). The question is, what should this be set to?
> >>>
> >>
> >> Yes that's a good question. But a share mounted with cifs should
> >> behave like it is's just a local harddrive partition right? So these
> >> values are obligatory...
> >>
> > 
> > No, not necessarily.
> > 
> >>  In my construction - so I'm speaking only for my own here -
> >> it's also set the size (and the blocks) in the FUSE fs. Remember, I'm
> >> using the FUSE fs fuse-workspace
> >> as the one which is used, and the various mounts to resources like smb
> >> shares (mounted with cifs of course, managed with autofs) are the
> >> underlying backend.
> >>
> >> My FUSE can correct things, like this.
> >>
> >> I wonder, it can correct things, but is it also a must?
> >> My fuse fs takes these values just from the underlying fs, and this
> >> can result in
> >> a size of directories of 4096 when the underlying fs is a mounted
> >> partition (of for example an USB disk) and zero
> >> when it's a cifs mounted smb share. Is it a bad thing that these
> >> values differ in the same fs (in my case thus fuse-workspace)??
> >>
> >> Maybe you know this, else I'll try at the fsdevel list.
> >>
> > 
> > It really comes down to this question:
> > 
> >     What is the size on a directory supposed to signify?
> > 
> 
> (Sorry for digging an old thread..)
> 
> I think it is really the space required (filesystem thinks it requires)
> for storing the metadata about the files that would be stored and it
> depends on the internal datastructures of the filesystem. It never
> shrinks but expands when the number of files increases.
> 
> For e.g. On a ext3 filesystem, it looks like the default size of
> directory on creation is 4096/4k and somewhere between 325 files and 350
> files, it changes from 4k to 12k.
> 
> To get the same behavior on CIFS, the client needs to be aware of the
> Server filesystem and need to have a rough idea of datastructures unless
> the Server provides the size. Also, the client needs to increase the
> size to replicate the same behavior when the number of files on the
> server increases.
> 
> I think the nearest information about the Server filesystem the client
> could get is 'block size' and the client could try to do some clever
> guess, but it may not always get it correct.
> 
> 

I guess my point with all of this is that the size of a directory is
undefined by POSIX. A zero size directory is no less correct than any
other size. If there are applications that depend on that value meaning
something, then they ought to reconsider doing that.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
