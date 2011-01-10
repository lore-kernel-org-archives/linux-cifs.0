From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 9 Jan 2011 18:19:05 -0600
Message-ID: <AANLkTimrozjFGPxgL9nH3mdS8N1CVfwx44h=fafjHyqs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus (2011-01-07
17:16:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (6):
      cifs: remove unnecessary locking around sequence_number
      cifs: replace some hardcoded values with preprocessor constants
      cifs: move "ntlmssp" and "local_leases" options out of experimental code
      cifs: show "acl" in DebugData Features when it's compiled in
      cifs: switch cifs_open and cifs_create to use CIFSSMBUnixSetFileInfo
      cifs: use CreationTime like an i_generation field

Nick Piggin (1):
      cifs: don't overwrite dentry name in d_revalidate

Pavel Shilovsky (4):
      CIFS: Simplify ipv*_connect functions into one (try #4)
      CIFS: Add match_port check during looking for an existing
connection (try #4)
      CIFS: Simplify non-posix open stuff (try #2)
      CIFS: Simplify cifs_open code

Shirish Pargaonkar (1):
      cifs: Support NTLM2 session security during NTLMSSP
authentication [try #5]

Steve French (2):
      Merge branch 'master' of /.../torvalds/linux-2.6
      [CIFS] Fix minor merge conflict in fs/cifs/dir.c

 fs/cifs/cache.c       |   16 +-
 fs/cifs/cifs_debug.c  |   22 +--
 fs/cifs/cifs_spnego.c |   10 +-
 fs/cifs/cifsencrypt.c |    6 +-
 fs/cifs/cifsfs.c      |   17 +-
 fs/cifs/cifsglob.h    |    9 +-
 fs/cifs/cifssmb.c     |    5 +-
 fs/cifs/connect.c     |  462 +++++++++++++++++++++++--------------------------
 fs/cifs/dir.c         |    6 +-
 fs/cifs/file.c        |  233 ++++++++++---------------
 fs/cifs/inode.c       |    6 +
 fs/cifs/readdir.c     |    1 +
 fs/cifs/sess.c        |  135 +++++++--------
 fs/cifs/transport.c   |    2 +-
 14 files changed, 417 insertions(+), 513 deletions(-)


-- 
Thanks,

Steve
