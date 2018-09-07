From: Stefan Metzmacher <metze@samba.org>
Subject: [PATCH] fs/cifs: require sha512
Date: Fri,  7 Sep 2018 18:24:17 +0200
Message-ID: <20180907162417.31977-1-metze@samba.org>
Cc: Stefan Metzmacher <metze@samba.org>,
        Stable <stable@vger.kernel.org>, linux-cifs@vger.kernel.org
To: Steve French <stfrench@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This got lost in commit 0fdfef9aa7ee68ddd508aef7c98630cfc054f8d6,
which removed CONFIG_CIFS_SMB311.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Fixes: 0fdfef9aa7ee68ddd ("smb3: simplify code by removing CONFIG_CIFS_SMB311")
CC: Stable <stable@vger.kernel.org>
CC: linux-cifs@vger.kernel.org
---
 fs/cifs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 35c83fe7dba01..abcd78e332feb 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -6,6 +6,7 @@ config CIFS
 	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select CRYPTO_CMAC
 	select CRYPTO_HMAC
 	select CRYPTO_ARC4
-- 
2.17.1
