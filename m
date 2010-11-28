From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] Add strict cache mode (try #4)
Date: Sun, 28 Nov 2010 11:12:46 +0300
Message-ID: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Re-posting the whole set of strict cache patches.

Pavel Shilovsky (6):
  CIFS: Make cifsFileInfo_put work with strict cache mode (try #4)
  CIFS: Make read call work with strict cache mode (try #2)
  CIFS: Make write call work with strict cache mode (try #2)
  CIFS: Make cifs_fsync work with strict cache mode (try #2)
  CIFS: Make cifs_file_map work with strict cache mode (try #2)
  CIFS: Add strictcache mount option (try #2)

 fs/cifs/README       |    5 +++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |   71 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/connect.c    |    5 +++
 fs/cifs/file.c       |   42 +++++++++++++++++++++--------
 5 files changed, 106 insertions(+), 18 deletions(-)

-- 
1.7.3.2
