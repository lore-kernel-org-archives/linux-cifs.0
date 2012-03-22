From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 22 Mar 2012 14:07:25 -0500
Message-ID: <CAH2r5mu6yOytCEoYYAtLjPhxtya44FRBYdTu-z+r0NdicAR3Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (3):
      cifs: fix issue mounting of DFS ROOT when redirecting from one
domain controller to the next
      cifs: clean up call to cifs_dfs_release_automount_timer()
      cifs: clean up ordering in exit_cifs

Pavel Shilovsky (7):
      CIFS: Fix a spurious error in cifs_push_posix_locks
      CIFS: Respect negotiated MaxMpxCount
      CIFS: Simplify inFlight logic
      CIFS: Introduce credit-based flow control
      CIFS: Make wait_for_free_request killable
      CIFS: Prepare credits code for a slot reservation
      CIFS: Delete echo_retries module parm

 fs/cifs/README       |    6 +---
 fs/cifs/cifs_debug.c |    3 +-
 fs/cifs/cifsfs.c     |   25 ++++++----------
 fs/cifs/cifsglob.h   |   47 +++++++++++++++++++++++-------
 fs/cifs/cifsproto.h  |    9 ++++++
 fs/cifs/cifssmb.c    |   18 ++++++-----
 fs/cifs/connect.c    |   44 ++++++++++++++++------------
 fs/cifs/dir.c        |    6 ++-
 fs/cifs/file.c       |   23 ++++++++-------
 fs/cifs/misc.c       |   19 ++++++++++++
 fs/cifs/transport.c  |   78 +++++++++++++++++++++++++++----------------------
 11 files changed, 169 insertions(+), 109 deletions(-)

-- 
Thanks,

Steve
