From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: make CIFS depend on CRYPTO_MD4
Date: Mon, 31 Jan 2011 08:41:36 -0500
Message-ID: <1296481296-13270-1-git-send-email-jlayton@redhat.com>
References: <4D469C99.9050905@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D469C99.9050905-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Recently CIFS was changed to use the kernel crypto API for MD4 hashes,
but the Kconfig dependencies were not changed to reflect this.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 27917a5..023d11b 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -3,6 +3,7 @@ config CIFS
 	depends on INET
 	select NLS
 	select CRYPTO
+	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ARC4
-- 
1.7.3.4
