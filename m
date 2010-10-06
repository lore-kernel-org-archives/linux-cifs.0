From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/15] cifs: clean up management of open filehandle (try #2)
Date: Wed,  6 Oct 2010 15:54:02 -0400
Message-ID: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second attempt at the patchset to clean up the management
of open filehandles in CIFS. The main changes are:

1) elimination of some more unnecessary NULL pointer checks

2) the cifs_file_list_lock (aka GlobalSMBSeslock) has been left as a
rwlock_t, though it has been renamed as before

3) the order of operations in cifs_oplock_break_put has been fixed --
previously it put the sb reference before the cifsFileInfo reference
which could have led to oopses.

4) cifs_flush only waits for writeback to complete on filehandles that
were opened with FMODE_WRITE set.

The patchset has passed several hours running the connectathon testsuite
in a loop.

Suresh and Shaggy both sent acks for various parts of the patchset, but
the last few patches had enough substantial changes that I didn't want
to add them without their "re-acks".

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
  cifs: rename GlobalSMBSeslock to cifs_file_list_lock
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
 fs/cifs/file.c       |  575 +++++++++++++++++++-------------------------------
 fs/cifs/inode.c      |   15 +-
 fs/cifs/misc.c       |   18 +--
 fs/cifs/readdir.c    |    6 +-
 11 files changed, 266 insertions(+), 474 deletions(-)

-- 
1.7.2.3
