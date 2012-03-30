From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 30 Mar 2012 16:04:50 -0500
Message-ID: <CAH2r5mtRpNBgjE5qTcb6sejy1Oq_uKOQtRPU2_hoyk7TnRubww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:
  Linus Torvalds (1):
        Merge tag 'stable/for-linus-3.4-tag-two' of
git://git.kernel.org/.../konrad/xen

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (11):
      cifs: add new cifsiod_wq workqueue
      cifs: add pid field to cifs_writedata
      cifs: allow caller to specify completion op when allocating writedata
      cifs: fix allocation in cifs_write_allocate_pages
      cifs: make cifsFileInfo_get return the cifsFileInfo pointer
      cifs: fix up get_numpages
      cifs: abstract out function to marshal up the iovec array for async writes
      cifs: call cifs_update_eof with i_lock held
      cifs: convert cifs_iovec_write to use async writes
      cifs: remove /proc/fs/cifs/OplockEnabled
      cifs: handle "sloppy" option appropriately

Pavel Shilovsky (6):
      CIFS: Separate protocol-specific code from transport routines
      CIFS: Separate protocol-specific code from demultiplex code
      CIFS: Separate protocol-specific code from cifs_readv_receive code
      CIFS: Expand CurrentMid field
      CIFS: Change mid_q_entry structure fields
      CIFS: Add missed forcemand mount option

Sachin Prabhu (1):
      cifs: use standard token parser for mount options

Steve French (3):
      [CIFS] Fix trivial sparse warning with asyn i/o patch
      Merge branch 'for-3.4'
      [CIFS] Update CIFS version number to 1.77

 fs/cifs/cifs_debug.c |   68 +--
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsfs.c     |   13 +-
 fs/cifs/cifsfs.h     |    2 +-
 fs/cifs/cifsglob.h   |   39 +-
 fs/cifs/cifsproto.h  |   20 +-
 fs/cifs/cifssmb.c    |  126 +++--
 fs/cifs/connect.c    | 1454 ++++++++++++++++++++++++++++++--------------------
 fs/cifs/file.c       |  271 ++++++----
 fs/cifs/misc.c       |  100 ++--
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  227 +++++----
 12 files changed, 1381 insertions(+), 946 deletions(-)

-- 
Thanks,

Steve
