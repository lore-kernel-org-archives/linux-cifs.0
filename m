From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/8] Implement SMB3 leases support
Date: Fri,  6 Sep 2013 00:14:55 +0400
Message-ID: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to add SMB3 leases support.

The first two patches fixes existing problems in lease break processing code and targeted to stable as well.

Then the code is prepared to make adding SMB3 leases easier (patches #3-#6).

Finaly in last two patches create lease v2 context is added and epoch value from the response is respected.

Pavel Shilovsky (8):
  CIFS: Fix memory leak when a lease break comes
  CIFS: Fix missing lease break from a client
  CIFS: Replace clientCanCache* bools with an integer
  CIFS: Store lease state itself rather than a mapped oplock value
  CIFS: Move creating lease buffer to ops struct
  CIFS: Move parsing lease buffer to ops struct
  CIFS: Add create lease v2 context for SMB3
  CIFS: Respect epoch value from create lease context v2

 fs/cifs/cifsfs.c    |   34 ++++---
 fs/cifs/cifsglob.h  |   42 +++++---
 fs/cifs/connect.c   |    2 +-
 fs/cifs/file.c      |   35 ++++---
 fs/cifs/inode.c     |    8 +-
 fs/cifs/misc.c      |   12 +--
 fs/cifs/smb1ops.c   |   12 ++-
 fs/cifs/smb2file.c  |   23 -----
 fs/cifs/smb2misc.c  |  182 +++++++++++++++++----------------
 fs/cifs/smb2ops.c   |  283 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.c   |   80 ++++-----------
 fs/cifs/smb2pdu.h   |   23 +++++
 fs/cifs/smb2proto.h |    2 -
 13 files changed, 497 insertions(+), 241 deletions(-)

-- 
1.7.10.4
