Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E026436405A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607132; cv=none; b=EWFgfCRkrKMIEmlIVWxi8pQX1nX91Q7sfwpgzT4kiM5t4ZGgTT80UCSpx939n9H66URi4qv/ZQF7nxveCaSnS8WQORS/6Ai++ZrpNPPUw3QrCQhUJUQn8Yj10h36xXxKAzrB0bRO7VljBO02NBrUXen2FWoCs4KvlM86mDjUA4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607132; c=relaxed/simple;
	bh=AWMcUxye6Zk1JO5vXGTY9ZaFKYcc0H77hK8geW7bjyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF/aePSQk2jpNHB6HHqX4r1TmqkqnC2f8aZe8E5VQMLmdqD9Gcx8ay4I1lDDlson9753ztmF4hifr4ujf0oqeQ0CMJZw0a1en05FnpniftUbabDs/Z5OwPArUWKhT+tNPHHnrMlHcr+U2NHJzdEcK6Pv/zlple1ZmKywUHFbBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D28MX7gL; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D28MX7gL"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso1712716b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607130; x=1787211930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u9LoEceTqMdvQ9byiECt1ejmOS2j4ZDtuU7edi0bVc8=;
        b=D28MX7gLPW8C8d4ZEXznnVAJF2BzqcY8OMhc6qF/Z3sdN7dYFnBTUGQatvNOsK+dS+
         Rvx9bxVKVPsLZeVCLGTM9urZWvj0xSlQVGm57/dPRpokzN0KTiHUU0yNLtAGue8OAzzj
         uBGJ2FkyD5wDPViIdn15oH6Uf9bOx7JcNeyXc9qH+DM9YrX2X2JHxZb6v6AIZlaGC7pR
         I4M3ZalhKvbnLKECdd0mnQQnm9SWBhByV8fgXFr6fF+/7IuIo4KIcIakXnpjinBrcq9/
         jG2y6F86/nPLpiU7Vw/LgmmN/PqQF6kYqKfJFhWnAWYoDx1B1YfqHTjs4SCGhZXUZYUs
         ozqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607130; x=1787211930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u9LoEceTqMdvQ9byiECt1ejmOS2j4ZDtuU7edi0bVc8=;
        b=p+hnUIEvttsWwHf2bQXkD5giyHMLM9RY55IBYJUa1UM8IFLvF71Ft0Wg4TTLSmDzVb
         GmLBJazFBNLErohgNVCAgIB0UlWg3Tj8LGq+7BYAy2ySw8JPDldGkCq1D8yH2xTMS3pg
         MxcrIxnNzlx0r6LRnYglQxbNyAWc4LOUSZMEI+JBh8ib8DbJd8oKsYU+HiBr9bgAQE1T
         Plw1s+dK7oX9S0MbiiHy/2bOOwlgLVzN0aNgU/ZLh3b+5+CNXxuRLvyw7I0PaOiUaIxW
         gGom+As/rZDihxsJ2ed8FTBMaTkoB2d2R2xPUxQyxj7p4fEN492S1tNOaNejeYyTxWOh
         15pA==
X-Forwarded-Encrypted: i=1; AHgh+RrWu0Ye1I4MU8sVLNDR4PGn/n3+M39yIKD1x+FWzBZbBoVlpfQN512ascazvtnjkRnW/m0wkIsiWErI@vger.kernel.org
X-Gm-Message-State: AOJu0YwKzIvWzYwU5hMdvSkrEPFdNav5JLcR8Iyg9P6plLoeJbdFDzjC
	yVLhhDxMSlduEhEx87gJ6Jj4mqVhQ/TK0jbkwniy0CDiuif8xP0CBuAtAQDJ1w==
X-Gm-Gg: AR+sD1371VHUtdAh1rTIWNGjEzLHW2JEUyNnEM4R4AL4ZPv4LePe8hZ89bGpB7ElikL
	8D4IYz3FhKvYKGcDqN2mk7gslHtmJ7g2I51ouz+3JgF9ESFpwOOS6UFEb+kOJX33m5wimMPtFgS
	Ako7JmdSqQ0xJ79yjKYwJrXP+teCh4hfkjMZ6mHYUbDl82T8WGcyO6jSjLubLX0lWlQ49w3SYw0
	XAZx7vTv8hsKthnSxvRJwHLWwS2Mxrw4SqVoudWyJ6/eOYqh/Bx0zo9MDfjcYXk4+0MrspOQQRD
	rA8fNT95lCgd/zHFp15w2YlszmA6r55XB4q5tHxlE8lALsbx6f1h8odt/nCjV8SwaWxifOQj2LZ
	txJyAKa1DKOXgVr3bagPH2+bh8XvHQy/AnWs+Q2zCc7yuhRZIacMPNpa30dMO4Kc5x2oqY6eazu
	QsqklFyoTddegJyC8eJkwxUb1q4K70m0V7tYdx/nZ1H+8tez9/lzVIT7vdQ88XkUo1E2J7AXVqC
	vVKWH6ujbVxEvcFSgiTLLs8kolsIFiImYklWNQXskJl3ZEg+ug54uVcTkDJP5sDFVooszrvbmRu
	ULhyGPLnBKvipCk0
X-Received: by 2002:a05:6a20:3ca7:b0:3bf:735d:7fb8 with SMTP id adf61e73a8af0-3cc552994e8mr5571774637.27.1786607130002;
        Thu, 13 Aug 2026 00:45:30 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:29 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 3/7] smb: client: sync retrans on remount
Date: Thu, 13 Aug 2026 07:45:13 +0000
Message-ID: <20260813074517.607275-4-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
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
 fs/smb/client/smb2ops.c    |  2 +-
 4 files changed, 37 insertions(+), 5 deletions(-)

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

