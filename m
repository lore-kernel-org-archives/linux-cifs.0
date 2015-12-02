From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: vfs: move btrfs clone ioctls to common code
Date: Wed, 2 Dec 2015 11:40:13 -0600
Message-ID: <CAH2r5msWk+oA=teWnLrpJhp48PEToMoWiN8H8+ptdvEko+GNbA@mail.gmail.com>
References: <1448563859-21922-1-git-send-email-hch@lst.de> <CAH2r5muW6=v6tx3BwXSYMgn7EZgzVANniebsxfwpdq9Y=0VcuA@mail.gmail.com>
 <20151202072757.GB15839@lst.de>
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
In-Reply-To: <20151202072757.GB15839-jcswGhMUV9g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 2, 2015 at 1:27 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> Hi Steve,
>
> we have two APIs in Linux:
>
>  - the copy_file_range syscall which just is a "do a copy by any means"
>  - the btrfs clone ioctls which have stricter semantics that very much
>    expect a reflink-like operation

If the copy_file_range is allowed to use any offload mechanism then
cifs.ko could be changed as follows, to fallback among the three
possible mechanisms depending on what the target supports.

- send the fastest one of the three choices,
 the "reflink-like") FSCTL_DUPLICATE_EXTENTS (there is a
server fs capability that we check at mount time that indicates whether
it is supported).   If it is not supported or if the source and target are on
different shares (exports) then fallback to
- send the ODX style copy offload (when implemented).  This is the only
one that could in theory support cross-server copies (rather than require copy
from a source and target on the same server)
- (if the above aren't supported) send the FSCTL_COPYCHUNK (currently
called via CIFS_IOC_COPYCHUNK_FILE)

For the btrfs_ioc_clone_range (or similar ", FSCTL_DUPLICATE_EXTENTS could
probably stay the same since it is the only one of the three that
guarantees using reflinks.

If we want to for Linux->Samba, we could probably add a whole file
clone (similar to hardlinks
on the wire) to Samba and cifs.ko if that is useful (as opposed to the
three mechanisms
above which are copy ranges)

In addition, I noticed that the cp command has added various
optimizations for sparse
file enablement.  I need to test those on cifs.ko and update the
ioctls for retrieving sparse
ranges o make sure that they work over SMB3 mounts, for optimizing
the case where the source file is sparse, and mostly empty.

> I plan to also wire up copy_file_range to try the clone_file_range method
> first if available to make life easier for file systems, but as there isn't
> any test coverage for that I don't dare to actually submit it yet.  I'll
> send a compile tested only RFC for it when resending this series.



-- 
Thanks,

Steve
