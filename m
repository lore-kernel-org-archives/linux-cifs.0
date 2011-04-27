From: Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>
Subject: [PATCH] cifs: Don't offer NFS export in Kconfig if nfsd is not enabled
Date: Wed, 27 Apr 2011 15:22:27 +0100
Message-ID: <1303914147-23012-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There's no point in supporting NFS export of filesystems if we don't have
nfsd in the first place.

Signed-off-by: Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>
---
 fs/cifs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 75c47cd..61e5f95 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -175,6 +175,6 @@ config CIFS_SMB2
 
 config CIFS_NFSD_EXPORT
 	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL
+	  depends on CIFS && NFSD && EXPERIMENTAL
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
-- 
1.7.4.1
