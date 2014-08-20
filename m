From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS Fixes
Date: Wed, 20 Aug 2014 11:54:12 -0500
Message-ID: <CAH2r5muUWNe8LKDJMsfTkMxaJHkf-uw6rnjoC6DeEqpS2gbqHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most important fixes in this set include three SMB3 fixes for stable
(including fix for possible kernel oops), and a workaround to allow
writes to Mac servers (only cifs dialect, not more current SMB2.1,
worked to Mac servers).   Also fallocate support added, and lease fix
from Jeff.

please pull the following changes since commit
c8d6637d0497d62093dbba0694c7b3a80b79bfe1:

  Merge tag 'modules-next-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-08-10
21:31:58 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 30175628bf7f521e9ee31ac98fa6d6fe7441a556=
:

  [SMB3] Enable fallocate -z support for SMB3 mounts (2014-08-17 18:16:=
40 -0500)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: handle lease F_UNLCK requests properly

Pavel Shilovsky (2):
      CIFS: Fix SMB2 readdir error handling
      CIFS: Fix wrong directory attributes after rename

Steve French (8):
      Add missing definitions for CIFS File System Attributes
      Add sparse file support to SMB2/SMB3 mounts
      Cleanup sparse file support by creating worker function for it
      [CIFS] Workaround MacOS server problem with SMB2.1 write      res=
ponse
      [CIFS] Possible null ptr deref in SMB2_tcon
      Incorrect error returned on setting file compressed on SMB2
      enable fallocate punch hole ("fallocate -p") for SMB3
      [SMB3] Enable fallocate -z support for SMB3 mounts

Vincent Stehl=C3=A9 (1):
      cifs: remove unused function cifs_oplock_break_wait

 fs/cifs/cifsfs.c       |  24 ++++++-
 fs/cifs/cifsglob.h     |   5 ++
 fs/cifs/cifspdu.h      |  23 +++++++
 fs/cifs/file.c         |   2 +-
 fs/cifs/inode.c        |   6 ++
 fs/cifs/misc.c         |   7 --
 fs/cifs/readdir.c      |   2 +-
 fs/cifs/smb1ops.c      |   7 ++
 fs/cifs/smb2maperror.c |   4 +-
 fs/cifs/smb2misc.c     |  17 ++++-
 fs/cifs/smb2ops.c      | 170 +++++++++++++++++++++++++++++++++++++++++=
++++++++
 fs/cifs/smb2pdu.c      |  16 +++--
 fs/cifs/smb2pdu.h      |   6 ++
 fs/cifs/smbfsctl.h     |   2 +-
 14 files changed, 269 insertions(+), 22 deletions(-)

--=20
Thanks,

Steve
