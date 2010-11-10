From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] Introducing new strict cache mode (try #5)
Date: Wed, 10 Nov 2010 18:41:45 +0300
Message-ID: <1289403711-12965-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here are new set of patches. I made changes according to Jeff's notices and fix bugs in fsync and mmap.

Pavel Shilovsky (6):
  CIFS: Make cifsFileInfo_put work with strict cache mode
  CIFS: Make read call work with strict cache mode
  CIFS: Make write call work with strict cache mode
  CIFS: Make cifs_fsync work with strict cache mode
  CIFS: Make cifs_file_map work with strict cache mode
  CIFS: Add strictcache mount option

 fs/cifs/README       |    5 +++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |   71 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/connect.c    |    5 +++
 fs/cifs/file.c       |   62 +++++++++++++++++++++++++++++++++----------
 5 files changed, 124 insertions(+), 20 deletions(-)

-- 
1.7.2.3
