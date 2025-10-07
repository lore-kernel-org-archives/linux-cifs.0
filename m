Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3039E1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859083; cv=none; b=GfWwee5JMBTNGSAXFV64YaGxKJGGMGvoO8Mb5sL/XqENPMgZFFE12IV49ui/YHBfqiXpvsYCOVmYh/5pnuBE1pXSr3MC44v0GfxSu5/QHgRnExcB9mocpHzUGTqueALtDWZtHgbWlpiX58ufGo8I9pQle73cV7v2xQBkOvX7O3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859083; c=relaxed/simple;
	bh=9X59sRNQb+FO2CHotbU9lFg2/6RhJlQjkf5nplqCvpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7yIBgSI6dSGjV5cUSCOqRYuPpdVYfBfVY7/i7ZFm2xxZ+wWMU7MEX9ixWQJxraVlC+syW8acoUq60qBS6lAd75wM98tkzjC26tgA/YrJhlDhpqELkSrnWjoJpZVY9HZBVbxav9myJbxbtRlk7aTx0kdoBfzc2AAhSxh2Api9Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wk7CBsj9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fcYoF1pB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wk7CBsj9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fcYoF1pB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wk7CBsj9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fcYoF1pB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wk7CBsj9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fcYoF1pB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52E8520AB2;
	Tue,  7 Oct 2025 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooUegt698n+g4yTVAYuY4MJJE7JOP/rTAf1gEOBD1KM=;
	b=Wk7CBsj9OO/QnCr5FesltoL3LYoazB4zThTivD0lkqqKUOq290hJN5jbUisHrIi7cYeU2v
	Leb2hQtTq1OVZrXQMAl8wSZnGMD0dr9IvO3rS/qHRuZAbWUAJPM77OAeH6BTEQlG1SkQEB
	R1/VvqltMLZRDq67DQ7J0oMNuEeZX88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooUegt698n+g4yTVAYuY4MJJE7JOP/rTAf1gEOBD1KM=;
	b=fcYoF1pBs9YDRPvRREvYoS+VxI7aXGrYwSCusW5nO0eZkhAH/kOpGLoNEmx7wUw4Oh4CRp
	G/kBxmLAqgy3hfAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wk7CBsj9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fcYoF1pB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooUegt698n+g4yTVAYuY4MJJE7JOP/rTAf1gEOBD1KM=;
	b=Wk7CBsj9OO/QnCr5FesltoL3LYoazB4zThTivD0lkqqKUOq290hJN5jbUisHrIi7cYeU2v
	Leb2hQtTq1OVZrXQMAl8wSZnGMD0dr9IvO3rS/qHRuZAbWUAJPM77OAeH6BTEQlG1SkQEB
	R1/VvqltMLZRDq67DQ7J0oMNuEeZX88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooUegt698n+g4yTVAYuY4MJJE7JOP/rTAf1gEOBD1KM=;
	b=fcYoF1pBs9YDRPvRREvYoS+VxI7aXGrYwSCusW5nO0eZkhAH/kOpGLoNEmx7wUw4Oh4CRp
	G/kBxmLAqgy3hfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2D5013693;
	Tue,  7 Oct 2025 17:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gxckJnBR5Wg8eAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:44:16 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 18/20] smb: client: skip dentry revalidation of cached root
Date: Tue,  7 Oct 2025 14:43:02 -0300
Message-ID: <20251007174304.1755251-19-ematsumiya@suse.de>
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
X-Rspamd-Queue-Id: 52E8520AB2
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL73jpmmudngk8cygugnauyh74)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

Don't check root dir dentry in cifs_dentry_needs_reval() as its inode
was created before the cfid, so the time check will fail and trigger an
unnecessary revalidation.

Also account for dir_cache_timeout in time comparison, because if we
have a cached dir, we have a lease for it, and, thus, may assume its
children are (still) valid.  To confirm that, let the ac*max checks
go through for granular results.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/inode.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4d7e7843e959..7a20070d3511 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2703,12 +2703,28 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
-	cfid = find_cached_dir(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
-	if (cfid) {
-		bool valid = time_after(cifs_i->time, cfid->ctime);
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
+			if (time_after(cifs_i->time, cfid->atime - dir_cache_timeout * HZ)) {
+				close_cached_dir(cfid);
+				return true;
+			}
 
-		close_cached_dir(cfid);
-		return !valid;
+			/*
+			 * From cached dir perspective, we're done -- attr caching (ac*max) may
+			 * have different requirements, so let the checks go through.
+			 */
+			close_cached_dir(cfid);
+		}
 	}
 
 	/*
-- 
2.51.0

