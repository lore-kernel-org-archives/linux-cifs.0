From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS FIxes
Date: Sat, 8 Apr 2017 18:08:55 -0500
Message-ID: <CAH2r5mtb32gv5JwxySkrMboWuGeQ_6fZAGxTOhuee1_HMG6gqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pulltThe following changes since commit
269c930e6698e6afa6d4606bfd241f4497597e79:

This is a set of CIFS/SMB3 fixes for stable.  There is another set of
4 SMB3 reconnect fixes for stable in progress but they are still being
reviewed/tested, so didn't want to wait any longer to send these 5
below.

  Merge tag 'xfs-4.11-fixes-3' of
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2017-04-06 14:42:05
-0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 806a28efe9b78ffae5e2757e1ee924b8e50c08ab:

  Reset TreeId to zero on SMB2 TREE_CONNECT (2017-04-07 08:04:41 -0500)

----------------------------------------------------------------
Jan-Marek Glogowski (1):
      Reset TreeId to zero on SMB2 TREE_CONNECT

Sachin Prabhu (3):
      Handle mismatched open calls
      SMB3: Rename clone_range to copychunk_range
      Introduce cifs_copy_file_range()

Tobias Regnery (1):
      CIFS: Fix build failure with smb2

 fs/cifs/cifsfs.c        | 87
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.h        |  5 +++++
 fs/cifs/cifsglob.h      | 18 ++++++++++++---
 fs/cifs/cifsproto.h     |  3 ++-
 fs/cifs/cifssmb.c       | 11 ++++++----
 fs/cifs/connect.c       | 13 +++++++++--
 fs/cifs/ioctl.c         | 66
+++++--------------------------------------------------
 fs/cifs/smb2misc.c      | 46 +++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c       | 41 +++++++++++++++++++++-------------
 fs/cifs/smb2pdu.c       |  4 ++++
 fs/cifs/smb2proto.h     |  7 ++++++
 fs/cifs/smb2transport.c | 55 ++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/transport.c     |  2 ++
 13 files changed, 268 insertions(+), 90 deletions(-)


-- 
Thanks,

Steve
