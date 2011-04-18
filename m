From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Mon, 18 Apr 2011 08:44:14 -0400
Message-ID: <20110418084414.295ef417@tlielax.poochiereds.net>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303129252-7006-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Apr 2011 16:20:52 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add rwpidforward mount option that switches on a mode when we forward
> pid of a process who opened a file to any read and write operation.
> 
> This can prevent applications like WINE from failing on read or write
> operation on a previously locked file region from the same netfd from
> another process if we use mandatory brlock style.
> It is actual for WINE because during a run of WINE program two processes
> work on the same netfd - share the same file struct between several VFS
> fds:
> 1) WINE-server does open and lock;
> 2) WINE-application does read and write.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/README       |    3 ++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |    8 ++++++
>  fs/cifs/cifsproto.h  |   21 ++++++++-------
>  fs/cifs/cifssmb.c    |   31 +++++++++++++++-------
>  fs/cifs/connect.c    |    5 +++
>  fs/cifs/dir.c        |    4 +-
>  fs/cifs/file.c       |   69 ++++++++++++++++++++++++++++++++++++++-----------
>  fs/cifs/inode.c      |   10 ++++---
>  fs/cifs/link.c       |    6 ++--
>  10 files changed, 113 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index 4a3ca0e..33f4ba0 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -457,6 +457,9 @@ A partial list of the supported mount options follows:
>  		otherwise - read from the server. All written data are stored
>  		in the cache, but if the client doesn't have Exclusive Oplock,
>  		it writes the data to the server.
> +  rwpidforward  Forward pid of a process who opened a file to any read or write
> +		operation on that file. This revent application like WINE
					         ^^^^^^
					    "prevents applications"
		
> +		from failing on read and write if we use mandatory brlock style.
>    acl   	Allow setfacl and getfacl to manage posix ACLs if server
>  		supports them.  (default)
>    noacl 	Do not allow setfacl and getfacl calls on this mount

[...]

> @@ -1112,6 +1119,7 @@ static int cifs_writepages(struct address_space *mapping,
>  	struct pagevec pvec;
>  	int rc = 0;
>  	int scanned = 0;
> +	__u32 netpid;
>  	int xid;
>  
>  	cifs_sb = CIFS_SB(mapping->host->i_sb);
> @@ -1251,10 +1259,15 @@ retry_write:
>  				cERROR(1, "No writable handles for inode");
>  				rc = -EBADF;
>  			} else {
> +				if (cifs_sb->mnt_cifs_flags &
> +							CIFS_MOUNT_RWPIDFORWARD)
> +					netpid = open_file->pid;
> +				else
> +					netpid = current->tgid;
>  				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
> -						   bytes_to_write, offset,
> -						   &bytes_written, iov, n_iov,
> -						   0);
> +						   netpid, bytes_to_write,
> +						   offset, &bytes_written,
> +						   iov, n_iov, 0);
>  				cifsFileInfo_put(open_file);
>  			}
>  
		^^^^^^^^^^^^^^^
When flushing data for writeback (writepage or writepages), I don't
think we should care if a lock is held or by whom. The kernel has
memory that needs to be freed and it wants to perform writes to make
that happen.

I don't think these codepaths ought to care about the RWPIDFORWARD flag
at all. I think you ought to try to make sure that writes in those
cases use whatever pid will allow the writes to succeed.

Also, we should probably get Steve to comment on which patchset he
intends to commit first. This one or the async writepages one. One of
them will need to be respun on top of the other.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
