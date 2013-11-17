From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sat, 16 Nov 2013 18:14:45 -0600
Message-ID: <CAH2r5mvtF2VksZSoAg3p5BLD5Dd4CkgLFYxyjua0Ldog1M20Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of cifs fixes most important of which is Pavel's fix for some
problems with handling Windows reparse points and also the security
fix for setfacl over a cifs mount to Samba removing part of the ACL.
Both of these fixes are for stable as well.  Also added most of
copychunk (copy offload) support to cifs although I expect a final
patch in that series (to fix handling of larger files) in a few days
(had to hold off on that in order to incorporate some additional code
review feedback). Also added support for O_DIRECT on forcedirectio
mounts (needed in order to run some of the server benchmarks over cifs
and smb2/smb3 mounts).


The following changes since commit 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c:

  Merge tag 'ftrace-urgent-3.12-v2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
(2013-11-08 08:54:53 +0900)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 0cbaa53cdd33080c1e2d67ad9295b83c7954f2b3:

  [CIFS] Warn if SMB3 encryption required by server (2013-11-15 23:50:24 -0600)

----------------------------------------------------------------
Jeff Layton (2):
      cifs: change ERRnomem error mapping from ENOMEM to EREMOTEIO
      cifs: don't spam the logs on unexpected lookup errors

Pavel Shilovsky (1):
      CIFS: Fix symbolic links usage

Steve French (5):
      [CIFS] O_DIRECT opens should work on directio mounts
      CIFS: SMB2/SMB3 Copy offload support (refcopy) phase 1
      [CIFS] Set copychunk defaults
      setfacl removes part of ACL when setting POSIX ACLs to Samba
      [CIFS] Warn if SMB3 encryption required by server

Tim Gardner (1):
      cifs: Use data structures to compute NTLMv2 response offsets

 fs/cifs/cifsencrypt.c  |  40 +++++++++++-------
 fs/cifs/cifsglob.h     |   8 +++-
 fs/cifs/cifspdu.h      |   8 +++-
 fs/cifs/cifssmb.c      |   8 ++--
 fs/cifs/dir.c          |   2 +-
 fs/cifs/file.c         |  22 ++++++++++
 fs/cifs/inode.c        |  23 +++++-----
 fs/cifs/ioctl.c        | 111 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/netmisc.c      |   2 +-
 fs/cifs/readdir.c      |  40 ++++--------------
 fs/cifs/smb1ops.c      |  21 +++++++++-
 fs/cifs/smb2inode.c    |  16 +++++--
 fs/cifs/smb2maperror.c |   2 +-
 fs/cifs/smb2ops.c      |  82 ++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c      |  12 +++++-
 fs/cifs/smb2pdu.h      |  33 ++++++++++++++-
 fs/cifs/smb2proto.h    |   2 +-
 17 files changed, 358 insertions(+), 74 deletions(-)

-- 
Thanks,

Steve
