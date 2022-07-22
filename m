Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B99C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 17:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiGVRDL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGVRDK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 13:03:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1FE3AB3B
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 10:03:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 978512031F;
        Fri, 22 Jul 2022 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658509387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=wV0JfYSBkAq2sT9GNtGTJIh32aq2pDT1HT3OmRgD3Ls=;
        b=rA2wmkd5jk5c2nyoR3K7orz2a2raoYVAxHyjU0v54pziCv/rcGBn010CQPH/2NQfWEvorQ
        75SAQbSv6WHfnsap10dfsE4vWPMRah5uWFgb5dk5TB0IzMZNPmFwWvt3bHBNuVq9x6SKeE
        QYt7nTzYqHDZcIVQ+wUR56klhDIo5M0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658509387;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=wV0JfYSBkAq2sT9GNtGTJIh32aq2pDT1HT3OmRgD3Ls=;
        b=Lcnpz9RMyk4fVcCTCkjbPML9VceTsHHyn24AOFQaShvYUu2SoZPnh/9vR5JFbnfp9GOOm4
        NEg2XR26fEuGJqDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 16C2113AB3;
        Fri, 22 Jul 2022 17:03:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id X1FgMkrY2mJsMAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 17:03:06 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: list_for_each() -> list_for_each_entry()
Date:   Fri, 22 Jul 2022 14:02:59 -0300
Message-Id: <20220722170259.29437-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Replace list_for_each() by list_for_each_entr() where appropriate.
Remove no longer used list_head stack variables.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c | 48 ++++++++++----------------------------------
 fs/cifs/connect.c    |  5 +----
 fs/cifs/file.c       | 10 +++------
 fs/cifs/misc.c       | 19 +++++-------------
 fs/cifs/smb2ops.c    |  7 ++-----
 5 files changed, 22 insertions(+), 67 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index f5e63dfac2b1..aac4240893af 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -168,7 +168,6 @@ cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 
 static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp, *tmp1, *tmp2;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -184,14 +183,10 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 #endif /* CIFS_DEBUG2 */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		list_for_each(tmp, &server->smb_ses_list) {
-			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-			list_for_each(tmp1, &ses->tcon_list) {
-				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
-				list_for_each(tmp2, &tcon->openFileList) {
-					cfile = list_entry(tmp2, struct cifsFileInfo,
-						     tlist);
+				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 					seq_printf(m,
 						"0x%x 0x%llx 0x%x %d %d %d %pd",
 						tcon->tid,
@@ -218,7 +213,6 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
@@ -381,9 +375,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 		seq_printf(m, "\n\n\tSessions: ");
 		i = 0;
-		list_for_each(tmp2, &server->smb_ses_list) {
-			ses = list_entry(tmp2, struct cifs_ses,
-					 smb_ses_list);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			i++;
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
@@ -447,9 +439,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			else
 				seq_puts(m, "none\n");
 
-			list_for_each(tmp3, &ses->tcon_list) {
-				tcon = list_entry(tmp3, struct cifs_tcon,
-						  tcon_list);
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				++j;
 				seq_printf(m, "\n\t%d) ", j);
 				cifs_debug_tcon(m, tcon);
@@ -474,9 +464,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 		seq_puts(m, "\n\n\tMIDs: ");
 		spin_lock(&GlobalMid_Lock);
-		list_for_each(tmp3, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp3, struct mid_q_entry,
-					qhead);
+		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			seq_printf(m, "\n\tState: %d com: %d pid:"
 					" %d cbdata: %p mid %llu\n",
 					mid_entry->mid_state,
@@ -504,7 +492,6 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 {
 	bool bv;
 	int rc;
-	struct list_head *tmp1, *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -525,9 +512,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		GlobalCurrentXid = 0;
 		spin_unlock(&GlobalMid_Lock);
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp1, &cifs_tcp_ses_list) {
-			server = list_entry(tmp1, struct TCP_Server_Info,
-					    tcp_ses_list);
+		list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 			server->max_in_flight = 0;
 #ifdef CONFIG_CIFS_STATS2
 			for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
@@ -538,13 +523,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				server->fastest_cmd[0] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
-			list_for_each(tmp2, &server->smb_ses_list) {
-				ses = list_entry(tmp2, struct cifs_ses,
-						 smb_ses_list);
-				list_for_each(tmp3, &ses->tcon_list) {
-					tcon = list_entry(tmp3,
-							  struct cifs_tcon,
-							  tcon_list);
+			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);
 					tcon->bytes_read = 0;
@@ -569,7 +549,6 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_CIFS_STATS2
 	int j;
 #endif /* STATS2 */
-	struct list_head *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -619,13 +598,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 					atomic_read(&server->smb2slowcmd[j]),
 					server->hostname, j);
 #endif /* STATS2 */
-		list_for_each(tmp2, &server->smb_ses_list) {
-			ses = list_entry(tmp2, struct cifs_ses,
-					 smb_ses_list);
-			list_for_each(tmp3, &ses->tcon_list) {
-				tcon = list_entry(tmp3,
-						  struct cifs_tcon,
-						  tcon_list);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				i++;
 				seq_printf(m, "\n%d) %s", i, tcon->treeName);
 				if (tcon->need_reconnect)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8859da70cb06..6e670e7c2182 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2257,13 +2257,10 @@ static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 static struct cifs_tcon *
 cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
-	struct list_head *tmp;
 	struct cifs_tcon *tcon;
 
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &ses->tcon_list) {
-		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-
+	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (!match_tcon(tcon, ctx))
 			continue;
 		++tcon->tc_count;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6985710e14c2..967663ad63a0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -928,9 +928,7 @@ int cifs_close(struct inode *inode, struct file *file)
 void
 cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *open_file;
-	struct list_head *tmp;
-	struct list_head *tmp1;
+	struct cifsFileInfo *open_file, *tmp;
 	struct list_head tmp_list;
 
 	if (!tcon->use_persistent || !tcon->need_reopen_files)
@@ -943,8 +941,7 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 
 	/* list all files open on tree connection, reopen resilient handles  */
 	spin_lock(&tcon->open_file_lock);
-	list_for_each(tmp, &tcon->openFileList) {
-		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
+	list_for_each_entry(open_file, &tcon->openFileList, tlist) {
 		if (!open_file->invalidHandle)
 			continue;
 		cifsFileInfo_get(open_file);
@@ -952,8 +949,7 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	list_for_each_safe(tmp, tmp1, &tmp_list) {
-		open_file = list_entry(tmp, struct cifsFileInfo, rlist);
+	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
 		if (cifs_reopen_file(open_file, false /* do not flush */))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 16168ebd1a62..a825cc09a53e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -400,7 +400,6 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 {
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
-	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *pCifsInode;
@@ -467,18 +466,14 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &srv->smb_ses_list) {
-		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-		list_for_each(tmp1, &ses->tcon_list) {
-			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+	list_for_each_entry(ses, &srv->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;
 
 			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
 			spin_lock(&tcon->open_file_lock);
-			list_for_each(tmp2, &tcon->openFileList) {
-				netfile = list_entry(tmp2, struct cifsFileInfo,
-						     tlist);
+			list_for_each_entry(netfile, &tcon->openFileList, tlist) {
 				if (pSMB->Fid != netfile->fid.netfid)
 					continue;
 
@@ -763,14 +758,12 @@ void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *cfile;
-	struct list_head *tmp;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 
 	INIT_LIST_HEAD(&file_head);
 	spin_lock(&tcon->open_file_lock);
-	list_for_each(tmp, &tcon->openFileList) {
-		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
+	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
@@ -793,7 +786,6 @@ void
 cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 {
 	struct cifsFileInfo *cfile;
-	struct list_head *tmp;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 	void *page;
@@ -802,8 +794,7 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 	INIT_LIST_HEAD(&file_head);
 	page = alloc_dentry_path();
 	spin_lock(&tcon->open_file_lock);
-	list_for_each(tmp, &tcon->openFileList) {
-		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
+	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		full_path = build_path_from_dentry(cfile->dentry, page);
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index aa4c1d403708..5bed8b584086 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2575,7 +2575,6 @@ static void
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	struct list_head *tmp, *tmp1;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
@@ -2583,10 +2582,8 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 		return;
 
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-		list_for_each(tmp1, &ses->tcon_list) {
-			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				tcon->need_reconnect = true;
 				spin_unlock(&cifs_tcp_ses_lock);
-- 
2.35.3

