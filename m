Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DE22F9C2D
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152590; cv=none; b=aFcGGoP+I25cTNDFLefBHuzQdXXSHCDWLTeV3zsjnXNLwaOrAYbFwuSoNrgOVxdsH6Cs6cQ8PeFZFwbm+twSAaiwC806zRcXOE4DFKfdK5VJ8x+CjfwgGZz5Z+IYrpesrDIyi+kqTMjvJtDKJ9Eog1jiQ5r6tZK6F9zoJ8SxUWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152590; c=relaxed/simple;
	bh=OThbIP7uQg7UJtp/Plhh7MmOOH2bedaZ62o5otXh0VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD4ZCTsV2dKDv01hs8IWBnmkxLNSV/fBa5djgPJA7BKee5DicyZlf5a5I/GIFocewtNvfkXqxbqqw4Z40pNusH3GqmBIpmgmiWAcrzBlQ7p6evqbT6NcCxbL3funhxEUxyPsVZXbC/z7H4pLaHcrNNJ3JUHMQ3RUTc0HLyoa4K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GsC3mz3J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZrVUZVPe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GsC3mz3J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZrVUZVPe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GsC3mz3J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZrVUZVPe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GsC3mz3J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZrVUZVPe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF516327EC;
	Mon, 29 Sep 2025 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77G8PIf7y6KfVa4qnwCFkj0P/onXda94/9Ms8otRqUc=;
	b=GsC3mz3JltrtiaQkAXqFrXwMRMMhoH/vmVr67ZX33rBK6BdQfBnnL3+kSlCMFEnpXnvkTN
	bJLqLznSriy5biEApt9wKJu73gFtMPD9wfOsGDviUZgO6622mez6AcsjytIFVCzAaqKOOF
	vn+jsr80CDhxfvuMe0N5M+gFOc1hQgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77G8PIf7y6KfVa4qnwCFkj0P/onXda94/9Ms8otRqUc=;
	b=ZrVUZVPefljSPerXnkgw2o/YeSHtv4E9z1BNbIAvRNFTWTJUNqt65wP8hs+EmMYpSMlH5E
	A/IhvOlFIJkBNwBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77G8PIf7y6KfVa4qnwCFkj0P/onXda94/9Ms8otRqUc=;
	b=GsC3mz3JltrtiaQkAXqFrXwMRMMhoH/vmVr67ZX33rBK6BdQfBnnL3+kSlCMFEnpXnvkTN
	bJLqLznSriy5biEApt9wKJu73gFtMPD9wfOsGDviUZgO6622mez6AcsjytIFVCzAaqKOOF
	vn+jsr80CDhxfvuMe0N5M+gFOc1hQgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77G8PIf7y6KfVa4qnwCFkj0P/onXda94/9Ms8otRqUc=;
	b=ZrVUZVPefljSPerXnkgw2o/YeSHtv4E9z1BNbIAvRNFTWTJUNqt65wP8hs+EmMYpSMlH5E
	A/IhvOlFIJkBNwBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CFE613782;
	Mon, 29 Sep 2025 13:29:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qWCEAciJ2mgiHAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:44 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 18/20] smb: client: fix dentry revalidation of cached root
Date: Mon, 29 Sep 2025 10:28:03 -0300
Message-ID: <20250929132805.220558-19-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Don't check root dir dentry in cifs_dentry_needs_reval() as its inode
was created before the cfid, so the time check will fail and trigger an
unnecessary revalidation.

Also account for dir_cache_timeout in time comparison, because if we
have a cached dir, we have a lease for it, and, thus, may assume its
children are (still) valid.  To confirm that, let the ac*max checks
go through for granular results.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/inode.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 35c5557d5ea1..4b817fd528f7 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2694,10 +2694,28 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
-	cfid = find_cached_dir(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
-	if (cfid) {
-		close_cached_dir(cfid);
-		return false;
+	if (!IS_ROOT(dentry)) {
+		cfid = find_cached_dir(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
+		if (cfid) {
+			/*
+			 * We hold a lease for the cached parent.
+			 * So as long as this child is within cached dir lifetime, we don't need to
+			 * revalidate it.
+			 *
+			 * Since cfid expiration is based on access time, use it for comparison
+			 * instead of creation time.
+			 */
+			if (time_before(cifs_i->time, cfid->atime - dir_cache_timeout * HZ)) {
+				close_cached_dir(cfid);
+				return true;
+			}
+
+			/*
+			 * From cached dir perspective, we're done -- attr caching (ac*max) may
+			 * have different requirements, so let the checks go through.
+			 */
+			close_cached_dir(cfid);
+		}
 	}
 
 	/*
-- 
2.49.0

