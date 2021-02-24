Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7046C433E6
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C39B6146B
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBYAAu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:00:50 -0500
Received: from mx.cjr.nz ([51.158.111.142]:15480 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234584AbhBYAAu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 19:00:50 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CEFB97FF6C;
        Thu, 25 Feb 2021 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1614211208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGM9InzdbyXQsvSQl1gRr0fL8Ql+PeREhHw6A1cXBNM=;
        b=oNV4IQhJ9+UR1HuwCGkK/DLSGrdHuzChJH8geo6pUk0sxIO2jueRW2wn4PWVnZjV2h3zA/
        +E2HlBrSEf4tQUlgOI2kj9EGqTQwftCF/HjTeBsBviM5JUtg7V9n0Z2cl0fBDnBjPTRxu4
        GsHy4LBvuVoXS33216/Nr0Z3Og1k05SvwrlfPgsJ/1332LzVMgR6dO03Z8b0I07ETVnsnv
        L6hp72wQxZXu26DKtDqYVFMUm+Xp9vngMQMHYqCGpnGrdUleiqhjW9U82r/xbWs/Y5wQBr
        Txtb0giiNNLkaRT1D9fOd6Vc+4+D8M1v3ZIrd+kpkReYN9AmpkhnSjEyC4rE0g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/4] cifs: introduce helper for finding referral server
Date:   Wed, 24 Feb 2021 20:59:23 -0300
Message-Id: <20210224235924.29931-3-pc@cjr.nz>
In-Reply-To: <20210224235924.29931-1-pc@cjr.nz>
References: <20210224235924.29931-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Some servers seem to mistakenly report different values for
capabilities and share flags, so we can't always rely on those values
to decide whether the resolved target can handle any new DFS
referrals.

Add a new helper is_referral_server() to check if all resolved targets
can handle new DFS referrals by directly looking at the
GET_DFS_REFERRAL.ReferralHeaderFlags value as specified in MS-DFSC
2.2.4 RESP_GET_DFS_REFERRAL in addition to is_tcon_dfs().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c   | 35 ++++++++++++++++++++++++++++++++++-
 fs/cifs/dfs_cache.c | 33 +++++++++++++++++----------------
 2 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f1729890aca5..37452b2e24b8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3331,6 +3331,33 @@ static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context
 	return rc;
 }
 
+/* Check if resolved targets can handle any DFS referrals */
+static int is_referral_server(const char *ref_path, struct cifs_tcon *tcon, bool *ref_server)
+{
+	int rc;
+	struct dfs_info3_param ref = {0};
+
+	if (is_tcon_dfs(tcon)) {
+		*ref_server = true;
+	} else {
+		cifs_dbg(FYI, "%s: ref_path=%s\n", __func__, ref_path);
+
+		rc = dfs_cache_noreq_find(ref_path, &ref, NULL);
+		if (rc) {
+			cifs_dbg(VFS, "%s: dfs_cache_noreq_find: failed (rc=%d)\n", __func__, rc);
+			return rc;
+		}
+		cifs_dbg(FYI, "%s: ref.flags=0x%x\n", __func__, ref.flags);
+		/*
+		 * Check if all targets are capable of handling DFS referrals as per
+		 * MS-DFSC 2.2.4 RESP_GET_DFS_REFERRAL.
+		 */
+		*ref_server = !!(ref.flags & DFSREF_REFERRAL_SERVER);
+		free_dfs_info_param(&ref);
+	}
+	return 0;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
@@ -3342,6 +3369,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	char *ref_path = NULL, *full_path = NULL;
 	char *oldmnt = NULL;
 	char *mntdata = NULL;
+	bool ref_server = false;
 
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
@@ -3407,11 +3435,16 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			break;
 		if (!tcon)
 			continue;
+
 		/* Make sure that requests go through new root servers */
-		if (is_tcon_dfs(tcon)) {
+		rc = is_referral_server(ref_path + 1, tcon, &ref_server);
+		if (rc)
+			break;
+		if (ref_server) {
 			put_root_ses(root_ses);
 			set_root_ses(cifs_sb, ses, &root_ses);
 		}
+
 		/* Get next dfs path and then continue chasing them if -EREMOTE */
 		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
 		/* Prevent recursion on broken link referrals */
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 4950ab0486ae..098b4bc8da59 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -37,11 +37,12 @@ struct cache_dfs_tgt {
 struct cache_entry {
 	struct hlist_node hlist;
 	const char *path;
-	int ttl;
-	int srvtype;
-	int flags;
+	int hdr_flags; /* RESP_GET_DFS_REFERRAL.ReferralHeaderFlags */
+	int ttl; /* DFS_REREFERRAL_V3.TimeToLive */
+	int srvtype; /* DFS_REREFERRAL_V3.ServerType */
+	int ref_flags; /* DFS_REREFERRAL_V3.ReferralEntryFlags */
 	struct timespec64 etime;
-	int path_consumed;
+	int path_consumed; /* RESP_GET_DFS_REFERRAL.PathConsumed */
 	int numtgts;
 	struct list_head tlist;
 	struct cache_dfs_tgt *tgthint;
@@ -166,14 +167,11 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				continue;
 
 			seq_printf(m,
-				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,"
-				   "interlink=%s,path_consumed=%d,expired=%s\n",
-				   ce->path,
-				   ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
-				   ce->ttl, ce->etime.tv_nsec,
-				   IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
-				   ce->path_consumed,
-				   cache_entry_expired(ce) ? "yes" : "no");
+				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
+				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
+				   ce->ttl, ce->etime.tv_nsec, ce->ref_flags, ce->hdr_flags,
+				   IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
+				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
 			list_for_each_entry(t, &ce->tlist, list) {
 				seq_printf(m, "  %s%s\n",
@@ -236,11 +234,12 @@ static inline void dump_tgts(const struct cache_entry *ce)
 
 static inline void dump_ce(const struct cache_entry *ce)
 {
-	cifs_dbg(FYI, "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,interlink=%s,path_consumed=%d,expired=%s\n",
+	cifs_dbg(FYI, "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 		 ce->path,
 		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
 		 ce->etime.tv_nsec,
-		 IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
+		 ce->hdr_flags, ce->ref_flags,
+		 IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
 		 ce->path_consumed,
 		 cache_entry_expired(ce) ? "yes" : "no");
 	dump_tgts(ce);
@@ -381,7 +380,8 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 	ce->ttl = refs[0].ttl;
 	ce->etime = get_expire_time(ce->ttl);
 	ce->srvtype = refs[0].server_type;
-	ce->flags = refs[0].ref_flag;
+	ce->hdr_flags = refs[0].flags;
+	ce->ref_flags = refs[0].ref_flag;
 	ce->path_consumed = refs[0].path_consumed;
 
 	for (i = 0; i < numrefs; i++) {
@@ -799,7 +799,8 @@ static int setup_referral(const char *path, struct cache_entry *ce,
 	ref->path_consumed = ce->path_consumed;
 	ref->ttl = ce->ttl;
 	ref->server_type = ce->srvtype;
-	ref->ref_flag = ce->flags;
+	ref->ref_flag = ce->ref_flags;
+	ref->flags = ce->hdr_flags;
 
 	return 0;
 
-- 
2.30.1

