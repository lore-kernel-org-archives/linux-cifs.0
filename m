From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/6] Improve transport code for future SMB2 usage
Date: Thu,  9 Feb 2012 11:41:30 +0300
Message-ID: <1328776890-4190-7-git-send-email-piastry@etersoft.ru>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328776890-4190-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to reorganize existing transport infrustructure
to make it easily expandable when SMB2 specific code come into the tree.

This let us avoid a code dublication and reduce the whole number of changes
coming with SMB2 code.

Pavel Shilovsky (6):
  CIFS: Introduce credit-based flow control
  CIFS: Separate protocol-specific code from transport routines
  CIFS: Separate protocol-specific code from demultiplex code
  CIFS: Separate protocol-specific code from cifs_readv_receive code
  CIFS: Expand CurrentMid field
  CIFS: Change mid_q_entry structure fields

 fs/cifs/cifs_debug.c |   25 +++---
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsglob.h   |   33 +++++--
 fs/cifs/cifsproto.h  |   11 +-
 fs/cifs/cifssmb.c    |   94 +++++++++++--------
 fs/cifs/connect.c    |   98 +++++++++-----------
 fs/cifs/misc.c       |   98 +++++++++++---------
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  252 +++++++++++++++++++++++++++++---------------------
 9 files changed, 349 insertions(+), 269 deletions(-)
