From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: vfs: move btrfs clone ioctls to common code
Date: Tue, 1 Dec 2015 16:48:12 -0600
Message-ID: <CAH2r5muW6=v6tx3BwXSYMgn7EZgzVANniebsxfwpdq9Y=0VcuA@mail.gmail.com>
References: <1448563859-21922-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Jeffrey Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448563859-21922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the new API is there a way to distinguish between the two copy
offload behaviors:

1) FSCTL_DUPLICATE_EXTENTS (where the server file system increments a
refcount on blocks in the range)
and
2) FSCTL_COPYCHUNK (where the server does a server side copy of the
requested range, but does not necessarily use reflink, although in the
case of Samba on btrfs it implements it this way).  In this case NTFS
will usually make a copy of the range requested rather than linking
the ranges.

For the former cifs uses (used prior to this patc) the btrfs ioctl,
for the latter it has a private ioctl (CIFS_IOC_COPYCHUNK_FILE).  For
the former the files have to be on the same share (export) for the
latter it just requires that the files be on the same server, and in
common cases (drag an drop in the file explorer on the desktop) the
source and target files would be on different mounts to the same
server.

There is an unimplemented (in cifs.ko) whole file clone operation
(copy-on-write file with a network API similar to the hardlink) but it
looks like it is no longer supported by newer servers, perhaps because
there is more interest in the ODX mechanism for duplicating files ala
https://msdn.microsoft.com/en-us/library/windows/desktop/hh848056(v=vs.85).aspx
across server farms for managing virtualization images.   I need to
add the ODX copy offload mechanism to cifs.ko but presumably it would
behave more like FSCTL_COPYCHUNK (ie not do a reflink of the blocks)

The performance improvements from server side copy offload is huge
whether or not reflink is done - so allowing the cp command (or common
user space commands ala robocopy which already does this in Windows)
to do fast copy is particularly important for network file systems.

On Thu, Nov 26, 2015 at 12:50 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> This patch set moves the existing btrfs clone ioctls that other file
> system have started to implement to common code, and allows the NFS
> server to export this functionality to remote systems.
>
> This work is based originally on my NFS CLONE prototype, which reused
> code from Anna Schumaker's NFS COPY prototype, as well as various
> updates from Peng Tao to this code.
>
> The patches are also available as a git branch and on gitweb:
>
>         git://git.infradead.org/users/hch/pnfs.git clone-for-viro
>         http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/clone-for-viro
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
