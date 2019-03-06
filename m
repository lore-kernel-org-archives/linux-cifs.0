Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1373C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84537205F4
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfCFSYR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:24:17 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:51553 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCFSYQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Mar 2019 13:24:16 -0500
Received: from orion.localdomain ([95.118.27.116]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MMoXE-1hKN333nhk-00ImC7; Wed, 06 Mar 2019 19:24:13 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH] fs: cifs: Kconfig: pedantic cleanups
Date:   Wed,  6 Mar 2019 19:24:12 +0100
Message-Id: <1551896652-26579-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:XGwuXoc9uG61PVfE+cT3OKDDckGJTZVpUa1ny4++Sa0ue0M7w6W
 IpPbSBy8brbGMTxKu72rLTI4K0EWlCKme5fcvA8JSlBGnKjpkzC/3n+7FVWyfhTmAo88s2b
 zukfcd1qZuXYs+67e1kkuPtMk+tZeNAkTl1WcHOJ2wi4xeiUf9gWbYKX0Tq7/qnxpPEfAvo
 SlY6y88fda1gdQy7WE4aw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gLzIxaadsOE=:xLIbTYPzwBDBnYf0tJ8F2u
 3M8d1bCVUNoqSYx/XqPURp7EyXiV/oDreSGaChazmJPB3MfF6XBU0cNfc4kPS0yhw6Oh9RT/o
 jbBXvRIZWg+GZb2qyZOSzcUIQnYtp7G1yUo6eK9J041yQJEDuMB4qszaRz4DxdjPaMDWqE2zh
 at0HFCRRwPHFgAvG8dL5jju5IijDufYGxNfUlQ8bYdoA0iZEvZOaeamhmb5R2UTyHdpADGxUF
 NpBKrpmyb078e88k93RDZf6bwQDiEwD4xD5PceZCpFiOGYfiaslKiCYBkG06tX9lQvvYBvRX1
 QB7qZBCfWLaUj1Cf2I5+ZVsNeHDsK2C5gmKwXxsS414bJcmZ1TLT3AyllLSx7tFxo8SIny5ZE
 GQIaKuJU6B5kfeCoALvnynez5UqG7QPg5eSqu+HBYTtg9UoBztvEbXnhuZ4l3davzoBM+cyMl
 yJvo/60QQuA9vholK4ScVh9yI++vsSkTjRUQtK0vV0UdIpFLpaiWDm18oo43MsFCh683a7Tra
 /DwxFo0U4yf1NQszuRGS6KO+niJnh4uXF+RGBvrhb+vcYYVRwbfZejR2OH9gDGrm2BpnZw9lF
 z3h5d85ghaR9rOy49NF0LPHjeOWMTRmzPRLdn4YrVpqoLFs8a9ZBvmQvvjQHkSFqXI6IPupc1
 DTmisOtxCvxvPMMjEFiFPQYnTXIwPFdVqkzTD+5gs4HdICRGHuhNJcngIkRRHvv9lTQzIJzpf
 9N/HmK6ewCY2bfsGyPxwOCLwfB6y4LTg0a381w==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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

