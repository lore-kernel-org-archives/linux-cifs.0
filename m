From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/11] Improve transport code for future SMB2 usage
Date: Wed, 22 Feb 2012 10:32:53 +0300
Message-ID: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of the patchset. The main change from the first one
is the patch that add the code to respect MaxMpxCount value got from
negotiate response.

The goal of this patchset is to reorganize existing transport infrustructure
to make it easily expandable when SMB2 specific code come into the tree.

This let us avoid a code dublication and reduce the whole number of changes
coming with SMB2 code.

Pavel Shilovsky (11):
  CIFS: Simplify inFlight logic
  CIFS: Introduce credit-based flow control
  CIFS: Count blocking lock command
  CIFS: Delete echo_retries module parm
  CIFS: Make wait_for_free_request interruptible
  CIFS: Respect MaxMpxCount field
  CIFS: Separate protocol-specific code from transport routines
  CIFS: Separate protocol-specific code from demultiplex code
  CIFS: Separate protocol-specific code from cifs_readv_receive code
  CIFS: Expand CurrentMid field
  CIFS: Change mid_q_entry structure fields

 fs/cifs/README       |    6 +-
 fs/cifs/cifs_debug.c |   28 ++--
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsfs.c     |   17 ---
 fs/cifs/cifsglob.h   |   98 ++++++++++++----
 fs/cifs/cifsproto.h  |   18 ++-
 fs/cifs/cifssmb.c    |  107 ++++++++++-------
 fs/cifs/connect.c    |  122 +++++++++-----------
 fs/cifs/dir.c        |    5 +-
 fs/cifs/file.c       |    4 +-
 fs/cifs/misc.c       |  147 ++++++++++++++++-------
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  324 ++++++++++++++++++++++++++++----------------------
 13 files changed, 515 insertions(+), 368 deletions(-)
