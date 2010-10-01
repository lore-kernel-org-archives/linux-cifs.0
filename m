From: Stef Bon <stef-/E4qUF3RmbfcqV2Q6a4srg@public.gmane.org>
Subject: Re: [autofs] [PATCH 00/17] Introduce automounter dentry ops
Date: Fri, 01 Oct 2010 09:57:54 +0200
Message-ID: <4CA59482.1040508@bononline.nl>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100930181455.30939.53914.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  On 09/30/2010 08:14 PM, David Howells wrote:
> The attached patches introduce a couple of new dentry operations for use by
> automounters and make AFS, NFS, CIFS and autofs4 use them.  This means that
> these filesystems no longer have to abuse lookup(), follow_link() and
> d_revalidate() to achieve the desired effect.

Improvments are always welcome as I look at it, but for my understanding,
how do these new dentry operations cooperate with cifs?

Cifs is the target filesystem, and handled by the automounter, thus the 
automounter is the initiator, not cifs.

As you describe it (well it looks like it, I may not understand...) cifs 
is the initiator, and the patches to the automounter make autofs handle 
cifs requests handle better?

What is now the case here?? I cannot understand.
Any explanation is appreciated.

Stef Bon
the Netherlands

> There are two dentry operations provided:
>
>   (1) struct vfsmount *(*d_automount)(struct path *path);
>
>       This is used by follow_automount() in fs/namei.c to ask the filesystem
>       that owns the dentry at the current path point to mount something on
>       @path.
>
>       It is called if either the inode belonging to the given dentry is flagged
>       S_AUTOMOUNT or the dentry is flagged DMANAGED_AUTOMOUNT, and if the dentry
>       has nothing mounted on it in the current namespace when someone attempts
>       to use that dentry.
>
>       No locks will be held when this is called.
>
>       d_op->d_automount() may return one of:
>
>       (a) The vfsmount mounted upon that dentry, in which case pathwalk will
>       	 move to the root dentry of that vfsmount.
>
>       (b) NULL if something was already mounted there, in which case pathwalk
>       	 will loop around and recheck the mountings.
>
>       (c) -EISDIR, in which case pathwalk will stop at this point and attempt to
>       	 use that dentry as the object of interest.  If the current dentry is
>       	 not terminal within the path, -EREMOTE will be returned.
>
>       (d) An error value, to be returned immediately.
>
>       Automount transits are counted as symlinks to prevent circular references
>       from being a problem.  If one is detected, -ELOOP will be returned.
>
>       If stat() is given AT_NO_AUTOMOUNT then d_op->d_automount() will not be
>       invoked on a terminal dentry; instead that dentry will be returned by
>       pathwalk.
>
>       follow_automount() also does not invoke d_op->d_automount() if the caller
>       gave AT_SYMLINK_NOFOLLOW to stat(), but rather returns the base dentry.
>
>
>   (2) int (*d_manage)(struct path *path, bool mounting_here);
>
>       This is called by managed_dentry() or follow_down() in fs/namei.c to
>       indicate to a filesystem that pathwalk is about to step off of the current
>       path point and walk to another point in the path.
>
>       This is called if DMANAGED_TRANSIT is set on a dentry.
>
>       This can then be used by autofs to stop non-daemon processes from walking
>       until it has finished constructing or expiring the tree behind the dentry.
>       It could also be used to prevent undesirables from mounting on this
>       dentry.
>
>       @mounting_here is true if called from follow_down() from mount, in which
>       case namespace_sem is held exclusively by the caller of follow_down().
>       Otherwise, no locks are held.
>
>       d_op->d_manage() may return one of:
>
>       (a) 0 to continue the pathwalk as normal.
>
>       (b) -EISDIR to prevent managed_dentry() from crossing to a mounted
>       	 filesystem or calling d_op->d_automount(), in which case the dentry
>       	 will be treated as an ordinary directory.
>
>       (c) An error to abort the pathwalk completely.
>
>
> To make this work for autofs, d_mounted in struct dentry has become d_managed.
> This used to be a count of the number of mounts on this dentry.  The bottom 28
> bits are still that (DMANAGED_MOUNTPOINT).  The upper four bits contain a
> couple of flags, DMANAGED_TRANSIT and DMANAGED_AUTOMOUNT.  This allows
> managed_dentry() to test all three conditions with minimumal overhead if none
> of them are true.
>
> For other filesystems, setting S_AUTOMOUNT is sufficient.  This is noted by
> __d_instantiate() which will set DMANAGED_AUTOMOUNT automatically if it is
> seen.  Checking S_AUTOMOUNT doesn't work for autofs, however, since the dentry
> might not have an inode, hence why a dentry flag also.
>
> S_AUTOMOUNT and d_automount() are introduced in patch 1; d_manage(), d_managed
> and DMANAGED_* are introduced in patch 7.
>
> David
> ---
>
> David Howells (8):
>        Make follow_down() handle d_manage()
>        Make dentry::d_mounted into a more general field for special function dirs
>        Add an AT_NO_AUTOMOUNT flag to suppress terminal automount
>        Remove the automount through follow_link() kludge code from pathwalk
>        CIFS: Use d_automount() rather than abusing follow_link()
>        NFS: Use d_automount() rather than abusing follow_link()
>        AFS: Use d_automount() rather than abusing follow_link()
>        Add a dentry op to handle automounting rather than abusing follow_link()
>
> Ian Kent (9):
>        autofs4 - bump version
>        autofs4 - add v4 pseudo direct mount support
>        autofs4 - fix wait validation
>        autofs4: cleanup autofs4_free_ino()
>        autofs4: cleanup dentry operations
>        autofs4: cleanup inode operations
>        autofs4: removed unused code
>        autofs4: add d_manage() dentry operation
>        autofs4: add d_automount() dentry operation
>
>
>   Documentation/filesystems/Locking |    2
>   Documentation/filesystems/vfs.txt |   22 +
>   fs/afs/dir.c                      |    1
>   fs/afs/inode.c                    |    3
>   fs/afs/internal.h                 |    1
>   fs/afs/mntpt.c                    |   47 +--
>   fs/autofs/dirhash.c               |    5
>   fs/autofs4/autofs_i.h             |  100 ++++--
>   fs/autofs4/dev-ioctl.c            |    2
>   fs/autofs4/expire.c               |   42 ++
>   fs/autofs4/inode.c                |   28 --
>   fs/autofs4/root.c                 |  668 ++++++++++++++++---------------------
>   fs/autofs4/waitq.c                |   17 +
>   fs/cifs/cifs_dfs_ref.c            |  134 ++++---
>   fs/cifs/cifsfs.h                  |    6
>   fs/cifs/dir.c                     |    2
>   fs/cifs/inode.c                   |    8
>   fs/dcache.c                       |    7
>   fs/namei.c                        |  243 +++++++++++--
>   fs/namespace.c                    |   20 +
>   fs/nfs/dir.c                      |    4
>   fs/nfs/inode.c                    |    4
>   fs/nfs/internal.h                 |    1
>   fs/nfs/namespace.c                |   87 ++---
>   fs/nfsd/vfs.c                     |    5
>   fs/stat.c                         |    4
>   include/linux/auto_fs4.h          |    2
>   include/linux/dcache.h            |   19 +
>   include/linux/fcntl.h             |    1
>   include/linux/fs.h                |    2
>   include/linux/namei.h             |    5
>   include/linux/nfs_fs.h            |    1
>   32 files changed, 836 insertions(+), 657 deletions(-)
>
> _______________________________________________
> autofs mailing list
> autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org
> http://linux.kernel.org/mailman/listinfo/autofs
>
