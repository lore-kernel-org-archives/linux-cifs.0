Return-Path: <SRS0=zgNb=YW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991E5CA9EC3
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 23:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5856A2086D
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 23:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ikrw4vMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfJ2Xv0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:51:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34076 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xv0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Oct 2019 19:51:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id e4so206889pgs.1
        for <linux-cifs@vger.kernel.org>; Tue, 29 Oct 2019 16:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=C5/Z9eSPKztv2rmtpB2ZD1w+utPQMJDvRI5rxk9DGyI=;
        b=Ikrw4vMK9h6uaZFjNltl8JIzsRivnPrYtrcgow1w+7Cz6Sz6+QWhhStzqdxTt33P0Z
         IkQ7QR7eukQSbPxX5wRG4c4tmmm7ENpk4ZKX1eGsxAdIW9niSL2kmHC4WS4oKQlruWVz
         Qf8MtTwsQSxFuLw3Vw7HW5yql8gf5S+uyHWGWWM3CRpbtRLx26VCpEV5esrK5OGw+Yn6
         8YGBlesASdFzfHfI3XaLsBKj3sUJsJARuq/0Q2cr3HZDEqCZNMValQc6SLNCqQLWfbHw
         aqlYp4Y58D9aZt7shYyIReS3f3P1/q6Tjav9u8BlFwI3pogB3/VujuJ7IpR37SsAjQNw
         bn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=C5/Z9eSPKztv2rmtpB2ZD1w+utPQMJDvRI5rxk9DGyI=;
        b=isofoDxAasVlrM0pi/4c5iafHaaGegUNEiGMdzESLWm52Ljxqwh7ffBvJ0Vq+OmxMO
         daknBkMTwc0WsPV6bYIHuAuY7RXJGfJeN4iD6giCkxiisPQ779YrjJVmcGD4hzK0Vkhr
         22ePxblez5fN8nx0O5Dpa/gnY7b7YXqOdgSixtzu6MsaLEX0osclzstF51l55Vnvw9kC
         YDXZ8p6ZvYbEtKFw550bIiBRv/koECkkrwQdUVnnundE7zcJCqkdt6T/BodElgyFCfDS
         bbQrbvnqqUqj2RoiLSVcHLSOfd7FxnHpJcm87g5eBq33zjQ1bHGDk1OaPSeBAtC3jFc3
         0GiQ==
X-Gm-Message-State: APjAAAXNS2MovRWWlDiBX/ks3s/QFWlICPNZCiUXDjDK+WbLrGWHbgoS
        VEShmI0Ka+r4L3Isgh5eFhNuFps=
X-Google-Smtp-Source: APXvYqwRUZEdfr/Rzi+jxn5GHWF6LWu6t1OVKWJYH16PTXEkTslF35DrKVXLnOzynkqYmqut6vrCvQ==
X-Received: by 2002:a62:8705:: with SMTP id i5mr703523pfe.238.1572393084698;
        Tue, 29 Oct 2019 16:51:24 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id v6sm234341pfe.104.2019.10.29.16.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:51:23 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: [PATCH] CIFS: Properly process SMB3 lease breaks
Date:   Tue, 29 Oct 2019 16:51:19 -0700
Message-Id: <20191029235119.29210-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currenly we doesn't assume that a server may break a lease
from RWH to RW which causes us setting a wrong lease state
on a file and thus mistakenly flushing data and byte-range
locks and purging cached data on the client. This leads to
performance degradation because subsequent IOs go directly
to the server.

Fix this by propagating new lease state and epoch values
to the oplock break handler through cifsFileInfo structure
and removing the use of cifsInodeInfo flags for that. It
allows to avoid some races of several lease/oplock breaks
using those flags in parallel.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h |  9 ++++++---
 fs/cifs/file.c     | 10 +++++++---
 fs/cifs/misc.c     | 17 +++--------------
 fs/cifs/smb1ops.c  |  8 +++-----
 fs/cifs/smb2misc.c | 32 +++++++-------------------------
 fs/cifs/smb2ops.c  | 44 ++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h  |  2 +-
 7 files changed, 57 insertions(+), 65 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5ef5a16c01d2..12b356b3799b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -268,8 +268,9 @@ struct smb_version_operations {
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
 	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
-	void (*downgrade_oplock)(struct TCP_Server_Info *,
-					struct cifsInodeInfo *, bool);
+	void (*downgrade_oplock)(struct TCP_Server_Info *server,
+				 struct cifsInodeInfo *cinode, __u32 oplock,
+				 unsigned int epoch, bool *purge_cache);
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
@@ -1248,6 +1249,8 @@ struct cifsFileInfo {
 	unsigned int f_flags;
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool oplock_break_cancelled:1;
+	unsigned int oplock_epoch; /* epoch from the lease break */
+	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
@@ -1388,7 +1391,7 @@ struct cifsInodeInfo {
 	unsigned int epoch;		/* used to track lease state changes */
 #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
 #define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
-#define CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2 (2) /* Downgrade oplock to L2 */
+#define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
 #define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
 #define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
 #define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 53dbb6e0d390..b6f544bc6c73 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4568,12 +4568,13 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
+	bool purge_cache = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
-	server->ops->downgrade_oplock(server, cinode,
-		test_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cinode->flags));
+	server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
+				      cfile->oplock_epoch, &purge_cache);
 
 	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
 						cifs_has_mand_locks(cinode)) {
@@ -4588,18 +4589,21 @@ void cifs_oplock_break(struct work_struct *work)
 		else
 			break_lease(inode, O_WRONLY);
 		rc = filemap_fdatawrite(inode->i_mapping);
-		if (!CIFS_CACHE_READ(cinode)) {
+		if (!CIFS_CACHE_READ(cinode) || purge_cache) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_zap_mapping(inode);
 		}
 		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
+		if (CIFS_CACHE_WRITE(cinode))
+			goto oplock_break_ack;
 	}
 
 	rc = cifs_push_locks(cfile);
 	if (rc)
 		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
+oplock_break_ack:
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5ad83bdb9bea..40ca394fd5de 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -488,21 +488,10 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
 					&pCifsInode->flags);
 
-				/*
-				 * Set flag if the server downgrades the oplock
-				 * to L2 else clear.
-				 */
-				if (pSMB->OplockLevel)
-					set_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &pCifsInode->flags);
-				else
-					clear_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &pCifsInode->flags);
-
-				cifs_queue_oplock_break(netfile);
+				netfile->oplock_epoch = 0;
+				netfile->oplock_level = pSMB->OplockLevel;
 				netfile->oplock_break_cancelled = false;
+				cifs_queue_oplock_break(netfile);
 
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b7421a096319..ebd59ab324d5 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -366,12 +366,10 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 
 static void
 cifs_downgrade_oplock(struct TCP_Server_Info *server,
-			struct cifsInodeInfo *cinode, bool set_level2)
+		      struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
 {
-	if (set_level2)
-		cifs_set_oplock_level(cinode, OPLOCK_READ);
-	else
-		cifs_set_oplock_level(cinode, 0);
+	cifs_set_oplock_level(cinode, oplock);
 }
 
 static bool
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index e311f58dc1c8..8db6201b18ba 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -534,7 +534,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 
 		cifs_dbg(FYI, "found in the open list\n");
 		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
-			 le32_to_cpu(rsp->NewLeaseState));
+			 lease_state);
 
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
@@ -543,17 +543,8 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 
 		set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
 
-		/*
-		 * Set or clear flags depending on the lease state being READ.
-		 * HANDLE caching flag should be added when the client starts
-		 * to defer closing remote file handles with HANDLE leases.
-		 */
-		if (lease_state & SMB2_LEASE_READ_CACHING_HE)
-			set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-				&cinode->flags);
-		else
-			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-				  &cinode->flags);
+		cfile->oplock_epoch = le16_to_cpu(rsp->Epoch);
+		cfile->oplock_level = lease_state;
 
 		cifs_queue_oplock_break(cfile);
 		kfree(lw);
@@ -576,7 +567,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 
 		cifs_dbg(FYI, "found in the pending open list\n");
 		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
-			 le32_to_cpu(rsp->NewLeaseState));
+			 lease_state);
 
 		open->oplock = lease_state;
 	}
@@ -699,18 +690,9 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
 					&cinode->flags);
 
-				/*
-				 * Set flag if the server downgrades the oplock
-				 * to L2 else clear.
-				 */
-				if (rsp->OplockLevel)
-					set_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &cinode->flags);
-				else
-					clear_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &cinode->flags);
+				cfile->oplock_epoch = 0;
+				cfile->oplock_level = rsp->OplockLevel;
+
 				spin_unlock(&cfile->file_info_lock);
 
 				cifs_queue_oplock_break(cfile);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7e8e8826c26f..3bbb65e58dd6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3249,22 +3249,38 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 
 static void
 smb2_downgrade_oplock(struct TCP_Server_Info *server,
-			struct cifsInodeInfo *cinode, bool set_level2)
+		      struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
 {
-	if (set_level2)
-		server->ops->set_oplock_level(cinode, SMB2_OPLOCK_LEVEL_II,
-						0, NULL);
-	else
-		server->ops->set_oplock_level(cinode, 0, 0, NULL);
+	server->ops->set_oplock_level(cinode, oplock, 0, NULL);
 }
 
 static void
-smb21_downgrade_oplock(struct TCP_Server_Info *server,
-		       struct cifsInodeInfo *cinode, bool set_level2)
+smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
+		       unsigned int epoch, bool *purge_cache);
+
+static void
+smb3_downgrade_oplock(struct TCP_Server_Info *server,
+		       struct cifsInodeInfo *cinode, __u32 oplock,
+		       unsigned int epoch, bool *purge_cache)
 {
-	server->ops->set_oplock_level(cinode,
-				      set_level2 ? SMB2_LEASE_READ_CACHING_HE :
-				      0, 0, NULL);
+	unsigned int old_state = cinode->oplock;
+	unsigned int old_epoch = cinode->epoch;
+	unsigned int new_state;
+
+	if (epoch > old_epoch) {
+		smb21_set_oplock_level(cinode, oplock, 0, NULL);
+		cinode->epoch = epoch;
+	}
+
+	new_state = cinode->oplock;
+	*purge_cache = false;
+
+	if ((old_state & CIFS_CACHE_READ_FLG) != 0 &&
+	    (new_state & CIFS_CACHE_READ_FLG) == 0)
+		*purge_cache = true;
+	else if (old_state == new_state && (epoch - old_epoch > 1))
+		*purge_cache = true;
 }
 
 static void
@@ -4449,7 +4465,7 @@ struct smb_version_operations smb21_operations = {
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,
@@ -4549,7 +4565,7 @@ struct smb_version_operations smb30_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
@@ -4657,7 +4673,7 @@ struct smb_version_operations smb311_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 747de9317659..26b663de1122 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1383,7 +1383,7 @@ struct smb2_oplock_break {
 struct smb2_lease_break {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 44 */
-	__le16 Reserved;
+	__le16 Epoch;
 	__le32 Flags;
 	__u8   LeaseKey[16];
 	__le32 CurrentLeaseState;
-- 
2.17.1

