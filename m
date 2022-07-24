Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC433C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiGXPMY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXPMX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF57010FE2
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 847665C982;
        Sun, 24 Jul 2022 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ShDs79B12eYAJ2gjoUY0pW9S885PxmstJF7s2Xd26SM=;
        b=S12RUEZnm7sSv/uSVSCJgHpEM6+vfM1OCWnaF5Og9RTCRkg2eyfV9UXRIfQAi+cT4jAacy
        FC+tJzHeoRxHn9kl5TVYkVgEAd4UHrIHLbdvyKLSbjelKl48oz5wdSvXaH6zc7EoJubDge
        DSAprYVOhBef8j2oaUMP+5I6HXOrHcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ShDs79B12eYAJ2gjoUY0pW9S885PxmstJF7s2Xd26SM=;
        b=EGRzR8xztIrM3uo82ra4iH/XIsOO85wjnWMJoWsoYwRTHHx33hwKp8aKOQUPkkYYqyHBhL
        EVOkS0xFZyE+SLBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0530513A8D;
        Sun, 24 Jul 2022 15:12:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZBxKLlNh3WJVMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:19 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 09/14] cifs: typedef tcon status enum
Date:   Sun, 24 Jul 2022 12:11:32 -0300
Message-Id: <20220724151137.7538-10-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

typedef "enum tid_status_enum" to "cifs_tcon_status_t".
Rename the status values.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsfs.c   |  4 ++--
 fs/cifs/cifsglob.h | 22 +++++++++++-----------
 fs/cifs/cifssmb.c  | 11 ++++++-----
 fs/cifs/connect.c  | 32 ++++++++++++++++----------------
 fs/cifs/misc.c     |  2 +-
 fs/cifs/smb2pdu.c  |  4 ++--
 6 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6db4b008dbb1..a8eb41657859 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -712,14 +712,14 @@ static void cifs_umount_begin(struct super_block *sb)
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&g_servers_lock);
-	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
+	if ((tcon->tc_count > 1) || (tcon->status == TCON_STATUS_EXITING)) {
 		/* we have other mounts to same share or we have
 		   already tried to force umount this and woken up
 		   all waiting network requests, nothing to do */
 		spin_unlock(&g_servers_lock);
 		return;
 	} else if (tcon->tc_count == 1)
-		tcon->status = TID_EXITING;
+		tcon->status = TCON_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0fa23f392bb9..dddd63b6dc82 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -130,16 +130,16 @@ typedef enum {
 } cifs_ses_status_t;
 
 /* associated with each tree connection to the server */
-enum tid_status_enum {
-	TID_NEW = 0,
-	TID_GOOD,
-	TID_EXITING,
-	TID_NEED_RECON,
-	TID_NEED_TCON,
-	TID_IN_TCON,
-	TID_NEED_FILES_INVALIDATE, /* currently unused */
-	TID_IN_FILES_INVALIDATE
-};
+typedef enum {
+	TCON_STATUS_NEW = 0,
+	TCON_STATUS_GOOD,
+	TCON_STATUS_EXITING,
+	TCON_STATUS_NEED_RECONNECT,
+	TCON_STATUS_NEED_TCON,
+	TCON_STATUS_IN_TCON,
+	TCON_STATUS_NEED_FILES_INVALIDATE, /* currently unused */
+	TCON_STATUS_IN_FILES_INVALIDATE
+} cifs_tcon_status_t;
 
 enum securityEnum {
 	Unspecified = 0,	/* not specified */
@@ -1179,7 +1179,7 @@ struct cifs_tcon {
 	char *password;		/* for share-level security */
 	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
-	enum tid_status_enum status;
+	cifs_tcon_status_t status;
 	atomic_t num_smbs_sent;
 	union {
 		struct {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 25009dd47f96..e286bb535c5d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -75,11 +75,12 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if ((tcon->ses->status != SES_STATUS_GOOD) || (tcon->status != TID_NEED_RECON)) {
+	if ((tcon->ses->status != SES_STATUS_GOOD) ||
+	    (tcon->status != TCON_STATUS_NEED_RECONNECT)) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
-	tcon->status = TID_IN_FILES_INVALIDATE;
+	tcon->status = TCON_STATUS_IN_FILES_INVALIDATE;
 	spin_unlock(&g_servers_lock);
 
 	/* list all files open on tree connection and mark them invalid */
@@ -99,8 +100,8 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	mutex_unlock(&tcon->crfid.fid_mutex);
 
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_IN_FILES_INVALIDATE)
-		tcon->status = TID_NEED_TCON;
+	if (tcon->status == TCON_STATUS_IN_FILES_INVALIDATE)
+		tcon->status = TCON_STATUS_NEED_TCON;
 	spin_unlock(&g_servers_lock);
 
 	/*
@@ -135,7 +136,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * have tcon) are allowed as we start force umount
 	 */
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_EXITING) {
+	if (tcon->status == TCON_STATUS_EXITING) {
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 55264aef1b83..467f1b598eec 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -281,7 +281,7 @@ cifs_mark_server_conns_for_reconnect(struct cifs_server_info *server,
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
-			tcon->status = TID_NEED_RECON;
+			tcon->status = TCON_STATUS_NEED_RECONNECT;
 		}
 		if (ses->tcon_ipc)
 			ses->tcon_ipc->need_reconnect = true;
@@ -2237,7 +2237,7 @@ cifs_get_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 
 static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
-	if (tcon->status == TID_EXITING)
+	if (tcon->status == TCON_STATUS_EXITING)
 		return 0;
 	if (strncmp(tcon->treeName, ctx->UNC, MAX_TREE_SIZE))
 		return 0;
@@ -4560,12 +4560,12 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
 	if (tcon->ses->status != SES_STATUS_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	    (tcon->status != TCON_STATUS_NEW &&
+	    tcon->status != TCON_STATUS_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	tcon->status = TID_IN_TCON;
+	tcon->status = TCON_STATUS_IN_TCON;
 	spin_unlock(&g_servers_lock);
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
@@ -4606,13 +4606,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	if (rc) {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+		if (tcon->status == TCON_STATUS_IN_TCON)
+			tcon->status = TCON_STATUS_NEED_TCON;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_GOOD;
+		if (tcon->status == TCON_STATUS_IN_TCON)
+			tcon->status = TCON_STATUS_GOOD;
 		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
@@ -4628,24 +4628,24 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
 	if (tcon->ses->status != SES_STATUS_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	    (tcon->status != TCON_STATUS_NEW &&
+	    tcon->status != TCON_STATUS_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	tcon->status = TID_IN_TCON;
+	tcon->status = TCON_STATUS_IN_TCON;
 	spin_unlock(&g_servers_lock);
 
 	rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
 	if (rc) {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+		if (tcon->status == TCON_STATUS_IN_TCON)
+			tcon->status = TCON_STATUS_NEED_TCON;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_GOOD;
+		if (tcon->status == TCON_STATUS_IN_TCON)
+			tcon->status = TCON_STATUS_GOOD;
 		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index e209aa3194de..c37ad2bb3ac4 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -124,7 +124,7 @@ tconInfoAlloc(void)
 	mutex_init(&ret_buf->crfid.dirents.de_mutex);
 
 	atomic_inc(&g_tcon_alloc_count);
-	ret_buf->status = TID_NEW;
+	ret_buf->status = TCON_STATUS_NEW;
 	++ret_buf->tc_count;
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e495121f7d99..73d28b2b4517 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -163,7 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		return 0;
 
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_EXITING) {
+	if (tcon->status == TCON_STATUS_EXITING) {
 		/*
 		 * only tree disconnect, open, and write,
 		 * (and ulogoff which does not have tcon)
@@ -3873,7 +3873,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		goto done;
 	}
 
-	tcon->status = TID_GOOD;
+	tcon->status = TCON_STATUS_GOOD;
 	tcon->retry = false;
 	tcon->need_reconnect = false;
 
-- 
2.35.3

