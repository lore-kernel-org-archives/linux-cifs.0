From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 0/7] Optimize reading in a short read case on reconnects
Date: Mon, 14 Jul 2014 13:01:10 +0400
Message-ID: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of the patchset that is going to make CIFS module behave according to POSIX -- return a short read if a reconnect happens during the reading.

These patches are rebased on top of the series "SMB 2.1/3 multicredit requests for reading/writing" of 16 patches.

Changes since v1:
1) fixed missed update of statistics;
2) disable short reads during reconnet on signed connections.

Pavel Shilovsky (7):
  CIFS: Indicate reconnect with ECONNABORTED error code
  CIFS: Use separate var for the number of bytes got in async read
  CIFS: Count got bytes in read_into_pages()
  CIFS: Fix possible buffer corruption in cifs_user_read()
  CIFS: Improve indentation in cifs_user_read()
  CIFS: Optimize cifs_user_read() in a short read case on reconnects
  CIFS: Optimize readpages in a short read case on reconnects

 fs/cifs/cifsglob.h |  1 +
 fs/cifs/cifssmb.c  | 11 +++++---
 fs/cifs/connect.c  |  8 +++---
 fs/cifs/file.c     | 79 ++++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2pdu.c  | 10 +++++--
 5 files changed, 74 insertions(+), 35 deletions(-)

-- 
1.8.1.2
