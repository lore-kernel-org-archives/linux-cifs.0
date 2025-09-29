Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BE26ACC
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152525; cv=none; b=S+fGiiAAd6wVM+L0WovgUGhyqf/RJEGb6QWeHhFDXFmswESuExX8vDOMc2wbe1zWuwOmPDU/bODdNArGHSnKIhqYNEe+EcAnM06Z6uqXgy+fYXyVoLGxKROXtV9y1M4e1fxEJ0dbsh/lpDjySrLwL69ruJdnCFGUzMlaC0uCMkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152525; c=relaxed/simple;
	bh=clr1tJVK/3MC2REy7aMQo2Et+4icS+XvPpafVXGkC2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReYfhaK9HbMQBHq7rYOKMoCIDnHFXjH8NgA3KgL+yC6BNRi3adDUN1uS/GUijPHwDfm3Xa3gPCijoamZJIgEr3MC9ROqmKwyDSrzZQBZ0ZlBBvUwejBjCKccBXQfYyWF0bgJM0ZgwZGb4PZ2IIIGLMV1KbDD9KrBDerziI2plDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XU1KciHO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mNaAMOa8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XU1KciHO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mNaAMOa8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XU1KciHO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mNaAMOa8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XU1KciHO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mNaAMOa8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF34E327C2;
	Mon, 29 Sep 2025 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIiH/lA9XjplvP0x2Gck+iA+XQwm/ulAyif68Cpjnq4=;
	b=XU1KciHOQ03ziU/qWNGXfGHgvgmbql5TwN+ypyL3sH4XRP8ctcFqqlnseGWOo3SCi753Nm
	L4NOm6F+qTWaQXzZyGlTKPhyy4WVR0r2lPkCGpFUxsaToL6qVFRgFvizcu1O2/c/cRBb3R
	FQ3r0YrDbczA6E3tONP5f69ydcSv4WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIiH/lA9XjplvP0x2Gck+iA+XQwm/ulAyif68Cpjnq4=;
	b=mNaAMOa8HJmzwVgFV5HeWCIaxDry8y66/BUKybdur9bAOfWPh/OyvTRi9ZKN6dW9g20j1e
	yXJGAOngGFG3lTCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIiH/lA9XjplvP0x2Gck+iA+XQwm/ulAyif68Cpjnq4=;
	b=XU1KciHOQ03ziU/qWNGXfGHgvgmbql5TwN+ypyL3sH4XRP8ctcFqqlnseGWOo3SCi753Nm
	L4NOm6F+qTWaQXzZyGlTKPhyy4WVR0r2lPkCGpFUxsaToL6qVFRgFvizcu1O2/c/cRBb3R
	FQ3r0YrDbczA6E3tONP5f69ydcSv4WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIiH/lA9XjplvP0x2Gck+iA+XQwm/ulAyif68Cpjnq4=;
	b=mNaAMOa8HJmzwVgFV5HeWCIaxDry8y66/BUKybdur9bAOfWPh/OyvTRi9ZKN6dW9g20j1e
	yXJGAOngGFG3lTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C1BF13782;
	Mon, 29 Sep 2025 13:28:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DZoXDYmJ2miwGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:41 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 03/20] smb: client: remove cached_dir_put_work/put_work
Date: Mon, 29 Sep 2025 10:27:48 -0300
Message-ID: <20250929132805.220558-4-ematsumiya@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Move cfid to dying list directly on cached_dir_lease_break(), and
schedule laundromat for cleanup there too.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 56 ++++++++++++--------------------------
 fs/smb/client/cached_dir.h |  1 -
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 8689ee4a883d..ab37a025ea1c 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -597,39 +597,11 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	flush_delayed_work(&cfids->laundromat_work);
 }
 
-/*
- * Release the cached directory's dentry and schedule immediate cleanup on laundromat.
- * Must be called with a reference to the cached_fid and a reference to the tcon.
- */
-static void cached_dir_put_work(struct work_struct *work)
-{
-	struct cached_fid *cfid = container_of(work, struct cached_fid, put_work);
-	struct cached_fids *cfids = cfid->cfids;
-	struct cifs_tcon *tcon = cfid->tcon;
-	struct dentry *dentry;
-
-	spin_lock(&cfid->fid_lock);
-	dentry = cfid->dentry;
-	cfid->dentry = NULL;
-	spin_unlock(&cfid->fid_lock);
-
-	dput(dentry);
-
-	/* move to dying list so laundromat can clean it up */
-	spin_lock(&cfids->cfid_list_lock);
-	list_move(&cfid->entry, &cfids->dying);
-	cfid->on_list = false;
-	cfids->num_entries--;
-	spin_unlock(&cfids->cfid_list_lock);
-
-	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
-	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
-}
-
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid;
+	bool found = false;
 
 	if (cfids == NULL)
 		return false;
@@ -643,16 +615,25 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			cfid->has_lease = false;
 			cfid->time = 0;
 
-			++tcon->tc_count;
-			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_lease_break);
-			queue_work(cfid_put_wq, &cfid->put_work);
-			spin_unlock(&cfids->cfid_list_lock);
-			return true;
+			/*
+			 * We found a lease, move it to the dying list and schedule immediate
+			 * cleanup on laundromat.
+			 * No need to take a ref here, as we still hold our initial one.
+			 */
+			list_move(&cfid->entry, &cfids->dying);
+			cfids->num_entries--;
+			cfid->on_list = false;
+			found = true;
+			break;
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
-	return false;
+
+	/* avoid unnecessary scheduling */
+	if (found)
+		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+
+	return found;
 }
 
 static struct cached_fid *init_cached_dir(const char *path)
@@ -668,7 +649,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 		return NULL;
 	}
 
-	INIT_WORK(&cfid->put_work, cached_dir_put_work);
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
@@ -681,8 +661,6 @@ static void free_cached_dir(struct cached_fid *cfid)
 {
 	struct cached_dirent *dirent, *q;
 
-	WARN_ON(work_pending(&cfid->put_work));
-
 	/*
 	 * Delete all cached dirent names
 	 */
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index e5445e3a7bd3..5e892d53a67a 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -44,7 +44,6 @@ struct cached_fid {
 	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
-	struct work_struct put_work;
 	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
 };
-- 
2.49.0

