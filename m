From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/8] SMB2 durable handles support
Date: Wed, 10 Jul 2013 13:59:52 +0400
Message-ID: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset implements SMB2 procotol feature -- durable handles. It allows to restore all file handle information after reconnect events. In particular, there is no need to reobtain byte-range locks.

While adding the feature, the patchset simplifies open codepath by introducing new cifs_open_parms structure.

Pavel Shilovsky (8):
  CIFS: Fix lease context buffer parsing
  CIFS: Respect create_options in smb2_open_file
  CIFS: Simplify SMB2_open code path
  CIFS: Simplify SMB2 create context handling
  CIFS: Request durable open for SMB2 opens
  CIFS: Introduce cifs_open_parms struct
  CIFS: Make SMB2_open use cifs_open_parms struct
  CIFS: Reconnect durable handles for SMB2

 fs/cifs/cifsglob.h  |   17 +++-
 fs/cifs/dir.c       |   14 +++-
 fs/cifs/file.c      |   39 ++++++---
 fs/cifs/smb1ops.c   |   29 ++++---
 fs/cifs/smb2file.c  |   24 +++---
 fs/cifs/smb2inode.c |   57 ++++++++------
 fs/cifs/smb2ops.c   |   54 ++++++++-----
 fs/cifs/smb2pdu.c   |  219 +++++++++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h   |   14 +++-
 fs/cifs/smb2proto.h |   16 ++--
 10 files changed, 325 insertions(+), 158 deletions(-)

-- 
1.7.10.4
