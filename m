From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
Date: Wed, 25 Jan 2017 16:07:29 +0100
Message-ID: <20170125160729.1c80eade@endymion>
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

* CIFS_SMB2 depends on CIFS, which depends on INET and selects NLS. So
  these dependencies do not need to be repeated for CIFS_SMB2.
* CIFS_SMB311 depends on CIFS_SMB2, which depends on INET. So this
  dependency doesn't need to be repeated for CIFS_SMB311.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-4.5-rc0.orig/fs/cifs/Kconfig	2016-01-11 00:01:32.000000000 +0100
+++ linux-4.5-rc0/fs/cifs/Kconfig	2016-01-22 09:48:02.217561471 +0100
@@ -169,8 +169,7 @@ config CIFS_NFSD_EXPORT
 
 config CIFS_SMB2
 	bool "SMB2 and SMB3 network file system support"
-	depends on CIFS && INET
-	select NLS
+	depends on CIFS
 	select KEYS
 	select FSCACHE
 	select DNS_RESOLVER
@@ -194,7 +193,7 @@ config CIFS_SMB2
 
 config CIFS_SMB311
 	bool "SMB3.1.1 network file system support (Experimental)"
-	depends on CIFS_SMB2 && INET
+	depends on CIFS_SMB2
 
 	help
 	  This enables experimental support for the newest, SMB3.1.1, dialect.


-- 
Jean Delvare
SUSE L3 Support
