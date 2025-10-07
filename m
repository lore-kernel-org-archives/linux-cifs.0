Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D660B1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859096; cv=none; b=fQr9J6KLUgrnjolznk7r/LDzygvRs5bTqmcvTpbb02jk/4U5AK8gQEInlelym3pEUht0QnSEBPrNc7CYRgJejS8OJe+uxdoL5sZ1Kkcy7r13ceRj9Zjt0+jaKrBDPZt0op2BsyHIUfBIxXe/lmWpRYX2vHh/w2AkZGh4goRB2jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859096; c=relaxed/simple;
	bh=qHQAHnOK0eo7UFK4ICgLfU6JPmc3NH15Eumal4GlHck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USekCt0yxiuX3pmvd3jzjh78b3sRu44x3x8VJ7OdJPApVvnRanZAUfQo0c6HyEP8ZkRBQJAvEjFofBeQqJHlhmG0vgn6qqKx2cj1XeWhD/xfkFfWviGimBtEx+lC9TA3+kDwN51dgFZTbFgKpTb9jyFlfkLMQAqc+AxkovIIDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JcUpzu4k; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OOui5Mab; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JcUpzu4k; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OOui5Mab; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JcUpzu4k";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OOui5Mab";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JcUpzu4k";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OOui5Mab"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E29220AD0;
	Tue,  7 Oct 2025 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdKGpm2Az0xziL+0brfEHqjHURDiqfa+uWfrIQaEOz4=;
	b=JcUpzu4ktt2HLrCxm2pfjibOVsA+/RSItPU1Qybcb0OVA7rVaABWEdr/zfJFkUfpgR0VtH
	2OmGJRQl2tyDloCswSofYNMJkIYHVDRF73FZVPRvc7D1gjSya027wJA7DHRYjAbpzKrN+9
	JuQJAIBQnHvsef3YgbfQO+hUM6MHWXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdKGpm2Az0xziL+0brfEHqjHURDiqfa+uWfrIQaEOz4=;
	b=OOui5MabJ2eSOw0PDaxcPBKeZjdM8BObL84MaoMtaAM3AmMXjOr4PN302kuAv6E72YZeTV
	CdjYUCdve2m7vOAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JcUpzu4k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OOui5Mab
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdKGpm2Az0xziL+0brfEHqjHURDiqfa+uWfrIQaEOz4=;
	b=JcUpzu4ktt2HLrCxm2pfjibOVsA+/RSItPU1Qybcb0OVA7rVaABWEdr/zfJFkUfpgR0VtH
	2OmGJRQl2tyDloCswSofYNMJkIYHVDRF73FZVPRvc7D1gjSya027wJA7DHRYjAbpzKrN+9
	JuQJAIBQnHvsef3YgbfQO+hUM6MHWXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdKGpm2Az0xziL+0brfEHqjHURDiqfa+uWfrIQaEOz4=;
	b=OOui5MabJ2eSOw0PDaxcPBKeZjdM8BObL84MaoMtaAM3AmMXjOr4PN302kuAv6E72YZeTV
	CdjYUCdve2m7vOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19E8213693;
	Tue,  7 Oct 2025 17:44:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id glOLNHZR5WhIeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:44:22 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 20/20] smb: client: cleanup open_cached_dir()
Date: Tue,  7 Oct 2025 14:43:04 -0300
Message-ID: <20251007174304.1755251-21-ematsumiya@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007174304.1755251-1-ematsumiya@suse.de>
References: <20251007174304.1755251-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 8E29220AD0
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL73jpmmudngk8cygugnauyh74)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

A bit of refactoring, and merge path_no_prefix() into path_to_dentry().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 133 ++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 77 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index defdde4f7ff1..43f9acb176e4 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -188,13 +188,33 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 	return found;
 }
 
-static struct dentry *
-path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
+/*
+ * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up calling ->lookup()
+ * which already adds those through build_path_from_dentry().
+ *
+ * Also, this should be called before sending a network request as we might reconnect and
+ * potentially end up having a different prefix path (e.g. after DFS failover).
+ *
+ * Callers must dput() returned dentry if !IS_ERR().
+ */
+static struct dentry *path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 {
 	struct dentry *dentry;
 	const char *s, *p;
 	char sep;
 
+	if (!*path)
+		return dget(cifs_sb->root);
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) && cifs_sb->prepath) {
+		size_t len = strlen(cifs_sb->prepath) + 1;
+
+		if (unlikely(len > strlen(path)))
+			return ERR_PTR(-EINVAL);
+
+		path += len;
+	}
+
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(cifs_sb->root);
 	s = path;
@@ -219,29 +239,12 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 		while (*s && *s != sep)
 			s++;
 
-		child = lookup_noperm_positive_unlocked(&QSTR_LEN(p, s - p),
-							dentry);
+		child = lookup_noperm_positive_unlocked(&QSTR_LEN(p, s - p), dentry);
 		dput(dentry);
 		dentry = child;
 	} while (!IS_ERR(dentry));
-	return dentry;
-}
-
-static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
-				  const char *path)
-{
-	size_t len = 0;
-
-	if (!*path)
-		return path;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
-	    cifs_sb->prepath) {
-		len = strlen(cifs_sb->prepath) + 1;
-		if (unlikely(len > strlen(path)))
-			return ERR_PTR(-EINVAL);
-	}
-	return path + len;
+	return dentry;
 }
 
 /*
@@ -277,31 +280,29 @@ struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, i
 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		    struct cifs_sb_info *cifs_sb, struct cached_fid **ret_cfid)
 {
-	struct cifs_ses *ses;
+	int rc, flags = 0, retries = 0, cur_sleep = 1;
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct TCP_Server_Info *server;
 	struct cifs_open_parms oparms;
-	struct smb2_create_rsp *o_rsp = NULL;
-	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct smb2_file_all_info info;
-	int resp_buftype[2];
+	struct smb2_create_rsp *o_rsp = NULL;
+	struct cached_fids *cfids;
+	struct cached_fid *cfid;
 	struct smb_rqst rqst[2];
 	struct kvec rsp_iov[2];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct cifs_fid *pfid;
+	struct dentry *dentry;
 	struct kvec qi_iov[1];
-	int rc, flags = 0;
+	struct cifs_ses *ses;
+	int resp_buftype[2];
 	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
-	struct cifs_fid *pfid;
-	struct dentry *dentry;
-	struct cached_fid *cfid;
-	struct cached_fids *cfids;
-	const char *npath;
-	int retries = 0, cur_sleep = 1;
 
-	if (cifs_sb->root == NULL)
+	if (!cifs_sb->root)
 		return -ENOENT;
 
-	if (tcon == NULL)
+	if (!tcon)
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
@@ -331,10 +332,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		return 0;
 	}
 
-	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
 	read_seqlock_excl(&cfids->entries_seqlock);
 	if (cfids->num_entries >= tcon->max_cached_dirs) {
 		read_sequnlock_excl(&cfids->entries_seqlock);
@@ -354,30 +351,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	cfid->tcon = tcon;
 	pfid = &cfid->fid;
 
-	/*
-	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
-	 * calling ->lookup() which already adds those through
-	 * build_path_from_dentry().  Also, do it earlier as we might reconnect
-	 * below when trying to send compounded request and then potentially
-	 * having a different prefix path (e.g. after DFS failover).
-	 */
-	npath = path_no_prefix(cifs_sb, path);
-	if (IS_ERR(npath)) {
-		rc = PTR_ERR(npath);
+	dentry = path_to_dentry(cifs_sb, path);
+	if (IS_ERR(dentry)) {
+		rc = PTR_ERR(dentry);
+		dentry = NULL;
 		goto out;
 	}
 
-	if (!npath[0]) {
-		dentry = dget(cifs_sb->root);
-	} else {
-		dentry = path_to_dentry(cifs_sb, npath);
-		if (IS_ERR(dentry)) {
-			dentry = NULL;
-			rc = -ENOENT;
-			goto out;
-		}
-	}
-
 	write_seqlock(&cfids->entries_seqlock);
 	write_seqlock(&cfid->seqlock);
 	cfid->dentry = dentry;
@@ -415,21 +395,26 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	oparms.fid = pfid;
 	oparms.replay = !!retries;
 
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path) {
+		rc = -ENOMEM;
+		goto oshr_free;
+	}
+
 	rc = SMB2_open_init(tcon, server, &rqst[0], &oplock, &oparms, utf16_path);
+	kfree(utf16_path);
+
 	if (rc)
 		goto oshr_free;
-	smb2_set_next_command(tcon, &rqst[0]);
 
+	smb2_set_next_command(tcon, &rqst[0]);
 	memset(&qi_iov, 0, sizeof(qi_iov));
 	rqst[1].rq_iov = qi_iov;
 	rqst[1].rq_nvec = 1;
 
-	rc = SMB2_query_info_init(tcon, server,
-				  &rqst[1], COMPOUND_FID,
-				  COMPOUND_FID, FILE_ALL_INFORMATION,
-				  SMB2_O_INFO_FILE, 0,
-				  sizeof(struct smb2_file_all_info) +
-				  PATH_MAX * 2, 0, NULL);
+	rc = SMB2_query_info_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
+				  FILE_ALL_INFORMATION, SMB2_O_INFO_FILE, 0,
+				  sizeof(struct smb2_file_all_info) + PATH_MAX * 2, 0, NULL);
 	if (rc)
 		goto oshr_free;
 
@@ -440,14 +425,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		smb2_set_replay(server, &rqst[1]);
 	}
 
-	rc = compound_send_recv(xid, ses, server,
-				flags, 2, rqst,
-				resp_buftype, rsp_iov);
+	rc = compound_send_recv(xid, ses, server, flags, 2, rqst, resp_buftype, rsp_iov);
 	if (rc) {
 		if (rc == -EREMCHG) {
 			tcon->need_reconnect = true;
-			pr_warn_once("server share %s deleted\n",
-				     tcon->tree_name);
+			pr_warn_once("server share %s deleted\n", tcon->tree_name);
 		}
 		goto oshr_free;
 	}
@@ -459,7 +441,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
 		rc = -EINVAL;
 		goto oshr_free;
@@ -478,9 +459,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
 
-	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset),
-					sizeof(struct smb2_file_all_info), &rsp_iov[1],
-					sizeof(struct smb2_file_all_info), (char *)&info)) {
+	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset), sizeof(info),
+					&rsp_iov[1], sizeof(info), (char *)&info)) {
 		cfid->file_all_info = kmemdup(&info, sizeof(info), GFP_ATOMIC);
 		if (!cfid->file_all_info) {
 			rc = -ENOMEM;
@@ -514,7 +494,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
-	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
-- 
2.51.0

