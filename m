From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 00/10] Prepare transport code for future SMB2 usage
Date: Tue, 20 Mar 2012 13:00:30 +0300
Message-ID: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to reorganize existing CIFS code to make it
easily expandable when SMB2 specific code come into the tree. This let us
avoid a code dublication and reduce the whole number of changes coming
with SMB2 code.

This should be applied on top of "Respect negotiated MaxMpxCount" patch that
goes alone.

Pavel Shilovsky (10):
  CIFS: Simplify inFlight logic
  CIFS: Introduce credit-based flow control
  CIFS: Make wait_for_free_request killable
  CIFS: Prepare credits code for a slot reservation
  CIFS: Delete echo_retries module parm
  CIFS: Separate protocol-specific code from transport routines
  CIFS: Separate protocol-specific code from demultiplex code
  CIFS: Separate protocol-specific code from cifs_readv_receive code
  CIFS: Expand CurrentMid field
  CIFS: Change mid_q_entry structure fields

 fs/cifs/README       |    6 +-
 fs/cifs/cifs_debug.c |   28 +++---
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsfs.c     |    5 -
 fs/cifs/cifsglob.h   |   69 ++++++++++--
 fs/cifs/cifsproto.h  |   14 ++-
 fs/cifs/cifssmb.c    |  104 ++++++++++--------
 fs/cifs/connect.c    |  126 +++++++++++----------
 fs/cifs/misc.c       |  117 ++++++++++++-------
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  305 ++++++++++++++++++++++++++++----------------------
 11 files changed, 451 insertions(+), 330 deletions(-)
