Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96BC1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859090; cv=none; b=NojnEZzubhHcBSptsgaQf3bjDolR2y0Jy00Ldzdb3HIViTRra5Nym4TMQltZkGTkb0EDbaZWEaaVhTgcXaVR0kBWTMhA8erPfsL9Ci+q2d1lhoWbePTiRfsnE/ljzYIHE/O+O6RjZqSeZi42x5L+GfmQnGd09+vKa4Hve3HpMag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859090; c=relaxed/simple;
	bh=PmVHIkgPQ9fnG141mI24izIHy5oP4OHyr4/5a2D80OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfDwrkSBrHhTw4aSUZ4HTH3C5/GfnoQL7U0bqPsZW5SgVzdnOO5JiBAQnZV1KGd7do38BGNRhXC2W2QwaKOuX3y9C+vGVrQMyElVtMirxdEkxU+JfK2Wax1u+StiSryTjTe35FwAF3xg0fXGAHzIzpJJ9LciK+VXlX+dWa47QJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z9D1/sTU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0FpyaenJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z9D1/sTU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0FpyaenJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z9D1/sTU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0FpyaenJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z9D1/sTU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0FpyaenJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F9DE20AAD;
	Tue,  7 Oct 2025 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9AoV5wSoLGXRpUtj3p0t9mvto0OYNAJl1+6wd2AQ/0=;
	b=z9D1/sTUNVHgZxceWGJvtCneo9Jj+Pw+W+9+fC/IoKQKB8TGJ4CJehHNevKNta0ik+87w+
	oH/1K4fObkk86dYTWxa70lRuoCyUFxUWCIadVYA7vuvaqKH4DfxvhZetEK/KaJps1cUg4V
	GQPjXtmFVl7TN+kgWWT7en31DcRBFsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9AoV5wSoLGXRpUtj3p0t9mvto0OYNAJl1+6wd2AQ/0=;
	b=0FpyaenJ7hoG4HU/7gZXl5AL5LZNdEobCLq8RfSva8AnjdoNSaSwGSCbHICw+/7WwwVWdH
	Pg8y7NQ3EgWdPgBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="z9D1/sTU";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0FpyaenJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9AoV5wSoLGXRpUtj3p0t9mvto0OYNAJl1+6wd2AQ/0=;
	b=z9D1/sTUNVHgZxceWGJvtCneo9Jj+Pw+W+9+fC/IoKQKB8TGJ4CJehHNevKNta0ik+87w+
	oH/1K4fObkk86dYTWxa70lRuoCyUFxUWCIadVYA7vuvaqKH4DfxvhZetEK/KaJps1cUg4V
	GQPjXtmFVl7TN+kgWWT7en31DcRBFsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9AoV5wSoLGXRpUtj3p0t9mvto0OYNAJl1+6wd2AQ/0=;
	b=0FpyaenJ7hoG4HU/7gZXl5AL5LZNdEobCLq8RfSva8AnjdoNSaSwGSCbHICw+/7WwwVWdH
	Pg8y7NQ3EgWdPgBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F04BB13693;
	Tue,  7 Oct 2025 17:44:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1JNQLXNR5WhDeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:44:19 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 19/20] smb: client: rework cached dirs synchronization
Date: Tue,  7 Oct 2025 14:43:03 -0300
Message-ID: <20251007174304.1755251-20-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL73jpmmudngk8cygugnauyh74)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,laundromat_work.work:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 6F9DE20AAD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

This patch adds usage of RCU and seqlocks for cached dir (list and
entries).

Traversing the list under RCU allows faster lookups (no locks) and also
guarantees that entries being read are not gone (i.e. prevents UAF).

seqlocks provides atomicity/consistency when reading entries, allowing
callers to re-check cfid in case of write-side invalidation.

Combined with refcounting, this new approach provides safety for
callers and flexibility for future enhancements.

Other:
- now that we can inform lookups of cfid changes, set cfid->dentry
  earlier in open_cached_dir() to allow by-dentry lookups to find
  this cfid

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 233 ++++++++++++++++++++++++-------------
 fs/smb/client/cached_dir.h |  18 ++-
 fs/smb/client/cifs_debug.c |   6 +-
 3 files changed, 168 insertions(+), 89 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d47428736692..defdde4f7ff1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,12 +16,12 @@
 #define CFID_INVALID_TIME 1
 
 static struct cached_fid *init_cached_dir(const char *path);
-static void smb2_close_cached_fid(struct kref *ref);
+static void cfid_release_ref(struct kref *ref);
 
 static inline void invalidate_cfid(struct cached_fid *cfid)
 {
 	/* callers must hold the list lock and do any list operations (del/move) themselves */
-	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+	lockdep_assert_held(&cfid->cfids->entries_seqlock.lock);
 
 	if (is_valid_cached_dir(cfid))
 		cfid->cfids->num_entries--;
@@ -31,18 +31,19 @@ static inline void invalidate_cfid(struct cached_fid *cfid)
 	cfid->atime = CFID_INVALID_TIME;
 }
 
-static inline void drop_cfid(struct cached_fid *cfid)
+static inline void __drop_cfid(struct cached_fid *cfid)
 {
 	struct dentry *dentry = NULL;
 	u64 pfid = 0, vfid = 0;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	write_seqlock(&cfid->cfids->entries_seqlock);
+	write_seqlock(&cfid->seqlock);
 	invalidate_cfid(cfid);
-
 	swap(cfid->dentry, dentry);
 	swap(cfid->fid.persistent_fid, pfid);
 	swap(cfid->fid.volatile_fid, vfid);
-	spin_unlock(&cfid->cfids->cfid_list_lock);
+	write_sequnlock(&cfid->seqlock);
+	write_sequnlock(&cfid->cfids->entries_seqlock);
 
 	dput(dentry);
 
@@ -56,11 +57,18 @@ static inline void drop_cfid(struct cached_fid *cfid)
 	}
 }
 
+static inline void drop_cfid(struct cached_fid *cfid)
+{
+	__drop_cfid(cfid);
+	kref_put(&cfid->refcount, cfid_release_ref);
+}
+
 /*
  * Find a cached dir based on @key and @mode (raw lookup).
  * The only validation done here is if cfid is going down (->ctime == CFID_INVALID_TIME).
  *
  * If @wait_open is true, keep retrying until cfid transitions from 'opening' to valid/invalid.
+ * Will also keep retrying on list seqcount invalidations.
  *
  * Callers must handle any other validation as needed.
  * Returned cfid, if found, has a ref taken, regardless of state.
@@ -70,7 +78,7 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 {
 	struct cached_fid *cfid, *found;
 	const char *parent_path = NULL;
-	bool match;
+	unsigned int lseq = 0;
 
 	if (!cfids || !key)
 		return NULL;
@@ -95,8 +103,16 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 retry_find:
 	found = NULL;
 
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
+	rcu_read_lock();
+	lseq = read_seqbegin(&cfids->entries_seqlock);
+	list_for_each_entry_rcu(cfid, &cfids->entries, entry) {
+		bool match = false;
+
+		if (need_seqretry(&cfids->entries_seqlock, lseq)) {
+			found = ERR_PTR(-ECHILD);
+			break;
+		}
+
 		/* don't even bother checking if it's going away */
 		if (cfid->ctime == CFID_INVALID_TIME)
 			continue;
@@ -113,23 +129,60 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 		if (!match)
 			continue;
 
-		/* only get a ref here if not waiting for open */
-		if (!wait_open)
-			kref_get(&cfid->refcount);
+		if (wait_open && !cfid->ctime) {
+			unsigned int cseq = read_seqbegin(&cfid->seqlock);
+
+			if (!cfid->ctime)
+				found = ERR_PTR(-ECHILD);
+			else if (!is_valid_cached_dir(cfid))
+				found = ERR_PTR(-EINVAL);
+
+			if (read_seqretry(&cfid->seqlock, cseq) && !found)
+				found = ERR_PTR(-ECHILD);
+
+			if (found)
+				break;
+		}
+
+		kref_get(&cfid->refcount);
 		found = cfid;
 		break;
 	}
-	spin_unlock(&cfids->cfid_list_lock);
 
-	if (wait_open && found) {
-		/* cfid is being opened in open_cached_dir(), retry lookup */
-		if (!found->ctime)
-			goto retry_find;
+	if (read_seqretry(&cfids->entries_seqlock, lseq)) {
+		if (wait_open) {
+			if (!found) {
+				found = ERR_PTR(-ECHILD);
+
+				/*
+				 * Not found but caller requested wait for open.
+				 * The list seqcount invalidation might have been our open, retry
+				 * only once more (in case it wasn't).
+				 */
+				wait_open = false;
+			}
+		}
 
-		/* we didn't get a ref above, so get one now */
-		kref_get(&found->refcount);
+		if (found && !IS_ERR(found)) {
+			/* can't put ref under RCU lock, do it below */
+			cfid = found;
+			found = ERR_PTR(-EUCLEAN);
+		}
+	}
+	rcu_read_unlock();
+
+	if (PTR_ERR(found) == -EUCLEAN) {
+		/* cfid is a valid object here, see the check above */
+		kref_put(&cfid->refcount, cfid_release_ref);
+		found = wait_open ? ERR_PTR(-ECHILD) : NULL;
 	}
 
+	if (PTR_ERR(found) == -ECHILD)
+		goto retry_find;
+
+	if (IS_ERR(found))
+		found = NULL;
+
 	kfree(parent_path);
 
 	return found;
@@ -209,7 +262,7 @@ struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, i
 		if (is_valid_cached_dir(cfid)) {
 			cfid->atime = jiffies;
 		} else {
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			kref_put(&cfid->refcount, cfid_release_ref);
 			cfid = NULL;
 		}
 	}
@@ -271,34 +324,35 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	if (!server->ops->new_lease_key)
 		return -EIO;
 
-	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
 	/* find_cached_dir() already checks if cfid is valid, so no need to check here */
 	cfid = find_cached_dir(cfids, path, CFID_LOOKUP_PATH);
 	if (cfid) {
-		rc = 0;
-		goto out;
+		*ret_cfid = cfid;
+		return 0;
 	}
 
-	spin_lock(&cfids->cfid_list_lock);
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	read_seqlock_excl(&cfids->entries_seqlock);
 	if (cfids->num_entries >= tcon->max_cached_dirs) {
-		spin_unlock(&cfids->cfid_list_lock);
+		read_sequnlock_excl(&cfids->entries_seqlock);
 		rc = -ENOENT;
 		goto out;
 	}
+	read_sequnlock_excl(&cfids->entries_seqlock);
 
+	/* no ned to lock cfid or entries yet */
 	cfid = init_cached_dir(path);
 	if (!cfid) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	cfid->cfids = cfids;
 	cfid->tcon = tcon;
-	spin_unlock(&cfids->cfid_list_lock);
+	pfid = &cfid->fid;
 
 	/*
 	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
@@ -323,16 +377,16 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 			goto out;
 		}
 	}
+
+	write_seqlock(&cfids->entries_seqlock);
+	write_seqlock(&cfid->seqlock);
 	cfid->dentry = dentry;
-	cfid->tcon = tcon;
 	dentry = NULL;
+	write_sequnlock(&cfid->seqlock);
 
-	spin_lock(&cfids->cfid_list_lock);
 	cfids->num_entries++;
-	list_add(&cfid->entry, &cfids->entries);
-	spin_unlock(&cfids->cfid_list_lock);
-
-	pfid = &cfid->fid;
+	list_add_rcu(&cfid->entry, &cfids->entries);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -398,8 +452,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		goto oshr_free;
 	}
 
-	spin_lock(&cfids->cfid_list_lock);
-
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -409,30 +461,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
 		goto oshr_free;
 	}
 
-	rc = smb2_parse_contexts(server, rsp_iov,
-				 &oparms.fid->epoch,
-				 oparms.fid->lease_key,
+	rc = smb2_parse_contexts(server, rsp_iov, &oparms.fid->epoch, oparms.fid->lease_key,
 				 &oplock, NULL, NULL);
-	if (rc) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (rc)
 		goto oshr_free;
-	}
 
 	rc = -EINVAL;
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
 		goto oshr_free;
-	}
+
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
-	}
+
 	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset),
 					sizeof(struct smb2_file_all_info), &rsp_iov[1],
 					sizeof(struct smb2_file_all_info), (char *)&info)) {
@@ -443,10 +488,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		}
 	}
 
-	cfid->ctime = jiffies;
-	cfid->atime = jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
-	/* At this point the directory handle is fully cached */
 	rc = 0;
 oshr_free:
 	SMB2_open_free(&rqst[0]);
@@ -454,16 +495,22 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 out:
-	/* cfid invalidated in the mean time, drop it below */
-	if (!rc && !is_valid_cached_dir(cfid))
+	/* cfid only becomes fully valid below, so can't use is_valid_cached_dir() here */
+	if (!rc && cfid->ctime == CFID_INVALID_TIME)
 		rc = -ENOENT;
 
 	if (rc) {
-		if (cfid) {
+		dput(dentry);
+
+		if (cfid)
 			drop_cfid(cfid);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
-		}
 	} else {
+		/* seqlocked-write will inform concurrent lookups of opening -> open transition */
+		write_seqlock(&cfid->seqlock);
+		cfid->ctime = jiffies;
+		cfid->atime = jiffies;
+		write_sequnlock(&cfid->seqlock);
+
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
@@ -483,7 +530,6 @@ static void __invalidate_cached_dirents(struct cached_fid *cfid)
 	if (!cfid)
 		return;
 
-	mutex_lock(&cfid->dirents.de_mutex);
 	list_for_each_entry_safe(de, q, &cfid->dirents.entries, entry) {
 		list_del(&de->entry);
 		kfree(de->name);
@@ -494,16 +540,13 @@ static void __invalidate_cached_dirents(struct cached_fid *cfid)
 	cfid->dirents.is_failed = false;
 	cfid->dirents.file = NULL;
 	cfid->dirents.pos = 0;
-	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
-static void
-smb2_close_cached_fid(struct kref *ref)
+static void cfid_rcu_free(struct rcu_head *rcu)
 {
-	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+	struct cached_fid *cfid = container_of(rcu, struct cached_fid, rcu);
 
 	__invalidate_cached_dirents(cfid);
-	drop_cfid(cfid);
 
 	kfree(cfid->file_all_info);
 	cfid->file_all_info = NULL;
@@ -512,6 +555,14 @@ smb2_close_cached_fid(struct kref *ref)
 	kfree(cfid);
 }
 
+static void cfid_release_ref(struct kref *ref)
+{
+	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+
+	__drop_cfid(cfid);
+	call_rcu_hurry(&cfid->rcu, cfid_rcu_free);
+}
+
 bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 {
 	struct cached_fid *cfid;
@@ -532,13 +583,16 @@ bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 		drop_cfid(cfid);
 	} else {
 		/* we're locked in smb2_is_valid_lease_break(), so can't dput/close here */
-		spin_lock(&cfids->cfid_list_lock);
+		write_seqlock(&cfids->entries_seqlock);
+		write_seqlock(&cfid->seqlock);
 		invalidate_cfid(cfid);
-		spin_unlock(&cfids->cfid_list_lock);
+		write_sequnlock(&cfid->seqlock);
+		write_sequnlock(&cfids->entries_seqlock);
+
+		/* put lookup ref */
+		kref_put(&cfid->refcount, cfid_release_ref);
 	}
 
-	/* put lookup ref */
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 
 	return true;
@@ -559,33 +613,39 @@ void invalidate_cached_dirents(struct cached_fids *cfids, const void *key, int m
 
 	cfid = find_cfid(cfids, key, mode, false);
 	if (cfid) {
-		__invalidate_cached_dirents(cfid);
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		if (is_valid_cached_dir(cfid)) {
+			mutex_lock(&cfid->dirents.de_mutex);
+			__invalidate_cached_dirents(cfid);
+			mutex_unlock(&cfid->dirents.de_mutex);
+		}
+		kref_put(&cfid->refcount, cfid_release_ref);
 	}
 }
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put(&cfid->refcount, cfid_release_ref);
 }
 
 static void invalidate_all_cfids(struct cached_fids *cfids, bool closed)
 {
-	struct cached_fid *cfid, *q;
+	struct cached_fid *cfid;
 
 	if (!cfids)
 		return;
 
 	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+	write_seqlock(&cfids->entries_seqlock);
+	list_for_each_entry(cfid, &cfids->entries, entry) {
+		write_seqlock(&cfid->seqlock);
 		invalidate_cfid(cfid);
 		if (closed) {
 			cfid->fid.persistent_fid = 0;
 			cfid->fid.volatile_fid = 0;
 		}
+		write_sequnlock(&cfid->seqlock);
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	/* run laundromat unconditionally now as there might have been previously queued work */
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
@@ -646,6 +706,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	seqlock_init(&cfid->seqlock);
 
 	/* this is our ref */
 	kref_init(&cfid->refcount);
@@ -661,20 +722,26 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 static void cfids_laundromat_worker(struct work_struct *work)
 {
-	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
+	struct cached_fids *cfids;
 	LIST_HEAD(entry);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
-	spin_lock(&cfids->cfid_list_lock);
+	synchronize_rcu();
+
+	write_seqlock(&cfids->entries_seqlock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		write_seqlock(&cfid->seqlock);
 		if (cfid_expired(cfid)) {
 			invalidate_cfid(cfid);
-			list_move(&cfid->entry, &entry);
+			/* can't use list_move() here because of possible RCU readers */
+			list_del_rcu(&cfid->entry);
+			list_add(&cfid->entry, &entry);
 		}
+		write_sequnlock(&cfid->seqlock);
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
@@ -690,7 +757,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		 * No risk for a double list_del() here because cfid is only on this list now.
 		 */
 		drop_cfid(cfid);
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work, dir_cache_timeout * HZ);
@@ -703,7 +769,8 @@ struct cached_fids *init_cached_dirs(void)
 	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
 	if (!cfids)
 		return NULL;
-	spin_lock_init(&cfids->cfid_list_lock);
+
+	seqlock_init(&cfids->entries_seqlock);
 	INIT_LIST_HEAD(&cfids->entries);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 86a1a927a521..99aad032ed5b 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,6 +8,8 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
+#include <linux/seqlock.h>
+
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
@@ -36,6 +38,13 @@ struct cached_dirents {
 
 struct cached_fid {
 	struct list_head entry;
+	struct rcu_head rcu;
+	/*
+	 * ->seqlock must be used:
+	 * - write-locked when updating
+	 * - rcu_read_lock() + seqcounted on reads
+	 */
+	seqlock_t seqlock;
 	struct cached_fids *cfids;
 	const char *path;
 	unsigned long ctime; /* (jiffies) creation time, when cfid was created (cached) */
@@ -50,11 +59,12 @@ struct cached_fid {
 
 /* default MAX_CACHED_FIDS is 16 */
 struct cached_fids {
-	/* Must be held when:
-	 * - accessing the cfids->entries list
-	 * - accessing cfids->num_entries
+	/*
+	 * ->entries_seqlock must be used when accessing ->entries or ->num_entries:
+	 * - write-locked when updating
+	 * - rcu_read_lock() + seqcounted on reads
 	 */
-	spinlock_t cfid_list_lock;
+	seqlock_t entries_seqlock;
 	int num_entries;
 	struct list_head entries;
 	struct delayed_work laundromat_work;
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 0c64ca56bff8..6cd03ac9930f 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -330,11 +330,13 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 				cfids = tcon->cfids;
 				if (!cfids)
 					continue;
-				spin_lock(&cfids->cfid_list_lock); /* check lock ordering */
+
+				read_seqlock_excl(&cfids->entries_seqlock);
 				seq_printf(m, "Num entries: %d, cached_dirents: %lu entries, %llu bytes\n",
 						cfids->num_entries,
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
+
 				list_for_each_entry(cfid, &cfids->entries, entry) {
 					seq_printf(m, "0x%x 0x%llx 0x%llx     %s",
 						tcon->tid,
@@ -350,7 +352,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						cfid->dirents.entries_count, cfid->dirents.bytes_used);
 					seq_printf(m, "\n");
 				}
-				spin_unlock(&cfids->cfid_list_lock);
+				read_sequnlock_excl(&cfids->entries_seqlock);
 			}
 		}
 	}
-- 
2.51.0

