Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA70D302CB6
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152513; cv=none; b=bk+9u+GSXxlevO6PTd6GahlzI/QZcaWFhhhf6qQnMiGzO/NHmDaNRx0cbGRpx/ela7fEnpEC1X7qSJv99xek+Odk0OV0bLAYIM9K66Z/u79NFhd6fRiK/8NUtXMTG8pWHXNIKj7qvuLKUW6ZWQ/nUA+TTbsKN6rNfx3G6+oLOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152513; c=relaxed/simple;
	bh=megmMjOVSa/FQOUaUlloSCFRuzVA+mQm19BgL4+JhRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRRDxux4egU8ijFpidvoZSEIsqQmwkWDFWHx9XFBFdZXXglNFSjWV2uZRcFzChmlpjUB85CcGS5+3pKlenOkAwxjDC0L02QXo/Qjfzg1Mlqp+wGI80bDWT0Hq7uIKmzdjC6wJ9zXFTLUi9id9rrJvWEpkZqHltSVsvSMduahrl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EVnkcyVF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ej/thRuu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wut7lDXa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6bPJgdrx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EVnkcyVF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ej/thRuu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wut7lDXa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6bPJgdrx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A6653F0F8;
	Mon, 29 Sep 2025 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mheW7xxwokLNBjHGtZaZUxFla6O7Z/P6F8cIrR1hVJA=;
	b=EVnkcyVFzwvTDO1jrWXf+OQ6h3XtjCk+zOBX9+1VBE3OSlc6FNnXG4Ht+wPeGJPlxDmr6g
	hOwl3IvTL6eMv3PpN9EhtN5Zkw3a2QWToY/VKk2i2DHWcN4jyaVFuBLuqreoQv9pB95bdU
	DpWFhF0xBtP12SRw34/KOr0W4mw0L9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mheW7xxwokLNBjHGtZaZUxFla6O7Z/P6F8cIrR1hVJA=;
	b=Ej/thRuurgBpbNf7u7BikvgOX+rFEVA1DniP2kqmil+gRuk6W0ZeloowcPqsFO2twaA3g4
	HQ/GGN0btJVqYoCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wut7lDXa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6bPJgdrx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mheW7xxwokLNBjHGtZaZUxFla6O7Z/P6F8cIrR1hVJA=;
	b=Wut7lDXaAuMUfNRo6he58bk+8lkceO4qaU75HkNV7+j1+1A3PiTUcLuzxCt9YgvMchuwJ/
	iEzlQsWvT97A1ShxljJoA1cVwG/nsphHMcaWLbcQRHi0eQYHzf+aPqznV/pk9jwOo4sXTk
	gIl9MMpLZBzM82nnLH6G4ALQhOU1JHA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mheW7xxwokLNBjHGtZaZUxFla6O7Z/P6F8cIrR1hVJA=;
	b=6bPJgdrxeysJ5J4vNmSiFJ64+RtBT+4x3RNXhd0sSryAQvtlDJswPhFla3RAfVnCgJPgVp
	IrV/VSkCdqUPkABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 289E813782;
	Mon, 29 Sep 2025 13:28:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tupJOHqJ2miUGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:26 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 01/20] smb: client: remove cfids_invalidation_worker
Date: Mon, 29 Sep 2025 10:27:46 -0300
Message-ID: <20250929132805.220558-2-ematsumiya@suse.de>
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
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9A6653F0F8
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
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[laundromat_work.work:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

We can do the same cleanup on laundromat.

On invalidate_all_cached_dirs(), run laundromat worker with 0 timeout
and flush it for immediate + sync cleanup.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 39 ++++++++++----------------------------
 fs/smb/client/cached_dir.h |  1 -
 2 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b69daeb1301b..f61fef810a23 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -553,13 +553,13 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
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
@@ -576,12 +576,11 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
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
@@ -702,25 +701,6 @@ static void free_cached_dir(struct cached_fid *cfid)
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
@@ -731,6 +711,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
 	spin_lock(&cfids->cfid_list_lock);
+	/* move cfids->dying to the local list */
+	list_cut_before(&entry, &cfids->dying, &cfids->dying);
+
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		if (cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
@@ -787,7 +770,6 @@ struct cached_fids *init_cached_dirs(void)
 	INIT_LIST_HEAD(&cfids->entries);
 	INIT_LIST_HEAD(&cfids->dying);
 
-	INIT_WORK(&cfids->invalidation_work, cfids_invalidation_worker);
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
@@ -808,7 +790,6 @@ void free_cached_dirs(struct cached_fids *cfids)
 		return;
 
 	cancel_delayed_work_sync(&cfids->laundromat_work);
-	cancel_work_sync(&cfids->invalidation_work);
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 46b5a2fdf15b..a3757a736d3e 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -60,7 +60,6 @@ struct cached_fids {
 	int num_entries;
 	struct list_head entries;
 	struct list_head dying;
-	struct work_struct invalidation_work;
 	struct delayed_work laundromat_work;
 };
 
-- 
2.49.0

