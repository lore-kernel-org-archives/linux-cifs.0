From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 17 Feb 2014 10:07:05 -0600
Message-ID: <CAH2r5mtdxTPGnS3iGF+qWeYjbA3TSNSKKWWvnxuH7EZL0WpaHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Three cifs fixes, the most important fixing the problem with passing
bogus pointers with writev (CVE-2014-0069).   Two additional cifs
fixes are still in review (including the fix for an append problem which
Al also discovered).

The following changes since commit 4a5c80d7b5615be8098f9d5da97d166afc318abc:

  [CIFS] clean up page array when uncached write send fails
(2014-02-07 20:47:00 -0600)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 2365c4eaf077c48574ab6f143960048fc0f31518:

  CIFS: Fix too big maxBuf size for SMB3 mounts (2014-02-14 16:50:47 -0600)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Steve French (1):
      [CIFS] Fix cifsacl mounts over smb2 to not call cifs

 fs/cifs/cifsacl.c   | 33 ++++++++++++++++++++++++---------
 fs/cifs/cifsglob.h  |  2 ++
 fs/cifs/cifsproto.h |  6 ++++--
 fs/cifs/dir.c       |  2 +-
 fs/cifs/file.c      | 39 +++++++++++++++++++++++++++++++++++----
 fs/cifs/inode.c     |  2 +-
 fs/cifs/smb1ops.c   |  1 +
 fs/cifs/smb2glob.h  |  3 +++
 fs/cifs/smb2ops.c   | 14 ++++----------
 fs/cifs/smb2pdu.c   |  4 +++-
 10 files changed, 78 insertions(+), 28 deletions(-)

-- 
Thanks,

Steve
