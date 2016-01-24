From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes
Date: Sat, 23 Jan 2016 21:06:05 -0600
Message-ID: <CAH2r5mtw2ONDj=gXQ521zXiAFM-hd=Ve9AH3OYDvt=z=dBhe-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following collection of CIFS/SMB3 fixes.  Includes a
couple bug fixes,  a few for improved debugging of cifs.ko and some
improvements to the way cifs does key generation.  I do have some
additional bug fixes I expect in the next week or two (to address a
problem found by xfstest, and some fixes for SMB3.11 dialect, and a
couple patches that just came in yesterday that I am reviewing).

The following changes since commit 7fdec82af6a9e190e53d07a1463d2a9ac49a8750:

  Merge tag 'xfs-for-linus-4.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
(2016-01-13 21:15:18 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 01b9b0b28626db4a47d7f48744d70abca9914ef1:

  cifs_dbg() outputs an uninitialized buffer in cifs_readdir()
(2016-01-14 14:45:49 -0600)

----------------------------------------------------------------
Arnd Hannemann (1):
      Print IP address of unresponsive server

Jamie Bainbridge (1):
      cifs: Ratelimit kernel log messages

Rabin Vincent (1):
      cifs: fix race between call_async() and reconnect()

Ross Lagerwall (2):
      cifs: Check uniqueid for SMB2+ and return -ESTALE if necessary
      cifs: Allow using O_DIRECT with cache=loose

Steve French (2):
      cifs: Make echo interval tunable
      Prepare for encryption support (first part). Add decryption and
encryption key generation. Thanks to Metze for helping with this.

Vasily Averin (1):
      cifs_dbg() outputs an uninitialized buffer in cifs_readdir()

 fs/cifs/cifs_debug.c    |   2 +-
 fs/cifs/cifs_debug.h    |   9 ++---
 fs/cifs/cifsfs.c        |  17 ++++++++
 fs/cifs/cifsglob.h      |  16 ++++++--
 fs/cifs/cifsproto.h     |   5 ++-
 fs/cifs/connect.c       |  36 +++++++++++++----
 fs/cifs/inode.c         |  24 +++++++++++-
 fs/cifs/misc.c          |   2 +-
 fs/cifs/readdir.c       |   1 +
 fs/cifs/smb2misc.c      |  36 ++++++++++++++---
 fs/cifs/smb2ops.c       |  13 ++++--
 fs/cifs/smb2pdu.c       |  10 ++---
 fs/cifs/smb2pdu.h       |   8 ++--
 fs/cifs/smb2proto.h     |   3 +-
 fs/cifs/smb2transport.c | 102 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/transport.c     |   6 ++-
 16 files changed, 238 insertions(+), 52 deletions(-)

-- 
Thanks,

Steve
