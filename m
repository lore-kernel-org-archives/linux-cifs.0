From: Benjamin Gilbert <benjamin.gilbert-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Select all required crypto modules
Date: Thu, 19 Oct 2017 13:09:29 -0700
Message-ID: <20171019200929.4055-1-benjamin.gilbert@coreos.com>
Cc: Benjamin Gilbert <benjamin.gilbert-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some dependencies were lost when CIFS_SMB2 was merged into CIFS.

Fixes: 2a38e12053b7 ("[SMB3] Remove ifdef since SMB3 (and later) now STRONGLY preferred")
Signed-off-by: Benjamin Gilbert <benjamin.gilbert-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index f7243617316c..d5b2e12b5d02 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -5,9 +5,14 @@ config CIFS
 	select CRYPTO
 	select CRYPTO_MD4
 	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	select CRYPTO_CMAC
 	select CRYPTO_HMAC
 	select CRYPTO_ARC4
+	select CRYPTO_AEAD2
+	select CRYPTO_CCM
 	select CRYPTO_ECB
+	select CRYPTO_AES
 	select CRYPTO_DES
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
-- 
2.13.6
