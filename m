From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 2/3] cifs: Only select the required crypto modules
Date: Wed, 25 Jan 2017 16:08:17 +0100
Message-ID: <20170125160817.1d6fb22d@endymion>
References: <20170125160639.255cd58e@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170125160639.255cd58e@endymion>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The sha256 and cmac crypto modules are only needed for SMB2+, so move
the select statements to config CIFS_SMB2. Also select CRYPTO_AES
there as SMB2+ needs it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-4.5-rc0.orig/fs/cifs/Kconfig	2016-01-22 09:52:13.700961277 +0100
+++ linux-4.5-rc0/fs/cifs/Kconfig	2016-01-22 09:56:23.420279765 +0100
@@ -9,8 +9,6 @@ config CIFS
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
 	select CRYPTO_DES
-	select CRYPTO_SHA256
-	select CRYPTO_CMAC
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
@@ -173,6 +171,9 @@ config CIFS_SMB2
 	select KEYS
 	select FSCACHE
 	select DNS_RESOLVER
+	select CRYPTO_AES
+	select CRYPTO_SHA256
+	select CRYPTO_CMAC
 
 	help
 	  This enables support for the Server Message Block version 2

-- 
Jean Delvare
SUSE L3 Support
