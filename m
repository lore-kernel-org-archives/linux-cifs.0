From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/3] Bugfixes for v3.17-rc
Date: Fri, 22 Aug 2014 13:32:08 +0400
Message-ID: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here is the set of bugfixes that was found during XFS testing (as a part of cifs-tests).
The patches are targeted for v3.17-rc and for stable as well.

Pavel Shilovsky (3):
  CIFS: Fix directory rename error
  CIFS: Fix wrong restart readdir for SMB1
  CIFS: Fix wrong filename length for SMB2

 fs/cifs/cifsglob.h  | 5 -----
 fs/cifs/inode.c     | 5 ++++-
 fs/cifs/readdir.c   | 2 +-
 fs/cifs/smb2file.c  | 2 +-
 fs/cifs/smb2inode.c | 2 +-
 fs/cifs/smb2ops.c   | 2 +-
 fs/cifs/smb2pdu.c   | 2 +-
 7 files changed, 9 insertions(+), 11 deletions(-)

-- 
1.9.1
