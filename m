From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: smb2 and shared superblock model
Date: Sat, 26 Mar 2011 14:06:38 -0400
Message-ID: <20110326140638.77580be3@corrin.poochiereds.net>
References: <AANLkTikvUqYG5GnOkYnrb67B1PJa7yrhzHiWT8+KxEPO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikvUqYG5GnOkYnrb67B1PJa7yrhzHiWT8+KxEPO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 26 Mar 2011 16:12:03 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi!
> 
> Today I investigated a bit about how to insert sharedblock model into
> cifs and get it work correctly with smb2.1 leases. Now we have the
> following archtecture:
> inode -> superblock -> tlink -> tcon -> sess -> srv - so we can
> definitely say what ses id and tree id we should use for a requested
> inode. It's from the one hand.
> 
> From another hand, we should share cached data between several
> sessions from the same client (according to SMB2 spec we should have
> one global file table). And everything is good if we will share
> superblock between several mounts that uses the same sess id and tcon
> id. But if these are different sessions that's brings a problem. A
> superblock is linked to only one tcon id and sess id but we need to
> share it between completely different sessions. So, it seems to me
> that according to nowadays situation we can't share the same data
> between different sessions.
> 
> So, now I suggest to share a superblock only between different mounts
> of the same sess id and tcon id. And every time we negotiate a
> different session (e.x. from another username) we should change
> ClientGUID. It causes the server to think that these are different
> clients and it won't grant leases on parallel opens from these
> sessions. So, in this case we solve data coherency problem but, of
> course, miss some advantages of SMB2 protocol.
> 
> Your comments/thoughts?
> 

That's not quite correct...

A superblock can point to more than one tcon in the multiuser mount
case. That's the whole reason for the tlink structure in the first
place.

The reason for a shared superblock is that you intend to mount the
exact same data in multiple places and don't intend to bind mount. With
NFS for instance, consider the case where you do something like this:

    # mount server:/export /mount1
    # mount server:/export/subdir /mount2

Suppose then that you access these files:

    /mount1/subdir/file1
    /mount2/file1

Traditionally, that would give you two different inodes connected to
two different superblocks. Cache consistency can easily be off, you end
up with duplicate data in cache, and dealing with fscache is
problematic since you can end up with collisions in the cache.

To fix that (mostly for the fscache problem), David Howells converted
NFS so that it would share superblocks in this situation. The two
vfsmounts point to the same superblock, but the root dentry is different
for each.

So...what does this mean for CIFS? We already look for an existing
server, session and tcon when we mount. To do this for CIFS you would
simply need to go a step farther and look for an existing superblock
that matches your needs and deal with setting up the root dentry
correctly.

I urge you to have a look at what NFS does in this case. It's
non-trivial but that is probably the best model for doing this in CIFS.

Here's the catch though...you now have to deal with all of the CIFS
mount options and decide which settings mean that you need to create a
new superblock instead of using an existing one on a new mount.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
