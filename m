From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 00/16] SMB 2.1/3 multicredit requests for reading/writing
Date: Mon, 21 Jul 2014 19:45:42 +0400
Message-ID: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of this patchset is to add large MTU/multicredits support for reading and writing from the CIFS client to servers that support SMB 2.1 and higher versions of the protocol.

The first patch fixes a reconnect bug in reading code. Other patches simplify the read/write code (2-4,7,8,11,13), fix rsize/wsize usage bug on reconnects (5,6,9,12,14,15) and introduce multicredits support (10,16).

Changes since v2:
1) patch #3 is refactored;
2) fix missed set_mapping_error() in patch #6;
3) fix missed updating of nr_pages value in patch #7;
4) remove unused offset var in patch #8;
5) add reviewed-by/acked-by tags.

Changes since v1:
1) read part is added;
2) several reconnects bug (related to the patchset and not) is fixed;
3) overall patch simplification/refactoring is done.


Pavel Shilovsky (16):
  CIFS: Fix async reading on reconnects
  CIFS: Separate page processing from writepages
  CIFS: Separate page sending from writepages
  CIFS: Separate pages initialization from writepages
  CIFS: Fix wsize usage in writepages
  CIFS: Fix cifs_writev_requeue when wsize changes
  CIFS: Separate filling pages from iovec write
  CIFS: Separate writing from iovec write
  CIFS: Fix wsize usage in iovec write
  CIFS: Use multicredits for SMB 2.1/3 writes
  CIFS: Separate page search from readpages
  CIFS: Fix rsize usage in readpages
  CIFS: Separate page reading from user read
  CIFS: Fix rsize usage in user read
  CIFS: Fix rsize usage for sync read
  CIFS: Use multicredits for SMB 2.1/3 reads

 fs/cifs/cifsglob.h      |  18 ++
 fs/cifs/cifsproto.h     |   3 +
 fs/cifs/cifssmb.c       |  88 ++++--
 fs/cifs/file.c          | 817 +++++++++++++++++++++++++++++-------------------
 fs/cifs/smb1ops.c       |   8 +
 fs/cifs/smb2ops.c       |  64 +++-
 fs/cifs/smb2pdu.c       |  63 +++-
 fs/cifs/smb2transport.c |   5 +
 fs/cifs/transport.c     |  25 +-
 9 files changed, 724 insertions(+), 367 deletions(-)

-- 
1.8.1.2
