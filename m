From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Sun, 22 May 2011 07:55:24 -0400
Message-ID: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This will never work properly with CIFS, as the protocol has no ability
whatsoever for looking up files by filehandle. It *might* be possible to
eventually do this with SMB2, but that remains to be seen.

For now, it just plain doesn't work. Mark it BROKEN to discourage
distros from enabling it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 75c47cd..f0f960d 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -175,6 +175,6 @@ config CIFS_SMB2
 
 config CIFS_NFSD_EXPORT
 	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL
+	  depends on CIFS && EXPERIMENTAL && BROKEN
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
-- 
1.7.4.4
