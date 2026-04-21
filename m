Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6A73D6CD3
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779106; cv=none; b=kmHs4xYN1SFUtVRJIV4UxTnNvv4ZzUif6lyvIJ/0HrXxEv/yr6o52DQZubJpuDeim9i9ZP5K8LZDeVCfvTpl6mk44dFrdTOCbbzLZ/5iogicpXsNI1IHYIRlAICi6NVIdWwGIYZi+L2O+iYl8OlQ3tls9z+Ez30vnDTbr/dvKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779106; c=relaxed/simple;
	bh=rtzLbw4RIYWWx8E+8Vh6qyW0xPEIHapmoYH7QH7SvVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UoRW3mIhsiziQGKtoVZ8UghUKa8Kx08hL82N7yFPyvVtobunV0+eBEgVobB06CQPUjZLAm6d4wjFsbLr0k24DTTyYaobuOkrX2lhPxieCgC99MOyLo6PS0A75hK+fZYVGSLvZ2EMzanKCnwAQQzuJvBjsO1i+qV6XFtioAKllpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vOJXhUrC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H3zq8okr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PoqT5sfe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4BMqNbyy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vOJXhUrC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H3zq8okr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PoqT5sfe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4BMqNbyy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E977E6A7F9;
	Tue, 21 Apr 2026 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776779103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3sbElsBw9zWD+uDS00a4Wk1wsPFZNyxQb+X+q2ouoxM=;
	b=vOJXhUrCIBAupsU5xXbDzEGZu05eBcqa7DGOgvkwAOMQ7LW33Wh6f+i4bmiyTvQer3pi/N
	gis2/Uh7whqFK217HBtiIC7XVQUbqf3vgI17HMCMfSLYXARlOmTl7eAYZRzuu5jg98ru+T
	m6ZJtHPDRgCqwfimRI2ax+aDA7GqY94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776779103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3sbElsBw9zWD+uDS00a4Wk1wsPFZNyxQb+X+q2ouoxM=;
	b=H3zq8okryEtUMqjFC3j9N8VGZTriKa1qbFgML88VcHcPfO/fyfYrESNGhtgd3v4pBOeQwn
	wKd1Y+e46KGsd4BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PoqT5sfe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4BMqNbyy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776779102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3sbElsBw9zWD+uDS00a4Wk1wsPFZNyxQb+X+q2ouoxM=;
	b=PoqT5sfe86gkU2Hx4rQiYy0aV691EcCNA6L2Nr0X/U4Uc/1PIoeWCQEQeFqcDiEXY/Ez0K
	brI67y88t6qETosSJUpR4LCautF2hA3WtAqa8nJeFvAYNjKRfg+ZOh+sH6H9is8LYI594s
	+BQBfrRXF9K9XgIDfh+gaYaddPrpZBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776779102;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3sbElsBw9zWD+uDS00a4Wk1wsPFZNyxQb+X+q2ouoxM=;
	b=4BMqNbyy7Mqc1Vf2ijrhh4ePUmiS81XDwsHhI9AXwMVVLv1/STNt2GNWTCgNQ4DRzqYRUe
	uXDp/RCnvE3oh6Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D89DB593AF;
	Tue, 21 Apr 2026 13:45:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lE2VM15/52n/HwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 21 Apr 2026 13:45:02 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2] smb: client: fix (remove) drop_dir_cache module parameter
Date: Tue, 21 Apr 2026 15:44:53 +0200
Message-ID: <20260421134453.271045-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.53.0
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,qemu.org:url];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E977E6A7F9

Being a module parameter, it's possible to do:

  # modprobe cifs drop_dir_cache=1

Which will lead to a crash, because cifs_tcp_ses_list hasn't been
initialized yet:

  [  168.242624] BUG: kernel NULL pointer dereference, address: 0000000000000010
  [  168.242952] #PF: supervisor read access in kernel mode
  [  168.243175] #PF: error_code(0x0000) - not-present page
  [  168.243394] PGD 0 P4D 0
  [  168.243524] Oops: Oops: 0000 [#1] SMP NOPTI
  [  168.243703] CPU: 2 UID: 0 PID: 1105 Comm: modprobe Not tainted 7.0.0-lku #5 PREEMPT(lazy)
  [  168.244054] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-2-g4f253b9b-prebuilt.qemu.org 04/01/2014
  [  168.244557] RIP: 0010:cifs_param_set_drop_dir_cache+0x7c/0x100 [cifs]
  ...
  [  168.248785] Call Trace:
  [  168.248915]  <TASK>
  [  168.249023]  parse_args+0x285/0x3a0
  [  168.249204]  ? __pfx_unknown_module_param_cb+0x10/0x10
  [  168.249448]  load_module+0x192b/0x1bb0
  [  168.249637]  ? __pfx_unknown_module_param_cb+0x10/0x10
  [  168.249882]  ? kernel_read_file+0x27d/0x2b0
  [  168.250088]  init_module_from_file+0xce/0xf0
  [  168.250291]  idempotent_init_module+0xfb/0x2f0
  [  168.250496]  __x64_sys_finit_module+0x5a/0xa0
  [  168.250694]  do_syscall_64+0xe0/0x5a0
  [  168.250863]  ? exc_page_fault+0x65/0x160
  [  168.251050]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [  168.251284] RIP: 0033:0x7fcaa12b774d

Instead of fixing this with some kind of "is module initialized"
approach, this patch instead moves that functionality to procfs,
setting a write op for the existing open_dirs entry, where
writing a 0 to it will drop the cached directory entries.

Also make it available only when CONFIG_CIFS_DEBUG=y.

A small change needed now is to not call flush_delayed_work()
on invalidate_all_cached_dirs() when called from procfs (can't sleep in
that context).
So add a @sync arg to invalidate_all_cached_dirs() to control when to
flush the delayed works.

Fixes: dde6667fa3c8 ("smb: client: add drop_dir_cache module parameter to invalidate cached dirents")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2:
- change to depend on CONFIG_CIFS_DEBUG instead of DEBUG2 (as per
  Bharath's request)
- remove redundant !IS_ENABLED(CONFIG_CIFS_DEBUG2) check from
  cifs_debug_dirs_proc_write() (already wrapped in ifdef)


 fs/smb/client/cached_dir.c |  5 ++--
 fs/smb/client/cached_dir.h |  2 +-
 fs/smb/client/cifs_debug.c | 56 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/cifsfs.c     | 37 -------------------------
 fs/smb/client/file.c       |  2 +-
 fs/smb/client/smb2pdu.c    |  2 +-
 6 files changed, 59 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f49..02791ec3c5a1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -593,7 +593,7 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
  * Invalidate all cached dirs when a TCON has been reset
  * due to a session loss.
  */
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
+void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
@@ -625,7 +625,8 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 
 	/* run laundromat unconditionally now as there might have been previously queued work */
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
-	flush_delayed_work(&cfids->laundromat_work);
+	if (sync)
+		flush_delayed_work(&cfids->laundromat_work);
 }
 
 static void
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 19d5592512e4..fc756836da95 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -90,7 +90,7 @@ void close_cached_dir(struct cached_fid *cfid);
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
+void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync);
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 0691d2a3e04b..f55e5cabdaee 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -306,6 +306,9 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 	LIST_HEAD(entry);
 
 	seq_puts(m, "# Version:1\n");
+#ifdef CONFIG_CIFS_DEBUG
+	seq_puts(m, "# Write 0 to this file to drop all cached directory entries\n");
+#endif /* CONFIG_CIFS_DEBUG */
 	seq_puts(m, "# Format:\n");
 	seq_puts(m, "# <tree id> <sess id> <persistent fid> <lease-key> <path>\n");
 
@@ -353,6 +356,51 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+#ifdef CONFIG_CIFS_DEBUG
+static int cifs_debug_dirs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_debug_dirs_proc_show, NULL);
+}
+
+/* Drop all cached directory entries across all CIFS mounts. */
+static ssize_t cifs_debug_dirs_proc_write(struct file *file, const char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	int rc, v;
+
+	rc = kstrtoint_from_user(buffer, count, 10, &v);
+	if (rc)
+		return rc;
+
+	if (v == 0) {
+		struct TCP_Server_Info *server;
+		struct cifs_ses *ses;
+		struct cifs_tcon *tcon;
+
+		spin_lock(&cifs_tcp_ses_lock);
+		list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
+				list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
+					invalidate_all_cached_dirs(tcon, false);
+			}
+		}
+		spin_unlock(&cifs_tcp_ses_lock);
+	}
+
+	return count;
+}
+
+static const struct proc_ops cifs_debug_dirs_proc_ops = {
+	.proc_open	= cifs_debug_dirs_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_debug_dirs_proc_write,
+};
+#endif /* CONFIG_CIFS_DEBUG */
+
 static __always_inline const char *compression_alg_str(__le16 alg)
 {
 	switch (alg) {
@@ -885,9 +933,11 @@ cifs_proc_init(void)
 	proc_create_single("open_files", 0400, proc_fs_cifs,
 			cifs_debug_files_proc_show);
 
-	proc_create_single("open_dirs", 0400, proc_fs_cifs,
-			cifs_debug_dirs_proc_show);
-
+#ifdef CONFIG_CIFS_DEBUG2
+	proc_create("open_dirs", 0644, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
+#else /* CONFIG_CIFS_DEBUG2 */
+	proc_create_single("open_dirs", 0400, proc_fs_cifs, cifs_debug_dirs_proc_show);
+#endif /* !CONFIG_CIFS_DEBUG2 */
 	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
 	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
 	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 081fc1f9447d..9f76b0347fa9 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -127,43 +127,6 @@ atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
 atomic_t cifs_sillycounter;
 atomic_t cifs_tmpcounter;
 
-/*
- * Write-only module parameter to drop all cached directory entries across
- * all CIFS mounts. Echo a non-zero value to trigger.
- */
-static void cifs_drop_all_dir_caches(void)
-{
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			if (cifs_ses_exiting(ses))
-				continue;
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
-				invalidate_all_cached_dirs(tcon);
-		}
-	}
-	spin_unlock(&cifs_tcp_ses_lock);
-}
-
-static int cifs_param_set_drop_dir_cache(const char *val, const struct kernel_param *kp)
-{
-	bool bv;
-	int rc = kstrtobool(val, &bv);
-
-	if (rc)
-		return rc;
-	if (bv)
-		cifs_drop_all_dir_caches();
-	return 0;
-}
-
-module_param_call(drop_dir_cache, cifs_param_set_drop_dir_cache, NULL, NULL, 0200);
-MODULE_PARM_DESC(drop_dir_cache, "Write 1 to drop all cached directory entries across all CIFS mounts");
-
 #ifdef CONFIG_CIFS_STATS2
 unsigned int slow_rsp_threshold = 1;
 module_param(slow_rsp_threshold, uint, 0644);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f743f058667f..664a2c223089 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -393,7 +393,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	invalidate_all_cached_dirs(tcon);
+	invalidate_all_cached_dirs(tcon, true);
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
 		tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cd8b49722149..cb61051f9af3 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2257,7 +2257,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	invalidate_all_cached_dirs(tcon);
+	invalidate_all_cached_dirs(tcon, true);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, server,
 				 (void **) &req,
-- 
2.53.0

