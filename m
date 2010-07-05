From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 01/09] cifs: add kernel config option for CIFS Client caching support
Date: Mon,  5 Jul 2010 18:11:33 +0530
Message-ID: <1278333693-30511-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-cachefs@redhat.com, David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Yes>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Add a kernel config option to enable local caching for CIFS.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: cifs-2.6/fs/cifs/Kconfig
===================================================================
--- cifs-2.6.orig/fs/cifs/Kconfig
+++ cifs-2.6/fs/cifs/Kconfig
@@ -131,6 +131,15 @@ config CIFS_DFS_UPCALL
 	    IP addresses) which is needed for implicit mounts of DFS junction
 	    points. If unsure, say N.
 
+config CIFS_FSCACHE
+	  bool "Provide CIFS client caching support (EXPERIMENTAL)"
+	  depends on EXPERIMENTAL
+	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
+	  help
+	    Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
+	    to be cached locally on disk through the general filesystem cache
+	    manager. If unsure, say N.
+
 config CIFS_EXPERIMENTAL
 	  bool "CIFS Experimental Features (EXPERIMENTAL)"
 	  depends on CIFS && EXPERIMENTAL
