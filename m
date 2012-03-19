From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: cifs: pull request for 3.4
Date: Mon, 19 Mar 2012 09:45:58 -0400
Message-ID: <20120319094558.1b6094b4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I think these patches have all been acked/reviewed for 3.4. You may
pull them when ready:

The following changes since commit 762ad8a5330325b789cfb6dc896f81cf273ff4e9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-03-13 18:39:28 -0700)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git cifs-3.4

Jeff Layton (11):
      cifs: clean up call to cifs_dfs_release_automount_timer()
      cifs: clean up ordering in exit_cifs
      cifs: add new cifsiod_wq workqueue
      cifs: add pid field to cifs_writedata
      cifs: allow caller to specify completion op when allocating writedata
      cifs: fix allocation in cifs_write_allocate_pages
      cifs: make cifsFileInfo_get return the cifsFileInfo pointer
      cifs: fix up get_numpages
      cifs: abstract out function to marshal up the iovec array for async writes
      cifs: call cifs_update_eof with i_lock held
      cifs: convert cifs_iovec_write to use async writes

 fs/cifs/cifsfs.c    |   25 +++--
 fs/cifs/cifsglob.h  |    7 +-
 fs/cifs/cifsproto.h |   15 +++-
 fs/cifs/cifssmb.c   |   35 ++++---
 fs/cifs/connect.c   |    8 +-
 fs/cifs/file.c      |  271 +++++++++++++++++++++++++++++++++------------------
 fs/cifs/misc.c      |    2 +-
 7 files changed, 235 insertions(+), 128 deletions(-)


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
