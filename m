Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA6A155389
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859003; cv=none; b=PGCx0DWVsMH3l6TCkSv8pW/Nj0I24zLGfxy+0mZ2ZLLYh+WCn7hAnPMnZ8JDR7Lx0sHA5AR99p2wFxn2ymfXHY/xc/rkoEfUowFbTGjDwoAp0VSBsHXEPcYy+dayQ2kOrhQ0blG5vFmB8ZvkHye81/VupAz8iSMy+sKgzjOOuz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859003; c=relaxed/simple;
	bh=H/3mu5qoj5HpLnA5hLKiX3HJ8WG1LNcJ9I104IQRpgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8keQjPZPc8BmHw/YvinLr1HJYEPgmrB93ZNz/itY1tE1pmhhPmP1nolaqzF9qTm6zKgXQYVGWiQUpXj0CCn7h7c12bbgz7MT99BUPFtla61NNarMITTBkSlTbwM4YyoHBjbUwpkOIaTimUVFUCDTbI/jg6zXhNGFEfyheY5DMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fSGMVLmC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7BMFlIAW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fSGMVLmC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7BMFlIAW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fSGMVLmC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7BMFlIAW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fSGMVLmC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7BMFlIAW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A58620AAF;
	Tue,  7 Oct 2025 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SofH7KG/p961JCPQwyVOsLLtV6dAf8WXXC+ZZzcglk=;
	b=fSGMVLmCU8LYa6aMTErey3Nx7g+DO9IQU4ApKWPj7hnLgBhpCWPyX/AKc8HLRHPaA0CPnp
	It51kctcC0NSXtuaFgY5gNi3rtEgiJv2dvbR/Cnp03n4+qIk83tE+DNCe2YwVll8jdxvz3
	dBJI2ToSstCDP25nEacQQx9HRVVojB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SofH7KG/p961JCPQwyVOsLLtV6dAf8WXXC+ZZzcglk=;
	b=7BMFlIAWRmnlCvUs8FND2hph/qjU3tAju+12k15KfUPcxedsh4HJEhlu7ItAnWjaGjWi3E
	+R1Rthp8e1SVM7Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SofH7KG/p961JCPQwyVOsLLtV6dAf8WXXC+ZZzcglk=;
	b=fSGMVLmCU8LYa6aMTErey3Nx7g+DO9IQU4ApKWPj7hnLgBhpCWPyX/AKc8HLRHPaA0CPnp
	It51kctcC0NSXtuaFgY5gNi3rtEgiJv2dvbR/Cnp03n4+qIk83tE+DNCe2YwVll8jdxvz3
	dBJI2ToSstCDP25nEacQQx9HRVVojB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SofH7KG/p961JCPQwyVOsLLtV6dAf8WXXC+ZZzcglk=;
	b=7BMFlIAWRmnlCvUs8FND2hph/qjU3tAju+12k15KfUPcxedsh4HJEhlu7ItAnWjaGjWi3E
	+R1Rthp8e1SVM7Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A36D13693;
	Tue,  7 Oct 2025 17:43:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aeVeGDdR5WjidwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:19 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 01/20] smb: client: remove cfids_invalidation_worker
Date: Tue,  7 Oct 2025 14:42:45 -0300
Message-ID: <20251007174304.1755251-2-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

We can do the same cleanup on laundromat.

On invalidate_all_cached_dirs(), run laundromat worker with 0 timeout
and flush it for immediate + sync cleanup.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 39 ++++++++++----------------------------
 fs/smb/client/cached_dir.h |  1 -
 2 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b36f9f9340f0..f6d192129a36 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -557,13 +557,13 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
 
-	if (cfids == NULL)
+	if (!cfids)
 		return;
 
 	/*
 	 * Mark all the cfids as closed, and move them to the cfids->dying list.
-	 * They'll be cleaned up later by cfids_invalidation_worker. Take
-	 * a reference to each cfid during this process.
+	 * They'll be cleaned up by laundromat.  Take a reference to each cfid
+	 * during this process.
 	 */
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
@@ -580,12 +580,11 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		} else
 			kref_get(&cfid->refcount);
 	}
-	/*
-	 * Queue dropping of the dentries once locks have been dropped
-	 */
-	if (!list_empty(&cfids->dying))
-		queue_work(cfid_put_wq, &cfids->invalidation_work);
 	spin_unlock(&cfids->cfid_list_lock);
+
+	/* run laundromat unconditionally now as there might have been previously queued work */
+	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+	flush_delayed_work(&cfids->laundromat_work);
 }
 
 static void
@@ -715,25 +714,6 @@ static void free_cached_dir(struct cached_fid *cfid)
 	kfree(cfid);
 }
 
-static void cfids_invalidation_worker(struct work_struct *work)
-{
-	struct cached_fids *cfids = container_of(work, struct cached_fids,
-						 invalidation_work);
-	struct cached_fid *cfid, *q;
-	LIST_HEAD(entry);
-
-	spin_lock(&cfids->cfid_list_lock);
-	/* move cfids->dying to the local list */
-	list_cut_before(&entry, &cfids->dying, &cfids->dying);
-	spin_unlock(&cfids->cfid_list_lock);
-
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
-		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-	}
-}
-
 static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
@@ -743,6 +723,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
 	spin_lock(&cfids->cfid_list_lock);
+	/* move cfids->dying to the local list */
+	list_cut_before(&entry, &cfids->dying, &cfids->dying);
+
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		if (cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
@@ -796,7 +779,6 @@ struct cached_fids *init_cached_dirs(void)
 	INIT_LIST_HEAD(&cfids->entries);
 	INIT_LIST_HEAD(&cfids->dying);
 
-	INIT_WORK(&cfids->invalidation_work, cfids_invalidation_worker);
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
@@ -820,7 +802,6 @@ void free_cached_dirs(struct cached_fids *cfids)
 		return;
 
 	cancel_delayed_work_sync(&cfids->laundromat_work);
-	cancel_work_sync(&cfids->invalidation_work);
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 31339dc32719..1e383db7c337 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -62,7 +62,6 @@ struct cached_fids {
 	int num_entries;
 	struct list_head entries;
 	struct list_head dying;
-	struct work_struct invalidation_work;
 	struct delayed_work laundromat_work;
 	/* aggregate accounting for all cached dirents under this tcon */
 	atomic_long_t total_dirents_entries;
-- 
2.51.0

