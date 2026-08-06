Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2994389DE3
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 19:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043171; cv=none; b=scWbby8+lD12r3aYP4BpLTJyp7mj3aCRIAS5jVANnoNAy9C/6UM3L4rZQz0KiKTpB+X1JwPZ6W9VtcqxJvz5xrq+2reOkOckxbEnVa54U6qFqQw5/6OCVIlyA8JBpppFI3/lpxVwHWTutkj45wOppZoA+6sWAsb8YybWhzs4GXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043171; c=relaxed/simple;
	bh=3SnucKZZNErOYS2qqaS0FJlAx16SgPSpvZU96GZPvXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YL8LF6QEukF8nzxki00pMBK/XpyhlRCgPIDBphr2iosffVna0kKH6bYjxgdY52qucMldhrfos3l8tGNrD3QREfeSz2SkhJmtGYGWxSda1/ZeDDl3IR69PyEKSuL7NH5gHKG4UuGTYQXoSc+aXAcsM2VDmnvyox9wrhDGS7kjwHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g3pULoVI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qEaNYxa/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U7X52XI4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rEYv+qAv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g3pULoVI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qEaNYxa/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U7X52XI4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rEYv+qAv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C46913E2A;
	Thu,  6 Aug 2026 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786043163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7zBwlQt+I8Zofg2FajDvhWgaMBKAICOOV+ZdeGhb/xM=;
	b=g3pULoVIFx4uecDtFY6UvmpvTWgVPOeY82J6NyvOiGMvjoLw5YuDlxCxaX0vMZwXlBDpFr
	3iaJoErL2KxmeTa6Vd62jeBD6/xTeDAIivWHEHxhSnSxcJBDlCyAp3rfA72kmUeLLa6ric
	y9Up10WfjwArAOXh2dKIIKMswzJS8hs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786043163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7zBwlQt+I8Zofg2FajDvhWgaMBKAICOOV+ZdeGhb/xM=;
	b=qEaNYxa/bbC6+pqistCl8OqFDTeCVV17dhP1sJY5wwrcQrPEA+sX+bkNJfb3gBBaJYILnf
	Ri40kVUmLg4PXHBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U7X52XI4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rEYv+qAv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786043159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7zBwlQt+I8Zofg2FajDvhWgaMBKAICOOV+ZdeGhb/xM=;
	b=U7X52XI4llFL2s4oWeMv8vfV6JySt7WuQ8f7upCs3faMsrjhAS+X08web3ygivafqWAnUD
	jr1XgTmBLj+I7Wz0zLaR8L0w30qhy8Hdm5iu1ItBTorN9GkJMU8KIhkkMHQcGaM6OvYjaC
	p4QoVpsnLI1MhHwp76ZOIGjEfk3znKE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786043159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7zBwlQt+I8Zofg2FajDvhWgaMBKAICOOV+ZdeGhb/xM=;
	b=rEYv+qAvRVPRulSKxnqrvZ0OF6yqyAcGRE/T1Z34S/YKF7gxXDGs+tF9iJEw+QdjkyvlCf
	YdysxpE2mFnVEYBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EE66779B6;
	Thu,  6 Aug 2026 19:05:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pl13BRfbdGo/XwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 06 Aug 2026 19:05:59 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] smb: client: require CONFIG_CIFS_DEBUG2=y for accounting tcon bytes stats
Date: Thu,  6 Aug 2026 16:05:40 -0300
Message-ID: <20260806190540.332207-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,suse.de:dkim];
	RCPT_COUNT_SEVEN(0.00)[9];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: C46913E2A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

cifs_stats_bytes_{read,written} uses tcon->stat_lock to account for
R/W bytes.  This is done unconditionally on every read/write since
commit fcabb89299d7 ("cifs: simple stats should always be enabled").

On a highly concurrent workload, a spinlock in the middle of the R/W
codepaths can become heavily contended, which is absurd given its
purpose (protect non-actionable debug/stat data).

Make tcon->{bytes_read,bytes_written,stat_lock} usage depend on
CONFIG_CIFS_DEBUG2=y.

Fixes: fcabb89299d7 ("cifs: simple stats should always be enabled")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifs_debug.c |  4 +++-
 fs/smb/client/cifsglob.h   | 24 ++++++++++++++++++++----
 fs/smb/client/misc.c       |  2 ++
 fs/smb/client/smb1ops.c    | 19 +++++++++++++++----
 fs/smb/client/smb2ops.c    |  7 +++++--
 5 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..3118174745e0 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -762,11 +762,13 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
+#ifdef CONFIG_CIFS_DEBUG2
 					spin_lock(&tcon->stat_lock);
 					tcon->bytes_read = 0;
 					tcon->bytes_written = 0;
-					tcon->stats_from_time = ktime_get_real_seconds();
 					spin_unlock(&tcon->stat_lock);
+#endif /* CONFIG_CIFS_DEBUG2 */
+					tcon->stats_from_time = ktime_get_real_seconds();
 					if (server->ops->clear_stats)
 						server->ops->clear_stats(tcon);
 				}
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..e0e945c1de0f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1240,9 +1240,11 @@ struct cifs_tcon {
 			atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
 		} smb2_stats;
 	} stats;
+#ifdef CONFIG_CIFS_DEBUG2
 	__u64    bytes_read;
 	__u64    bytes_written;
 	spinlock_t stat_lock;  /* protects the two fields above */
+#endif /* CONFIG_CIFS_DEBUG2 */
 	time64_t stats_from_time;
 	FILE_SYSTEM_DEVICE_INFO fsDevInfo;
 	FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated */
@@ -1655,10 +1657,11 @@ convert_delimiter(char *path, char delim)
 
 #define cifs_stats_inc atomic_inc
 
+#ifdef CONFIG_CIFS_DEBUG2
 static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
 					    unsigned int bytes)
 {
-	if (bytes) {
+	if (likely(bytes)) {
 		spin_lock(&tcon->stat_lock);
 		tcon->bytes_written += bytes;
 		spin_unlock(&tcon->stat_lock);
@@ -1668,10 +1671,23 @@ static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
 static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
 					 unsigned int bytes)
 {
-	spin_lock(&tcon->stat_lock);
-	tcon->bytes_read += bytes;
-	spin_unlock(&tcon->stat_lock);
+	if (likely(bytes)) {
+		spin_lock(&tcon->stat_lock);
+		tcon->bytes_read += bytes;
+		spin_unlock(&tcon->stat_lock);
+	}
+}
+#else /* CONFIG_CIFS_DEBUG2 */
+static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
+					    unsigned int bytes)
+{
+}
+
+static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
+					 unsigned int bytes)
+{
 }
+#endif /* !CONFIG_CIFS_DEBUG2 */
 
 
 /*
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04..597dc3c68cd2 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -145,7 +145,9 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
 	INIT_LIST_HEAD(&ret_buf->cifs_sb_list);
 	spin_lock_init(&ret_buf->open_file_lock);
+#ifdef CONFIG_CIFS_DEBUG2
 	spin_lock_init(&ret_buf->stat_lock);
+#endif /* CONFIG_CIFS_DEBUG2 */
 	spin_lock_init(&ret_buf->sb_list_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index dc5a8c1da623..484e12cb9181 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -817,14 +817,25 @@ cifs_clear_stats(struct cifs_tcon *tcon)
 static void
 cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 {
+	u64 bytes_read = 0, bytes_written = 0;
+
+#ifdef CONFIG_CIFS_DEBUG2
+	bytes_read = tcon->bytes_read;
+	bytes_written = tcon->bytes_written;
+#endif /* CONFIG_CIFS_DEBUG2 */
+
 	seq_printf(m, " Oplocks breaks: %d",
 		   atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
 	seq_printf(m, "\nReads:  %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_reads),
-		   (long long)(tcon->bytes_read));
+		   atomic_read(&tcon->stats.cifs_stats.num_reads), bytes_read);
+#ifndef CONFIG_CIFS_DEBUG2
+	seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
+#endif /* !CONFIG_CIFS_DEBUG2 */
 	seq_printf(m, "\nWrites: %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_writes),
-		   (long long)(tcon->bytes_written));
+		   atomic_read(&tcon->stats.cifs_stats.num_writes), bytes_written);
+#ifndef CONFIG_CIFS_DEBUG2
+	seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
+#endif /* !CONFIG_CIFS_DEBUG2 */
 	seq_printf(m, "\nFlushes: %d",
 		   atomic_read(&tcon->stats.cifs_stats.num_flushes));
 	seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d..e1e28f202d0c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1425,9 +1425,12 @@ smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 	 *  Can't display SMB2_NEGOTIATE, SESSION_SETUP, LOGOFF, CANCEL and ECHO
 	 *  totals (requests sent) since those SMBs are per-session not per tcon
 	 */
+#ifdef CONFIG_CIFS_DEBUG2
 	seq_printf(m, "\nBytes read: %llu  Bytes written: %llu",
-		   (long long)(tcon->bytes_read),
-		   (long long)(tcon->bytes_written));
+		   tcon->bytes_read, tcon->bytes_written);
+#else /* CONFIG_CIFS_DEBUG2 */
+	seq_puts(m, "\nBytes read: 0 Bytes written: 0 (CONFIG_CIFS_DEBUG2 is disabled)");
+#endif /* !CONFIG_CIFS_DEBUG2 */
 	seq_printf(m, "\nOpen files: %d total (local), %d open on server",
 		   atomic_read(&tcon->num_local_opens),
 		   atomic_read(&tcon->num_remote_opens));
-- 
2.55.0

