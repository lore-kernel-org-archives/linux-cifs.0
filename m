From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
Date: Fri, 22 Jan 2016 10:20:49 +0100
Message-ID: <20160122102049.50a817a4@endymion.delvare>
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

* CIFS_SMB2 depends on CIFS, which depends on INET and selects NLS. So
  these dependencies do not need to be repeated for CIFS_SMB2.
* CIFS_SMB311 depends on CIFS_SMB2, which depends on INET. So this
  dependency doesn't need to be repeated for CIFS_SMB311.

Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
