From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/16] cifs: clean up management of open filehandles (try #4)
Date: Mon, 11 Oct 2010 15:07:17 -0400
Message-ID: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fourth attempt at a cleanup for the filehandle management code in CIFS.

While looking at Suresh's comment, I noticed some discrepancies about
how files were being opened, particularly in the posix code. So, this
set has a new patch to fix up the flag usage in the POSIX open code.
Please review that carefully as this is really fiddly code.

The only other real change is to actually remove the dependency on list
order from find_readable_file. The rest of the patches are pretty much
the same as the last set, but some of them had to be respun because of
the cifs_posix_open cleanup.

I've tested this for several hours with connectathon and it seems to
be ok. Comments and suggestions welcome.

Jeff Layton (16):
  cifs: keep dentry reference in cifsFileInfo instead of inode
    reference
  cifs: don't use vfsmount to pin superblock for oplock breaks
  cifs: eliminate cifs_posix_open_inode_helper
  cifs: fix flags handling in cifs_posix_open
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
 fs/cifs/cifsproto.h  |    8 +-
 fs/cifs/cifssmb.c    |    4 +-
 fs/cifs/dir.c        |  159 +-----------
 fs/cifs/file.c       |  685 ++++++++++++++++++++++----------------------------
 fs/cifs/inode.c      |   15 +-
 fs/cifs/misc.c       |   18 +-
 fs/cifs/readdir.c    |    6 +-
 11 files changed, 357 insertions(+), 594 deletions(-)

-- 
1.7.2.3
