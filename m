From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] cifs: remove unused SMB2 config and mount options
Date: Sun, 22 May 2011 07:04:51 -0400
Message-ID: <20110522110451.GA14262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There's no SMB2 support in the CIFS filesystem driver, so there's no need to
have a config and mount option for it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/Kconfig
===================================================================
--- linux-2.6.orig/fs/cifs/Kconfig	2011-05-22 12:58:07.148945770 +0200
+++ linux-2.6/fs/cifs/Kconfig	2011-05-22 12:58:20.511946113 +0200
@@ -153,26 +153,6 @@ config CIFS_ACL
 	    Allows to fetch CIFS/NTFS ACL from the server.  The DACL blob
 	    is handed over to the application/caller.
 
-config CIFS_SMB2
-	bool "SMB2 network file system support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET && BROKEN
-	select NLS
-	select KEYS
-	select FSCACHE
-	select DNS_RESOLVER
-
-	help
-	  This enables experimental support for the SMB2 (Server Message Block
-	  version 2) protocol. The SMB2 protocol is the successor to the
-	  popular CIFS and SMB network file sharing protocols. SMB2 is the
-	  native file sharing mechanism for recent versions of Windows
-	  operating systems (since Vista).  SMB2 enablement will eventually
-	  allow users better performance, security and features, than would be
-	  possible with cifs. Note that smb2 mount options also are simpler
-	  (compared to cifs) due to protocol improvements.
-
-	  Unless you are a developer or tester, say N.
-
 config CIFS_NFSD_EXPORT
 	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
 	  depends on CIFS && EXPERIMENTAL
Index: linux-2.6/fs/cifs/connect.c
===================================================================
--- linux-2.6.orig/fs/cifs/connect.c	2011-05-22 12:58:07.156946032 +0200
+++ linux-2.6/fs/cifs/connect.c	2011-05-22 12:58:20.515945837 +0200
@@ -102,7 +102,6 @@ struct smb_vol {
 	bool fsc:1;	/* enable fscache */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	bool multiuser:1;
-	bool use_smb2:1; /* force smb2 use on mount instead of cifs */
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -1062,13 +1061,6 @@ cifs_parse_mount_options(const char *mou
 				   (strnicmp(value, "1", 1) == 0)) {
 				/* this is the default */
 				continue;
-			} else if ((strnicmp(value, "smb2", 4) == 0) ||
-				   (strnicmp(value, "2", 1) == 0)) {
-#ifdef CONFIG_CIFS_SMB2
-				vol->use_smb2 = true;
-#else
-				cERROR(1, "smb2 support not enabled");
-#endif /* CONFIG_CIFS_SMB2 */
 			}
 		} else if ((strnicmp(data, "unc", 3) == 0)
 			   || (strnicmp(data, "target", 6) == 0)
