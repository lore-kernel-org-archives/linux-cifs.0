From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/3] cifs: Only select the required crypto modules
Date: Fri, 22 Jan 2016 10:22:40 +0100
Message-ID: <20160122102240.5640dd5d@endymion.delvare>
References: <20160122101654.20fa96e3@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122101654.20fa96e3-R0o5gVi9kd7kN2dkZ6Wm7A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The sha256 and cmac crypto modules are only needed for SMB2+, so move
the select statements to config CIFS_SMB2. Also select CRYPTO_AES
there as SMB2+ needs it.

Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
