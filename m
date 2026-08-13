Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3767455199
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614186; cv=none; b=Xo0r9KpkbcVEQ2hchREkZRCZ2JQbP5fpLMdmKG3TOm7fOHhBvBdtXzWIVjQtRyYx1RvFmMfF8WXdt31t5cSSr5TQIYBZDBemEV2UgAG29p6kyh0nxiD8SesZJktFfXMwV++g1owpRtgfx6gnOek04tihkcFdRaYCwK4Z0LehWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614186; c=relaxed/simple;
	bh=aJkOpCDY5VtfVy3SFnzSQG38VCfz575mXq9hJLCxq3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1ze0Q4V3QPNdPD4O81nxs6IHxgCqbDshRjlUpvKG3OpoGkFKaA/K9uODi+M5pCKY7F5TTfkFlij2sjcBC9jgJkIEG5m1bUudz2n8Iv6rM1cbrT/e08dBZaA963YwM2uUqpxFivwim7KwjMYqSe9Krsnfwy+kVPkLcAqrDkdaa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l691NVO9; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l691NVO9"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso2762237a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614184; x=1787218984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M2M9hHsSIeg31QoY9lrcASLnaqjcm3Y4m+SKGUDWO4k=;
        b=l691NVO9Gmzu0DWCeb5xaO5SvCKJpzzFs0hwRTqgwegq8faM7cM/d7+pNYhV36Lmkv
         fP5fI94QZQuU/k+9rBudLJv36QO7Znf4P9lcRO5qfML5TWOIcdV0qmrs5160rjD/gZ79
         AjIPZ4/PHhQszknXmu1LGAthUmON391y7mMUeTVwcqPcIMlKGiOKm2hrrMh4Y0shfgLV
         F14q0Ex74FJDu5s/NGiGdxwygYttg2zbFw/NhbmfSunRDqn5vPGulhjKinkFscDkNqE/
         OsMqS6J3Taz3igdByXOuh6k1muWLiV/h5QmkUMbW8xBLzUwyscpQwh0/YOzg2H+aPM8C
         O1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614184; x=1787218984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M2M9hHsSIeg31QoY9lrcASLnaqjcm3Y4m+SKGUDWO4k=;
        b=eGDoE/4iw6ec0SBFVj+M5N/EUNIMTpUXyVGq9f86UrACtiJID//LdJL9vIKRCYUoQz
         QZ5y0VdeSd5CzEbz7VsSWgHJGU8w+zOFUAjbxgbQ2QZLYGDkR54DhR996ZDijt0StZnK
         ZeUsRuolv2SmfJOBQZdx8rAQ72DtGiJGQ76xj2hQeMXZ4QG9uC20pdtTJ/gY9xRxyO+c
         cpqIt81NXrCLjUtFNkrjwwu35rWx9wdJOSO5Ykf1OmZriqhLJm8rQioTRuJzo9Y+hDVE
         cjjqXKA+JQCCPput3v3b/Kju3o9N9+MRmr4YZVL62qUI05330mL9XeUyLZY9hfeXVTJw
         0Dgg==
X-Forwarded-Encrypted: i=1; AHgh+RpgTxTLBu3OhfszF5tFfFBuafmkQ0c6zZKqBdEU7316AhRe4Pkf3uS1T77uh8W/Me0PyZwDzc/cle82@vger.kernel.org
X-Gm-Message-State: AOJu0YwgatmsPTW5cbaUza0HO3/zQRosNOITbPJjPCbDg0BOZEQpG+ka
	W1xrNH6TOjOoFddXaBKAik/ZyCFeZZDaEju4ro0XvQZoVMNGmioyaB44G1qoMQ==
X-Gm-Gg: AR+sD13LHulLqfW3ASXZLxFq68hLdO6tr567XfdcuHemg8yVNhtbzRfHVjpXH67Q0r4
	xejNrECxPSQ9ab5rWnaPuedgXlsiRxkFr3M2x2jeYMe48xLHxmmTyBQZID22IqhZGiLGTJqRiew
	7cbCMnFzv1wbiCr5Z7g3OrtGXqnNOm3XKezcFiT0wTXjHJZkA6gjb5Mwhz5Y+bqiryfqbaU6KrH
	gwCL5hGYVqmz0alk4BVT+vJaoIlaNm5pCf33BVR4FghmmK3fICQd9kdZJmvYqJampXzXRr1pbUL
	kZiEsmrTm95HiMPLnTCutRy3flW9dDGR1rtQOEOA3J9qWtopRsdKvy1rQW8CRihNUgDe0h7gYFh
	euTFyGe/OXsGvsJqc+GEAkk+NWfA5WHRIIJXoFI5vijPyzhkMVWrjq1tQbwou6jVDn0Q90Q7qrQ
	SGo2NyYMF/7t2Sy4XW3JXc2BC5Uoju5KobnplHHEanNIJwvcMV/yc1MhSpMSfHsF0GHoVe28pUv
	KBnFFyabmT7Zu3Rm7NBPPYmr1XXs++yDn3JODxxLaKijpL8FWqJzLd1sCPjOncgV4EkUA0TKnwP
	aVxBrBlQn0wDMkTY
X-Received: by 2002:a17:90b:3b81:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-3931dfdd5b1mr5135828a91.3.1786614184125;
        Thu, 13 Aug 2026 02:43:04 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:03 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 3/8] smb: client: sync retrans on remount
Date: Thu, 13 Aug 2026 09:42:46 +0000
Message-ID: <20260813094251.666373-4-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

The retrans mount option controls how many times the client retries a
request before giving up.  Remount stored the new value in
cifs_sb->ctx but never pushed it to server->retrans, so the live
connection kept using the old count.

Add smb3_sync_server_opts() to copy ctx options that live on
TCP_Server_Info into the running server after a successful remount.
For now it handles retrans; later patches extend it to other
server-level knobs.  Because the earlier "sync runtime state into ctx"
patch seeds the baseline retrans from the live server, a bare
'mount -o remount' carries the current value forward and the parser
only overwrites it when the user passes retrans=N -- so an explicit
retrans=0 now correctly resets to the compile-time default.

server->retrans is a plain word shared by all mounts on the
connection, so reconfiguring one mount changes the value seen by the
others.  That matches existing semantics: cifs_show_options() already
reports server->retrans per mount and the retry path always uses the
server's value.  Its access sites are each a single independent
read or write, so they use READ_ONCE()/WRITE_ONCE() to avoid tearing
rather than taking srv_lock.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifsfs.c     |  6 ++++--
 fs/smb/client/connect.c    |  4 ++--
 fs/smb/client/fs_context.c | 30 ++++++++++++++++++++++++++++++
 fs/smb/client/sess.c       |  2 +-
 fs/smb/client/smb2ops.c    |  2 +-
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a1dacc7d8f74..07d58b26f455 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -627,6 +627,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct sockaddr *srcaddr;
 	unsigned int sbflags;
+	unsigned int retrans;
 
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
@@ -782,8 +783,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",rasize=%u", cifs_sb->ctx->rasize);
 	if (tcon->ses->server->min_offload)
 		seq_printf(s, ",esize=%u", tcon->ses->server->min_offload);
-	if (tcon->ses->server->retrans)
-		seq_printf(s, ",retrans=%u", tcon->ses->server->retrans);
+	retrans = READ_ONCE(tcon->ses->server->retrans);
+	if (retrans)
+		seq_printf(s, ",retrans=%u", retrans);
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ba749ec25a59..b5d257a83b4f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1658,7 +1658,7 @@ static int match_server(struct TCP_Server_Info *server,
 	if (server->min_offload != ctx->min_offload)
 		return 0;
 
-	if (server->retrans != ctx->retrans)
+	if (READ_ONCE(server->retrans) != ctx->retrans)
 		return 0;
 
 	return 1;
@@ -1873,7 +1873,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 */
 	__module_get(THIS_MODULE);
 	tcp_ses->min_offload = ctx->min_offload;
-	tcp_ses->retrans = ctx->retrans;
+	WRITE_ONCE(tcp_ses->retrans, ctx->retrans);
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d81bdc875580..2fb40e9e1652 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -964,6 +964,16 @@ static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb,
 	ctx->nosharesock = server->nosharesock;
 	spin_unlock(&server->srv_lock);
 
+	/*
+	 * retrans lives on the shared TCP_Server_Info and can be updated by
+	 * a remount of any mount sharing the connection.  Sync it from the
+	 * live server so a bare remount carries the current value forward
+	 * instead of writing a stale per-mount copy back in
+	 * smb3_sync_server_opts().  Read with READ_ONCE to pair with the
+	 * lockless WRITE_ONCE writers and the runtime retry-path reader.
+	 */
+	ctx->retrans = READ_ONCE(server->retrans);
+
 	/*
 	 * These connection-tied options live on the shared TCP_Server_Info and
 	 * are reported by cifs_show_options() from server->*, not from the
@@ -1318,6 +1328,24 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Synchronize server-level options that are stored on TCP_Server_Info
+ * at mount time.  These fields are consulted at runtime (retry logic)
+ * so remount needs to update the live server struct in addition to
+ * cifs_sb->ctx.  Note these live on TCP_Server_Info and are therefore
+ * shared across all mounts to the same server; reconfiguring one mount
+ * updates the value seen by every other mount sharing the connection,
+ * matching how cifs_show_options() and the runtime retry path already
+ * read them unsynchronized from the server struct.
+ */
+static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
+{
+	struct TCP_Server_Info *server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	WRITE_ONCE(server->retrans, ctx->retrans);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1516,6 +1544,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 7cf7dd104f7c..dd5a1531808d 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -557,7 +557,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->ignore_signature = ses->server->ignore_signature;
 	ctx->leaf_fullpath = ses->server->leaf_fullpath;
 	ctx->rootfs = ses->server->noblockcnt;
-	ctx->retrans = ses->server->retrans;
+	ctx->retrans = READ_ONCE(ses->server->retrans);
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d..0debeb36447d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2837,7 +2837,7 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 	if (!pretries || !pcur_sleep)
 		return false;
 
-	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
+	if (tcon->retry || (*pretries)++ < READ_ONCE(tcon->ses->server->retrans)) {
 		/* Update sleep time for exponential backoff */
 		if (!(*pcur_sleep))
 			(*pcur_sleep) = 1;
-- 
2.43.0

