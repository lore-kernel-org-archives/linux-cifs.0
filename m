From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/3] cifs: add version-specific containers
Date: Wed, 16 May 2012 23:15:02 +0400
Message-ID: <1337195705-1381-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the respin of Jeff's modified patchset: struct smb_version_values was added
to handle protocol specific values (like LOCKING_ANDX_SHARED_LOCK, etc) and
struct smb_version_operations is targeted for functions only.

For now, I drop smb2 patch - it will come further.

Jeff Layton (3):
  cifs: remove the vers= and version= synonyms for ver=
  cifs: add a smb_version_operations/values structures and a
    smb_version enum
  cifs: convert send_nt_cancel into a version specific op

 fs/cifs/Makefile    |    2 +-
 fs/cifs/cifsfs.c    |    1 +
 fs/cifs/cifsglob.h  |   25 ++++++++++++++++++-
 fs/cifs/connect.c   |   47 +++++++++++++++++++++++++++++++---
 fs/cifs/smb1ops.c   |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |   46 ++++++----------------------------
 6 files changed, 144 insertions(+), 45 deletions(-)
 create mode 100644 fs/cifs/smb1ops.c
