Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DDCC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 22:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbiGVWnL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiGVWnL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 18:43:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ADBBB5
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 15:43:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EDA92200F2;
        Fri, 22 Jul 2022 22:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658529786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koEZ7rzzxQ7S0O/y6NMa1nUepMOXOGjsdD5oNtB8Bns=;
        b=zODlXtcP7XFAiwdKx1+Fb3wBLPrkQWgxPzc+RQYkqtToXVQ3j5yQwibbU9ifYebwA5SDae
        XMJA9X2RggVyEpXc8wAv5E0FH1JO9OtNOsZtZ99C2sPk8hEVpcAnLNV8t4ohRGqUBwmKfK
        swpWDMJZtE1+8uZ1/sZzovCnVtNqRvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658529786;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koEZ7rzzxQ7S0O/y6NMa1nUepMOXOGjsdD5oNtB8Bns=;
        b=aPUaWF4+xYn1f61aReaMxaBgZZJvj2aHwVW1CcZAurXMcwJffMKJBDWhbegvC8IIWA09iL
        TFd8wQ/qOTl7gCAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 33917134A9;
        Fri, 22 Jul 2022 22:43:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CBXhOfkn22KIIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 22:43:05 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH 3/4] cifs: standardize top comments format
Date:   Fri, 22 Jul 2022 19:42:53 -0300
Message-Id: <20220722224254.8738-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220722224254.8738-1-ematsumiya@suse.de>
References: <20220722224254.8738-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use only 1 space after comment start, remove unecessary extra lines.

Done via sed, might have affected some code comments, will fix up later.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_dfs_ref.c  | 10 +++++-----
 fs/cifs/cifs_fs_sb.h    |  8 +++-----
 fs/cifs/cifs_ioctl.h    |  8 +++-----
 fs/cifs/cifs_spnego.c   |  9 ++++-----
 fs/cifs/cifs_spnego.h   |  9 ++++-----
 fs/cifs/cifs_unicode.c  |  8 +++-----
 fs/cifs/cifs_unicode.h  |  5 ++---
 fs/cifs/cifs_uniupr.h   |  2 +-
 fs/cifs/cifsacl.c       | 10 ++++------
 fs/cifs/cifsacl.h       |  8 +++-----
 fs/cifs/cifsencrypt.c   | 12 +++++-------
 fs/cifs/cifsfs.c        | 10 +++++-----
 fs/cifs/cifsfs.h        |  8 ++++----
 fs/cifs/cifsglob.h      |  7 +++----
 fs/cifs/cifspdu.h       | 14 +++++---------
 fs/cifs/cifssmb.c       | 10 ++++------
 fs/cifs/connect.c       | 11 ++++-------
 fs/cifs/dir.c           | 10 ++++------
 fs/cifs/dns_resolve.c   | 12 +++++-------
 fs/cifs/dns_resolve.h   | 11 +++++------
 fs/cifs/export.c        | 12 +++++-------
 fs/cifs/file.c          | 13 +++++--------
 fs/cifs/fs_context.c    |  4 ++--
 fs/cifs/fs_context.h    |  4 ++--
 fs/cifs/fscache.c       |  9 ++++-----
 fs/cifs/fscache.h       |  9 ++++-----
 fs/cifs/inode.c         |  8 +++-----
 fs/cifs/ioctl.c         | 12 +++++-------
 fs/cifs/link.c          |  8 +++-----
 fs/cifs/misc.c          |  8 +++-----
 fs/cifs/netmisc.c       |  9 ++++-----
 fs/cifs/ntlmssp.h       |  8 +++-----
 fs/cifs/readdir.c       | 12 +++++-------
 fs/cifs/rfc1002pdu.h    | 10 ++++------
 fs/cifs/sess.c          | 10 ++++------
 fs/cifs/smb2file.c      |  8 +++-----
 fs/cifs/smb2glob.h      | 10 ++++------
 fs/cifs/smb2inode.c     |  8 +++-----
 fs/cifs/smb2maperror.c  | 10 ++++------
 fs/cifs/smb2misc.c      |  8 +++-----
 fs/cifs/smb2pdu.c       | 16 ++++++----------
 fs/cifs/smb2pdu.h       | 11 ++++-------
 fs/cifs/smb2proto.h     |  8 +++-----
 fs/cifs/smb2status.h    | 12 +++++-------
 fs/cifs/smb2transport.c |  8 +++-----
 fs/cifs/smbdirect.c     |  4 ++--
 fs/cifs/smbdirect.h     |  4 ++--
 fs/cifs/smberr.h        | 12 +++++-------
 fs/cifs/trace.c         |  4 ++--
 fs/cifs/trace.h         |  4 ++--
 fs/cifs/transport.c     | 14 +++++---------
 fs/cifs/unc.c           |  4 ++--
 fs/cifs/winucase.c      |  1 -
 fs/cifs/xattr.c         |  8 +++-----
 54 files changed, 193 insertions(+), 279 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 23fa4fa3cb16..5c776f4639f4 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Contains the CIFS DFS referral mounting routines used for handling
- *   traversal via DFS junction point
+ * Contains the CIFS DFS referral mounting routines used for handling
+ * traversal via DFS junction point
  *
- *   Copyright (c) 2007 Igor Mammedov
- *   Copyright (C) International Business Machines  Corp., 2008
- *   Author(s): Igor Mammedov (niallain@gmail.com)
+ * Copyright (c) 2007 Igor Mammedov
+ * Copyright (c) International Business Machines Corp., 2008
+ * Author(s): Igor Mammedov (niallain@gmail.com)
  *		Steve French (sfrench@us.ibm.com)
  */
 
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 7317534ac410..4381511028e1 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2002,2004
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2002,2004
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/rbtree.h>
 
 #ifndef _CIFS_FS_SB_H
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index bf2850b54f3b..1748b7db9d88 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -1,11 +1,9 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Structure definitions for io control for cifs/smb3
  *
- *   Structure definitions for io control for cifs/smb3
- *
- *   Copyright (c) 2015 Steve French <steve.french@primarydata.com>
- *
- */
+ * Copyright (c) 2015 Steve French <steve.french@primarydata.com>
+*/
 
 struct smb_mnt_fs_info {
 	__u32	version; /* 0001 */
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 342717bf1dc2..5c52d08725a4 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   SPNEGO upcall management for CIFS
+ * SPNEGO upcall management for CIFS
  *
- *   Copyright (c) 2007 Red Hat, Inc.
- *   Author(s): Jeff Layton (jlayton@redhat.com)
- *
- */
+ * Copyright (c) 2007 Red Hat, Inc.
+ * Author(s): Jeff Layton (jlayton@redhat.com)
+*/
 
 #include <linux/list.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/cifs_spnego.h b/fs/cifs/cifs_spnego.h
index 3819940e2ab5..358b7220b593 100644
--- a/fs/cifs/cifs_spnego.h
+++ b/fs/cifs/cifs_spnego.h
@@ -1,12 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   SPNEGO upcall management for CIFS
+ * SPNEGO upcall management for CIFS
  *
- *   Copyright (c) 2007 Red Hat, Inc.
- *   Author(s): Jeff Layton (jlayton@redhat.com)
+ * Copyright (c) 2007 Red Hat, Inc.
+ * Author(s): Jeff Layton (jlayton@redhat.com)
  *              Steve French (sfrench@us.ibm.com)
- *
- */
+*/
 
 #ifndef _CIFS_SPNEGO_H
 #define _CIFS_SPNEGO_H
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index e7582dd79179..e701e8916275 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -1,8 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2000,2009
- *   Modified by Steve French (sfrench@us.ibm.com)
+ * Copyright (c) International Business Machines Corp., 2000,2009
+ * Modified by Steve French (sfrench@us.ibm.com)
  */
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -243,8 +242,7 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
  * NAME:	cifs_strtoUTF16()
  *
  * FUNCTION:	Convert character string to unicode string
- *
- */
+*/
 int
 cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	      const struct nls_table *codepage)
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 9bad387d2bff..9a2e65212bdb 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -6,7 +6,7 @@
  *     Convert a unicode character to upper or lower case using
  *     compressed tables.
  *
- *   Copyright (c) International Business Machines  Corp., 2000,2009
+ * Copyright (c) International Business Machines  Corp., 2000,2009
  *
  * Notes:
  *     These APIs are based on the C library functions.  The semantics
@@ -62,8 +62,7 @@
  * NO_MAP_UNI_RSVD  = do not perform any remapping of the character
  * SFM_MAP_UNI_RSVD = map reserved characters using SFM scheme (MAC compatible)
  * SFU_MAP_UNI_RSVD = map reserved characters ala SFU ("mapchars" option)
- *
- */
+*/
 #define NO_MAP_UNI_RSVD		0
 #define SFM_MAP_UNI_RSVD	1
 #define SFU_MAP_UNI_RSVD	2
diff --git a/fs/cifs/cifs_uniupr.h b/fs/cifs/cifs_uniupr.h
index 529bd690fd91..66e87cb9f374 100644
--- a/fs/cifs/cifs_uniupr.h
+++ b/fs/cifs/cifs_uniupr.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (c) International Business Machines  Corp., 2000,2002
+ * Copyright (c) International Business Machines  Corp., 2000,2002
  *
  * uniupr.h - Unicode compressed case ranges
 */
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 73754cb74065..d9bc8cee6317 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Copyright (c) International Business Machines Corp., 2007,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *
- *   Copyright (C) International Business Machines  Corp., 2007,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- *   Contains the routines for mapping CIFS/NTFS ACLs
- *
- */
+ * Contains the routines for mapping CIFS/NTFS ACLs
+*/
 
 #include <linux/fs.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 6c051b3ae922..227cb8f123a5 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2007
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2007
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #ifndef _CIFSACL_H
 #define _CIFSACL_H
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 663cb9db4908..dfc5bce69fe6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Encryption and hashing operations relating to NTLM, NTLMv2.  See MS-NLMP
+ * for more detailed information
  *
- *   Encryption and hashing operations relating to NTLM, NTLMv2.  See MS-NLMP
- *   for more detailed information
- *
- *   Copyright (C) International Business Machines  Corp., 2005,2013
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2005,2013
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #include <linux/fs.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index da2a53daeae3..c81935405b70 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Copyright (c) International Business Machines Corp., 2002,2008
+ * Copyright (c) SUSE LLC, 2022
+ * Author(s): Steve French (sfrench@us.ibm.com)
+ *		Enzo Matsumiya <ematsumiya@suse.de>
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- *   Common Internet FileSystem (CIFS) client
- *
+ * SMBFS client
  */
 
 /* Note that BB means BUGBUG (ie something to fix eventually) */
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index deef6c8d0dc3..b6c4fbe5ccc6 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2002, 2007
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
+ * Copyright (c) International Business Machines  Corp., 2002, 2007
+ * Copyright (c) SUSE LLC, 2022
+ * Author(s): Steve French (sfrench@us.ibm.com)
+ *		Enzo Matsumiya <ematsumiya@suse.de>
  */
 
 #ifndef _CIFSFS_H
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 65c7e5b55278..bbc02fea2181 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1,10 +1,9 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   Copyright (C) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Copyright (c) International Business Machines  Corp., 2002,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org)
- *
- */
+*/
 #ifndef _CIFS_GLOB_H
 #define _CIFS_GLOB_H
 
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d3c5e3d23385..c280677f6358 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2002,2009
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2002,2009
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #ifndef _CIFSPDU_H
 #define _CIFSPDU_H
@@ -477,8 +475,7 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
  *  Typedefs can always be removed later if they are too distracting
  *  and they are only used for the CIFSs PDUs themselves, not
  *  internal cifs vfs structures
- *
- */
+*/
 
 typedef struct negotiate_req {
 	struct smb_hdr hdr;	/* wct = 0 */
@@ -747,8 +744,7 @@ typedef struct smb_com_tconx_rsp_ext {
  * IPC      ie named pipe
  * COMM
  * ?????    ie any type
- *
- */
+*/
 
 typedef struct smb_com_echo_req {
 	struct	smb_hdr hdr;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 011d17b7523c..049a1ba7e297 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Copyright (c) International Business Machines Corp., 2002,2010
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2010
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- *   Contains the routines for constructing the SMB PDUs themselves
- *
- */
+ * Contains the routines for constructing the SMB PDUs themselves
+*/
 
  /* SMB/CIFS PDU handling routines here - except for leftovers in connect.c   */
  /* These are mostly routines that operate on a pathname, or on a tree id     */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8859da70cb06..6ebfe8b9ce80 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2011
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2011
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/fs.h>
 #include <linux/net.h>
 #include <linux/string.h>
@@ -379,8 +377,7 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
  * if mark_smb_session is passed as true, unconditionally mark
  * the smb session (and tcon) for reconnect as well. This value
  * doesn't really matter for non-multichannel scenario.
- *
- */
+*/
 static int __cifs_reconnect(struct TCP_Server_Info *server,
 			    bool mark_smb_session)
 {
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ce9b22aecfba..3783889a9dc5 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * vfs operations that deal with dentries
  *
- *   vfs operations that deal with dentries
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2009
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2009
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 0458d28d71aa..8af13d34f627 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -1,16 +1,14 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) 2007 Igor Mammedov
- *   Author(s): Igor Mammedov (niallain@gmail.com)
+ * Copyright (c) 2007 Igor Mammedov
+ * Author(s): Igor Mammedov (niallain@gmail.com)
  *              Steve French (sfrench@us.ibm.com)
  *              Wang Lei (wang840925@gmail.com)
  *		David Howells (dhowells@redhat.com)
  *
- *   Contains the CIFS DFS upcall routines used for hostname to
- *   IP address translation.
- *
- */
+ * Contains the CIFS DFS upcall routines used for hostname to
+ * IP address translation.
+*/
 
 #include <linux/slab.h>
 #include <linux/dns_resolver.h>
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index 5a617278a669..dee549bba4c7 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -1,12 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   DNS Resolver upcall management for CIFS DFS
- *   Handles host name to IP address resolution
+ * DNS Resolver upcall management for CIFS DFS
+ * Handles host name to IP address resolution
  *
- *   Copyright (c) International Business Machines  Corp., 2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #ifndef _DNS_RESOLVE_H
 #define _DNS_RESOLVE_H
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 37c28415df1e..bf9b0361c497 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -1,14 +1,12 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Copyright (c) International Business Machines Corp., 2007
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *
- *   Copyright (C) International Business Machines  Corp., 2007
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Common Internet FileSystem (CIFS) client
  *
- *   Common Internet FileSystem (CIFS) client
- *
- *   Operations related to support for exporting files via NFSD
- *
- */
+ * Operations related to support for exporting files via NFSD
+*/
 
  /*
   * See Documentation/filesystems/nfs/exporting.rst
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6985710e14c2..01f3b1db129f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * vfs operations that deal with files
  *
- *   vfs operations that deal with files
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2010
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Copyright (c) International Business Machines Corp., 2002,2010
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org)
- *
- */
+*/
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
 #include <linux/stat.h>
@@ -430,8 +428,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
  * @cifs_file:	cifs/smb3 specific info (eg refcounts) for an open file
  * @wait_oplock_handler: must be false if called from oplock_break_handler
  * @offload:	not offloaded on close and oplock breaks
- *
- */
+*/
 void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		       bool wait_oplock_handler, bool offload)
 {
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index f76d9920a7a7..c218126dc701 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (C) 2020, Microsoft Corporation.
+ * Copyright (c) 2020, Microsoft Corporation.
  *
- *   Author(s): Steve French <stfrench@microsoft.com>
+ * Author(s): Steve French <stfrench@microsoft.com>
  *              David Howells <dhowells@redhat.com>
  */
 #include <linux/ctype.h>
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index ec4a8af72570..68d5c4e2f6ad 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (C) 2020, Microsoft Corporation.
+ * Copyright (c) 2020, Microsoft Corporation.
  *
- *   Author(s): Steve French <stfrench@microsoft.com>
+ * Author(s): Steve French <stfrench@microsoft.com>
  *              David Howells <dhowells@redhat.com>
  */
 
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 23ef56f55ce5..45b5df911bf9 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   CIFS filesystem cache interface
+ * CIFS filesystem cache interface
  *
- *   Copyright (c) 2010 Novell, Inc.
- *   Author(s): Suresh Jayaraman <sjayaraman@suse.de>
- *
- */
+ * Copyright (c) 2010 Novell, Inc.
+ * Author(s): Suresh Jayaraman <sjayaraman@suse.de>
+*/
 #include "fscache.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 435e826fdd9a..cc7f5033b7d0 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *   CIFS filesystem cache interface definitions
+ * CIFS filesystem cache interface definitions
  *
- *   Copyright (c) 2010 Novell, Inc.
- *   Authors(s): Suresh Jayaraman (sjayaraman@suse.de>
- *
- */
+ * Copyright (c) 2010 Novell, Inc.
+ * Authors(s): Suresh Jayaraman (sjayaraman@suse.de>
+*/
 #ifndef _CIFS_FSCACHE_H
 #define _CIFS_FSCACHE_H
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 46ebc2554b53..687237571c11 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2010
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2010
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0359b604bdbc..d2de957df2de 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * vfs operations that deal with io control
  *
- *   vfs operations that deal with io control
- *
- *   Copyright (C) International Business Machines  Corp., 2005,2013
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2005,2013
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -174,7 +172,7 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 
 	/*
 	 * see:
-	 *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html
+	 * https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html
 	 * for more information and description of original intent of the flags
 	 */
 	switch (flags) {
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index bbdf3281559c..6b9ff8f8d122 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index ec0069058f45..944d073edad8 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #include <linux/slab.h>
 #include <linux/ctype.h>
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 28caae7aed1b..7cd52ea80a90 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
+ * Copyright (c) International Business Machines Corp., 2002,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *
- *   Copyright (c) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- *   Error mapping routines from Samba libsmb/errormap.c
- *   Copyright (C) Andrew Tridgell 2001
+ * Error mapping routines from Samba libsmb/errormap.c
+ * Copyright (c) Andrew Tridgell 2001
  */
 
 #include <linux/net.h>
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 7a00acffa6ea..69111c35719b 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2002,2007
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2002,2007
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #define NTLMSSP_SIGNATURE "NTLMSSP"
 /* Message Types */
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 384cabdf47ca..79c8c443a2ce 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Directory search handling
  *
- *   Directory search handling
- *
- *   Copyright (C) International Business Machines  Corp., 2004, 2008
- *   Copyright (C) Red Hat, Inc., 2011
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2004, 2008
+ * Copyright (c) Red Hat, Inc., 2011
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/rfc1002pdu.h b/fs/cifs/rfc1002pdu.h
index b32940b2b2bf..09110b34b74b 100644
--- a/fs/cifs/rfc1002pdu.h
+++ b/fs/cifs/rfc1002pdu.h
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Protocol Data Unit definitions for RFC 1001/1002 support
  *
- *   Protocol Data Unit definitions for RFC 1001/1002 support
- *
- *   Copyright (c) International Business Machines  Corp., 2004
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2004
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 /* NB: unlike smb/cifs packets, the RFC1002 structures are big endian */
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 02c8b2906196..b07be54846e4 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * SMB/CIFS session setup handling routines
  *
- *   SMB/CIFS session setup handling routines
- *
- *   Copyright (c) International Business Machines  Corp., 2006, 2009
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2006, 2009
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #include "cifspdu.h"
 #include "cifsglob.h"
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index f5dcc4940b6d..f80f2e989ffe 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -1,11 +1,9 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002, 2011
- *   Author(s): Steve French (sfrench@us.ibm.com),
+ * Copyright (c) International Business Machines Corp., 2002, 2011
+ * Author(s): Steve French (sfrench@us.ibm.com),
  *              Pavel Shilovsky ((pshilovsky@samba.org) 2012
- *
- */
+*/
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index c240ce7bc0ed..bb91031423e0 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -1,15 +1,13 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Definitions for various global variables and structures
  *
- *   Definitions for various global variables and structures
- *
- *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ * Copyright (c) International Business Machines  Corp., 2002, 2011
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *
- */
+*/
 #ifndef _SMB2_GLOB_H
 #define _SMB2_GLOB_H
 
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8571a459c710..75925d119bb9 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ * Copyright (c) International Business Machines Corp., 2002, 2011
  *                 Etersoft, 2012
- *   Author(s): Pavel Shilovsky (pshilovsky@samba.org),
+ * Author(s): Pavel Shilovsky (pshilovsky@samba.org),
  *              Steve French (sfrench@us.ibm.com)
- *
- */
+*/
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 194799ddd382..3ae0c1296d22 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Functions which do error mapping of SMB2 status codes to POSIX errors
  *
- *   Functions which do error mapping of SMB2 status codes to POSIX errors
- *
- *   Copyright (C) International Business Machines  Corp., 2009
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2009
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 #include <linux/errno.h>
 #include "cifsglob.h"
 #include "cifs_debug.h"
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 818cc4dee0e2..577b0537541d 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2011
+ * Copyright (c) International Business Machines Corp., 2002,2011
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *
- */
+*/
 #include <linux/ctype.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 295ee8b88055..a0019a46104e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1,14 +1,12 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2009, 2013
+ * Copyright (c) International Business Machines Corp., 2009, 2013
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
  *
- *   Contains the routines for constructing the SMB2 PDUs themselves
- *
- */
+ * Contains the routines for constructing the SMB2 PDUs themselves
+*/
 
  /* SMB2 PDU handling routines here - except for leftovers (eg session setup) */
  /* Note that there are handle based routines which must be		      */
@@ -848,7 +846,6 @@ add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
 
 
 /*
- *
  *	SMB2 Worker functions follow:
  *
  *	The general structure of the worker functions is:
@@ -859,8 +856,7 @@ add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
  *	5) Decode variable length data area (if any for this SMB2 command type)
  *	6) Call free smb buffer
  *	7) return
- *
- */
+*/
 
 int
 SMB2_negotiate(const unsigned int xid,
@@ -3281,7 +3277,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 }
 
 /*
- *   Individual callers to ioctl worker function follow
+ * Individual callers to ioctl worker function follow
  */
 
 int
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 8cad2a5c516b..ac72d34e1e67 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2009, 2013
+ * Copyright (c) International Business Machines  Corp., 2009, 2013
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *
- */
+*/
 
 #ifndef _SMB2PDU_H
 #define _SMB2PDU_H
@@ -51,8 +49,7 @@ struct smb2_rdma_crypto_transform {
  *  See MS-SMB2.PDF specification for protocol details.
  *  The Naming convention is the lower case version of the SMB2
  *  command code name for the struct. Note that structures must be packed.
- *
- */
+*/
 
 #define COMPOUND_FID 0xFFFFFFFFFFFFFFFFULL
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index c210e1221c9a..a80aceb8b78c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2002, 2011
+ * Copyright (c) International Business Machines  Corp., 2002, 2011
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *
- */
+*/
 #ifndef _SMB2PROTO_H
 #define _SMB2PROTO_H
 #include <linux/nls.h>
diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
index 283bef0ae839..940c07590a00 100644
--- a/fs/cifs/smb2status.h
+++ b/fs/cifs/smb2status.h
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * SMB2 Status code (network error) definitions
+ * Definitions are from MS-ERREF
  *
- *   SMB2 Status code (network error) definitions
- *   Definitions are from MS-ERREF
- *
- *   Copyright (c) International Business Machines  Corp., 2009,2011
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines  Corp., 2009,2011
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 /*
  *  0 1 2 3 4 5 6 7 8 9 0 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 53ff6bc11939..1a0ceecd5170 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ * Copyright (c) International Business Machines Corp., 2002, 2011
  *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org) 2006
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *
- */
+*/
 
 #include <linux/fs.h>
 #include <linux/list.h>
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fbbec22bcc8..a2cf17ac823a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (C) 2017, Microsoft Corporation.
+ * Copyright (c) 2017, Microsoft Corporation.
  *
- *   Author(s): Long Li <longli@microsoft.com>
+ * Author(s): Long Li <longli@microsoft.com>
  */
 #include <linux/module.h>
 #include <linux/highmem.h>
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index f7b98793c664..b42769d56d16 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (C) 2017, Microsoft Corporation.
+ * Copyright (c) 2017, Microsoft Corporation.
  *
- *   Author(s): Long Li <longli@microsoft.com>
+ * Author(s): Long Li <longli@microsoft.com>
  */
 #ifndef _SMBDIRECT_H
 #define _SMBDIRECT_H
diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
index 1d96335a046c..514739487331 100644
--- a/fs/cifs/smberr.h
+++ b/fs/cifs/smberr.h
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
+ * Copyright (c) International Business Machines  Corp., 2002,2004
+ * Author(s): Steve French (sfrench@us.ibm.com)
  *
- *   Copyright (c) International Business Machines  Corp., 2002,2004
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- *   See Error Codes section of the SNIA CIFS Specification
- *   for more information
- *
- */
+ * See Error Codes section of the SNIA CIFS Specification
+ * for more information
+*/
 
 #define SUCCESS	0x00	/* The request was successful. */
 #define ERRDOS	0x01	/* Error is from the core DOS operating system set */
diff --git a/fs/cifs/trace.c b/fs/cifs/trace.c
index 465483787193..2a6ba22b6fd6 100644
--- a/fs/cifs/trace.c
+++ b/fs/cifs/trace.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *   Copyright (C) 2018, Microsoft Corporation.
+ * Copyright (c) 2018, Microsoft Corporation.
  *
- *   Author(s): Steve French <stfrench@microsoft.com>
+ * Author(s): Steve French <stfrench@microsoft.com>
  */
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
index 7b9a85f5b93c..7abf58911d63 100644
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *   Copyright (C) 2018, Microsoft Corporation.
+ * Copyright (c) 2018, Microsoft Corporation.
  *
- *   Author(s): Steve French <stfrench@microsoft.com>
+ * Author(s): Steve French <stfrench@microsoft.com>
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM cifs
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 081dd21b731e..8d24f7d5cd49 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1,11 +1,9 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *   Jeremy Allison (jra@samba.org) 2006.
- *
- */
+ * Copyright (c) International Business Machines Corp., 2002,2008
+ * Author(s): Steve French (sfrench@us.ibm.com)
+ * Jeremy Allison (jra@samba.org) 2006.
+*/
 
 #include <linux/fs.h>
 #include <linux/list.h>
@@ -877,14 +875,12 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 }
 
 /*
- *
  * Send an SMB Request.  No response info (other than return code)
  * needs to be parsed.
  *
  * flags indicate the type of request buffer and how long to wait
  * and whether to log NT STATUS code (error) before mapping it to POSIX error
- *
- */
+*/
 int
 SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 		 char *in_buf, int flags)
diff --git a/fs/cifs/unc.c b/fs/cifs/unc.c
index f6fc5e343ea4..857f3c6f084e 100644
--- a/fs/cifs/unc.c
+++ b/fs/cifs/unc.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Copyright (C) 2020, Microsoft Corporation.
+ * Copyright (c) 2020, Microsoft Corporation.
  *
- *   Author(s): Steve French <stfrench@microsoft.com>
+ * Author(s): Steve French <stfrench@microsoft.com>
  *              Suresh Jayaraman <sjayaraman@suse.de>
  *              Jeff Layton <jlayton@kernel.org>
  */
diff --git a/fs/cifs/winucase.c b/fs/cifs/winucase.c
index 2f075b5b50df..168a3df193b7 100644
--- a/fs/cifs/winucase.c
+++ b/fs/cifs/winucase.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *
  * Copyright (c) Jeffrey Layton <jlayton@redhat.com>, 2013
  *
  * The const tables in this file were converted from the following info
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 9d486fbbfbbd..531bf9d1a2f9 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: LGPL-2.1
 /*
- *
- *   Copyright (c) International Business Machines  Corp., 2003, 2007
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *
- */
+ * Copyright (c) International Business Machines Corp., 2003, 2007
+ * Author(s): Steve French (sfrench@us.ibm.com)
+*/
 
 #include <linux/fs.h>
 #include <linux/posix_acl_xattr.h>
-- 
2.35.3

