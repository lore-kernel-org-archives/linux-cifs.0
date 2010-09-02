From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] Revert "[CIFS] CIFS requires CRYPTO, not just CRYPTO_MD5 selected in Kconfig"
Date: Wed,  1 Sep 2010 21:37:30 -0400
Message-ID: <1283391455-6848-2-git-send-email-jlayton@redhat.com>
References: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283391455-6848-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit 8ef1b8351d2dce758f24c8e0321f62cc36d90818.
---
 fs/cifs/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 0ed2139..0da1deb 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,7 +2,6 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
-	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_ARC4
 	help
-- 
1.7.2.2
