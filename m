Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A82FE599
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152564; cv=none; b=qDmDvflN28pqE84Aew31aP4C3mo5piH8PFho4GPC2KL9CSj6ItUtDCZTPLVCWKRtyPt4ELmfrCKOz01um+ZcAdzENWgxnLMB8UWqrCwRRsJwWHL4NPbEDuBk3U3H+VVr3Z2KKkpCedcdHpQLVP79dLlx8tHmJ2LqekNtQC6EHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152564; c=relaxed/simple;
	bh=BpH/U1ChYJYFFScCBcEORa/QER7MXDoAumZv8ZEL4H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffSPNNDM+5dDpMTH9hI7BSZKyH4H/iusIGqfucdZ7MiejRKoMemy5jPhQrMdd5xuBBxnGMHhIkNyOtfTbI1xs0ctWfU4aqOiJDB4wcucq+UAC5n/wfprBGI+RAWKkKwYDH8YbU1MTddczhYtomtFQzk1n9QRZ9YjftAojGN6f2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QUteWMQQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YB0Kwyd/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Eu5YrH5y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Lp6RyrUA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QUteWMQQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YB0Kwyd/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Eu5YrH5y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Lp6RyrUA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F16663E87F;
	Mon, 29 Sep 2025 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aex7BIXaPalc7NFaHsSCorJMaoHBbsuicg+Bbvs2uuo=;
	b=QUteWMQQwbhY8AvHz5s2AS28h8V+CRRDdDVMS8zKww64k9Gcp3sP2El3I/hxCkRkofGzNr
	wJUfaYbJk9TnIP/qMhGAmDX49pddpGvaIHoSk5ytpOdCgy0xbRxQojRKunc3aeMQU+/JF4
	DxU4diV4IBePl6RiN+BmHZ4uxdz0dy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152555;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aex7BIXaPalc7NFaHsSCorJMaoHBbsuicg+Bbvs2uuo=;
	b=YB0Kwyd/NoEUQfOzZubz+TgCHU89cnP6U3LCcqhn0/ZEHFxaW47YdQCEnuR+Z821IiTZrW
	xZ+G7/mG8M/iS7Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Eu5YrH5y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Lp6RyrUA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aex7BIXaPalc7NFaHsSCorJMaoHBbsuicg+Bbvs2uuo=;
	b=Eu5YrH5yHXvjnqGep2J5csENLjaFrNUPmbhy3yFvmeDXigkBVdQ8l1BjOp1v8Y8LYYw+Bc
	HQX+/JhruZaKAG5X60CF9JglDeohxUuozMeyPymntFVGgnjHMnTwcVmq/z11i3rl0DvHRf
	Wv+zq6lwkfWVjtWJBsUpA0t6O465bEU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aex7BIXaPalc7NFaHsSCorJMaoHBbsuicg+Bbvs2uuo=;
	b=Lp6RyrUA5C5wS9zfWwKsrBZv7+HfB9FF9nFc5bGTRv0cjCrBV0Zys6uIaRZgsUjPOD4hrS
	M0d9pZ7OInQltUCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 715AD13782;
	Mon, 29 Sep 2025 13:29:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FCBYDqqJ2mjyGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:14 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 11/20] smb: client: simplify cached_fid state checking
Date: Mon, 29 Sep 2025 10:27:56 -0300
Message-ID: <20250929132805.220558-12-ematsumiya@suse.de>
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: F16663E87F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

cached_fid validity (usable by callers) is already based on ->time != 0,
having other flags/booleans to check the same thing can be confusing and
make things unnecessarily complex.

This patch removes cached_fid booleans ->has_lease, ->is_open,
->file_all_info_is_valid.

Replace their semantics with already existing, simpler checks:

- ->is_open is replaced by checking if persistent_fid != 0
- ->has_lease is currently used as a "is valid" check, but we already
  validate it based on ->time anyway, so drop it
- ->file_all_info becomes a pointer and its presence becomes its
  validity

This patch also concretly defines the "is opening" semantic; it's
based on ->time == 0, which is used as "creation time", so the only
time it's 0 is between allocation and valid (opened/cached) or invalid,
and it also never transitions back to 0 again.
(->last_access_time follows the same, but it's already used for
expiration checks)

Other:
- add CFID_INVALID_TIME (value 1); this allows us to differentiate
  between opening (0), valid (jiffies), or invalid (1)
- rename time/last_access_time to ctime/atime to follow other common
  usage of such fields

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 72 +++++++++++++++++++-------------------
 fs/smb/client/cached_dir.h | 14 +++-----
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/smb2inode.c  | 17 +++++----
 4 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 84ea2653cdb9..ff71f2c06b72 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -12,6 +12,9 @@
 #include "smb2proto.h"
 #include "cached_dir.h"
 
+/* since jiffies can never be 1 here, use it as an invalid value to add meaning for our purposes */
+#define CFID_INVALID_TIME 1
+
 static struct cached_fid *init_cached_dir(const char *path);
 static void smb2_close_cached_fid(struct kref *ref);
 
@@ -24,29 +27,30 @@ static inline void invalidate_cfid(struct cached_fid *cfid)
 		cfid->cfids->num_entries--;
 
 	/* do not change other fields here! */
-	cfid->time = 0;
-	cfid->last_access_time = 1;
+	cfid->ctime = CFID_INVALID_TIME;
+	cfid->atime = CFID_INVALID_TIME;
 }
 
 static inline void drop_cfid(struct cached_fid *cfid)
 {
 	struct dentry *dentry = NULL;
+	u64 pfid = 0, vfid = 0;
 
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	invalidate_cfid(cfid);
 
 	spin_lock(&cfid->fid_lock);
 	swap(cfid->dentry, dentry);
+	swap(cfid->fid.persistent_fid, pfid);
+	swap(cfid->fid.volatile_fid, vfid);
 	spin_unlock(&cfid->fid_lock);
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 
 	dput(dentry);
 
-	if (cfid->is_open) {
-		int rc;
-
-		cfid->is_open = false;
-		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid, cfid->fid.volatile_fid);
+	if (pfid) {
+		/* cfid->tcon is never set to NULL, so no need to check/swap it */
+		int rc = SMB2_close(0, cfid->tcon, pfid, vfid);
 
 		/* SMB2_close should handle -EBUSY or -EAGAIN */
 		if (rc)
@@ -56,7 +60,7 @@ static inline void drop_cfid(struct cached_fid *cfid)
 
 /*
  * Find a cached dir based on @key and @mode (raw lookup).
- * The only validation done here is if cfid is not going down (last_access_time != 1).
+ * The only validation done here is if cfid is going down (->ctime == CFID_INVALID_TIME).
  *
  * If @wait_open is true, keep retrying until cfid transitions from 'opening' to valid/invalid.
  *
@@ -78,7 +82,7 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		/* don't even bother checking if it's going away */
-		if (cfid->last_access_time == 1)
+		if (cfid->ctime == CFID_INVALID_TIME)
 			continue;
 
 		if (mode == CFID_LOOKUP_PATH)
@@ -103,7 +107,7 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 
 	if (wait_open && found) {
 		/* cfid is being opened in open_cached_dir(), retry lookup */
-		if (found->has_lease && !found->time && !found->last_access_time)
+		if (!found->ctime)
 			goto retry_find;
 
 		/* we didn't get a ref above, so get one now */
@@ -185,7 +189,7 @@ struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, i
 	cfid = find_cfid(cfids, key, mode, true);
 	if (cfid) {
 		if (cfid_is_valid(cfid)) {
-			cfid->last_access_time = jiffies;
+			cfid->atime = jiffies;
 		} else {
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 			cfid = NULL;
@@ -207,6 +211,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	struct cifs_open_parms oparms;
 	struct smb2_create_rsp *o_rsp = NULL;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
+	struct smb2_file_all_info info;
 	int resp_buftype[2];
 	struct smb_rqst rqst[2];
 	struct kvec rsp_iov[2];
@@ -241,6 +246,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	dentry = NULL;
 	cfid = NULL;
 	*ret_cfid = NULL;
+	memset(&info, 0, sizeof(info));
 	server = cifs_pick_channel(ses);
 
 	if (!server->ops->new_lease_key)
@@ -250,7 +256,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	/* find_cached_dir() already checks has_lease and time, so no need to check here */
+	/* find_cached_dir() already validates cfid if found, so no need to check here again */
 	cfid = find_cached_dir(cfids, path, CFID_LOOKUP_PATH);
 	if (cfid) {
 		rc = 0;
@@ -393,7 +399,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		}
 		goto oshr_free;
 	}
-	cfid->is_open = true;
 
 	spin_lock(&cfids->cfid_list_lock);
 
@@ -430,19 +435,21 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
 	}
-	if (!smb2_validate_and_copy_iov(
-				le16_to_cpu(qi_rsp->OutputBufferOffset),
-				sizeof(struct smb2_file_all_info),
-				&rsp_iov[1], sizeof(struct smb2_file_all_info),
-				(char *)&cfid->file_all_info))
-		cfid->file_all_info_is_valid = true;
-
-	cfid->time = jiffies;
-	cfid->last_access_time = jiffies;
+	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset),
+					sizeof(struct smb2_file_all_info), &rsp_iov[1],
+					sizeof(struct smb2_file_all_info), (char *)&info)) {
+		cfid->file_all_info = kmemdup(&info, sizeof(info), GFP_ATOMIC);
+		if (!cfid->file_all_info) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	cfid->ctime = jiffies;
+	cfid->atime = jiffies;
 	spin_unlock(&cfids->cfid_list_lock);
 	/* At this point the directory handle is fully cached */
 	rc = 0;
-
 oshr_free:
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
@@ -485,6 +492,8 @@ static void smb2_close_cached_fid(struct kref *ref)
 		kfree(de);
 	}
 
+	kfree(cfid->file_all_info);
+	cfid->file_all_info = NULL;
 	kfree(cfid->path);
 	cfid->path = NULL;
 	kfree(cfid);
@@ -538,9 +547,10 @@ static void invalidate_all_cfids(struct cached_fids *cfids, bool closed)
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		invalidate_cfid(cfid);
-		cfid->has_lease = false;
-		if (closed)
-			cfid->is_open = false;
+		if (closed) {
+			cfid->fid.persistent_fid = 0;
+			cfid->fid.volatile_fid = 0;
+		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -611,16 +621,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 	/* this is caller/lease ref */
 	kref_get(&cfid->refcount);
 
-	/*
-	 * Set @cfid->has_lease to true during construction so that the lease
-	 * reference can be put in cached_dir_lease_break() due to a potential
-	 * lease break right after the request is sent or while @cfid is still
-	 * being cached, or if a reconnection is triggered during construction.
-	 * Concurrent processes won't be to use it yet due to @cfid->time being
-	 * zero.
-	 */
-	cfid->has_lease = true;
-
 	return cfid;
 }
 
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index bed5ba68b07f..c45151446049 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -33,17 +33,14 @@ struct cached_fid {
 	struct list_head entry;
 	struct cached_fids *cfids;
 	const char *path;
-	bool has_lease:1;
-	bool is_open:1;
-	bool file_all_info_is_valid:1;
-	unsigned long time; /* jiffies of when lease was taken */
-	unsigned long last_access_time; /* jiffies of when last accessed */
+	unsigned long ctime; /* (jiffies) creation time, when cfid was created (cached) */
+	unsigned long atime; /* (jiffies) access time, when it was last used */
 	struct kref refcount;
 	struct cifs_fid fid;
 	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
-	struct smb2_file_all_info file_all_info;
+	struct smb2_file_all_info *file_all_info;
 	struct cached_dirents dirents;
 };
 
@@ -68,13 +65,12 @@ enum {
 
 static inline bool cfid_expired(const struct cached_fid *cfid)
 {
-	return (cfid->last_access_time &&
-		time_is_before_jiffies(cfid->last_access_time + HZ * dir_cache_timeout));
+	return (cfid->atime && time_is_before_jiffies(cfid->atime + HZ * dir_cache_timeout));
 }
 
 static inline bool cfid_is_valid(const struct cached_fid *cfid)
 {
-	return (cfid->has_lease && cfid->time && !cfid_expired(cfid));
+	return (cfid->fid.persistent_fid && cfid->ctime && !cfid_expired(cfid));
 }
 
 extern struct cached_fids *init_cached_dirs(void);
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 2337cf795db3..bb27b9c97724 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -314,7 +314,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						ses->Suid,
 						cfid->fid.persistent_fid,
 						cfid->path);
-					if (cfid->file_all_info_is_valid)
+					if (cfid->file_all_info)
 						seq_printf(m, "\tvalid file info");
 					if (cfid->dirents.is_valid)
 						seq_printf(m, ", valid dirents");
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 62d6adf50ad1..8ccdd1a3ba2c 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -970,14 +970,17 @@ int smb2_query_path_info(const unsigned int xid,
 
 		/* If it is a root and its handle is cached then use it */
 		if (!rc) {
-			if (cfid->file_all_info_is_valid) {
-				memcpy(&data->fi, &cfid->file_all_info,
-				       sizeof(data->fi));
+			if (cfid->file_all_info) {
+				memcpy(&data->fi, cfid->file_all_info, sizeof(data->fi));
 			} else {
-				rc = SMB2_query_info(xid, tcon,
-						     cfid->fid.persistent_fid,
-						     cfid->fid.volatile_fid,
-						     &data->fi);
+				rc = SMB2_query_info(xid, tcon, cfid->fid.persistent_fid,
+						     cfid->fid.volatile_fid, &data->fi);
+				if (!rc) {
+					cfid->file_all_info = kmemdup(&data->fi, sizeof(data->fi),
+								      GFP_KERNEL);
+					if (!cfid->file_all_info)
+						rc = -ENOMEM;
+				}
 			}
 			close_cached_dir(cfid);
 			return rc;
-- 
2.49.0

