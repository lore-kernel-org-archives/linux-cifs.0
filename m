Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21FBC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 22:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiGVWnO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 18:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiGVWnN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 18:43:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93418BB5
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 15:43:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 478EE2019F;
        Fri, 22 Jul 2022 22:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658529790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNn0IvgbwKzEXKLqn2TcEsYfaY4yA6br+6w7p5UL+OQ=;
        b=qxijLxk3Nj1GtJrSOKRQzNsVTLxY/qNwSFVz75kQlRvYuCQZ0WLlQXcCkRaId/BkwpadOQ
        ZtGMpf8q8XJ0r4rMPOFnaqqfD2Rlg7icAzjY7N/m5dUyQ6bpmJYqrtvLcn1dV5Xs/+sYW8
        TM+n3D+yyiT7ByRWRI+LyV/MaMcCoLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658529790;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNn0IvgbwKzEXKLqn2TcEsYfaY4yA6br+6w7p5UL+OQ=;
        b=AOvque4FO5Hf5jBzuYkly4OuG3DcAItfFuioLXbzzHECAU5vOAr7DLS9hX22R4NSmgCnyl
        kANlBcOq91qd5tDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BEE1D134A9;
        Fri, 22 Jul 2022 22:43:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id taNJIP0n22KRIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 22:43:09 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH 4/4] cifs: standardize authors emails to RFC5322 format
Date:   Fri, 22 Jul 2022 19:42:54 -0300
Message-Id: <20220722224254.8738-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220722224254.8738-1-ematsumiya@suse.de>
References: <20220722224254.8738-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change (author@example.com) to <author@example.com>

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_dfs_ref.c  | 4 ++--
 fs/cifs/cifs_fs_sb.h    | 2 +-
 fs/cifs/cifs_spnego.c   | 2 +-
 fs/cifs/cifs_spnego.h   | 4 ++--
 fs/cifs/cifs_unicode.c  | 2 +-
 fs/cifs/cifsacl.c       | 2 +-
 fs/cifs/cifsacl.h       | 2 +-
 fs/cifs/cifsencrypt.c   | 2 +-
 fs/cifs/cifsfs.c        | 2 +-
 fs/cifs/cifsfs.h        | 2 +-
 fs/cifs/cifsglob.h      | 4 ++--
 fs/cifs/cifspdu.h       | 2 +-
 fs/cifs/cifssmb.c       | 2 +-
 fs/cifs/connect.c       | 2 +-
 fs/cifs/dir.c           | 2 +-
 fs/cifs/dns_resolve.c   | 8 ++++----
 fs/cifs/dns_resolve.h   | 2 +-
 fs/cifs/export.c        | 2 +-
 fs/cifs/file.c          | 4 ++--
 fs/cifs/inode.c         | 2 +-
 fs/cifs/ioctl.c         | 2 +-
 fs/cifs/link.c          | 2 +-
 fs/cifs/misc.c          | 2 +-
 fs/cifs/netmisc.c       | 2 +-
 fs/cifs/ntlmssp.h       | 2 +-
 fs/cifs/readdir.c       | 2 +-
 fs/cifs/rfc1002pdu.h    | 2 +-
 fs/cifs/sess.c          | 2 +-
 fs/cifs/smb2file.c      | 4 ++--
 fs/cifs/smb2glob.h      | 6 +++---
 fs/cifs/smb2inode.c     | 4 ++--
 fs/cifs/smb2maperror.c  | 2 +-
 fs/cifs/smb2misc.c      | 4 ++--
 fs/cifs/smb2pdu.c       | 4 ++--
 fs/cifs/smb2pdu.h       | 4 ++--
 fs/cifs/smb2proto.h     | 4 ++--
 fs/cifs/smb2status.h    | 2 +-
 fs/cifs/smb2transport.c | 6 +++---
 fs/cifs/smbencrypt.c    | 4 ++--
 fs/cifs/smberr.h        | 2 +-
 fs/cifs/transport.c     | 4 ++--
 fs/cifs/xattr.c         | 2 +-
 42 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 5c776f4639f4..2b7fd67e4947 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -5,8 +5,8 @@
  *
  * Copyright (c) 2007 Igor Mammedov
  * Copyright (c) International Business Machines Corp., 2008
- * Author(s): Igor Mammedov (niallain@gmail.com)
- *		Steve French (sfrench@us.ibm.com)
+ * Author(s): Igor Mammedov <niallain@gmail.com>
+ *		Steve French <sfrench@us.ibm.com>
  */
 
 #include <linux/dcache.h>
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 4381511028e1..910bddc24ce5 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2002,2004
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/rbtree.h>
 
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 5c52d08725a4..c3215be17869 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -3,7 +3,7 @@
  * SPNEGO upcall management for CIFS
  *
  * Copyright (c) 2007 Red Hat, Inc.
- * Author(s): Jeff Layton (jlayton@redhat.com)
+ * Author(s): Jeff Layton <jlayton@redhat.com>
 */
 
 #include <linux/list.h>
diff --git a/fs/cifs/cifs_spnego.h b/fs/cifs/cifs_spnego.h
index 358b7220b593..bcf31a5eb223 100644
--- a/fs/cifs/cifs_spnego.h
+++ b/fs/cifs/cifs_spnego.h
@@ -3,8 +3,8 @@
  * SPNEGO upcall management for CIFS
  *
  * Copyright (c) 2007 Red Hat, Inc.
- * Author(s): Jeff Layton (jlayton@redhat.com)
- *              Steve French (sfrench@us.ibm.com)
+ * Author(s): Jeff Layton <jlayton@redhat.com>
+ *              Steve French <sfrench@us.ibm.com>
 */
 
 #ifndef _CIFS_SPNEGO_H
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index e701e8916275..4d077ad42e4d 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) International Business Machines Corp., 2000,2009
- * Modified by Steve French (sfrench@us.ibm.com)
+ * Modified by Steve French <sfrench@us.ibm.com>
  */
 #include <linux/fs.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d9bc8cee6317..d38677e59484 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2007,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *
  * Contains the routines for mapping CIFS/NTFS ACLs
 */
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 227cb8f123a5..3856d04c7f18 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2007
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #ifndef _CIFSACL_H
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index dfc5bce69fe6..7198cae5bbf0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -4,7 +4,7 @@
  * for more detailed information
  *
  * Copyright (c) International Business Machines Corp., 2005,2013
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #include <linux/fs.h>
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c81935405b70..19c947572afb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) International Business Machines Corp., 2002,2008
  * Copyright (c) SUSE LLC, 2022
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *		Enzo Matsumiya <ematsumiya@suse.de>
  *
  * SMBFS client
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b6c4fbe5ccc6..a11fb8be7daa 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) International Business Machines  Corp., 2002, 2007
  * Copyright (c) SUSE LLC, 2022
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *		Enzo Matsumiya <ematsumiya@suse.de>
  */
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bbc02fea2181..ab01f13aafc7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2002,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Jeremy Allison (jra@samba.org)
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Jeremy Allison <jra@samba.org>
 */
 #ifndef _CIFS_GLOB_H
 #define _CIFS_GLOB_H
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index c280677f6358..fdb9ee427790 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2002,2009
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #ifndef _CIFSPDU_H
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 049a1ba7e297..d7cf1fae3af5 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2010
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *
  * Contains the routines for constructing the SMB PDUs themselves
 */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6ebfe8b9ce80..5a6b4c02a6bc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2011
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/net.h>
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 3783889a9dc5..13124b9c737d 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -3,7 +3,7 @@
  * vfs operations that deal with dentries
  *
  * Copyright (c) International Business Machines Corp., 2002,2009
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/stat.h>
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 8af13d34f627..c2e3c0b8ae70 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) 2007 Igor Mammedov
- * Author(s): Igor Mammedov (niallain@gmail.com)
- *              Steve French (sfrench@us.ibm.com)
- *              Wang Lei (wang840925@gmail.com)
- *		David Howells (dhowells@redhat.com)
+ * Author(s): Igor Mammedov <niallain@gmail.com>
+ *              Steve French <sfrench@us.ibm.com>
+ *              Wang Lei <wang840925@gmail.com>
+ *		David Howells <dhowells@redhat.com>
  *
  * Contains the CIFS DFS upcall routines used for hostname to
  * IP address translation.
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index dee549bba4c7..91af52ceed67 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -4,7 +4,7 @@
  * Handles host name to IP address resolution
  *
  * Copyright (c) International Business Machines  Corp., 2008
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #ifndef _DNS_RESOLVE_H
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index bf9b0361c497..5c9290d55e02 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2007
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *
  * Common Internet FileSystem (CIFS) client
  *
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 01f3b1db129f..4d9eb64ad855 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3,8 +3,8 @@
  * vfs operations that deal with files
  *
  * Copyright (c) International Business Machines Corp., 2002,2010
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Jeremy Allison (jra@samba.org)
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Jeremy Allison <jra@samba.org>
 */
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 687237571c11..6a42ab16755f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2010
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/stat.h>
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index d2de957df2de..7365abf170a4 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -3,7 +3,7 @@
  * vfs operations that deal with io control
  *
  * Copyright (c) International Business Machines Corp., 2005,2013
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #include <linux/fs.h>
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 6b9ff8f8d122..2990697916a3 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/stat.h>
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 944d073edad8..62e7871d0f2b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #include <linux/slab.h>
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 7cd52ea80a90..06f3ba5b05e3 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) International Business Machines Corp., 2002,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *
  * Error mapping routines from Samba libsmb/errormap.c
  * Copyright (c) Andrew Tridgell 2001
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 69111c35719b..fa8dcfee89ed 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2002,2007
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #define NTLMSSP_SIGNATURE "NTLMSSP"
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 79c8c443a2ce..14546c32021d 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -4,7 +4,7 @@
  *
  * Copyright (c) International Business Machines Corp., 2004, 2008
  * Copyright (c) Red Hat, Inc., 2011
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff --git a/fs/cifs/rfc1002pdu.h b/fs/cifs/rfc1002pdu.h
index 09110b34b74b..6060a87fa97f 100644
--- a/fs/cifs/rfc1002pdu.h
+++ b/fs/cifs/rfc1002pdu.h
@@ -3,7 +3,7 @@
  * Protocol Data Unit definitions for RFC 1001/1002 support
  *
  * Copyright (c) International Business Machines  Corp., 2004
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 /* NB: unlike smb/cifs packets, the RFC1002 structures are big endian */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index b07be54846e4..2d2066e292e1 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -3,7 +3,7 @@
  * SMB/CIFS session setup handling routines
  *
  * Copyright (c) International Business Machines Corp., 2006, 2009
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #include "cifspdu.h"
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index f80f2e989ffe..739207751999 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002, 2011
- * Author(s): Steve French (sfrench@us.ibm.com),
- *              Pavel Shilovsky ((pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>,
+ *              Pavel Shilovsky <(pshilovsky@samba.org> 2012
 */
 #include <linux/fs.h>
 #include <linux/stat.h>
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index bb91031423e0..563222b34fd1 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -4,9 +4,9 @@
  *
  * Copyright (c) International Business Machines  Corp., 2002, 2011
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Jeremy Allison (jra@samba.org)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Jeremy Allison <jra@samba.org>
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
 */
 #ifndef _SMB2_GLOB_H
 #define _SMB2_GLOB_H
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 75925d119bb9..e68cc6ebf765 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2002, 2011
  *                 Etersoft, 2012
- * Author(s): Pavel Shilovsky (pshilovsky@samba.org),
- *              Steve French (sfrench@us.ibm.com)
+ * Author(s): Pavel Shilovsky <pshilovsky@samba.org>,
+ *              Steve French <sfrench@us.ibm.com>
 */
 #include <linux/fs.h>
 #include <linux/stat.h>
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 3ae0c1296d22..4d39abf54234 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -3,7 +3,7 @@
  * Functions which do error mapping of SMB2 status codes to POSIX errors
  *
  * Copyright (c) International Business Machines Corp., 2009
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 #include <linux/errno.h>
 #include "cifsglob.h"
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 577b0537541d..2183907ce8d8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2002,2011
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
 */
 #include <linux/ctype.h>
 #include "cifsglob.h"
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a0019a46104e..45f3db4da860 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2009, 2013
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
  *
  * Contains the routines for constructing the SMB2 PDUs themselves
 */
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index ac72d34e1e67..b9d6c0fc8cbd 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) International Business Machines  Corp., 2009, 2013
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
 */
 
 #ifndef _SMB2PDU_H
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a80aceb8b78c..0cd765107f17 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) International Business Machines  Corp., 2002, 2011
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
 */
 #ifndef _SMB2PROTO_H
 #define _SMB2PROTO_H
diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
index 940c07590a00..a561c0d0fa52 100644
--- a/fs/cifs/smb2status.h
+++ b/fs/cifs/smb2status.h
@@ -4,7 +4,7 @@
  * Definitions are from MS-ERREF
  *
  * Copyright (c) International Business Machines  Corp., 2009,2011
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 /*
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 1a0ceecd5170..01b81532c874 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -2,9 +2,9 @@
 /*
  * Copyright (c) International Business Machines Corp., 2002, 2011
  *                 Etersoft, 2012
- * Author(s): Steve French (sfrench@us.ibm.com)
- *              Jeremy Allison (jra@samba.org) 2006
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ *              Jeremy Allison <jra@samba.org> 2006
+ *              Pavel Shilovsky <pshilovsky@samba.org> 2012
 */
 
 #include <linux/fs.h>
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 0214092d2714..8824191ec1e6 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -6,8 +6,8 @@
    Copyright (C) Andrew Tridgell 1992-2000
    Copyright (C) Luke Kenneth Casson Leighton 1996-2000
    Modified by Jeremy Allison 1995.
-   Copyright (C) Andrew Bartlett <abartlet@samba.org> 2002-2003
-   Modified by Steve French (sfrench@us.ibm.com) 2002-2003
+   Copyright (c) Andrew Bartlett <abartlet@samba.org> 2002-2003
+   Modified by Steve French <sfrench@us.ibm.com> 2002-2003
 
 */
 
diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
index 514739487331..483c4575865f 100644
--- a/fs/cifs/smberr.h
+++ b/fs/cifs/smberr.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines  Corp., 2002,2004
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
  *
  * See Error Codes section of the SNIA CIFS Specification
  * for more information
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 8d24f7d5cd49..9d3407699c88 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2002,2008
- * Author(s): Steve French (sfrench@us.ibm.com)
- * Jeremy Allison (jra@samba.org) 2006.
+ * Author(s): Steve French <sfrench@us.ibm.com>
+ * Jeremy Allison <jra@samba.org> 2006.
 */
 
 #include <linux/fs.h>
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 531bf9d1a2f9..7a1aa2107d10 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (c) International Business Machines Corp., 2003, 2007
- * Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French <sfrench@us.ibm.com>
 */
 
 #include <linux/fs.h>
-- 
2.35.3

