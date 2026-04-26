Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB49225403
	for <linux-cifs@vger.kernel.org>; Sun, 26 Apr 2026 11:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777203606; cv=none; b=BgWWkSwePaCBvezxNSGE9T9CNd5B+O/0LtnGKEQArucCXjYG+6UM/j0HTRcKQnAql2+zeXs3mJEzi1dZVa8iE+2PAABfuZEpMQKlXycLVrCEBqwKK4W6NeHhckG6PCzPxZizD3A3Cad2ue4zh1E04njLXZrgfDdj0NbZ4ABFIS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777203606; c=relaxed/simple;
	bh=uUSWvtReHSlFTIbCuzSEBV2iRHYiwBnsryAviXJOa88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H/ye5sustyQui2v2Wf4yMSlfNCw91cfs7pylAX9fr+kTqz9tuMgg/7RtDqlPhqab52kVBdzKzOgvsvRpnybSHL3CxlUaaqPifXBxDjKRU3omim9DKqFmEioKPjhk9N34IYoOax8/XCZD4qtStkyp4V7rMa6KzSriAJQx6urcV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tN0zX9my; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rQsn9D3n; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tN0zX9my; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rQsn9D3n; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tN0zX9my";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rQsn9D3n";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tN0zX9my";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rQsn9D3n"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8EBB65BD1F;
	Sun, 26 Apr 2026 11:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777203603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k7CUfRvC2GQWVFD5dgWSAr1t4h4XzQuC/Gopo1bQkaY=;
	b=tN0zX9myvyJDu4FF1C5TytJTK1AwB4LTElk395KN+x/We8hVR+0AKGg/1xi4NsP7THOEQf
	CW1OXyetzz9m1vK+oYJadWocHcuLAoNfvhcqOA4kg7Q9yiJT1tB9mROyovf4AakafkFa5D
	RQfpGRJFfZLP2vOjKtUnkzGPQKHxQiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777203603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k7CUfRvC2GQWVFD5dgWSAr1t4h4XzQuC/Gopo1bQkaY=;
	b=rQsn9D3nJJcJXLzty0AdkVmvMP7DwktBdYIIEwnjiyIwcOAmARKHwbH4W+hfRYupcHRLTu
	dVK9265JCAxiS+BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tN0zX9my;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQsn9D3n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777203603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k7CUfRvC2GQWVFD5dgWSAr1t4h4XzQuC/Gopo1bQkaY=;
	b=tN0zX9myvyJDu4FF1C5TytJTK1AwB4LTElk395KN+x/We8hVR+0AKGg/1xi4NsP7THOEQf
	CW1OXyetzz9m1vK+oYJadWocHcuLAoNfvhcqOA4kg7Q9yiJT1tB9mROyovf4AakafkFa5D
	RQfpGRJFfZLP2vOjKtUnkzGPQKHxQiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777203603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k7CUfRvC2GQWVFD5dgWSAr1t4h4XzQuC/Gopo1bQkaY=;
	b=rQsn9D3nJJcJXLzty0AdkVmvMP7DwktBdYIIEwnjiyIwcOAmARKHwbH4W+hfRYupcHRLTu
	dVK9265JCAxiS+BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2FCA593B0;
	Sun, 26 Apr 2026 11:40:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CHwGJH57Wm0ewAAD6G6ig
	(envelope-from <ddiss@suse.de>); Sun, 26 Apr 2026 11:40:01 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH] smb/client: remove unused smb3_parse_opt()
Date: Sun, 26 Apr 2026 21:39:37 +1000
Message-ID: <20260426113937.30818-1-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 8EBB65BD1F
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Commit abdb1742a3123 ("cifs: get rid of mount options string parsing")
removed the last caller.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 fs/smb/client/cifsproto.h  |  1 -
 fs/smb/client/fs_context.c | 31 -------------------------------
 2 files changed, 32 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 884bfa1cf0b42..b7cd67b64a833 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -89,7 +89,6 @@ int cifs_handle_standard(struct TCP_Server_Info *server,
 			 struct mid_q_entry *mid);
 char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
-int smb3_parse_opt(const char *options, const char *key, char **val);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 int cifs_discard_remaining_data(struct TCP_Server_Info *server);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a46764c247107..6433eb2093dce 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -536,37 +536,6 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 	return 0;
 }
 
-int smb3_parse_opt(const char *options, const char *key, char **val)
-{
-	int rc = -ENOENT;
-	char *opts, *orig, *p;
-
-	orig = opts = kstrdup(options, GFP_KERNEL);
-	if (!opts)
-		return -ENOMEM;
-
-	while ((p = strsep(&opts, ","))) {
-		char *nval;
-
-		if (!*p)
-			continue;
-		if (strncasecmp(p, key, strlen(key)))
-			continue;
-		nval = strchr(p, '=');
-		if (nval) {
-			if (nval == p)
-				continue;
-			*nval++ = 0;
-			*val = kstrdup(nval, GFP_KERNEL);
-			rc = !*val ? -ENOMEM : 0;
-			goto out;
-		}
-	}
-out:
-	kfree(orig);
-	return rc;
-}
-
 /*
  * Remove duplicate path delimiters. Windows is supposed to do that
  * but there are some bugs that prevent rename from working if there are
-- 
2.51.0

