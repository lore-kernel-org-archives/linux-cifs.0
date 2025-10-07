Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031272E8B67
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859031; cv=none; b=NtFrO16PTQh0I5PnJOTfPMdi4+ds202BpUK6ak3P16LiLoYnI++fPY+ovfzr0FpkT/jiYIOldl8dSwDaaxhjt+CJk/iPMPSa8WMJrxDUY5OdbzBYuWq1X7MweKB3QX/c+BaqnMsaCGxsQsPBdf5xuJJf3eL0bWOwi4q/p9O3WeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859031; c=relaxed/simple;
	bh=/9yZ58yiiezi8oYQxkqUV/UaWn42VN4V1OhTFa3ZX8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4Z+Cg/FUqVrPpe2v2TMkMI5fQ+DofPY5tV+xniqjcTJ/GjWwYwINCAfwqqGPG3OiDeJtSWONRLObo9ZUBw9blK+hsL99kQ4tSGYt4japn/PBul8S8KBpJTTRekAMHebevYGbZYgd+kGn6RCUFnik+Jl6LJohaC/9iunRoimroY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RBqVyA/Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eubZBr81; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RBqVyA/Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eubZBr81; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RBqVyA/Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eubZBr81";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RBqVyA/Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eubZBr81"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FB3020AAD;
	Tue,  7 Oct 2025 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbcOyk5eOuuXIE6vSnbkmGIVyAdtf6JGCrR+/hy7CDk=;
	b=RBqVyA/Q6+fuiNaCTPFjeEOykpqCq9d3scu40WDgBh1rlNS2JWI9h+zEYFnFUEMq1jBlCL
	Hz9rRgkj5RCcECEdG6RDRTbPU9y5scc7SGvKNiTjplYcAWI9fEEuTi97Mxb/KqXwjAZp3r
	fXsoS6gS9K8ME9mGF3nWujkFNUcQ8BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbcOyk5eOuuXIE6vSnbkmGIVyAdtf6JGCrR+/hy7CDk=;
	b=eubZBr81Ran0dgG1pb6yIiIVtV1lOvIuEnx+yCXAV8jl5a0y/ELhvfz0wHzouzzfdLwZz1
	YlT4lewWE92yA1DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RBqVyA/Q";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eubZBr81
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbcOyk5eOuuXIE6vSnbkmGIVyAdtf6JGCrR+/hy7CDk=;
	b=RBqVyA/Q6+fuiNaCTPFjeEOykpqCq9d3scu40WDgBh1rlNS2JWI9h+zEYFnFUEMq1jBlCL
	Hz9rRgkj5RCcECEdG6RDRTbPU9y5scc7SGvKNiTjplYcAWI9fEEuTi97Mxb/KqXwjAZp3r
	fXsoS6gS9K8ME9mGF3nWujkFNUcQ8BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbcOyk5eOuuXIE6vSnbkmGIVyAdtf6JGCrR+/hy7CDk=;
	b=eubZBr81Ran0dgG1pb6yIiIVtV1lOvIuEnx+yCXAV8jl5a0y/ELhvfz0wHzouzzfdLwZz1
	YlT4lewWE92yA1DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFC1A13693;
	Tue,  7 Oct 2025 17:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hr9uHVNR5WgTeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:47 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 10/20] smb: client: refactor dropping cached dirs
Date: Tue,  7 Oct 2025 14:42:54 -0300
Message-ID: <20251007174304.1755251-11-ematsumiya@suse.de>
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
X-Rspamd-Queue-Id: 2FB3020AAD
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

- s/drop_cached_dir_by_name/drop_cached_dir/
  make it a generic find + invalidate function to replace
  drop_cached_dir_by_name() and cached_dir_lease_break()

We now funnel any cleanup to laundromat, so we can make the release
callback free only dirents, path, and cfid itself.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 78 +++++++++++---------------------------
 fs/smb/client/cached_dir.h |  3 +-
 fs/smb/client/inode.c      |  2 +-
 fs/smb/client/smb2inode.c  |  7 ++--
 fs/smb/client/smb2misc.c   |  2 +-
 5 files changed, 29 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 100d608828f2..bae298af4099 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -476,22 +476,6 @@ smb2_close_cached_fid(struct kref *ref)
 	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
 	struct cached_dirent *de, *q;
 
-	/*
-	 * There's no way a valid cfid can reach here.
-	 *
-	 * This is because we hould our own ref, and whenever we put it, we invalidate the cfid.
-	 *
-	 * So even if an external caller puts the last ref, cfid will already have been invalidated
-	 * by then by one of the invalidations that can happen concurrently, e.g. lease break,
-	 * invalidate_all_cached_dirs().
-	 *
-	 * So this check is mostly for precaution, but since we can still take the correct action
-	 * (just list_del()) if it's the case, do so.
-	 */
-	if (WARN_ON(is_valid_cached_dir(cfid)))
-		/* remaining invalidation done by drop_cfid() below */
-		list_del(&cfid->entry);
-
 	drop_cfid(cfid);
 
 	/* Delete all cached dirent names */
@@ -506,23 +490,36 @@ smb2_close_cached_fid(struct kref *ref)
 	kfree(cfid);
 }
 
-void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name)
+bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 {
 	struct cached_fid *cfid;
 
-	if (!cfids)
-		return;
+	if (!cfids || !key)
+		return false;
 
-	cfid = find_cached_dir(cfids, name, CFID_LOOKUP_PATH);
-	if (!cfid) {
-		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
-		return;
-	}
+	/*
+	 * Raw lookup here as we _must_ find any matching cfid, no matter its state.
+	 * Also, we might be racing with the SMB2 open in open_cached_dir(), so no need to wait
+	 * for it to finish.
+	 */
+	cfid = find_cfid(cfids, key, mode, false);
+	if (!cfid)
+		return false;
 
-	drop_cfid(cfid);
+	if (mode != CFID_LOOKUP_LEASEKEY) {
+		drop_cfid(cfid);
+	} else {
+		/* we're locked in smb2_is_valid_lease_break(), so can't dput/close here */
+		spin_lock(&cfids->cfid_list_lock);
+		invalidate_cfid(cfid);
+		spin_unlock(&cfids->cfid_list_lock);
+	}
 
 	/* put lookup ref */
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+
+	return true;
 }
 
 void close_cached_dir(struct cached_fid *cfid)
@@ -589,37 +586,6 @@ void invalidate_all_cached_dirs(struct cached_fids *cfids)
 	flush_delayed_work(&cfids->laundromat_work);
 }
 
-bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
-{
-	struct cached_fids *cfids = tcon->cfids;
-	struct cached_fid *cfid;
-
-	if (cfids == NULL)
-		return false;
-
-	/*
-	 * Raw lookup here as we _must_ find our lease, no matter cfid state.
-	 * Also, this lease break might be coming from the SMB2 open in open_cached_dir(), so no
-	 * need to wait for it to finish.
-	 */
-	cfid = find_cfid(cfids, lease_key, CFID_LOOKUP_LEASEKEY, false);
-	if (cfid) {
-		/* found a lease, invalidate cfid and schedule immediate cleanup on laundromat */
-		spin_lock(&cfids->cfid_list_lock);
-		invalidate_cfid(cfid);
-		cfid->has_lease = false;
-		spin_unlock(&cfids->cfid_list_lock);
-
-		/* put lookup ref */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
-
-		return true;
-	}
-
-	return false;
-}
-
 static struct cached_fid *init_cached_dir(const char *path)
 {
 	struct cached_fid *cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 8d9733b8fbb6..e338c7afcb50 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -89,8 +89,7 @@ extern struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 			   struct cifs_sb_info *cifs_sb, struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
-extern void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name);
+extern bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cached_fids *cfids);
-extern bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 34a31617c298..1fe7eb315dda 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2629,7 +2629,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			 * ->i_nlink and then mark it as delete pending.
 			 */
 			if (S_ISDIR(inode->i_mode)) {
-				drop_cached_dir_by_name(tcon->cfids, to_name);
+				drop_cached_dir(tcon->cfids, to_name, CFID_LOOKUP_PATH);
 				spin_lock(&inode->i_lock);
 				i_size_write(inode, 0);
 				clear_nlink(inode);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 33962c72e2fc..90b869b59ff6 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1160,7 +1160,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	struct cifs_open_parms oparms;
 
-	drop_cached_dir_by_name(tcon->cfids, name);
+	drop_cached_dir(tcon->cfids, name, CFID_LOOKUP_PATH);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
 			     FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
 	return smb2_compound_op(xid, tcon, cifs_sb,
@@ -1315,7 +1315,7 @@ int smb2_rename_path(const unsigned int xid,
 	struct cifsFileInfo *cfile;
 	__u32 co = file_create_options(source_dentry);
 
-	drop_cached_dir_by_name(tcon->cfids, from_name);
+	drop_cached_dir(tcon->cfids, from_name, CFID_LOOKUP_PATH);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
@@ -1597,7 +1597,8 @@ int smb2_rename_pending_delete(const char *full_path,
 		goto out;
 	}
 
-	drop_cached_dir_by_name(tcon->cfids, full_path);
+	drop_cached_dir(tcon->cfids, full_path, CFID_LOOKUP_PATH);
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     DELETE | FILE_WRITE_ATTRIBUTES,
 			     FILE_OPEN, co, ACL_NO_MODE);
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 89d933b4a8bc..71d987f76a12 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -660,7 +660,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 			}
 			spin_unlock(&tcon->open_file_lock);
 
-			if (cached_dir_lease_break(tcon, rsp->LeaseKey)) {
+			if (drop_cached_dir(tcon->cfids, rsp->LeaseKey, CFID_LOOKUP_LEASEKEY)) {
 				spin_unlock(&cifs_tcp_ses_lock);
 				return true;
 			}
-- 
2.51.0

