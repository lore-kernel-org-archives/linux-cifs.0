From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS/SMB3 Fixes
Date: Sat, 18 Oct 2014 15:25:00 -0500
Message-ID: <CAH2r5mt7NYqJa9_3N97Qk+HpGmGJXTwqW+ZY-J5Egb8u3_qqkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Improved SMB3 support (symlink and device emulation, and remapping by default
the 7 reserved posix characters) and a workaround for cifs mounts to Mac
(working around a commonly encountered Mac server bug)

Please pull the following changes since commit
0429fbc0bdc297d64188483ba029a23773ae07b0:

  Merge branch 'for-3.18-consistent-ops' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2014-10-15
07:48:18 +0200)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to ff273cb879fbc6cd3c5d03a56cfc33f5830e2837:

  [CIFS] Remove obsolete comment (2014-10-17 17:17:12 -0500)

----------------------------------------------------------------
Steve French (10):
      add defines for two new file attributes
      Allow mknod and mkfifo on SMB2/SMB3 mounts
      Add mfsymlinks support for SMB2.1/SMB3. Part 1 create symlink
      mfsymlinks support for SMB2.1/SMB3. Part 2 query symlink
      Allow conversion of characters in Mac remap range. Part 1
      Allow conversion of characters in Mac remap range (part 2)
      Remap reserved posix characters by default (part 3/3)
      Workaround Mac server problem
      Check minimum response length on query_network_interface
      [CIFS] Remove obsolete comment

 fs/cifs/cifs_fs_sb.h   |   1 +
 fs/cifs/cifs_unicode.c | 203 +++++++++++++++++++++++++++++++++++++------------
 fs/cifs/cifs_unicode.h |  31 +++++++-
 fs/cifs/cifsencrypt.c  |   2 +-
 fs/cifs/cifsglob.h     |   6 +-
 fs/cifs/cifssmb.c      |  16 ++--
 fs/cifs/connect.c      |  46 +++++++++--
 fs/cifs/dir.c          |  22 ++++--
 fs/cifs/file.c         |   6 +-
 fs/cifs/inode.c        |  57 ++++++++------
 fs/cifs/link.c         | 145 +++++++++++++++++++++++++++++++++--
 fs/cifs/readdir.c      |   8 +-
 fs/cifs/smb1ops.c      |  33 ++++----
 fs/cifs/smb2misc.c     |  12 ++-
 fs/cifs/smb2ops.c      |  27 ++++---
 fs/cifs/smb2pdu.c      |   2 +
 fs/cifs/smb2pdu.h      |   2 +
 fs/cifs/smb2proto.h    |   8 +-
 fs/cifs/smbencrypt.c   |   1 +
 fs/cifs/xattr.c        |  32 +++-----
 20 files changed, 489 insertions(+), 171 deletions(-)

-- 
Thanks,

Steve
