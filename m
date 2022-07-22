Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50521C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 22:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiGVWnH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 18:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiGVWnF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 18:43:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18EBC8D
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 15:43:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5479338278;
        Fri, 22 Jul 2022 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658529783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5+1D+rOEQ8qSiyVt2pQPIfWltvv1vG4L24y8yru/Lc=;
        b=IguS5IhNRK3PwJPkLSFAE3ghZbDUP5thwQ8sCf63esQDhUMKP1Pfk8aLaBcVDYX3pfkStU
        GFEA1GUD439V3P6tPHcIMGKX/1nneEmQ3fsBdL23Y/Zc7bJ0nirFdY7NQWRLp5u+lT1pMa
        /hvv5XbqqIZnZ4mKv3MwE+KgJh52jEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658529783;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5+1D+rOEQ8qSiyVt2pQPIfWltvv1vG4L24y8yru/Lc=;
        b=oY4YQ2MZ64NAKnzc2wv47mRusESy1fm3JMJojpHsb77BNDF38efThG/TiSzyB4SuoFX2r/
        ywZFWGokrjn0AmAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5F1C134A9;
        Fri, 22 Jul 2022 22:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AieOIfYn22KFIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 22:43:02 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH 2/4] cifs: standardize SPDX header comment
Date:   Fri, 22 Jul 2022 19:42:52 -0300
Message-Id: <20220722224254.8738-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220722224254.8738-1-ematsumiya@suse.de>
References: <20220722224254.8738-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use "//" comments for SPDX header since it seems to be most common (at
least among kernel files) than the "/* ... */" variant.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_fs_sb.h   | 2 +-
 fs/cifs/cifs_ioctl.h   | 2 +-
 fs/cifs/cifs_spnego.h  | 2 +-
 fs/cifs/cifs_swn.h     | 2 +-
 fs/cifs/cifs_unicode.h | 2 +-
 fs/cifs/cifs_uniupr.h  | 2 +-
 fs/cifs/cifsacl.h      | 2 +-
 fs/cifs/cifsfs.h       | 2 +-
 fs/cifs/cifsglob.h     | 3 +--
 fs/cifs/cifspdu.h      | 2 +-
 fs/cifs/dfs_cache.h    | 2 +-
 fs/cifs/dns_resolve.h  | 2 +-
 fs/cifs/fs_context.h   | 2 +-
 fs/cifs/fscache.h      | 2 +-
 fs/cifs/netlink.h      | 2 +-
 fs/cifs/nterr.h        | 2 +-
 fs/cifs/ntlmssp.h      | 2 +-
 fs/cifs/rfc1002pdu.h   | 2 +-
 fs/cifs/smb2glob.h     | 2 +-
 fs/cifs/smb2pdu.h      | 2 +-
 fs/cifs/smb2proto.h    | 2 +-
 fs/cifs/smb2status.h   | 2 +-
 fs/cifs/smbdirect.h    | 2 +-
 fs/cifs/smberr.h       | 2 +-
 fs/cifs/trace.h        | 2 +-
 25 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 013a4bd65280..7317534ac410 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002,2004
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index 03e6531998b0..bf2850b54f3b 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Structure definitions for io control for cifs/smb3
diff --git a/fs/cifs/cifs_spnego.h b/fs/cifs/cifs_spnego.h
index 7f102ffeb675..3819940e2ab5 100644
--- a/fs/cifs/cifs_spnego.h
+++ b/fs/cifs/cifs_spnego.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *   SPNEGO upcall management for CIFS
  *
diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
index 8a9d2a5c9077..934cbd7bb3ce 100644
--- a/fs/cifs/cifs_swn.h
+++ b/fs/cifs/cifs_swn.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Witness Service client for CIFS
  *
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 80b3d845419f..9bad387d2bff 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * cifs_unicode:  Unicode kernel case support
  *
diff --git a/fs/cifs/cifs_uniupr.h b/fs/cifs/cifs_uniupr.h
index 7b272fcdf0d3..529bd690fd91 100644
--- a/fs/cifs/cifs_uniupr.h
+++ b/fs/cifs/cifs_uniupr.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (c) International Business Machines  Corp., 2000,2002
  *
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index f7037fd03886..6c051b3ae922 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2007
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index d7f4917c191d..deef6c8d0dc3 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002, 2007
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 721799b9a7a9..65c7e5b55278 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1,6 +1,5 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
- *
  *   Copyright (C) International Business Machines  Corp., 2002,2008
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org)
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d869e1ed3648..d3c5e3d23385 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002,2009
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index 52070d1df189..490aa28eec38 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * DFS referral cache routines
  *
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index afc0df381246..5a617278a669 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *   DNS Resolver upcall management for CIFS DFS
  *   Handles host name to IP address resolution
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 5f093cb7e9b9..ec4a8af72570 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2020, Microsoft Corporation.
  *
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index aa3b941a5555..435e826fdd9a 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *   CIFS filesystem cache interface definitions
  *
diff --git a/fs/cifs/netlink.h b/fs/cifs/netlink.h
index e2fa8ed24c54..8c4e680eb41f 100644
--- a/fs/cifs/netlink.h
+++ b/fs/cifs/netlink.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Netlink routines for CIFS
  *
diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
index edd4741cab0a..0a35538dd338 100644
--- a/fs/cifs/nterr.h
+++ b/fs/cifs/nterr.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
    Unix SMB/Netbios implementation.
    Version 1.9.
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 55758b9ec877..7a00acffa6ea 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002,2007
diff --git a/fs/cifs/rfc1002pdu.h b/fs/cifs/rfc1002pdu.h
index ae1d025da294..b32940b2b2bf 100644
--- a/fs/cifs/rfc1002pdu.h
+++ b/fs/cifs/rfc1002pdu.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Protocol Data Unit definitions for RFC 1001/1002 support
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 82e916ad167c..c240ce7bc0ed 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Definitions for various global variables and structures
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 286044850e85..8cad2a5c516b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2009, 2013
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a69f1eed1cfe..c210e1221c9a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002, 2011
diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
index a9e958166fc5..283bef0ae839 100644
--- a/fs/cifs/smb2status.h
+++ b/fs/cifs/smb2status.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   SMB2 Status code (network error) definitions
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a87fca82a796..f7b98793c664 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2017, Microsoft Corporation.
  *
diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
index aeffdad829e2..1d96335a046c 100644
--- a/fs/cifs/smberr.h
+++ b/fs/cifs/smberr.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  *   Copyright (c) International Business Machines  Corp., 2002,2004
diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
index 6b88dc2e364f..7b9a85f5b93c 100644
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  *   Copyright (C) 2018, Microsoft Corporation.
  *
-- 
2.35.3

