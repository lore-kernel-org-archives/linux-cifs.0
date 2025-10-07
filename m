Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA02E8B7E
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859035; cv=none; b=NpegtErR+uNKhwvBVrFF0DkfW+F9lRDgKt8g6xnBMx/cQxcheELpOShs9sd+p2jdXm8VZQBZ0Y+ttTKldJpkK77oWYxQM1q9hNcGoWOLkF8GviCyWxG4f7y455fRLaekpwYzY236/QChYsrdeCdsNXk3KEGtryhLGUjwyOuZcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859035; c=relaxed/simple;
	bh=shIWJIhGfg/1zH2wxuag0W4xaURBA7SgGu1xkUGpS5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1gr1QhVg8QmEaACiUJ1aWqoqTeCenMBPUl5hykHcv3THOw6gEEgUc7bHmX6LMb0XfCkFjbAloiUB99owg7+QSEwTgahoQz7xV0MqVmQkGalweNfYV3mmODOuv7RPWzimxDd332vqCPNLZz/0IFQA0nswR/g1qUdH+330FfDhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J7e8qBrI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YjbzhJfM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J7e8qBrI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YjbzhJfM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J7e8qBrI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YjbzhJfM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J7e8qBrI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YjbzhJfM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6D0E34216;
	Tue,  7 Oct 2025 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aodX2fH2V5surhO8Ys9x7EV1X6s7JM7yD9SOjphc+cY=;
	b=J7e8qBrIFW1DGKC1KsxOcNzUTHxw3DrihZmJxO5swnT8wheFtwluoPqoXUsEHYps19lX7w
	ebEXoQJT4v5IGAM2K5GtjnY8r3KVeKWMFSCVIYoXkm4vgCeTbeDwTzVBqaZ9nYFwQaY6Hy
	z5xSDZMI7DmTny61nY9gpZT31LuhoGc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aodX2fH2V5surhO8Ys9x7EV1X6s7JM7yD9SOjphc+cY=;
	b=YjbzhJfMPanv+TqYsMtEE+Bwm984aFdE1SOAInNNGWdmtipmGg6KMa7UHv8oTc4+KAhHLM
	VXf9C5pTKgvoP2Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aodX2fH2V5surhO8Ys9x7EV1X6s7JM7yD9SOjphc+cY=;
	b=J7e8qBrIFW1DGKC1KsxOcNzUTHxw3DrihZmJxO5swnT8wheFtwluoPqoXUsEHYps19lX7w
	ebEXoQJT4v5IGAM2K5GtjnY8r3KVeKWMFSCVIYoXkm4vgCeTbeDwTzVBqaZ9nYFwQaY6Hy
	z5xSDZMI7DmTny61nY9gpZT31LuhoGc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aodX2fH2V5surhO8Ys9x7EV1X6s7JM7yD9SOjphc+cY=;
	b=YjbzhJfMPanv+TqYsMtEE+Bwm984aFdE1SOAInNNGWdmtipmGg6KMa7UHv8oTc4+KAhHLM
	VXf9C5pTKgvoP2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 530F613693;
	Tue,  7 Oct 2025 17:43:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oBEZB0pR5WgIeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:38 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 07/20] smb: client: merge free_cached_dir in release callback
Date: Tue,  7 Oct 2025 14:42:51 -0300
Message-ID: <20251007174304.1755251-8-ematsumiya@suse.de>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

free_cached_dir() is no longer used anywhere else.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 47 ++++++++++----------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index e86c86643379..155013602dbb 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -13,7 +13,6 @@
 #include "cached_dir.h"
 
 static struct cached_fid *init_cached_dir(const char *path);
-static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 
 static inline void invalidate_cfid(struct cached_fid *cfid)
@@ -459,6 +458,7 @@ static void
 smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+	struct cached_dirent *de, *q;
 
 	/*
 	 * There's no way a valid cfid can reach here.
@@ -477,7 +477,17 @@ smb2_close_cached_fid(struct kref *ref)
 		list_del(&cfid->entry);
 
 	drop_cfid(cfid);
-	free_cached_dir(cfid);
+
+	/* Delete all cached dirent names */
+	list_for_each_entry_safe(de, q, &cfid->dirents.entries, entry) {
+		list_del(&de->entry);
+		kfree(de->name);
+		kfree(de);
+	}
+
+	kfree(cfid->path);
+	cfid->path = NULL;
+	kfree(cfid);
 }
 
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
@@ -615,39 +625,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 	return cfid;
 }
 
-static void free_cached_dir(struct cached_fid *cfid)
-{
-	struct cached_dirent *dirent, *q;
-
-	/*
-	 * Delete all cached dirent names
-	 */
-	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
-		list_del(&dirent->entry);
-		kfree(dirent->name);
-		kfree(dirent);
-	}
-
-	/* adjust tcon-level counters and reset per-dir accounting */
-	if (cfid->cfids) {
-		if (cfid->dirents.entries_count)
-			atomic_long_sub((long)cfid->dirents.entries_count,
-					&cfid->cfids->total_dirents_entries);
-		if (cfid->dirents.bytes_used) {
-			atomic64_sub((long long)cfid->dirents.bytes_used,
-					&cfid->cfids->total_dirents_bytes);
-			atomic64_sub((long long)cfid->dirents.bytes_used,
-					&cifs_dircache_bytes_used);
-		}
-	}
-	cfid->dirents.entries_count = 0;
-	cfid->dirents.bytes_used = 0;
-
-	kfree(cfid->path);
-	cfid->path = NULL;
-	kfree(cfid);
-}
-
 static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
-- 
2.51.0

