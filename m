From: Jeff Layton <jlayton@redhat.com>
Subject: Re: Mount failure due to restricted access to a point along the
 mount path
Date: Tue, 14 May 2013 13:09:06 +0200
Message-ID: <20130514130906.7f9525bf@corrin.poochiereds.net>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
	<20130510102754.184cd90d@corrin.poochiereds.net>
	<20130514105119.66a5bc3f@corrin.poochiereds.net>
	<CAH2r5msxb+zB6av5wz5_55MbhCR4FWjJpnyP=vzg-=48gg3vkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-cifs@vger.kernel.org,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sjayaraman@novell.com
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5msxb+zB6av5wz5_55MbhCR4FWjJpnyP=vzg-=48gg3vkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 14 May 2013 05:44:48 -0500
Steve French <smfrench@gmail.com> wrote:

> On Tue, May 14, 2013 at 3:51 AM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Fri, 10 May 2013 10:27:54 -0400
> > Jeff Layton <jlayton@redhat.com> wrote:
> >
> >> On Fri, 10 May 2013 16:13:30 +0200
> >> Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> > Hi,
> >> >
> >> > A while ago this was discussed:
> >> >
> >> >   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
> >> >
> >> > This is essentially a regression introduced by the shared superblock
> >> > changes in 3.0 and several SUSE customers are complaining about it.
> >> > I've created a temporary fix which reverts 29 commits related to the
> >> > shared superblock changes.  It works, but it's obviously not a
> >> > permanent fix, especially since we definitely don't want to diverge
> >> > from mainline.
> >> >
> >> > Is this issue being worked on?  Don't other distros have similar reports?
> >> >
> >> > Thanks,
> >> > Miklos
> >>
> >> I don't know of anyone currently working on it. There are a couple of
> >> possible approaches to fixing it, I think:
> >>
> >> 1) if the dentries to get down to the root of the mount don't already
> >> exist, then attach some sort of "placeholder" inode that can be fleshed
> >> out later if and when the dentry is accessed via other means.
> >>
> >> 2) do something like what NFS does (see commit 54ceac45). This becomes
> >> a bit more complicated due to the fact that the server may not hand out
> >> real inode numbers and we sometimes have to fake them up.
> >>
> >> #1 is probably simpler to implement, but I'll confess that I haven't
> >> thought through all of the potential problems with it.
> >>
> >
> > So, giving this some more thought, I think #2 is really the correct way
> > to fix this. Here's the main problem though:
> >
> > Suppose someone mounts:
> >
> >     //server/share/foo/bar/baz
> >
> > We make the sb->s_root point to the top level share, and then create a
> > disconnected dentry for "baz" to return from ->mount.
> >
> > Then, a little while later, //server/share gets mounted separately and
> > a user walks down to /foo/bar/baz within the same share.
> >
> > How do we ensure that we don't end up with two "baz" dentries in this
> > situation? With NFS, we can be reasonably sure that there's a 1:1
> > correspondance of filehandle to inode.
> >
> > Under CIFS, it's possible that it's faking up inode numbers if the
> > server doesn't provide them via a UniqueID field. The only real
> > identifying info we have for the inode in that case is the pathname.
> 
> Since this (support for server generated inode numbers) is most common
> case (especially with SMB2 and later) - I don't mind making dependency
> on the server supporting UniqueID for this.

There are still some problems even when the server does supply them. We
sometimes find that they aren't suitable for various reasons or aren't
to be trusted, and the client disables server inode numbers on the fly.

What do you do at that point if you already have 2 mounts sharing the
superblock?

-- 
Jeff Layton <jlayton@redhat.com>
