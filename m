From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 12 Jul 2013 10:04:38 -0500
Message-ID: <CAH2r5mva3f6_WbYPH7LQ0r_p9GTzBd-p4RKPGHtPJTMh0Z__eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes for 4 cifs bugs, including a reconnect problem, a problem
parsing responses to SMB2 open request, and setting nlink incorrectly
to some servers which don't report it properly on the wire.  Also
improves data integrity on reconnect with series from Pavel which adds
durable handle support for SMB2.

The following changes since commit 80cc38b16389849a6e06441ace4530f6b2497c3c:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
(2013-07-04 11:40:58 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 689c3db4d57a73bee6c5ad7797fce7b54d32a87c:

  CIFS: Fix a deadlock when a file is reopened (2013-07-11 18:05:41 -0500)

----------------------------------------------------------------
Pavel Shilovsky (10):
      CIFS: Fix lease context buffer parsing
      CIFS: Respect create_options in smb2_open_file
      CIFS: Simplify SMB2_open code path
      CIFS: Simplify SMB2 create context handling
      CIFS: Request durable open for SMB2 opens
      CIFS: Introduce cifs_open_parms struct
      CIFS: Make SMB2_open use cifs_open_parms struct
      CIFS: Reconnect durable handles for SMB2
      CIFS: Reopen the file if reconnect durable handle failed
      CIFS: Fix a deadlock when a file is reopened

Steve French (3):
      Limit allocation of crypto mechanisms to dialect which requires
      [CIFS] use sensible file nlink values if unprovided
      [CIFS] Fix minor endian error in durable handle patch series

 fs/cifs/cifsencrypt.c   | 195 +++++++++++++++++++-----------------------
 fs/cifs/cifsglob.h      |  17 +++-
 fs/cifs/cifsproto.h     |   1 -
 fs/cifs/connect.c       |   6 --
 fs/cifs/dir.c           |  14 ++-
 fs/cifs/file.c          |  54 ++++++++----
 fs/cifs/inode.c         |   5 ++
 fs/cifs/smb1ops.c       |  29 ++++---
 fs/cifs/smb2file.c      |  24 +++---
 fs/cifs/smb2inode.c     |  57 +++++++------
 fs/cifs/smb2ops.c       |  54 ++++++++----
 fs/cifs/smb2pdu.c       | 220 ++++++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h       |  14 ++-
 fs/cifs/smb2proto.h     |  16 ++--
 fs/cifs/smb2transport.c |  90 +++++++++++++++++++-
 15 files changed, 515 insertions(+), 281 deletions(-)

-- 
Thanks,

Steve
