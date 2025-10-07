Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5FE1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859065; cv=none; b=HrbU3+UUvZR7jgIATq2Grz+Z2ca0vkRZKcX/OO4oSG3gJJxFRWcnvo17YmB+u0KzXN0lFrMafahrCKHNrO8XizCqclnc1DizNW83NSlH2N7oGcv2H+zZlRvBvBw21XXRw1F4uFswwXiiQLQg/PFbYo4FoRfBmoYYZzsB9NRP/70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859065; c=relaxed/simple;
	bh=dCg8CAYDeMQZKwV8oHIm6ykbJ9CJmCHivH/v35SLcmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt/NAvRrcx+F6+hwAahWCFEmMO3GGYSMFV0qX/kBVkHi2pr6klSsYYb9tQYi7nWKW/nRtxo0b8IwCMoSTqSWfQkxf1MAyoOtMyyT+2sgtuXzkXJ8xxHb/TvgXLvHnmgFLbtSkUb2horhHH4EXxSSvN1Qr66hkTCkh0902Z30ajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZEINoIwx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SoDjAxzW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Pd35N6k1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VnxI0Szw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZEINoIwx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SoDjAxzW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Pd35N6k1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VnxI0Szw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAEBC20AC9;
	Tue,  7 Oct 2025 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNJHytqSTH1qLmI6zG0quyqO6vtmq+cNpFR1trzqTow=;
	b=ZEINoIwx+B+S9RfgDoOF4C0EaY1lhPsXcn2bVJOp3vvPD1UT8aua5d7vOaX5egXQYfzvPt
	uAVUM0FmjSJ+VyWHzvcjge+m37ad/9ScHsAYvoCoKyeE93GF2XheByxKNsjlxhOfG5yP1M
	ick0pHv2eqP3QYvItRzxsBOgCV5Ty7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNJHytqSTH1qLmI6zG0quyqO6vtmq+cNpFR1trzqTow=;
	b=SoDjAxzWsgf2LaerV8HAN2lOycY/BSeW+UADLsdcUZuuF0lHPgjxXsIKSxW1a8m5sModzh
	UICMtreNYMctr1Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNJHytqSTH1qLmI6zG0quyqO6vtmq+cNpFR1trzqTow=;
	b=Pd35N6k1L531wCzNayjq4Q9iz/4JRJ7R7j0ycaf101ZNtq3NdQs7sPvD6cvleYRMgw/bSr
	sBl5+F7RS94WU+LVMCpd/9SEo64xrBMfkgrlPov0eEBdN2XPYewByYI//LfudImZeNUh2u
	EiQLeXaF0C+26WEohdFOuL3Pi9NaZi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNJHytqSTH1qLmI6zG0quyqO6vtmq+cNpFR1trzqTow=;
	b=VnxI0Szwto4PFIIgSS4GuV/2u/4aJVtMPgPnkWqEeF77YxEK4+wt+RRTWRX+DEtYTmXf7z
	XsB9gsDNgcCGNJDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7652B13693;
	Tue,  7 Oct 2025 17:44:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ocOID2NR5WgueAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:44:03 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 15/20] smb: client: remove cached_dirent->fattr
Date: Tue,  7 Oct 2025 14:42:59 -0300
Message-ID: <20251007174304.1755251-16-ematsumiya@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
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

Replace with ->unique_id and ->dtype -- the only fields used from
cifs_fattr.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.h | 6 ++++--
 fs/smb/client/readdir.c    | 9 ++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index de1231bdb0d9..86a1a927a521 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,13 +8,15 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
-
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
 	int namelen;
 	loff_t pos;
-	struct cifs_fattr fattr;
+
+	/* filled from cifs_fattr */
+	u64 unique_id;
+	unsigned int dtype;
 };
 
 struct cached_dirents {
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 32dcbb702b14..96b5074d72a5 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -850,9 +850,7 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 		 * initial scan.
 		 */
 		ctx->pos = dirent->pos;
-		rc = dir_emit(ctx, dirent->name, dirent->namelen,
-			      dirent->fattr.cf_uniqueid,
-			      dirent->fattr.cf_dtype);
+		rc = dir_emit(ctx, dirent->name, dirent->namelen, dirent->unique_id, dirent->dtype);
 		if (!rc)
 			return rc;
 		ctx->pos++;
@@ -905,9 +903,10 @@ static bool add_cached_dirent(struct cached_dirents *cde,
 		cde->is_failed = 1;
 		return false;
 	}
-	de->pos = ctx->pos;
 
-	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
+	de->pos = ctx->pos;
+	de->unique_id = fattr->cf_uniqueid;
+	de->dtype = fattr->cf_dtype;
 
 	list_add_tail(&de->entry, &cde->entries);
 	/* update accounting */
-- 
2.51.0

