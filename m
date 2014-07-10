From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/7] Optimize reading in a short read case on reconnects
Date: Thu, 10 Jul 2014 13:30:40 +0400
Message-ID: <1404984647-8710-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is going to make CIFS module behave according to POSIX -- return a short read if a reconnect happens during the reading.

These patches are rebased on top of the series "SMB 2.1/3 multicredit requests for reading/writing" of 16 patches.

Pavel Shilovsky (7):
  CIFS: Indicate reconnect with ECONNABORTED error code
  CIFS: Use separate var for the number of bytes got in async read
  CIFS: Count got bytes in read_into_pages()
  CIFS: Fix possible buffer corruption in direct read
  CIFS: Improve indentation in cifs_user_read()
  CIFS: Optimize cifs_user_read() in a short read case on reconnects
  CIFS: Optimize readpages in a short read case on reconnects

 fs/cifs/cifsglob.h |  1 +
 fs/cifs/cifssmb.c  |  5 ++--
 fs/cifs/connect.c  |  8 +++---
 fs/cifs/file.c     | 79 ++++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2pdu.c  |  4 +--
 5 files changed, 62 insertions(+), 35 deletions(-)

-- 
1.8.1.2
