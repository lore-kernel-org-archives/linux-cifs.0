From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] Introducing new strict cache mode (try #4)
Date: Fri,  5 Nov 2010 11:29:31 +0300
Message-ID: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I add new ones (fsync, mmap) and modified previous patches (read, write, close) and their descriptions. Here is the complete set of them.

Pavel Shilovsky (6):
  CIFS: Make cifsFileInfo_put work with strict cache mode
  CIFS: Make read call work with strict cache mode
  CIFS: Make write call work with strict cache mode
  CIFS: Make cifs_fsync work with strict cache mode
  CIFS: Make cifs_file_map work with strict cache mode
  CIFS: Add strictcache mount option

 fs/cifs/README       |    5 +++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |   79 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/connect.c    |    5 +++
 fs/cifs/file.c       |   54 +++++++++++++++++++++++++---------
 5 files changed, 123 insertions(+), 21 deletions(-)

-- 
1.7.2.3
