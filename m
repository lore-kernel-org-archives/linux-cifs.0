Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4FBC43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 22:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6034820684
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 22:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfCFWXG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:23:06 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:53917 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfCFWXG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Mar 2019 17:23:06 -0500
Received: from orion.localdomain ([95.118.27.116]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MBjA4-1hDmxs3AXU-00CAdP; Wed, 06 Mar 2019 23:23:00 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH v2] fs: cifs: Kconfig: pedantic formatting
Date:   Wed,  6 Mar 2019 23:22:59 +0100
Message-Id: <1551910979-1026-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551896652-26579-1-git-send-email-info@metux.net>
References: <1551896652-26579-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:Ez81XChpMwND3AzaUOrABKKXQSnfKrwPmGY42WkP+K8+qcdgrTT
 WabrX+p9J62OcUAg43M2ZWUUzOZKCU+IPfh2jY+BZYWbYxn8RMDMdkrZWIkA1Aa+WzbAn0L
 v0wa0gAYq34DekhMMQcXtwz/VIC4MTczWRVfFpIWLMonPBVcNKFkXX4zdVXt0Lmr3dZ/3qT
 1jzEquJYNmo2dp4IH021Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:o3ziDoIMevo=:cWOTuTaSdRjeJN7Yy/+qpP
 C0zKsweNlJMyQQB/kZMIFz8Aq1WXFblTQecN3iJTsXYNa/bywPX1ffJwz/eFQ4M+ZQ0yFxlvB
 37sAnkUDz5qFd99hGi48m+9Fglj8K5/vnoyEec9w5/56uf5KbnAr5ox4PhJW0BZUBV5AjkwFA
 Xz2KzriZug47Vh6B2Tl72IKk6F8A3OB6iD0DDvGLvoHiCRpliX/oAUk2Ti36Osr+xSodbUVMm
 hES+UERf39eB/rwosasiuVYCXhAE2qBlw1wbOXCeZWYqpT3B2jsFjvNF5t4dJCb/Oz3/T8vvL
 51d3OGtpdj0Ym9SZY4oq0e/2qphBHHOlW6w/zduaQ+LA3ki/9Y/NPDQ10S6UZTgv+LUHuF3I0
 Dxole+Tu9KTTvdb/n3LidV8zL/sat+DZOfFXgnOJl9UYuhQMhdPgEh/bEHMMsTe+R+LGRc91F
 CT7shfMRkymnwi9IkS21XEx+hxSHAigKjdkAh5LnCGaW66r0x1+AzODhoEexKm6kN4ng/l2tZ
 J0+0W/GAQs9ajTJ2zL996IiP4XA9J+rMbqCaTemX5M94DjYLbtn5esmBnvCgbIGPvjNiavCHG
 V3KL17VZpuTy33L7lYTJDfrKvAAdPc8LP264o33XQrOBrxPc1Mgpg1ks8CNnAVHLcnQhGXrb/
 uPxQCjAUmysk7evsoNWhM9AImXMKvSEkD7djkrjswHvU8sKZA17VvAvVhz2dhR8C5LIu60Fx2
 lsCWnX0XLZXPF6XUZ4V5xdWdJfO/5j3vX6rMEA==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Formatting of Kconfig files doesn't look so pretty, so just
take damp cloth and clean it up.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 fs/cifs/Kconfig | 120 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index f1ddc9d..76724ef 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -117,25 +117,25 @@ config CIFS_UPCALL
 	  secure Kerberos authentication is required). If unsure, say Y.
 
 config CIFS_XATTR
-        bool "CIFS extended attributes"
-        depends on CIFS
-        help
-          Extended attributes are name:value pairs associated with inodes by
-          the kernel or by users (see the attr(5) manual page for details).
-          CIFS maps the name of extended attributes beginning with the user
-          namespace prefix to SMB/CIFS EAs.  EAs are stored on Windows
-          servers without the user namespace prefix, but their names are
-          seen by Linux cifs clients prefaced by the user namespace prefix.
-          The system namespace (used by some filesystems to store ACLs) is
-          not supported at this time.
-
-          If unsure, say Y.
+	bool "CIFS extended attributes"
+	depends on CIFS
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page for details).
+	  CIFS maps the name of extended attributes beginning with the user
+	  namespace prefix to SMB/CIFS EAs.  EAs are stored on Windows
+	  servers without the user namespace prefix, but their names are
+	  seen by Linux cifs clients prefaced by the user namespace prefix.
+	  The system namespace (used by some filesystems to store ACLs) is
+	  not supported at this time.
+
+	  If unsure, say Y.
 
 config CIFS_POSIX
-        bool "CIFS POSIX Extensions"
-        depends on CIFS && CIFS_ALLOW_INSECURE_LEGACY && CIFS_XATTR
-        help
-          Enabling this option will cause the cifs client to attempt to
+	bool "CIFS POSIX Extensions"
+	depends on CIFS && CIFS_ALLOW_INSECURE_LEGACY && CIFS_XATTR
+	help
+	  Enabling this option will cause the cifs client to attempt to
 	  negotiate a newer dialect with servers, such as Samba 3.0.5
 	  or later, that optionally can handle more POSIX like (rather
 	  than Windows like) file behavior.  It also enables
@@ -144,61 +144,62 @@ config CIFS_POSIX
 	  CIFS POSIX ACL support.  If unsure, say N.
 
 config CIFS_ACL
-	  bool "Provide CIFS ACL support"
-	  depends on CIFS_XATTR && KEYS
-	  help
-	    Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
-	    is handed over to the application/caller.  See the man
-	    page for getcifsacl for more information.  If unsure, say Y.
+	bool "Provide CIFS ACL support"
+	depends on CIFS_XATTR && KEYS
+	help
+	  Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
+	  is handed over to the application/caller.  See the man
+	  page for getcifsacl for more information.  If unsure, say Y.
 
 config CIFS_DEBUG
 	bool "Enable CIFS debugging routines"
 	default y
 	depends on CIFS
 	help
-	   Enabling this option adds helpful debugging messages to
-	   the cifs code which increases the size of the cifs module.
-	   If unsure, say Y.
+	  Enabling this option adds helpful debugging messages to
+	  the cifs code which increases the size of the cifs module.
+	  If unsure, say Y.
+
 config CIFS_DEBUG2
 	bool "Enable additional CIFS debugging routines"
 	depends on CIFS_DEBUG
 	help
-	   Enabling this option adds a few more debugging routines
-	   to the cifs code which slightly increases the size of
-	   the cifs module and can cause additional logging of debug
-	   messages in some error paths, slowing performance. This
-	   option can be turned off unless you are debugging
-	   cifs problems.  If unsure, say N.
+	  Enabling this option adds a few more debugging routines
+	  to the cifs code which slightly increases the size of
+	  the cifs module and can cause additional logging of debug
+	  messages in some error paths, slowing performance. This
+	  option can be turned off unless you are debugging
+	  cifs problems.  If unsure, say N.
 
 config CIFS_DEBUG_DUMP_KEYS
 	bool "Dump encryption keys for offline decryption (Unsafe)"
 	depends on CIFS_DEBUG
 	help
-	   Enabling this will dump the encryption and decryption keys
-	   used to communicate on an encrypted share connection on the
-	   console. This allows Wireshark to decrypt and dissect
-	   encrypted network captures. Enable this carefully.
-	   If unsure, say N.
+	  Enabling this will dump the encryption and decryption keys
+	  used to communicate on an encrypted share connection on the
+	  console. This allows Wireshark to decrypt and dissect
+	  encrypted network captures. Enable this carefully.
+	  If unsure, say N.
 
 config CIFS_DFS_UPCALL
-	  bool "DFS feature support"
-	  depends on CIFS && KEYS
-	  select DNS_RESOLVER
-	  help
-	    Distributed File System (DFS) support is used to access shares
-	    transparently in an enterprise name space, even if the share
-	    moves to a different server.  This feature also enables
-	    an upcall mechanism for CIFS which contacts userspace helper
-	    utilities to provide server name resolution (host names to
-	    IP addresses) which is needed in order to reconnect to
-	    servers if their addresses change or for implicit mounts of
-	    DFS junction points. If unsure, say Y.
+	bool "DFS feature support"
+	depends on CIFS && KEYS
+	select DNS_RESOLVER
+	help
+	  Distributed File System (DFS) support is used to access shares
+	  transparently in an enterprise name space, even if the share
+	  moves to a different server.  This feature also enables
+	  an upcall mechanism for CIFS which contacts userspace helper
+	  utilities to provide server name resolution (host names to
+	  IP addresses) which is needed in order to reconnect to
+	  servers if their addresses change or for implicit mounts of
+	  DFS junction points. If unsure, say Y.
 
 config CIFS_NFSD_EXPORT
-	  bool "Allow nfsd to export CIFS file system"
-	  depends on CIFS && BROKEN
-	  help
-	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
+	bool "Allow nfsd to export CIFS file system"
+	depends on CIFS && BROKEN
+	help
+	  Allows NFS server to export a CIFS mounted share (nfsd over cifs)
 
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support (Experimental)"
@@ -209,10 +210,9 @@ config CIFS_SMB_DIRECT
 	  say N.
 
 config CIFS_FSCACHE
-	  bool "Provide CIFS client caching support"
-	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
-	  help
-	    Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
-	    to be cached locally on disk through the general filesystem cache
-	    manager. If unsure, say N.
-
+	bool "Provide CIFS client caching support"
+	depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
+	help
+	  Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
+	  to be cached locally on disk through the general filesystem cache
+	  manager. If unsure, say N.
-- 
1.9.1

