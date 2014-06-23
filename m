From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/9] SMB2.1 multicredit requests for writing
Date: Mon, 23 Jun 2014 18:58:28 +0400
Message-ID: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to add large MTU/multicredits support for writing from the CIFS client to servers that support SMB 2.1 and higher versions of the protocol.

First three patches simplify the writepages code. Patches #4 and #5 both fix the problem in writepages when a server changes wsize value after reconnects from the client. Patches #6 and #7 simplify the iovec write code, #8 fixes the wsize changing problem there. Finally, patch #9 introduces multicredits support for writing.

Pavel Shilovsky (9):
  CIFS: Separate page processing from writepages
  CIFS: Separate page sending from writepages
  CIFS: Separate pages initialization from writepages
  CIFS: Fix wsize usage in writepages
  CIFS: Fix cifs_writev_requeue when wsize changes
  CIFS: Separate filling pages from iovec write
  CIFS: Separate writing from iovec write
  CIFS: Fix wsize usage in iovec write
  CIFS: Use multicredits for writes

 fs/cifs/cifsglob.h      |   17 ++
 fs/cifs/cifsproto.h     |    3 +
 fs/cifs/cifssmb.c       |   84 ++++++--
 fs/cifs/file.c          |  540 ++++++++++++++++++++++++++++-------------------
 fs/cifs/smb1ops.c       |    8 +
 fs/cifs/smb2ops.c       |   62 +++++-
 fs/cifs/smb2pdu.c       |   24 ++-
 fs/cifs/smb2transport.c |    5 +
 fs/cifs/transport.c     |   25 ++-
 9 files changed, 517 insertions(+), 251 deletions(-)

-- 
1.7.10.4
