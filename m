Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B6717B428
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732308029; cv=none; b=EJ9i2sSRU3J880bQjHKddhlKF5tMQlV04onHI5aQzTMIgZk4vddfHdiQUAgsH8LIUpZL6lX89THJmwwiDQP7CnEC2qlke20JKbqVu8U7qrjkHBxx6dKb5Zl6KvMVq3XkdhgDiyYH6ueOvYOSupuYixGAY+5W6DMsIZEZgERzLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732308029; c=relaxed/simple;
	bh=0PwJN3P6MSeos9IsDuxhVPjeVqsSGd7ZpcCxzxQM7q0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iJCJ8aFbzUiMOIMlE332HzseM7MUomn983BbbwUB15nH61hKHVhpf1MBNx7v/W3cnksz1E5UsLsPfZ5Dmot7unOqyLvLioQJRuL5XKjYdx8BWk/i3TzEqt0nndeMnaIM4zypdWEP6SGUF+jwAp40VhO4qYuamdFKq73M+mIe048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gddzncbG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gddzncbG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-432d86a3085so22490165e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 12:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732308025; x=1732912825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YnHKWcRlA0I2oh1wz02JZjMuVoTlgYEwJJfYf772VaM=;
        b=gddzncbGPthjPiC9boYK491rk3qx4ouubdU1iXRLN2t9QmimeHb2fY+oAox4nvY4Aj
         iMg7SDcxT+LEBO7yGFOPhL1bJ6uUSceIj7wqwUCp9Ha6Xm9doGGN47NYO6PJMxwL04X+
         lE0UW4Mrgq6UdctbnsxRQNSseFfKuz/wPHHergm3u9Ykz8ggef99UXiXp9j9gZKLJO5X
         mEhUukdxul1EwtrsWY4MC1q2nl2UkpRCrjft1XtxozbHuoUJS6sAj11ITLx690fIg7j/
         s52ibBCEW2JMjZseaQs/lWZt4Id4BfxrOSf2AJukaydxQST1V3nly8KKZwTtgtXvojoW
         oVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732308025; x=1732912825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YnHKWcRlA0I2oh1wz02JZjMuVoTlgYEwJJfYf772VaM=;
        b=wdWZpAhQ+qmnM2z1Jmp4WjwpX8gq85LXvmFyePMsWZLgmplyylI2PKD1Xj4ncAxwzH
         UAQp+ZXNNrGGIh4zmj/P38LcUzsI+eJumFoziCmktUp2ql7/CgQYn0IkxWWD3h3F03nb
         F1K1YnuiiKvxvkGvJC/661ukDIG5IywiaRvvG4bhFN+3HfNtgdSTPitgSye8WpKVfwEK
         /SShDxVp6VSrUmHJATKBnTelqqeIWIrgs46IJibr4lOhx8qmJJY08+rYsUADExGxeXg5
         7To3rg0Z+mOPoMMOc4HkBdAEX9IxJeRJmxKPQZ6UDisSO6J7gkjsqZooSSMiQWFhphX0
         m3yA==
X-Forwarded-Encrypted: i=1; AJvYcCXuQR46fevoLKZVHTwuJetvS2TxnJ4B4SzwEzEgUIk2a7Hfvf8mG5V5k8H3T8isZJUuQFVoaXbfs/Db@vger.kernel.org
X-Gm-Message-State: AOJu0YyKJT2fNbUfOoHv0GIVprH8FCQdzAo/iUmcey3nqpynohfkrHjd
	FkUZasIJUzJVN4MO5rbaZp7faqv0Ys7ItyvwmPchPfFtO7OVSYmmyb5fCrqRsZk=
X-Gm-Gg: ASbGncuMJsoItS4ZRAXXnewp/i/npEwmdfoOKDboVSyvf9og+Y93Bs/vJuv10ycKINI
	VyuWpZq5e7BpkX56JMYmsQNZNSMvxK9OZ6eWhdRcM6Nl9ZIba/7WobmszsaOzidxjv5dXY0a0Re
	oQliKTR6Rt1WR/TrhjFJqN+3EF9v9tWk+vRCM2qtKtmVpl2NLPvPi5D0VIP61MmebfzrIXmQlFo
	D4UXHlstH6R5SkzwevPEUWIMSM5aK9Zb2hrByodlG7pYJxKspGGoibNilG3cbDt9fhcSg==
X-Google-Smtp-Source: AGHT+IFHHBkYnA5nnrnO5MCxjX9DohUXcN8wRaS79IdTXulXBEJPliM+Cog8Hr2G1XQNNfXDGCtPCw==
X-Received: by 2002:a05:6000:156b:b0:37d:461d:b1ea with SMTP id ffacd0b85a97d-38260be3c89mr4072336f8f.48.1732308025166;
        Fri, 22 Nov 2024 12:40:25 -0800 (PST)
Received: from localhost.localdomain ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de57a3d1sm2053423b3a.194.2024.11.22.12.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 12:40:24 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 1/2] smb: client: disable directory caching when dir_cache_timeout is zero
Date: Fri, 22 Nov 2024 17:39:00 -0300
Message-ID: <20241122203901.283703-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the dir_cache_timeout description, setting it to zero
should disable the caching of directory contents. However, even when
dir_cache_timeout is zero, some caching related functions are still
invoked, and the worker thread is initiated, which is unintended
behavior.

Fix the issue by setting tcon->nohandlecache to true when
dir_cache_timeout is zero, ensuring that directory handle caching
is properly disabled.

Clean up the code to reflect this change, to improve consistency,
and to remove other unnecessary checks.

is_smb1_server() check inside open_cached_dir() can be removed because
dir caching is only enabled for SMB versions >= 2.0.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 12 +++++++-----
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/connect.c    | 10 +++++-----
 fs/smb/client/misc.c       |  4 ++--
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 8b510c858f4ff..d8b1cf1043c35 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -162,15 +162,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
 
-	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
-	    is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
+	if (cifs_sb->root == NULL)
+		return -ENOENT;
+
+	if (tcon == NULL)
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
 	cfids = tcon->cfids;
 
-	if (cifs_sb->root == NULL)
-		return -ENOENT;
+	if (cfids == NULL)
+		return -EOPNOTSUPP;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -394,7 +396,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	struct cached_fids *cfids = tcon->cfids;
 
 	if (cfids == NULL)
-		return -ENOENT;
+		return -EOPNOTSUPP;
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 075985bfb13a8..d89d31b6dd97a 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -530,7 +530,7 @@ extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
 
 extern struct cifs_ses *sesInfoAlloc(void);
 extern void sesInfoFree(struct cifs_ses *);
-extern struct cifs_tcon *tcon_info_alloc(bool dir_leases_enabled,
+extern struct cifs_tcon *tcon_info_alloc(bool enable_dir_cache,
 					 enum smb3_tcon_ref_trace trace);
 extern void tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace);
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b227d61a6f205..f74e0b94f848c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2593,7 +2593,7 @@ static struct cifs_tcon *
 cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	struct cifs_tcon *tcon;
-	bool nohandlecache;
+	bool enable_dir_cache;
 	int rc, xid;
 
 	tcon = cifs_find_tcon(ses, ctx);
@@ -2614,15 +2614,15 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (ses->server->dialect >= SMB20_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
-		nohandlecache = ctx->nohandlecache;
+		enable_dir_cache = !ctx->nohandlecache && (dir_cache_timeout != 0);
 	else
-		nohandlecache = true;
-	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
+		enable_dir_cache = false;
+	tcon = tcon_info_alloc(enable_dir_cache, netfs_trace_tcon_ref_new);
 	if (tcon == NULL) {
 		rc = -ENOMEM;
 		goto out_fail;
 	}
-	tcon->nohandlecache = nohandlecache;
+	tcon->nohandlecache = !enable_dir_cache;
 
 	if (ctx->snapshot_time) {
 		if (ses->server->vals->protocol_id == 0) {
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 4373dd64b66d4..60f35d827382c 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -111,7 +111,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 }
 
 struct cifs_tcon *
-tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
+tcon_info_alloc(bool enable_dir_cache, enum smb3_tcon_ref_trace trace)
 {
 	struct cifs_tcon *ret_buf;
 	static atomic_t tcon_debug_id;
@@ -120,7 +120,7 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 	if (!ret_buf)
 		return NULL;
 
-	if (dir_leases_enabled == true) {
+	if (enable_dir_cache) {
 		ret_buf->cfids = init_cached_dirs();
 		if (!ret_buf->cfids) {
 			kfree(ret_buf);
-- 
2.46.0

