From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v4 0/5] Separate protocol-specific part from locking code
Date: Wed, 16 May 2012 13:57:29 +0400
Message-ID: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The first two patches are remains the same from the previous version. Others
have been changed according to the new approach where we have protocol ops
structure for every server.

The patches are applied on top of slightly modified Jeff's patches
(values were separated from smb_version_operations to smb_version_values structure).

The branch with the patches:
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-patches-new

All comments are welcome - we need to clarify these ones before I move to SMB2 patches.

Pavel Shilovsky (5):
  CIFS: Move locks to cifsFileInfo structure
  CIFS: Convert lock type to 32 bit variable
  CIFS: Separate protocol specific lock type handling
  CIFS: Separate protocol specific part from getlk
  CIFS: Separate protocol specific part from setlk

 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |   20 +++++-
 fs/cifs/file.c     |  174 ++++++++++++++++++++++++++++++----------------------
 fs/cifs/smb1ops.c  |   12 ++++
 4 files changed, 128 insertions(+), 79 deletions(-)
