From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/15] cifs: clean up management of open filehandle (try #3)
Date: Fri,  8 Oct 2010 13:30:57 -0400
Message-ID: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the third attempt at the patchset to clean up management of
open filehandles in CIFS. The main changes from try #2 are:

1) the cifs_file_list_lock has been converted to a spinlock after much
discussion about it on-list.

2) the list order for the inode->openFileList has been eliminated. After
reviewing the code more thoroughly, I came to the conclusion that the
list order was essentially meaningless anyway.

The rest of the set is essentially unchanged. I've left Suresh and
Shaggy's Acked-by/Reviewed-by lines in place except on patches that
have had substantial changes.

Jeff Layton (15):
  cifs: keep dentry reference in cifsFileInfo instead of inode
    reference
  cifs: don't use vfsmount to pin superblock for oplock breaks
  cifs: eliminate cifs_posix_open_inode_helper
  cifs: eliminate oflags option from cifs_new_fileinfo
  cifs: eliminate the inode argument from cifs_new_fileinfo
  cifs: clean up cifs_reopen_file
  cifs: cifs_write argument change and cleanup
  cifs: eliminate pfile pointer from cifsFileInfo
  cifs: move cifs_new_fileinfo to file.c
  cifs: convert GlobalSMBSeslock from a rwlock to regular spinlock
  cifs: move cifsFileInfo_put to file.c
  cifs: move close processing from cifs_close to cifsFileInfo_put
  cifs: convert cifsFileInfo->count to non-atomic counter
  cifs: wait for writeback to complete in cifs_flush
  cifs: eliminate cifsInodeInfo->write_behind_rc

 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |   21 ++-
 fs/cifs/cifsfs.h     |    6 +-
 fs/cifs/cifsglob.h   |   28 +--
 fs/cifs/cifsproto.h  |    6 +-
 fs/cifs/cifssmb.c    |    4 +-
 fs/cifs/dir.c        |   60 +-----
 fs/cifs/file.c       |  570 +++++++++++++++++++-------------------------------
 fs/cifs/inode.c      |   15 +-
 fs/cifs/misc.c       |   18 +--
 fs/cifs/readdir.c    |    6 +-
 11 files changed, 261 insertions(+), 474 deletions(-)

-- 
1.7.2.3
