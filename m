Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA151F95C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152558; cv=none; b=iGZ5qQHWvhfPxBm6Ms9ZSw2NbOdX4sTTc6W6Bh9KxMg0Ls0oVZO8NBZdV/eyF1YhnX3HIdg5RXyE8OPOzG/K3bx3WN6RdHvuR7v6/obkn3YD3LbT5pAhqJCbrSyAooLYnHPderfPR8QUds3IutgHZjtY4QYcH2DqrMTWfk2pZgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152558; c=relaxed/simple;
	bh=dPOcAXxS8b034KnM7BqMzKsiwyq+aFY2Sf8pdHBrn18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcraZBAE/D281aLGgGSoV47mzi1VVsAgMFYw4ELgk+H4vCOyWf63Xo4KpWiVENhxjMJe9hGCl+9WFDMZ0T5ht84GysDCMZzUkxw8FOxs4GcnQRY0M6iyBLtbpCxi66HxXaAsvsK6Bl/cpZaiifOvLKR6Xe5IFQHHdnl/+leLkgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vU2b0lj0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LDeFWTwP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vU2b0lj0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LDeFWTwP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vU2b0lj0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LDeFWTwP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vU2b0lj0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LDeFWTwP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C973320FE5;
	Mon, 29 Sep 2025 13:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IE7da0SZmT1nYrHxN/buoJs+W2XgXyGbewqcG7mTBq4=;
	b=vU2b0lj03jPBuVw/sPBLo4pqWioBGVMEJDr7c8m9ksJNRL7i6VJchXDYi3JJyJF7UxajeX
	KHMJKs31vu7pYrcFAfs75qz8k/+J2brO96TaPWg/hBXKwLpiRTRkfIMMsYPke7eVS0zAPY
	IkvTTzgztDxW3JlCl3jxYGwvsdXoNw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IE7da0SZmT1nYrHxN/buoJs+W2XgXyGbewqcG7mTBq4=;
	b=LDeFWTwPxXIT08PqRXY3yOjHU98FkjFzbDpQAJrojSCMOYrRgqaNKFIKUREMEYHudze7bf
	0CoAUFfCx71a17Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IE7da0SZmT1nYrHxN/buoJs+W2XgXyGbewqcG7mTBq4=;
	b=vU2b0lj03jPBuVw/sPBLo4pqWioBGVMEJDr7c8m9ksJNRL7i6VJchXDYi3JJyJF7UxajeX
	KHMJKs31vu7pYrcFAfs75qz8k/+J2brO96TaPWg/hBXKwLpiRTRkfIMMsYPke7eVS0zAPY
	IkvTTzgztDxW3JlCl3jxYGwvsdXoNw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IE7da0SZmT1nYrHxN/buoJs+W2XgXyGbewqcG7mTBq4=;
	b=LDeFWTwPxXIT08PqRXY3yOjHU98FkjFzbDpQAJrojSCMOYrRgqaNKFIKUREMEYHudze7bf
	0CoAUFfCx71a17Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 575E413782;
	Mon, 29 Sep 2025 13:29:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id If0aCKeJ2mjuGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:11 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 10/20] smb: client: refactor dropping cached dirs
Date: Mon, 29 Sep 2025 10:27:55 -0300
Message-ID: <20250929132805.220558-11-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250929132805.220558-1-ematsumiya@suse.de>
References: <20250929132805.220558-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

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
index 37a9bff26da7..84ea2653cdb9 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -476,22 +476,6 @@ static void smb2_close_cached_fid(struct kref *ref)
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
-	if (WARN_ON(cfid_is_valid(cfid)))
-		/* remaining invalidation done by drop_cfid() below */
-		list_del(&cfid->entry);
-
 	drop_cfid(cfid);
 
 	/* Delete all cached dirent names */
@@ -506,23 +490,36 @@ static void smb2_close_cached_fid(struct kref *ref)
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
index afb9af227219..bed5ba68b07f 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -82,8 +82,7 @@ extern struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void
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
index df236c844611..f2eff1138ed0 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2615,7 +2615,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			 * ->i_nlink and then mark it as delete pending.
 			 */
 			if (S_ISDIR(inode->i_mode)) {
-				drop_cached_dir_by_name(tcon->cfids, to_name);
+				drop_cached_dir(tcon->cfids, to_name, CFID_LOOKUP_PATH);
 				spin_lock(&inode->i_lock);
 				i_size_write(inode, 0);
 				clear_nlink(inode);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c76fe1dec390..62d6adf50ad1 100644
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
@@ -1238,7 +1238,7 @@ int smb2_rename_path(const unsigned int xid,
 	struct cifsFileInfo *cfile;
 	__u32 co = file_create_options(source_dentry);
 
-	drop_cached_dir_by_name(tcon->cfids, from_name);
+	drop_cached_dir(tcon->cfids, from_name, CFID_LOOKUP_PATH);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
@@ -1520,7 +1520,8 @@ int smb2_rename_pending_delete(const char *full_path,
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
2.49.0

