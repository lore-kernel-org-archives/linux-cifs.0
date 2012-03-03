From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 00/17] Preparations before SMB2 protocol support
Date: Sat,  3 Mar 2012 12:37:01 +0300
Message-ID: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to reorganize existing CIFS code to make it
easily expandable when SMB2 specific code come into the tree. This let us
avoid a code dublication and reduce the whole number of changes coming
with SMB2 code.

Pavel Shilovsky (17):
  CIFS: Simplify inFlight logic
  CIFS: Introduce credit-based flow control
  CIFS: Count blocking lock command
  CIFS: Delete echo_retries module parm
  CIFS: Make wait_for_free_request killable
  CIFS: Respect MaxMpxCount field
  CIFS: Separate protocol-specific code from transport routines
  CIFS: Separate protocol-specific code from demultiplex code
  CIFS: Separate protocol-specific code from cifs_readv_receive code
  CIFS: Expand CurrentMid field
  CIFS: Change mid_q_entry structure fields
  CIFS: Move locks to file structure
  CIFS: Fix VFS locks usage
  CIFS: Convert lock type to 32 bit variable
  CIFS: Separate protocol specific lock type handling
  CIFS: Separate protocol specific part from getlk
  CIFS: Separate protocol specific part from setlk

 fs/cifs/README       |    6 +-
 fs/cifs/cifs_debug.c |   28 ++--
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsfs.c     |   18 ---
 fs/cifs/cifsglob.h   |   98 +++++++++++----
 fs/cifs/cifsproto.h  |   18 ++-
 fs/cifs/cifssmb.c    |  107 ++++++++++-------
 fs/cifs/connect.c    |  123 +++++++++----------
 fs/cifs/dir.c        |    5 +-
 fs/cifs/file.c       |  254 ++++++++++++++++++++++++++++-----------
 fs/cifs/misc.c       |  152 +++++++++++++++++-------
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  327 +++++++++++++++++++++++++++++---------------------
 13 files changed, 702 insertions(+), 441 deletions(-)
