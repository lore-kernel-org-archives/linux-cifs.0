From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Mount failure due to restricted access to a point along the
 mount path
Date: Tue, 14 May 2013 10:51:19 +0200
Message-ID: <20130514105119.66a5bc3f@corrin.poochiereds.net>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
	<20130510102754.184cd90d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130510102754.184cd90d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 May 2013 10:27:54 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 10 May 2013 16:13:30 +0200
> Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org> wrote:
> 
> > Hi,
> > 
> > A while ago this was discussed:
> > 
> >   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
> > 
> > This is essentially a regression introduced by the shared superblock
> > changes in 3.0 and several SUSE customers are complaining about it.
> > I've created a temporary fix which reverts 29 commits related to the
> > shared superblock changes.  It works, but it's obviously not a
> > permanent fix, especially since we definitely don't want to diverge
> > from mainline.
> > 
> > Is this issue being worked on?  Don't other distros have similar reports?
> > 
> > Thanks,
> > Miklos
> 
> I don't know of anyone currently working on it. There are a couple of
> possible approaches to fixing it, I think:
> 
> 1) if the dentries to get down to the root of the mount don't already
> exist, then attach some sort of "placeholder" inode that can be fleshed
> out later if and when the dentry is accessed via other means.
> 
> 2) do something like what NFS does (see commit 54ceac45). This becomes
> a bit more complicated due to the fact that the server may not hand out
> real inode numbers and we sometimes have to fake them up.
> 
> #1 is probably simpler to implement, but I'll confess that I haven't
> thought through all of the potential problems with it.
> 

So, giving this some more thought, I think #2 is really the correct way
to fix this. Here's the main problem though:

Suppose someone mounts:

    //server/share/foo/bar/baz

We make the sb->s_root point to the top level share, and then create a
disconnected dentry for "baz" to return from ->mount.

Then, a little while later, //server/share gets mounted separately and
a user walks down to /foo/bar/baz within the same share.

How do we ensure that we don't end up with two "baz" dentries in this
situation? With NFS, we can be reasonably sure that there's a 1:1
correspondance of filehandle to inode.

Under CIFS, it's possible that it's faking up inode numbers if the
server doesn't provide them via a UniqueID field. The only real
identifying info we have for the inode in that case is the pathname.

Perhaps we'd be best off to just rip out the sb sharing after all.
Getting all of the corner cases right when the protocol and server
implementations are so problematic is really, really difficult.

If we do go that route, then the fscache code will need some work since
it uses the sharename as a sb cookie.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
