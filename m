From: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 00/14] cifs: clean up management of open filehandles
Date: Mon, 04 Oct 2010 15:31:56 -0500
Message-ID: <1286224316.9136.2.camel@shaggy-w500>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2010-10-04 at 13:52 -0400, Jeff Layton wrote:
> This patchset fixes a number of problems with the existing CIFS code. It
> eliminates the backreference to the filp from cifsFileInfo, allowing a
> cifsFileInfo to outlive the filp that it was generated against.
> 
> With that change, most of the closing of a filehandle on the server is
> moved to cifsFileInfo_put. cifs_close is then changed to just put the
> filehandle instead of trying to wait around for existing users to
> finish with it.
> 
> With this change, there is some further cleanup that can be done as
> well. For instance, there's no real need to continually search for new
> filehandles in cifs_writepages now that we hold a reference to one. I'll
> hold back on that until I know how this set has been received.
> 
> This set is an ordered set and should not be committed out of order. It
> should be bisectable. I've tested the resulting set and it seems to work
> fine.

These all look good to me.  Cleans up the code rather nicely.

Shaggy

> Jeff Layton (14):
>   cifs: keep dentry reference in cifsFileInfo instead of inode
>     reference
>   cifs: don't use vfsmount to pin superblock for oplock breaks
>   cifs: eliminate cifs_posix_open_inode_helper
>   cifs: eliminate oflags option from cifs_new_fileinfo
>   cifs: eliminate the inode argument from cifs_new_fileinfo
>   cifs: clean up cifs_reopen_file
>   cifs: cifs_write argument change and cleanup
>   cifs: eliminate pfile pointer from cifsFileInfo
>   cifs: move cifs_new_fileinfo to file.c
>   cifs: convert GlobalSMBSeslock from a rwlock to regular spinlock
>   cifs: move cifsFileInfo_put to file.c
>   cifs: move close processing from cifs_close to cifsFileInfo_put
>   cifs: wait for writeback to complete in cifs_flush
>   cifs: eliminate cifsInodeInfo->write_behind_rc
> 
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |   21 ++-
>  fs/cifs/cifsfs.h     |    6 +-
>  fs/cifs/cifsglob.h   |   19 +--
>  fs/cifs/cifsproto.h  |    6 +-
>  fs/cifs/cifssmb.c    |    4 +-
>  fs/cifs/dir.c        |   60 +-----
>  fs/cifs/file.c       |  574 +++++++++++++++++++-------------------------------
>  fs/cifs/inode.c      |   15 +-
>  fs/cifs/misc.c       |   18 +--
>  fs/cifs/readdir.c    |    6 +-
>  11 files changed, 260 insertions(+), 470 deletions(-)
> 

-- 
Dave Kleikamp
IBM Linux Technology Center
