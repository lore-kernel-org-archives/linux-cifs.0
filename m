Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5812C43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGXPMq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXPMp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0F010FC4
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B28CF35066;
        Sun, 24 Jul 2022 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBZdal7gGPsSY+bH8sEouahPuMrwOtVXUYueC3vp5LQ=;
        b=l/LTQadWazmpY2oHGz94av2qbPKwrxM0JlFNo57gCO8IvqcSA9IN4rZkkeryxhEVdTWRCT
        7is3GeSZS6l3aA2ES0HdYhFCABVJcTRiRMK/1hIPHpXdidknMURK0wuCRXP544tEDdmzEq
        I3t/uMG/CbRpo8xDnYpZk8n4HR4VCO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBZdal7gGPsSY+bH8sEouahPuMrwOtVXUYueC3vp5LQ=;
        b=O7trB1VnufiDko/9+J0ItZxMo17TjJJZXoDADXvU9MtHlhreXinXzTd0uh5K1fftJ4ZrBN
        iTeaf5q9DdTc2FCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A763213A8D;
        Sun, 24 Jul 2022 15:12:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kQOyGWZh3WJxMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:38 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 14/14] cifs: rename more list_heads, remove redundant prefixes
Date:   Sun, 24 Jul 2022 12:11:37 -0300
Message-Id: <20220724151137.7538-15-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename more list_heads to better represent whether they're a list entry
or a "real" list.

Remove smb_rqst "rq_" field prefixes.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   |  30 +++----
 fs/cifs/cifsglob.h      |  14 +--
 fs/cifs/cifssmb.c       |  36 ++++----
 fs/cifs/connect.c       |   8 +-
 fs/cifs/dfs_cache.c     | 158 ++++++++++++++++----------------
 fs/cifs/dfs_cache.h     |  40 ++++-----
 fs/cifs/misc.c          |  10 +--
 fs/cifs/smb1ops.c       |   2 +-
 fs/cifs/smb2inode.c     |  52 +++++------
 fs/cifs/smb2ops.c       | 184 ++++++++++++++++++-------------------
 fs/cifs/smb2pdu.c       | 194 ++++++++++++++++++++--------------------
 fs/cifs/smb2transport.c |  28 +++---
 fs/cifs/smbdirect.c     |  18 ++--
 fs/cifs/transport.c     |  64 ++++++-------
 14 files changed, 419 insertions(+), 419 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 8a2b882de76d..f653d42ff936 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -30,8 +30,8 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 {
 	int i;
 	int rc;
-	struct kvec *iov = rqst->rq_iov;
-	int n_vec = rqst->rq_nvec;
+	struct kvec *iov = rqst->iov;
+	int n_vec = rqst->nvec;
 	int is_smb2 = server->vals->header_preamble_size == 0;
 
 	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
@@ -63,23 +63,23 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 	}
 
 	/* now hash over the rq_pages array */
-	for (i = 0; i < rqst->rq_npages; i++) {
+	for (i = 0; i < rqst->npages; i++) {
 		void *kaddr;
 		unsigned int len, offset;
 
 		rqst_page_get_length(rqst, i, &len, &offset);
 
-		kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;
+		kaddr = (char *) kmap(rqst->pages[i]) + offset;
 
 		rc = crypto_shash_update(shash, kaddr, len);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update with payload\n",
 				 __func__);
-			kunmap(rqst->rq_pages[i]);
+			kunmap(rqst->pages[i]);
 			return rc;
 		}
 
-		kunmap(rqst->rq_pages[i]);
+		kunmap(rqst->pages[i]);
 	}
 
 	rc = crypto_shash_final(shash, signature);
@@ -101,7 +101,7 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 {
 	int rc;
 
-	if (!rqst->rq_iov || !signature || !server)
+	if (!rqst->iov || !signature || !server)
 		return -EINVAL;
 
 	rc = cifs_alloc_hash("md5", &server->secmech.md5,
@@ -132,10 +132,10 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server,
 {
 	int rc = 0;
 	char smb_signature[20];
-	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->iov[0].iov_base;
 
-	if (rqst->rq_iov[0].iov_len != 4 ||
-	    rqst->rq_iov[0].iov_base + 4 != rqst->rq_iov[1].iov_base)
+	if (rqst->iov[0].iov_len != 4 ||
+	    rqst->iov[0].iov_base + 4 != rqst->iov[1].iov_base)
 		return -EIO;
 
 	if ((cifs_pdu == NULL) || (server == NULL))
@@ -173,8 +173,8 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server,
 int cifs_sign_smbv(struct kvec *iov, int n_vec, struct cifs_server_info *server,
 		   __u32 *pexpected_response_sequence)
 {
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = n_vec };
+	struct smb_rqst rqst = { .iov = iov,
+				 .nvec = n_vec };
 
 	return cifs_sign_rqst(&rqst, server, pexpected_response_sequence);
 }
@@ -201,10 +201,10 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	unsigned int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
-	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->iov[0].iov_base;
 
-	if (rqst->rq_iov[0].iov_len != 4 ||
-	    rqst->rq_iov[0].iov_base + 4 != rqst->rq_iov[1].iov_base)
+	if (rqst->iov[0].iov_len != 4 ||
+	    rqst->iov[0].iov_base + 4 != rqst->iov[1].iov_base)
 		return -EIO;
 
 	if (cifs_pdu == NULL || server == NULL)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5ead24f9965b..0bb343c86fdf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -208,13 +208,13 @@ struct cifs_cred {
  * to start at the beginning of the first page.
  */
 struct smb_rqst {
-	struct kvec	*rq_iov;	/* array of kvecs */
-	unsigned int	rq_nvec;	/* number of kvecs in array */
-	struct page	**rq_pages;	/* pointer to array of page ptrs */
-	unsigned int	rq_offset;	/* the offset to the 1st page */
-	unsigned int	rq_npages;	/* number pages in array */
-	unsigned int	rq_pagesz;	/* page size to use */
-	unsigned int	rq_tailsz;	/* length of last page */
+	struct kvec	*iov;		/* array of kvecs */
+	unsigned int	nvec;		/* number of kvecs in array */
+	struct page	**pages;	/* pointer to array of page ptrs */
+	unsigned int	offset;		/* the offset to the 1st page */
+	unsigned int	npages;		/* number pages in array */
+	unsigned int	pagesz;		/* page size to use */
+	unsigned int	tailsz;		/* length of last page */
 };
 
 struct mid_q_entry;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index dcad67d8f165..7ee1838de8f3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -695,8 +695,8 @@ CIFSSMBEcho(struct cifs_server_info *server)
 	ECHO_REQ *smb;
 	int rc = 0;
 	struct kvec iov[2];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 2 };
+	struct smb_rqst rqst = { .iov = iov,
+				 .nvec = 2 };
 
 	cifs_dbg(FYI, "In echo request\n");
 
@@ -1564,13 +1564,13 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct cifs_server_info *server = tcon->ses->server;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 2,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+	struct smb_rqst rqst = { .iov = rdata->iov,
+				 .nvec = 2,
+				 .pages = rdata->pages,
+				 .offset = rdata->page_offset,
+				 .npages = rdata->nr_pages,
+				 .pagesz = rdata->pagesz,
+				 .tailsz = rdata->tailsz };
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u\n",
@@ -1620,8 +1620,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	READ_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 2 };
+	struct smb_rqst rqst = { .iov = rdata->iov,
+				 .nvec = 2 };
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
 		 __func__, rdata->offset, rdata->bytes);
@@ -2184,13 +2184,13 @@ cifs_async_writev(struct cifs_writedata *wdata,
 	iov[1].iov_len = get_rfc1002_length(smb) + 1;
 	iov[1].iov_base = (char *)smb + 4;
 
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
-	rqst.rq_pages = wdata->pages;
-	rqst.rq_offset = wdata->page_offset;
-	rqst.rq_npages = wdata->nr_pages;
-	rqst.rq_pagesz = wdata->pagesz;
-	rqst.rq_tailsz = wdata->tailsz;
+	rqst.iov = iov;
+	rqst.nvec = 2;
+	rqst.pages = wdata->pages;
+	rqst.offset = wdata->page_offset;
+	rqst.npages = wdata->nr_pages;
+	rqst.pagesz = wdata->pagesz;
+	rqst.tailsz = wdata->tailsz;
 
 	cifs_dbg(FYI, "async write at %llu %u bytes\n",
 		 wdata->offset, wdata->bytes);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18b343389a9d..b4688c11ec06 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -551,7 +551,7 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 	} while (server->status == SERVER_STATUS_NEED_RECONNECT);
 
 	if (target_hint)
-		dfs_cache_noreq_update_tgthint(refpath, target_hint);
+		dfs_cache_noreq_update_tgt_hint(refpath, target_hint);
 
 	dfs_cache_free_tgts(&tl);
 
@@ -3580,7 +3580,7 @@ static int connect_dfs_target(struct mount_ctx *mnt_ctx, const char *full_path,
 	if (!rc) {
 		if (cifs_is_referral_server(mnt_ctx->tcon, &ref))
 			set_root_ses(mnt_ctx);
-		rc = dfs_cache_update_tgthint(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
+		rc = dfs_cache_update_tgt_hint(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
 					      cifs_remap(cifs_sb), ref_path, tit);
 	}
 
@@ -4496,7 +4496,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
 			if (rc)
 				continue;
-			rc = dfs_cache_noreq_update_tgthint(server->current_fullpath + 1, tit);
+			rc = dfs_cache_noreq_update_tgt_hint(server->current_fullpath + 1, tit);
 			if (!rc)
 				rc = cifs_update_super_prepath(cifs_sb, prefix);
 		} else {
@@ -4506,7 +4506,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 
 			if (!rc) {
 				rc = -EREMOTE;
-				list_replace_init(&ntl.tl_list, &tl->tl_list);
+				list_replace_init(&ntl.list, &tl->list);
 			} else
 				dfs_cache_free_tgts(&ntl);
 		}
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index eb5539b32d74..4d2cf8719a6b 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -32,11 +32,11 @@
 struct cache_dfs_tgt {
 	char *name;
 	int path_consumed;
-	struct list_head list;
+	struct list_head head;
 };
 
 struct cache_entry {
-	struct hlist_node hlist;
+	struct hlist_node node;
 	const char *path;
 	int hdr_flags; /* RESP_GET_DFS_REFERRAL.ReferralHeaderFlags */
 	int ttl; /* DFS_REREFERRAL_V3.TimeToLive */
@@ -44,14 +44,14 @@ struct cache_entry {
 	int ref_flags; /* DFS_REREFERRAL_V3.ReferralEntryFlags */
 	struct timespec64 etime;
 	int path_consumed; /* RESP_GET_DFS_REFERRAL.PathConsumed */
-	int numtgts;
-	struct list_head tlist;
-	struct cache_dfs_tgt *tgthint;
+	int num_tgts;
+	struct list_head tgt_list;
+	struct cache_dfs_tgt *tgt_hint;
 };
 
 /* List of referral server sessions per dfs mount */
 struct mount_group {
-	struct list_head list;
+	struct list_head head;
 	uuid_t id;
 	struct cifs_ses *sessions[CACHE_MAX_ENTRIES];
 	int num_sessions;
@@ -118,7 +118,7 @@ static void mount_group_release(struct kref *kref)
 	struct mount_group *mg = container_of(kref, struct mount_group, refcount);
 
 	mutex_lock(&mount_group_list_lock);
-	list_del(&mg->list);
+	list_del(&mg->head);
 	mutex_unlock(&mount_group_list_lock);
 	__mount_group_release(mg);
 }
@@ -127,7 +127,7 @@ static struct mount_group *find_mount_group_locked(const uuid_t *id)
 {
 	struct mount_group *mg;
 
-	list_for_each_entry(mg, &mount_group_list, list) {
+	list_for_each_entry(mg, &mount_group_list, head) {
 		if (uuid_equal(&mg->id, id))
 			return mg;
 	}
@@ -149,7 +149,7 @@ static struct mount_group *__get_mount_group_locked(const uuid_t *id)
 	uuid_copy(&mg->id, id);
 	mg->num_sessions = 0;
 	spin_lock_init(&mg->lock);
-	list_add(&mg->list, &mount_group_list);
+	list_add(&mg->head, &mount_group_list);
 	return mg;
 }
 
@@ -170,8 +170,8 @@ static void free_mount_group_list(void)
 {
 	struct mount_group *mg, *tmp_mg;
 
-	list_for_each_entry_safe(mg, tmp_mg, &mount_group_list, list) {
-		list_del_init(&mg->list);
+	list_for_each_entry_safe(mg, tmp_mg, &mount_group_list, head) {
+		list_del_init(&mg->head);
 		__mount_group_release(mg);
 	}
 }
@@ -229,8 +229,8 @@ static inline void free_tgts(struct cache_entry *ce)
 {
 	struct cache_dfs_tgt *t, *n;
 
-	list_for_each_entry_safe(t, n, &ce->tlist, list) {
-		list_del(&t->list);
+	list_for_each_entry_safe(t, n, &ce->tgt_list, head) {
+		list_del(&t->head);
 		kfree(t->name);
 		kfree(t);
 	}
@@ -238,7 +238,7 @@ static inline void free_tgts(struct cache_entry *ce)
 
 static inline void flush_cache_ent(struct cache_entry *ce)
 {
-	hlist_del_init(&ce->hlist);
+	hlist_del_init(&ce->node);
 	kfree(ce->path);
 	free_tgts(ce);
 	atomic_dec(&cache_count);
@@ -254,8 +254,8 @@ static void flush_cache_ents(void)
 		struct hlist_node *n;
 		struct cache_entry *ce;
 
-		hlist_for_each_entry_safe(ce, n, l, hlist) {
-			if (!hlist_unhashed(&ce->hlist))
+		hlist_for_each_entry_safe(ce, n, l, node) {
+			if (!hlist_unhashed(&ce->node))
 				flush_cache_ent(ce);
 		}
 	}
@@ -276,8 +276,8 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
 		struct hlist_head *l = &cache_htable[i];
 
-		hlist_for_each_entry(ce, l, hlist) {
-			if (hlist_unhashed(&ce->hlist))
+		hlist_for_each_entry(ce, l, node) {
+			if (hlist_unhashed(&ce->node))
 				continue;
 
 			seq_printf(m,
@@ -287,10 +287,10 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				   IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
-			list_for_each_entry(t, &ce->tlist, list) {
+			list_for_each_entry(t, &ce->tgt_list, head) {
 				seq_printf(m, "  %s%s\n",
 					   t->name,
-					   ce->tgthint == t ? " (target hint)" : "");
+					   ce->tgt_hint == t ? " (target hint)" : "");
 			}
 		}
 	}
@@ -340,9 +340,9 @@ static inline void dump_tgts(const struct cache_entry *ce)
 	struct cache_dfs_tgt *t;
 
 	cifs_dbg(FYI, "target list:\n");
-	list_for_each_entry(t, &ce->tlist, list) {
+	list_for_each_entry(t, &ce->tgt_list, head) {
 		cifs_dbg(FYI, "  %s%s\n", t->name,
-			 ce->tgthint == t ? " (target hint)" : "");
+			 ce->tgt_hint == t ? " (target hint)" : "");
 	}
 }
 
@@ -448,7 +448,7 @@ static int cache_entry_hash(const void *data, int size, unsigned int *hash)
 /* Return target hint of a DFS cache entry */
 static inline char *get_tgt_name(const struct cache_entry *ce)
 {
-	struct cache_dfs_tgt *t = ce->tgthint;
+	struct cache_dfs_tgt *t = ce->tgt_hint;
 
 	return t ? t->name : ERR_PTR(-ENOENT);
 }
@@ -480,7 +480,7 @@ static struct cache_dfs_tgt *alloc_target(const char *name, int path_consumed)
 		return ERR_PTR(-ENOMEM);
 	}
 	t->path_consumed = path_consumed;
-	INIT_LIST_HEAD(&t->list);
+	INIT_LIST_HEAD(&t->head);
 	return t;
 }
 
@@ -489,7 +489,7 @@ static struct cache_dfs_tgt *alloc_target(const char *name, int path_consumed)
  * target hint.
  */
 static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
-			 struct cache_entry *ce, const char *tgthint)
+			 struct cache_entry *ce, const char *tgt_hint)
 {
 	int i;
 
@@ -508,17 +508,17 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 			free_tgts(ce);
 			return PTR_ERR(t);
 		}
-		if (tgthint && !strcasecmp(t->name, tgthint)) {
-			list_add(&t->list, &ce->tlist);
-			tgthint = NULL;
+		if (tgt_hint && !strcasecmp(t->name, tgt_hint)) {
+			list_add(&t->head, &ce->tgt_list);
+			tgt_hint = NULL;
 		} else {
-			list_add_tail(&t->list, &ce->tlist);
+			list_add_tail(&t->head, &ce->tgt_list);
 		}
-		ce->numtgts++;
+		ce->num_tgts++;
 	}
 
-	ce->tgthint = list_first_entry_or_null(&ce->tlist,
-					       struct cache_dfs_tgt, list);
+	ce->tgt_hint = list_first_entry_or_null(&ce->tgt_list,
+					       struct cache_dfs_tgt, head);
 
 	return 0;
 }
@@ -536,8 +536,8 @@ static struct cache_entry *alloc_cache_entry(struct dfs_info3_param *refs, int n
 	ce->path = refs[0].path_name;
 	refs[0].path_name = NULL;
 
-	INIT_HLIST_NODE(&ce->hlist);
-	INIT_LIST_HEAD(&ce->tlist);
+	INIT_HLIST_NODE(&ce->node);
+	INIT_LIST_HEAD(&ce->tgt_list);
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
@@ -559,8 +559,8 @@ static void remove_oldest_entry_locked(void)
 	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
 		struct hlist_head *l = &cache_htable[i];
 
-		hlist_for_each_entry(ce, l, hlist) {
-			if (hlist_unhashed(&ce->hlist))
+		hlist_for_each_entry(ce, l, node) {
+			if (hlist_unhashed(&ce->node))
 				continue;
 			if (!to_del || timespec64_compare(&ce->etime,
 							  &to_del->etime) < 0)
@@ -610,7 +610,7 @@ static int add_cache_entry_locked(struct dfs_info3_param *refs, int numrefs)
 	}
 	spin_unlock(&cache_ttl_lock);
 
-	hlist_add_head(&ce->hlist, &cache_htable[hash]);
+	hlist_add_head(&ce->node, &cache_htable[hash]);
 	dump_ce(ce);
 
 	atomic_inc(&cache_count);
@@ -648,7 +648,7 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
 {
 	struct cache_entry *ce;
 
-	hlist_for_each_entry(ce, &cache_htable[hash], hlist) {
+	hlist_for_each_entry(ce, &cache_htable[hash], node) {
 		if (dfs_path_equal(ce->path, strlen(ce->path), path, len)) {
 			dump_ce(ce);
 			return ce;
@@ -737,15 +737,15 @@ static int update_cache_entry_locked(struct cache_entry *ce, const struct dfs_in
 
 	WARN_ON(!rwsem_is_locked(&htable_rw_lock));
 
-	if (ce->tgthint) {
-		s = ce->tgthint->name;
+	if (ce->tgt_hint) {
+		s = ce->tgt_hint->name;
 		th = kstrdup(s, GFP_ATOMIC);
 		if (!th)
 			return -ENOMEM;
 	}
 
 	free_tgts(ce);
-	ce->numtgts = 0;
+	ce->num_tgts = 0;
 
 	rc = copy_ref_data(refs, numrefs, ce, th);
 
@@ -878,42 +878,42 @@ static int setup_referral(const char *path, struct cache_entry *ce,
 static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
 {
 	int rc;
-	struct list_head *head = &tl->tl_list;
+	struct list_head *tgt_list = &tl->list;
 	struct cache_dfs_tgt *t;
 	struct dfs_cache_tgt_iterator *it, *nit;
 
 	memset(tl, 0, sizeof(*tl));
-	INIT_LIST_HEAD(head);
+	INIT_LIST_HEAD(tgt_list);
 
-	list_for_each_entry(t, &ce->tlist, list) {
+	list_for_each_entry(t, &ce->tgt_list, head) {
 		it = kzalloc(sizeof(*it), GFP_ATOMIC);
 		if (!it) {
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
 
-		it->it_name = kstrdup(t->name, GFP_ATOMIC);
-		if (!it->it_name) {
+		it->name = kstrdup(t->name, GFP_ATOMIC);
+		if (!it->name) {
 			kfree(it);
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
-		it->it_path_consumed = t->path_consumed;
+		it->path_consumed = t->path_consumed;
 
-		if (ce->tgthint == t)
-			list_add(&it->it_list, head);
+		if (ce->tgt_hint == t)
+			list_add(&it->head, tgt_list);
 		else
-			list_add_tail(&it->it_list, head);
+			list_add_tail(&it->head, tgt_list);
 	}
 
-	tl->tl_numtgts = ce->numtgts;
+	tl->num_tgts = ce->num_tgts;
 
 	return 0;
 
 err_free_it:
-	list_for_each_entry_safe(it, nit, head, it_list) {
-		list_del(&it->it_list);
-		kfree(it->it_name);
+	list_for_each_entry_safe(it, nit, tgt_list, head) {
+		list_del(&it->head);
+		kfree(it->name);
 		kfree(it);
 	}
 	return rc;
@@ -1025,7 +1025,7 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 }
 
 /**
- * dfs_cache_update_tgthint - update target hint of a DFS cache entry
+ * dfs_cache_update_tgt_hint - update target hint of a DFS cache entry
  *
  * If it doesn't find the cache entry, then it will get a DFS referral for @path
  * and create a new entry.
@@ -1042,7 +1042,7 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
  *
  * Return zero if the target hint was updated successfully, otherwise non-zero.
  */
-int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
+int dfs_cache_update_tgt_hint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
@@ -1069,16 +1069,16 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 		goto out_unlock;
 	}
 
-	t = ce->tgthint;
+	t = ce->tgt_hint;
 
-	if (likely(!strcasecmp(it->it_name, t->name)))
+	if (likely(!strcasecmp(it->name, t->name)))
 		goto out_unlock;
 
-	list_for_each_entry(t, &ce->tlist, list) {
-		if (!strcasecmp(t->name, it->it_name)) {
-			ce->tgthint = t;
+	list_for_each_entry(t, &ce->tgt_list, head) {
+		if (!strcasecmp(t->name, it->name)) {
+			ce->tgt_hint = t;
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
-				 it->it_name);
+				 it->name);
 			break;
 		}
 	}
@@ -1091,7 +1091,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 }
 
 /**
- * dfs_cache_noreq_update_tgthint - update target hint of a DFS cache entry
+ * dfs_cache_noreq_update_tgt_hint - update target hint of a DFS cache entry
  * without sending any requests to the currently connected server.
  *
  * NOTE: This function will neither update a cache entry in case it was
@@ -1104,7 +1104,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
  *
  * Return zero if the target hint was updated successfully, otherwise non-zero.
  */
-int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_iterator *it)
+int dfs_cache_noreq_update_tgt_hint(const char *path, const struct dfs_cache_tgt_iterator *it)
 {
 	int rc;
 	struct cache_entry *ce;
@@ -1124,16 +1124,16 @@ int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_
 	}
 
 	rc = 0;
-	t = ce->tgthint;
+	t = ce->tgt_hint;
 
-	if (unlikely(!strcasecmp(it->it_name, t->name)))
+	if (unlikely(!strcasecmp(it->name, t->name)))
 		goto out_unlock;
 
-	list_for_each_entry(t, &ce->tlist, list) {
-		if (!strcasecmp(t->name, it->it_name)) {
-			ce->tgthint = t;
+	list_for_each_entry(t, &ce->tgt_list, head) {
+		if (!strcasecmp(t->name, it->name)) {
+			ce->tgt_hint = t;
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
-				 it->it_name);
+				 it->name);
 			break;
 		}
 	}
@@ -1172,9 +1172,9 @@ int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iter
 		goto out_unlock;
 	}
 
-	cifs_dbg(FYI, "%s: target name: %s\n", __func__, it->it_name);
+	cifs_dbg(FYI, "%s: target name: %s\n", __func__, it->name);
 
-	rc = setup_referral(path, ce, ref, it->it_name);
+	rc = setup_referral(path, ce, ref, it->name);
 
 out_unlock:
 	up_read(&htable_rw_lock);
@@ -1273,19 +1273,19 @@ int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 	size_t target_pplen, dfsref_pplen;
 	size_t len, c;
 
-	if (!it || !path || !share || !prefix || strlen(path) < it->it_path_consumed)
+	if (!it || !path || !share || !prefix || strlen(path) < it->path_consumed)
 		return -EINVAL;
 
-	sep = it->it_name[0];
+	sep = it->name[0];
 	if (sep != '\\' && sep != '/')
 		return -EINVAL;
 
-	target_ppath = parse_target_share(it->it_name, &target_share);
+	target_ppath = parse_target_share(it->name, &target_share);
 	if (IS_ERR(target_ppath))
 		return PTR_ERR(target_ppath);
 
 	/* point to prefix in DFS referral path */
-	dfsref_ppath = path + it->it_path_consumed;
+	dfsref_ppath = path + it->path_consumed;
 	dfsref_ppath += strspn(dfsref_ppath, "/\\");
 
 	target_pplen = strlen(target_ppath);
@@ -1578,10 +1578,10 @@ static void refresh_cache(struct cifs_ses **sessions)
 	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
 		struct hlist_head *l = &cache_htable[i];
 
-		hlist_for_each_entry(ce, l, hlist) {
+		hlist_for_each_entry(ce, l, node) {
 			if (count == ARRAY_SIZE(ref_paths))
 				goto out_unlock;
-			if (hlist_unhashed(&ce->hlist) || !cache_entry_expired(ce) ||
+			if (hlist_unhashed(&ce->node) || !cache_entry_expired(ce) ||
 			    IS_ERR(find_ipc_from_server_path(sessions, ce->path)))
 				continue;
 			ref_paths[count++] = kstrdup(ce->path, GFP_ATOMIC);
@@ -1642,7 +1642,7 @@ static void refresh_cache_worker(struct work_struct *work)
 
 	/* Get refereces of mount groups */
 	mutex_lock(&mount_group_list_lock);
-	list_for_each_entry(mg, &mount_group_list, list) {
+	list_for_each_entry(mg, &mount_group_list, head) {
 		kref_get(&mg->refcount);
 		list_add(&mg->refresh_list, &mglist);
 	}
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index 52070d1df189..9243d87ec198 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -13,17 +13,17 @@
 #include <linux/uuid.h>
 #include "cifsglob.h"
 
-#define DFS_CACHE_TGT_LIST_INIT(var) { .tl_numtgts = 0, .tl_list = LIST_HEAD_INIT((var).tl_list), }
+#define DFS_CACHE_TGT_LIST_INIT(var) { .num_tgts = 0, .list = LIST_HEAD_INIT((var).list), }
 
 struct dfs_cache_tgt_list {
-	int tl_numtgts;
-	struct list_head tl_list;
+	int num_tgts;
+	struct list_head list;
 };
 
 struct dfs_cache_tgt_iterator {
-	char *it_name;
-	int it_path_consumed;
-	struct list_head it_list;
+	char *name;
+	int path_consumed;
+	struct list_head head;
 };
 
 int dfs_cache_init(void);
@@ -35,10 +35,10 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nl
 		   struct dfs_cache_tgt_list *tgt_list);
 int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 			 struct dfs_cache_tgt_list *tgt_list);
-int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
+int dfs_cache_update_tgt_hint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it);
-int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_iterator *it);
+int dfs_cache_noreq_update_tgt_hint(const char *path, const struct dfs_cache_tgt_iterator *it);
 int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iterator *it,
 			       struct dfs_info3_param *ref);
 int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
@@ -52,10 +52,10 @@ static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
 		       struct dfs_cache_tgt_iterator *it)
 {
-	if (!tl || list_empty(&tl->tl_list) || !it ||
-	    list_is_last(&it->it_list, &tl->tl_list))
+	if (!tl || list_empty(&tl->list) || !it ||
+	    list_is_last(&it->head, &tl->list))
 		return NULL;
-	return list_next_entry(it, it_list);
+	return list_next_entry(it, head);
 }
 
 static inline struct dfs_cache_tgt_iterator *
@@ -63,35 +63,35 @@ dfs_cache_get_tgt_iterator(struct dfs_cache_tgt_list *tl)
 {
 	if (!tl)
 		return NULL;
-	return list_first_entry_or_null(&tl->tl_list,
+	return list_first_entry_or_null(&tl->list,
 					struct dfs_cache_tgt_iterator,
-					it_list);
+					head);
 }
 
 static inline void dfs_cache_free_tgts(struct dfs_cache_tgt_list *tl)
 {
 	struct dfs_cache_tgt_iterator *it, *nit;
 
-	if (!tl || list_empty(&tl->tl_list))
+	if (!tl || list_empty(&tl->list))
 		return;
-	list_for_each_entry_safe(it, nit, &tl->tl_list, it_list) {
-		list_del(&it->it_list);
-		kfree(it->it_name);
+	list_for_each_entry_safe(it, nit, &tl->list, head) {
+		list_del(&it->head);
+		kfree(it->name);
 		kfree(it);
 	}
-	tl->tl_numtgts = 0;
+	tl->num_tgts = 0;
 }
 
 static inline const char *
 dfs_cache_get_tgt_name(const struct dfs_cache_tgt_iterator *it)
 {
-	return it ? it->it_name : NULL;
+	return it ? it->name : NULL;
 }
 
 static inline int
 dfs_cache_get_nr_tgts(const struct dfs_cache_tgt_list *tl)
 {
-	return tl ? tl->tl_numtgts : 0;
+	return tl ? tl->num_tgts : 0;
 }
 
 #endif /* _CIFS_DFS_CACHE_H */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 0f7315b00d34..67ce599401e2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1130,13 +1130,13 @@ cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
 void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
 				unsigned int *len, unsigned int *offset)
 {
-	*len = rqst->rq_pagesz;
-	*offset = (page == 0) ? rqst->rq_offset : 0;
+	*len = rqst->pagesz;
+	*offset = (page == 0) ? rqst->offset : 0;
 
-	if (rqst->rq_npages == 1 || page == rqst->rq_npages-1)
-		*len = rqst->rq_tailsz;
+	if (rqst->npages == 1 || page == rqst->npages-1)
+		*len = rqst->tailsz;
 	else if (page == 0)
-		*len = rqst->rq_pagesz - rqst->rq_offset;
+		*len = rqst->pagesz - rqst->offset;
 }
 
 void extract_unc_hostname(const char *unc, const char **h, size_t *len)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b51454d95f71..704c7632ee00 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -30,7 +30,7 @@ send_nt_cancel(struct cifs_server_info *server, struct smb_rqst *rqst,
 	       struct mid_q_entry *mid)
 {
 	int rc = 0;
-	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->iov[0].iov_base;
 
 	/* -4 for RFC1001 length and +2 for BCC field */
 	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index adbaac71b433..817dbf9abef3 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -27,9 +27,9 @@
 static void
 free_set_inf_compound(struct smb_rqst *rqst)
 {
-	if (rqst[1].rq_iov)
+	if (rqst[1].iov)
 		SMB2_set_info_free(&rqst[1]);
-	if (rqst[2].rq_iov)
+	if (rqst[2].iov)
 		SMB2_close_free(&rqst[2]);
 }
 
@@ -108,8 +108,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	vars->oparms.mode = mode;
 	vars->oparms.cifs_sb = cifs_sb;
 
-	rqst[num_rqst].rq_iov = &vars->open_iov[0];
-	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[num_rqst].iov = &vars->open_iov[0];
+	rqst[num_rqst].nvec = SMB2_CREATE_IOV_SIZE;
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[num_rqst], &oplock, &vars->oparms,
 			    utf16_path);
@@ -125,8 +125,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Operation */
 	switch (command) {
 	case SMB2_OP_QUERY_INFO:
-		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
+		rqst[num_rqst].iov = &vars->qi_iov[0];
+		rqst[num_rqst].nvec = 1;
 
 		if (cfile)
 			rc = SMB2_query_info_init(tcon, server,
@@ -159,8 +159,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						     full_path);
 		break;
 	case SMB2_OP_POSIX_QUERY_INFO:
-		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
+		rqst[num_rqst].iov = &vars->qi_iov[0];
+		rqst[num_rqst].nvec = 1;
 
 		if (cfile)
 			rc = SMB2_query_info_init(tcon, server,
@@ -203,8 +203,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_mkdir_enter(xid, ses->id, tcon->tid, full_path);
 		break;
 	case SMB2_OP_RMDIR:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
+		rqst[num_rqst].iov = &vars->si_iov[0];
+		rqst[num_rqst].nvec = 1;
 
 		size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
 		data[0] = &delete_pending[0];
@@ -221,8 +221,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_rmdir_enter(xid, ses->id, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_EOF:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
+		rqst[num_rqst].iov = &vars->si_iov[0];
+		rqst[num_rqst].nvec = 1;
 
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
@@ -239,8 +239,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_set_eof_enter(xid, ses->id, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 1;
+		rqst[num_rqst].iov = &vars->si_iov[0];
+		rqst[num_rqst].nvec = 1;
 
 
 		size[0] = sizeof(FILE_BASIC_INFO);
@@ -273,8 +273,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						   full_path);
 		break;
 	case SMB2_OP_RENAME:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 2;
+		rqst[num_rqst].iov = &vars->si_iov[0];
+		rqst[num_rqst].nvec = 2;
 
 		len = (2 * UniStrnlen((wchar_t *)ptr, PATH_MAX));
 
@@ -312,8 +312,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_rename_enter(xid, ses->id, tcon->tid, full_path);
 		break;
 	case SMB2_OP_HARDLINK:
-		rqst[num_rqst].rq_iov = &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec = 2;
+		rqst[num_rqst].iov = &vars->si_iov[0];
+		rqst[num_rqst].nvec = 2;
 
 		len = (2 * UniStrnlen((wchar_t *)ptr, PATH_MAX));
 
@@ -350,8 +350,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto after_close;
 	/* Close */
 	flags |= CIFS_CP_CREATE_CLOSE_OP;
-	rqst[num_rqst].rq_iov = &vars->close_iov[0];
-	rqst[num_rqst].rq_nvec = 1;
+	rqst[num_rqst].iov = &vars->close_iov[0];
+	rqst[num_rqst].nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[num_rqst], COMPOUND_FID,
 			     COMPOUND_FID, false);
@@ -393,9 +393,9 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
 				ptr);
 		}
-		if (rqst[1].rq_iov)
+		if (rqst[1].iov)
 			SMB2_query_info_free(&rqst[1]);
-		if (rqst[2].rq_iov)
+		if (rqst[2].iov)
 			SMB2_close_free(&rqst[2]);
 		if (rc)
 			trace_smb3_query_info_compound_err(xid,  ses->id,
@@ -413,9 +413,9 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				le32_to_cpu(qi_rsp->OutputBufferLength),
 				&rsp_iov[1], sizeof(struct smb311_posix_qinfo) /* add SIDs */, ptr);
 		}
-		if (rqst[1].rq_iov)
+		if (rqst[1].iov)
 			SMB2_query_info_free(&rqst[1]);
-		if (rqst[2].rq_iov)
+		if (rqst[2].iov)
 			SMB2_close_free(&rqst[2]);
 		if (rc)
 			trace_smb3_posix_query_info_compound_err(xid,  ses->id, tcon->tid, rc);
@@ -427,7 +427,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			trace_smb3_delete_err(xid,  ses->id, tcon->tid, rc);
 		else
 			trace_smb3_delete_done(xid, ses->id, tcon->tid);
-		if (rqst[1].rq_iov)
+		if (rqst[1].iov)
 			SMB2_close_free(&rqst[1]);
 		break;
 	case SMB2_OP_MKDIR:
@@ -435,7 +435,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			trace_smb3_mkdir_err(xid,  ses->id, tcon->tid, rc);
 		else
 			trace_smb3_mkdir_done(xid, ses->id, tcon->tid);
-		if (rqst[1].rq_iov)
+		if (rqst[1].iov)
 			SMB2_close_free(&rqst[1]);
 		break;
 	case SMB2_OP_HARDLINK:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 884bf9061715..4b2bdc4a50bb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -847,8 +847,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Open */
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms.tcon = tcon;
 	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
@@ -864,8 +864,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-	rqst[1].rq_iov = qi_iov;
-	rqst[1].rq_nvec = 1;
+	rqst[1].iov = qi_iov;
+	rqst[1].nvec = 1;
 
 	rc = SMB2_query_info_init(tcon, server,
 				  &rqst[1], COMPOUND_FID,
@@ -1351,8 +1351,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Open */
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
@@ -1371,8 +1371,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Set Info */
 	memset(&si_iov, 0, sizeof(si_iov));
-	rqst[1].rq_iov = si_iov;
-	rqst[1].rq_nvec = 1;
+	rqst[1].iov = si_iov;
+	rqst[1].nvec = 1;
 
 	len = sizeof(*ea) + ea_name_len + ea_value_len + 1;
 	ea = kzalloc(len, GFP_KERNEL);
@@ -1400,8 +1400,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Close */
 	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
-	rqst[2].rq_nvec = 1;
+	rqst[2].iov = close_iov;
+	rqst[2].nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
 	smb2_set_related(&rqst[2]);
@@ -1704,8 +1704,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 	}
 
 	/* Open */
-	rqst[0].rq_iov = &vars->open_iov[0];
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = &vars->open_iov[0];
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
@@ -1748,8 +1748,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 			rc = -EPERM;
 			goto free_open_req;
 		}
-		rqst[1].rq_iov = &vars->io_iov[0];
-		rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
+		rqst[1].iov = &vars->io_iov[0];
+		rqst[1].nvec = SMB2_IOCTL_IOV_SIZE;
 
 		rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
 				     qi.info_type, true, buffer, qi.output_buffer_length,
@@ -1766,8 +1766,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 			rc = -EINVAL;
 			goto free_open_req;
 		}
-		rqst[1].rq_iov = &vars->si_iov[0];
-		rqst[1].rq_nvec = 1;
+		rqst[1].iov = &vars->si_iov[0];
+		rqst[1].nvec = 1;
 
 		/* MS-FSCC 2.4.13 FileEndOfFileInformation */
 		size[0] = 8;
@@ -1778,8 +1778,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 					SMB2_O_INFO_FILE, 0, data, size);
 		free_req1_func = SMB2_set_info_free;
 	} else if (qi.flags == PASSTHRU_QUERY_INFO) {
-		rqst[1].rq_iov = &vars->qi_iov[0];
-		rqst[1].rq_nvec = 1;
+		rqst[1].iov = &vars->qi_iov[0];
+		rqst[1].nvec = 1;
 
 		rc = SMB2_query_info_init(tcon, server,
 				  &rqst[1], COMPOUND_FID,
@@ -1800,8 +1800,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 	smb2_set_related(&rqst[1]);
 
 	/* Close */
-	rqst[2].rq_iov = &vars->close_iov[0];
-	rqst[2].rq_nvec = 1;
+	rqst[2].iov = &vars->close_iov[0];
+	rqst[2].nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -2403,8 +2403,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Open */
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
@@ -2424,8 +2424,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	search_info->last_entry_index = 2;
 
 	memset(&qd_iov, 0, sizeof(qd_iov));
-	rqst[1].rq_iov = qd_iov;
-	rqst[1].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
+	rqst[1].iov = qd_iov;
+	rqst[1].nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
 
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst[1],
@@ -2613,7 +2613,7 @@ smb2_set_related(struct smb_rqst *rqst)
 {
 	struct smb2_hdr *shdr;
 
-	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr = (struct smb2_hdr *)(rqst->iov[0].iov_base);
 	if (shdr == NULL) {
 		cifs_dbg(FYI, "shdr NULL in smb2_set_related\n");
 		return;
@@ -2632,7 +2632,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	unsigned long len = smb_rqst_len(server, rqst);
 	int i, num_padding;
 
-	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr = (struct smb2_hdr *)(rqst->iov[0].iov_base);
 	if (shdr == NULL) {
 		cifs_dbg(FYI, "shdr NULL in smb2_set_next_command\n");
 		return;
@@ -2650,9 +2650,9 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 		 * If we do not have encryption then we can just add an extra
 		 * iov for the padding.
 		 */
-		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
-		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
-		rqst->rq_nvec++;
+		rqst->iov[rqst->nvec].iov_base = smb2_padding;
+		rqst->iov[rqst->nvec].iov_len = num_padding;
+		rqst->nvec++;
 		len += num_padding;
 	} else {
 		/*
@@ -2662,18 +2662,18 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 		 * We have to flatten this into a single buffer and add
 		 * the padding to it.
 		 */
-		for (i = 1; i < rqst->rq_nvec; i++) {
-			memcpy(rqst->rq_iov[0].iov_base +
-			       rqst->rq_iov[0].iov_len,
-			       rqst->rq_iov[i].iov_base,
-			       rqst->rq_iov[i].iov_len);
-			rqst->rq_iov[0].iov_len += rqst->rq_iov[i].iov_len;
+		for (i = 1; i < rqst->nvec; i++) {
+			memcpy(rqst->iov[0].iov_base +
+			       rqst->iov[0].iov_len,
+			       rqst->iov[i].iov_base,
+			       rqst->iov[i].iov_len);
+			rqst->iov[0].iov_len += rqst->iov[i].iov_len;
 		}
-		memset(rqst->rq_iov[0].iov_base + rqst->rq_iov[0].iov_len,
+		memset(rqst->iov[0].iov_base + rqst->iov[0].iov_len,
 		       0, num_padding);
-		rqst->rq_iov[0].iov_len += num_padding;
+		rqst->iov[0].iov_len += num_padding;
 		len += num_padding;
-		rqst->rq_nvec = 1;
+		rqst->nvec = 1;
 	}
 
  finished:
@@ -2724,8 +2724,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		open_cached_dir(xid, tcon, path, cifs_sb, &cfid); /* cfid null if open dir failed */
 
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms.tcon = tcon;
 	oparms.desired_access = desired_access;
@@ -2741,8 +2741,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-	rqst[1].rq_iov = qi_iov;
-	rqst[1].rq_nvec = 1;
+	rqst[1].iov = qi_iov;
+	rqst[1].nvec = 1;
 
 	if (cfid) {
 		rc = SMB2_query_info_init(tcon, server,
@@ -2769,8 +2769,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
-	rqst[2].rq_nvec = 1;
+	rqst[2].iov = close_iov;
+	rqst[2].nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -3160,8 +3160,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Open */
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
@@ -3180,8 +3180,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* IOCTL */
 	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov = io_iov;
-	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
+	rqst[1].iov = io_iov;
+	rqst[1].nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], fid.persistent_fid,
@@ -3199,8 +3199,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Close */
 	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
-	rqst[2].rq_nvec = 1;
+	rqst[2].iov = close_iov;
+	rqst[2].nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -3341,8 +3341,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	 * to see if there is a handle already open that we can use
 	 */
 	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst[0].iov = open_iov;
+	rqst[0].nvec = SMB2_CREATE_IOV_SIZE;
 
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
@@ -3361,8 +3361,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* IOCTL */
 	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov = io_iov;
-	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
+	rqst[1].iov = io_iov;
+	rqst[1].nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], COMPOUND_FID,
@@ -3380,8 +3380,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Close */
 	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
-	rqst[2].rq_nvec = 1;
+	rqst[2].iov = close_iov;
+	rqst[2].nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -4471,7 +4471,7 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 		   struct smb_rqst *old_rq, __le16 cipher_type)
 {
 	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
+			(struct smb2_hdr *)old_rq->iov[0].iov_base;
 
 	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
@@ -4504,9 +4504,9 @@ static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 
 /* Assumes the first rqst has a transform header as the first iov.
  * I.e.
- * rqst[0].rq_iov[0]  is transform header
- * rqst[0].rq_iov[1+] data to be encrypted/decrypted
- * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
+ * rqst[0].iov[0]  is transform header
+ * rqst[0].iov[1+] data to be encrypted/decrypted
+ * rqst[1+].iov[0+] data to be encrypted/decrypted
  */
 static struct scatterlist *
 init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
@@ -4520,7 +4520,7 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 
 	sg_len = 1;
 	for (i = 0; i < num_rqst; i++)
-		sg_len += rqst[i].rq_nvec + rqst[i].rq_npages;
+		sg_len += rqst[i].nvec + rqst[i].npages;
 
 	sg = kmalloc_array(sg_len, sizeof(struct scatterlist), GFP_KERNEL);
 	if (!sg)
@@ -4528,22 +4528,22 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 
 	sg_init_table(sg, sg_len);
 	for (i = 0; i < num_rqst; i++) {
-		for (j = 0; j < rqst[i].rq_nvec; j++) {
+		for (j = 0; j < rqst[i].nvec; j++) {
 			/*
 			 * The first rqst has a transform header where the
 			 * first 20 bytes are not part of the encrypted blob
 			 */
 			skip = (i == 0) && (j == 0) ? 20 : 0;
 			smb2_sg_set_buf(&sg[idx++],
-					rqst[i].rq_iov[j].iov_base + skip,
-					rqst[i].rq_iov[j].iov_len - skip);
+					rqst[i].iov[j].iov_base + skip,
+					rqst[i].iov[j].iov_len - skip);
 			}
 
-		for (j = 0; j < rqst[i].rq_npages; j++) {
+		for (j = 0; j < rqst[i].npages; j++) {
 			unsigned int len, offset;
 
 			rqst_page_get_length(&rqst[i], j, &len, &offset);
-			sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, offset);
+			sg_set_page(&sg[idx++], rqst[i].pages[j], len, offset);
 		}
 	}
 	smb2_sg_set_buf(&sg[idx], sign, SMB2_SIGNATURE_SIZE);
@@ -4584,7 +4584,7 @@ crypt_message(struct cifs_server_info *server, int num_rqst,
 	      struct smb_rqst *rqst, int enc)
 {
 	struct smb2_transform_hdr *tr_hdr =
-		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
+		(struct smb2_transform_hdr *)rqst[0].iov[0].iov_base;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc = 0;
 	struct scatterlist *sg;
@@ -4690,10 +4690,10 @@ smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst)
 	int i, j;
 
 	for (i = 0; i < num_rqst; i++) {
-		if (rqst[i].rq_pages) {
-			for (j = rqst[i].rq_npages - 1; j >= 0; j--)
-				put_page(rqst[i].rq_pages[j]);
-			kfree(rqst[i].rq_pages);
+		if (rqst[i].pages) {
+			for (j = rqst[i].npages - 1; j >= 0; j--)
+				put_page(rqst[i].pages[j]);
+			kfree(rqst[i].pages);
 		}
 	}
 }
@@ -4708,34 +4708,34 @@ smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst)
  * only contains a single iov for the transform header which we then can pass
  * to crypt_message().
  *
- * new_rq[0].rq_iov[0] :  smb2_transform_hdr pre-allocated by the caller
- * new_rq[1+].rq_iov[*] == old_rq[0+].rq_iov[*] : SMB2/3 requests
+ * new_rq[0].iov[0] :  smb2_transform_hdr pre-allocated by the caller
+ * new_rq[1+].iov[*] == old_rq[0+].iov[*] : SMB2/3 requests
  */
 static int
 smb3_init_transform_rq(struct cifs_server_info *server, int num_rqst,
 		       struct smb_rqst *new_rq, struct smb_rqst *old_rq)
 {
 	struct page **pages;
-	struct smb2_transform_hdr *tr_hdr = new_rq[0].rq_iov[0].iov_base;
+	struct smb2_transform_hdr *tr_hdr = new_rq[0].iov[0].iov_base;
 	unsigned int npages;
 	unsigned int orig_len = 0;
 	int i, j;
 	int rc = -ENOMEM;
 
 	for (i = 1; i < num_rqst; i++) {
-		npages = old_rq[i - 1].rq_npages;
+		npages = old_rq[i - 1].npages;
 		pages = kmalloc_array(npages, sizeof(struct page *),
 				      GFP_KERNEL);
 		if (!pages)
 			goto err_free;
 
-		new_rq[i].rq_pages = pages;
-		new_rq[i].rq_npages = npages;
-		new_rq[i].rq_offset = old_rq[i - 1].rq_offset;
-		new_rq[i].rq_pagesz = old_rq[i - 1].rq_pagesz;
-		new_rq[i].rq_tailsz = old_rq[i - 1].rq_tailsz;
-		new_rq[i].rq_iov = old_rq[i - 1].rq_iov;
-		new_rq[i].rq_nvec = old_rq[i - 1].rq_nvec;
+		new_rq[i].pages = pages;
+		new_rq[i].npages = npages;
+		new_rq[i].offset = old_rq[i - 1].offset;
+		new_rq[i].pagesz = old_rq[i - 1].pagesz;
+		new_rq[i].tailsz = old_rq[i - 1].tailsz;
+		new_rq[i].iov = old_rq[i - 1].iov;
+		new_rq[i].nvec = old_rq[i - 1].nvec;
 
 		orig_len += smb_rqst_len(server, &old_rq[i - 1]);
 
@@ -4752,12 +4752,12 @@ smb3_init_transform_rq(struct cifs_server_info *server, int num_rqst,
 
 			rqst_page_get_length(&new_rq[i], j, &len, &offset);
 
-			dst = (char *) kmap(new_rq[i].rq_pages[j]) + offset;
-			src = (char *) kmap(old_rq[i - 1].rq_pages[j]) + offset;
+			dst = (char *) kmap(new_rq[i].pages[j]) + offset;
+			src = (char *) kmap(old_rq[i - 1].pages[j]) + offset;
 
 			memcpy(dst, src, len);
-			kunmap(new_rq[i].rq_pages[j]);
-			kunmap(old_rq[i - 1].rq_pages[j]);
+			kunmap(new_rq[i].pages[j]);
+			kunmap(old_rq[i - 1].pages[j]);
 		}
 	}
 
@@ -4799,12 +4799,12 @@ decrypt_raw_data(struct cifs_server_info *server, char *buf,
 	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
 	iov[1].iov_len = buf_data_size;
 
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
-	rqst.rq_pages = pages;
-	rqst.rq_npages = npages;
-	rqst.rq_pagesz = PAGE_SIZE;
-	rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
+	rqst.iov = iov;
+	rqst.nvec = 2;
+	rqst.pages = pages;
+	rqst.npages = npages;
+	rqst.pagesz = PAGE_SIZE;
+	rqst.tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
 
 	rc = crypt_message(server, 1, &rqst, 0);
 	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 405c42f09484..85c454774a3f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -947,8 +947,8 @@ SMB2_negotiate(const unsigned int xid,
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -1360,8 +1360,8 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 	req->SecurityBufferLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = sess_data->iov;
-	rqst.rq_nvec = 2;
+	rqst.iov = sess_data->iov;
+	rqst.nvec = 2;
 
 	/* BB add code to build os and lm fields */
 	rc = cifs_send_recv(sess_data->xid, sess_data->ses,
@@ -1785,8 +1785,8 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, ses->server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
@@ -1888,8 +1888,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
+	rqst.iov = iov;
+	rqst.nvec = 2;
 
 	/* Need 64 for max size write so ask for more in case not there yet */
 	req->hdr.CreditRequest = cpu_to_le16(64);
@@ -1995,8 +1995,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, ses->server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
@@ -2718,8 +2718,8 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_iov;
+	rqst.iov = iov;
+	rqst.nvec = n_iov;
 
 	/* no need to inc num_remote_opens because we close it just below */
 	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->id, CREATE_NOT_FILE,
@@ -2775,7 +2775,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 	int copy_size;
 	int uni_path_len;
 	unsigned int total_len;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	__le16 *copy_path;
 	int rc;
 
@@ -2938,7 +2938,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 	}
 	add_query_id_context(iov, &n_iov);
 
-	rqst->rq_nvec = n_iov;
+	rqst->nvec = n_iov;
 	return 0;
 }
 
@@ -2950,11 +2950,11 @@ SMB2_open_free(struct smb_rqst *rqst)
 {
 	int i;
 
-	if (rqst && rqst->rq_iov) {
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base);
-		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
-				kfree(rqst->rq_iov[i].iov_base);
+	if (rqst && rqst->iov) {
+		cifs_small_buf_release(rqst->iov[0].iov_base);
+		for (i = 1; i < rqst->nvec; i++)
+			if (rqst->iov[i].iov_base != smb2_padding)
+				kfree(rqst->iov[i].iov_base);
 	}
 }
 
@@ -2984,8 +2984,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = SMB2_CREATE_IOV_SIZE;
+	rqst.iov = iov;
+	rqst.nvec = SMB2_CREATE_IOV_SIZE;
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst, oplock, oparms, path);
@@ -3059,7 +3059,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 		__u32 max_response_size)
 {
 	struct smb2_ioctl_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int total_len;
 	int rc;
 	char *in_data_buf;
@@ -3099,12 +3099,12 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 		/* do not set InputOffset if no input data */
 		req->InputOffset =
 		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
-		rqst->rq_nvec = 2;
+		rqst->nvec = 2;
 		iov[0].iov_len = total_len - 1;
 		iov[1].iov_base = in_data_buf;
 		iov[1].iov_len = indatalen;
 	} else {
-		rqst->rq_nvec = 1;
+		rqst->nvec = 1;
 		iov[0].iov_len = total_len;
 	}
 
@@ -3146,11 +3146,11 @@ void
 SMB2_ioctl_free(struct smb_rqst *rqst)
 {
 	int i;
-	if (rqst && rqst->rq_iov) {
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
-		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
-				kfree(rqst->rq_iov[i].iov_base);
+	if (rqst && rqst->iov) {
+		cifs_small_buf_release(rqst->iov[0].iov_base); /* request */
+		for (i = 1; i < rqst->nvec; i++)
+			if (rqst->iov[i].iov_base != smb2_padding)
+				kfree(rqst->iov[i].iov_base);
 	}
 }
 
@@ -3199,8 +3199,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = SMB2_IOCTL_IOV_SIZE;
+	rqst.iov = iov;
+	rqst.nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst, persistent_fid, volatile_fid, opcode,
@@ -3312,7 +3312,7 @@ SMB2_close_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 		u64 persistent_fid, u64 volatile_fid, bool query_attrs)
 {
 	struct smb2_close_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int total_len;
 	int rc;
 
@@ -3336,8 +3336,8 @@ SMB2_close_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 void
 SMB2_close_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov)
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	if (rqst && rqst->iov)
+		cifs_small_buf_release(rqst->iov[0].iov_base); /* request */
 }
 
 int
@@ -3366,8 +3366,8 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	/* check if need to ask server to return timestamps in close response */
 	if (pbuf)
@@ -3488,7 +3488,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 		     size_t output_len, size_t input_len, void *input)
 {
 	struct smb2_query_info_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int total_len;
 	int rc;
 
@@ -3520,8 +3520,8 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 void
 SMB2_query_info_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov)
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	if (rqst && rqst->iov)
+		cifs_small_buf_release(rqst->iov[0].iov_base); /* request */
 }
 
 static int
@@ -3554,8 +3554,8 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = SMB2_query_info_init(tcon, server,
 				  &rqst, persistent_fid, volatile_fid,
@@ -3676,7 +3676,7 @@ SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
 		 u32 completion_filter, bool watch_tree)
 {
 	struct smb2_change_notify_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int total_len;
 	int rc;
 
@@ -3725,8 +3725,8 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = SMB2_notify_init(xid, &rqst, tcon, server,
 			      persistent_fid, volatile_fid,
@@ -3748,8 +3748,8 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 				ses->id, (u8)watch_tree, completion_filter);
 
  cnotify_exit:
-	if (rqst.rq_iov)
-		cifs_small_buf_release(rqst.rq_iov[0].iov_base); /* request */
+	if (rqst.iov)
+		cifs_small_buf_release(rqst.iov[0].iov_base); /* request */
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	return rc;
 }
@@ -3905,8 +3905,8 @@ SMB2_echo(struct cifs_server_info *server)
 	struct smb2_echo_req *req;
 	int rc = 0;
 	struct kvec iov[1];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 1 };
+	struct smb_rqst rqst = { .iov = iov,
+				 .nvec = 1 };
 	unsigned int total_len;
 
 	cifs_dbg(FYI, "In echo request for conn_id %lld\n", server->conn_id);
@@ -3943,8 +3943,8 @@ SMB2_echo(struct cifs_server_info *server)
 void
 SMB2_flush_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov)
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	if (rqst && rqst->iov)
+		cifs_small_buf_release(rqst->iov[0].iov_base); /* request */
 }
 
 int
@@ -3953,7 +3953,7 @@ SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
 		u64 persistent_fid, u64 volatile_fid)
 {
 	struct smb2_flush_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int total_len;
 	int rc;
 
@@ -3993,8 +3993,8 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = SMB2_flush_init(xid, &rqst, tcon, server,
 			     persistent_fid, volatile_fid);
@@ -4127,13 +4127,13 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct smb2_hdr *shdr =
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
-	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+	struct smb_rqst rqst = { .iov = &rdata->iov[1],
+				 .nvec = 1,
+				 .pages = rdata->pages,
+				 .offset = rdata->page_offset,
+				 .npages = rdata->nr_pages,
+				 .pagesz = rdata->pagesz,
+				 .tailsz = rdata->tailsz };
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",
@@ -4213,8 +4213,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	char *buf;
 	struct smb2_hdr *shdr;
 	struct cifs_io_parms io_parms;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 1 };
+	struct smb_rqst rqst = { .iov = rdata->iov,
+				 .nvec = 1 };
 	struct cifs_server_info *server;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	unsigned int total_len;
@@ -4306,8 +4306,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, io_parms->server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -4529,17 +4529,17 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	iov[0].iov_len = total_len - 1;
 	iov[0].iov_base = (char *)req;
 
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
-	rqst.rq_pages = wdata->pages;
-	rqst.rq_offset = wdata->page_offset;
-	rqst.rq_npages = wdata->nr_pages;
-	rqst.rq_pagesz = wdata->pagesz;
-	rqst.rq_tailsz = wdata->tailsz;
+	rqst.iov = iov;
+	rqst.nvec = 1;
+	rqst.pages = wdata->pages;
+	rqst.offset = wdata->page_offset;
+	rqst.npages = wdata->nr_pages;
+	rqst.pagesz = wdata->pagesz;
+	rqst.tailsz = wdata->tailsz;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (wdata->mr) {
 		iov[0].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
-		rqst.rq_npages = 0;
+		rqst.npages = 0;
 	}
 #endif
 	cifs_dbg(FYI, "async write at %llu %u bytes\n",
@@ -4644,8 +4644,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	iov[0].iov_len = total_len - 1;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec + 1;
+	rqst.iov = iov;
+	rqst.nvec = n_vec + 1;
 
 	rc = cifs_send_recv(xid, io_parms->tcon->ses, server,
 			    &rqst,
@@ -4835,7 +4835,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 		MAX_SMB2_CREATE_RESPONSE_SIZE -
 		MAX_SMB2_CLOSE_RESPONSE_SIZE;
 	unsigned int total_len;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	int len, rc;
 
 	rc = smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, server,
@@ -4893,8 +4893,8 @@ int SMB2_query_directory_init(const unsigned int xid,
 
 void SMB2_query_directory_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov) {
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	if (rqst && rqst->iov) {
+		cifs_small_buf_release(rqst->iov[0].iov_base); /* request */
 	}
 }
 
@@ -4993,8 +4993,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
+	rqst.iov = iov;
+	rqst.nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
 
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst, persistent_fid,
@@ -5048,7 +5048,7 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 		   void **data, unsigned int *size)
 {
 	struct smb2_set_info_req *req;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	unsigned int i, total_len;
 	int rc;
 
@@ -5075,7 +5075,7 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 	/* 1 for Buffer */
 	iov[0].iov_len = total_len - 1;
 
-	for (i = 1; i < rqst->rq_nvec; i++) {
+	for (i = 1; i < rqst->nvec; i++) {
 		le32_add_cpu(&req->BufferLength, size[i]);
 		iov[i].iov_base = (char *)data[i];
 		iov[i].iov_len = size[i];
@@ -5087,8 +5087,8 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct cifs_server_info *server,
 void
 SMB2_set_info_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov)
-		cifs_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	if (rqst && rqst->iov)
+		cifs_buf_release(rqst->iov[0].iov_base); /* request */
 }
 
 static int
@@ -5121,8 +5121,8 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = num;
+	rqst.iov = iov;
+	rqst.nvec = num;
 
 	rc = SMB2_set_info_init(tcon, server,
 				&rqst, persistent_fid, volatile_fid, pid,
@@ -5227,8 +5227,8 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
@@ -5334,8 +5334,8 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = &iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = &iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -5385,8 +5385,8 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = &iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = &iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -5452,8 +5452,8 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = &iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = &iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -5537,8 +5537,8 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_stats_inc(&tcon->stats.cifs.locks);
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
+	rqst.iov = iov;
+	rqst.nvec = 2;
 
 	rc = cifs_send_recv(xid, tcon->ses, server,
 			    &rqst, &resp_buf_type, flags,
@@ -5610,8 +5610,8 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rqst.iov = iov;
+	rqst.nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2b6ffd255d75..53ef472342ec 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -216,7 +216,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 	struct shash_desc *shash;
@@ -269,7 +269,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 	 * __cifs_calc_signature().
 	 */
 	drqst = *rqst;
-	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
+	if (drqst.nvec >= 2 && iov[0].iov_len == 4) {
 		rc = crypto_shash_update(shash, iov[0].iov_base,
 					 iov[0].iov_len);
 		if (rc) {
@@ -278,8 +278,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 					__func__);
 			goto out;
 		}
-		drqst.rq_iov++;
-		drqst.rq_nvec--;
+		drqst.iov++;
+		drqst.nvec--;
 	}
 
 	rc = __cifs_calc_signature(&drqst, server, sigptr, shash);
@@ -548,7 +548,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
-	struct kvec *iov = rqst->rq_iov;
+	struct kvec *iov = rqst->iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct shash_desc *shash;
 	struct crypto_shash *hash;
@@ -599,7 +599,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 	 * __cifs_calc_signature().
 	 */
 	drqst = *rqst;
-	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
+	if (drqst.nvec >= 2 && iov[0].iov_len == 4) {
 		rc = crypto_shash_update(shash, iov[0].iov_base,
 					 iov[0].iov_len);
 		if (rc) {
@@ -607,8 +607,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct cifs_server_info *server,
 				 __func__);
 			goto out;
 		}
-		drqst.rq_iov++;
-		drqst.rq_nvec--;
+		drqst.iov++;
+		drqst.nvec--;
 	}
 
 	rc = __cifs_calc_signature(&drqst, server, sigptr, shash);
@@ -631,7 +631,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server)
 	bool is_binding;
 	bool is_signed;
 
-	shdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	shdr = (struct smb2_hdr *)rqst->iov[0].iov_base;
 	ssr = (struct smb2_sess_setup_req *)shdr;
 
 	is_binding = shdr->Command == SMB2_SESSION_SETUP &&
@@ -663,7 +663,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct cifs_server_info *server)
 	unsigned int rc;
 	char server_response_sig[SMB2_SIGNATURE_SIZE];
 	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+			(struct smb2_hdr *)rqst->iov[0].iov_base;
 
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
@@ -814,8 +814,8 @@ smb2_check_receive(struct mid_q_entry *mid, struct cifs_server_info *server,
 {
 	unsigned int len = mid->resp_buf_size;
 	struct kvec iov[1];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 1 };
+	struct smb_rqst rqst = { .iov = iov,
+				 .nvec = 1 };
 
 	iov[0].iov_base = (char *)mid->resp_buf;
 	iov[0].iov_len = len;
@@ -840,7 +840,7 @@ smb2_setup_request(struct cifs_ses *ses, struct cifs_server_info *server,
 {
 	int rc;
 	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+			(struct smb2_hdr *)rqst->iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(server, shdr);
@@ -866,7 +866,7 @@ smb2_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+			(struct smb2_hdr *)rqst->iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	spin_lock(&g_servers_lock);
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index f897af5d5fef..67852fa831c5 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2025,17 +2025,17 @@ int smbd_send(struct cifs_server_info *server,
 	rqst_idx = 0;
 next_rqst:
 	rqst = &rqst_array[rqst_idx];
-	iov = rqst->rq_iov;
+	iov = rqst->iov;
 
 	cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
 		rqst_idx, smb_rqst_len(server, rqst));
-	for (i = 0; i < rqst->rq_nvec; i++)
+	for (i = 0; i < rqst->nvec; i++)
 		dump_smb(iov[i].iov_base, iov[i].iov_len);
 
 
-	log_write(INFO, "rqst_idx=%d nvec=%d rqst->rq_npages=%d rq_pagesz=%d rq_tailsz=%d buflen=%lu\n",
-		  rqst_idx, rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
-		  rqst->rq_tailsz, smb_rqst_len(server, rqst));
+	log_write(INFO, "rqst_idx=%d nvec=%d rqst->npages=%d rq_pagesz=%d rq_tailsz=%d buflen=%lu\n",
+		  rqst_idx, rqst->nvec, rqst->npages, rqst->pagesz,
+		  rqst->tailsz, smb_rqst_len(server, rqst));
 
 	start = i = 0;
 	buflen = 0;
@@ -2080,14 +2080,14 @@ int smbd_send(struct cifs_server_info *server,
 						goto done;
 				}
 				i++;
-				if (i == rqst->rq_nvec)
+				if (i == rqst->nvec)
 					break;
 			}
 			start = i;
 			buflen = 0;
 		} else {
 			i++;
-			if (i == rqst->rq_nvec) {
+			if (i == rqst->nvec) {
 				/* send out all remaining vecs */
 				remaining_data_length -= buflen;
 				log_write(INFO, "sending iov[] from start=%d i=%d nvecs=%d remaining_data_length=%d\n",
@@ -2104,7 +2104,7 @@ int smbd_send(struct cifs_server_info *server,
 	}
 
 	/* now sending pages if there are any */
-	for (i = 0; i < rqst->rq_npages; i++) {
+	for (i = 0; i < rqst->npages; i++) {
 		unsigned int offset;
 
 		rqst_page_get_length(rqst, i, &buflen, &offset);
@@ -2120,7 +2120,7 @@ int smbd_send(struct cifs_server_info *server,
 				  i, j * max_iov_size + offset, size,
 				  remaining_data_length);
 			rc = smbd_post_send_page(
-				info, rqst->rq_pages[i],
+				info, rqst->pages[i],
 				j*max_iov_size + offset,
 				size, remaining_data_length);
 			if (rc)
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0849f96ee580..a2d83952626e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -264,12 +264,12 @@ smb_rqst_len(struct cifs_server_info *server, struct smb_rqst *rqst)
 	unsigned long buflen = 0;
 
 	if (server->vals->header_preamble_size == 0 &&
-	    rqst->rq_nvec >= 2 && rqst->rq_iov[0].iov_len == 4) {
-		iov = &rqst->rq_iov[1];
-		nvec = rqst->rq_nvec - 1;
+	    rqst->nvec >= 2 && rqst->iov[0].iov_len == 4) {
+		iov = &rqst->iov[1];
+		nvec = rqst->nvec - 1;
 	} else {
-		iov = rqst->rq_iov;
-		nvec = rqst->rq_nvec;
+		iov = rqst->iov;
+		nvec = rqst->nvec;
 	}
 
 	/* total up iov array first */
@@ -282,17 +282,17 @@ smb_rqst_len(struct cifs_server_info *server, struct smb_rqst *rqst)
 	 * multiple pages ends at page boundary, rq_tailsz needs to be set to
 	 * PAGE_SIZE.
 	 */
-	if (rqst->rq_npages) {
-		if (rqst->rq_npages == 1)
-			buflen += rqst->rq_tailsz;
+	if (rqst->npages) {
+		if (rqst->npages == 1)
+			buflen += rqst->tailsz;
 		else {
 			/*
 			 * If there is more than one page, calculate the
 			 * buffer length based on rq_offset and rq_tailsz
 			 */
-			buflen += rqst->rq_pagesz * (rqst->rq_npages - 1) -
-					rqst->rq_offset;
-			buflen += rqst->rq_tailsz;
+			buflen += rqst->pagesz * (rqst->npages - 1) -
+					rqst->offset;
+			buflen += rqst->tailsz;
 		}
 	}
 
@@ -365,8 +365,8 @@ __smb_send_rqst(struct cifs_server_info *server, int num_rqst,
 	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
 
 	for (j = 0; j < num_rqst; j++) {
-		iov = rqst[j].rq_iov;
-		n_vec = rqst[j].rq_nvec;
+		iov = rqst[j].iov;
+		n_vec = rqst[j].nvec;
 
 		size = 0;
 		for (i = 0; i < n_vec; i++) {
@@ -383,10 +383,10 @@ __smb_send_rqst(struct cifs_server_info *server, int num_rqst,
 		total_len += sent;
 
 		/* now walk the page array and send each page in it */
-		for (i = 0; i < rqst[j].rq_npages; i++) {
+		for (i = 0; i < rqst[j].npages; i++) {
 			struct bio_vec bvec;
 
-			bvec.bv_page = rqst[j].rq_pages[i];
+			bvec.bv_page = rqst[j].pages[i];
 			rqst_page_get_length(&rqst[j], i, &bvec.bv_len,
 					     &bvec.bv_offset);
 
@@ -473,8 +473,8 @@ smb_send_rqst(struct cifs_server_info *server, int num_rqst,
 
 	iov.iov_base = tr_hdr;
 	iov.iov_len = sizeof(*tr_hdr);
-	cur_rqst[0].rq_iov = &iov;
-	cur_rqst[0].rq_nvec = 1;
+	cur_rqst[0].iov = &iov;
+	cur_rqst[0].nvec = 1;
 
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
 					    &cur_rqst[0], rqst);
@@ -493,8 +493,8 @@ smb_send(struct cifs_server_info *server, struct smb_hdr *smb_buffer,
 	 unsigned int smb_buf_length)
 {
 	struct kvec iov[2];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 2 };
+	struct smb_rqst rqst = { .iov = iov,
+				 .nvec = 2 };
 
 	iov[0].iov_base = smb_buffer;
 	iov[0].iov_len = 4;
@@ -771,11 +771,11 @@ struct mid_q_entry *
 cifs_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *hdr = (struct smb_hdr *)rqst->iov[0].iov_base;
 	struct mid_q_entry *mid;
 
-	if (rqst->rq_iov[0].iov_len != 4 ||
-	    rqst->rq_iov[0].iov_base + 4 != rqst->rq_iov[1].iov_base)
+	if (rqst->iov[0].iov_len != 4 ||
+	    rqst->iov[0].iov_base + 4 != rqst->iov[1].iov_base)
 		return ERR_PTR(-EIO);
 
 	/* enable signing if server requires it */
@@ -961,8 +961,8 @@ cifs_check_receive(struct mid_q_entry *mid, struct cifs_server_info *server,
 	if (server->sign) {
 		struct kvec iov[2];
 		int rc = 0;
-		struct smb_rqst rqst = { .rq_iov = iov,
-					 .rq_nvec = 2 };
+		struct smb_rqst rqst = { .iov = iov,
+					 .nvec = 2 };
 
 		iov[0].iov_base = mid->resp_buf;
 		iov[0].iov_len = 4;
@@ -985,11 +985,11 @@ cifs_setup_request(struct cifs_ses *ses, struct cifs_server_info *ignored,
 		   struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *hdr = (struct smb_hdr *)rqst->iov[0].iov_base;
 	struct mid_q_entry *mid;
 
-	if (rqst->rq_iov[0].iov_len != 4 ||
-	    rqst->rq_iov[0].iov_base + 4 != rqst->rq_iov[1].iov_base)
+	if (rqst->iov[0].iov_len != 4 ||
+	    rqst->iov[0].iov_base + 4 != rqst->iov[1].iov_base)
 		return ERR_PTR(-EIO);
 
 	rc = allocate_mid(ses, hdr, &mid);
@@ -1191,7 +1191,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&g_servers_lock);
 
 		cifs_server_lock(server);
-		smb311_update_preauth_hash(ses, server, rqst[0].rq_iov, rqst[0].rq_nvec);
+		smb311_update_preauth_hash(ses, server, rqst[0].iov, rqst[0].nvec);
 		cifs_server_unlock(server);
 
 		spin_lock(&g_servers_lock);
@@ -1327,8 +1327,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	new_iov[1].iov_len -= 4;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = new_iov;
-	rqst.rq_nvec = n_vec + 1;
+	rqst.iov = new_iov;
+	rqst.nvec = n_vec + 1;
 
 	rc = cifs_send_recv(xid, ses, ses->server,
 			    &rqst, resp_buf_type, flags, resp_iov);
@@ -1346,7 +1346,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	struct mid_q_entry *midQ;
 	unsigned int len = be32_to_cpu(in_buf->smb_buf_length);
 	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
-	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
+	struct smb_rqst rqst = { .iov = &iov, .nvec = 1 };
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 	struct cifs_server_info *server;
 
@@ -1489,7 +1489,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses;
 	unsigned int len = be32_to_cpu(in_buf->smb_buf_length);
 	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
-	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
+	struct smb_rqst rqst = { .iov = &iov, .nvec = 1 };
 	unsigned int instance;
 	struct cifs_server_info *server;
 
-- 
2.35.3

