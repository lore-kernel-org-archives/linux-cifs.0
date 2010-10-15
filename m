From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/13] cifs: clean up management of open filehandles (try #5)
Date: Fri, 15 Oct 2010 15:33:55 -0400
Message-ID: <1287171248-464-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fifth attempt at a cleanup of the filehandle management code in CIFS.
The changes from the last set are pretty minimal.

Steve has committed the first three patches in the set, so they've been
dropped from this patchbomb.

Also, I've put the list ordering back in for the flist. I still think
it's a worthless optimization and just makes the code more confusing and
fragile, but Steve feels strongly that it should stay as an ordered
list.

I'd like to see this merged before the 2.6.37 merge window opens.
Comments and suggestions welcome...

Jeff Layton (13):
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

 fs/cifs/cifsfs.c    |    3 +-
 fs/cifs/cifsglob.h  |   25 +--
 fs/cifs/cifsproto.h |    8 +-
 fs/cifs/cifssmb.c   |    4 +-
 fs/cifs/dir.c       |  156 +-------------
 fs/cifs/file.c      |  612 +++++++++++++++++++++++++--------------------------
 fs/cifs/inode.c     |   15 +-
 fs/cifs/misc.c      |   16 +-
 fs/cifs/readdir.c   |    6 +-
 9 files changed, 334 insertions(+), 511 deletions(-)

-- 
1.7.2.3
