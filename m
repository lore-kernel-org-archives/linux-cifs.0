Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8233EE1FA
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371691; cv=none; b=lZdcLqTODfqSgKIbEa78rTZ7SyAYwsQLVNgRdegHcEercE2eIcUy8M5TSIw+LaTHIq7d8CYhD6bDRN2CshYi86pnpZdDcm7vzk9SQ0zqODNpupZqKSMaYaZishs6h3fGHRMD0Ts/V64J7yRSyt3KFaZnZBC8ux5zsI+FonetZ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371691; c=relaxed/simple;
	bh=RI10n1qN9PRuciwWVrmcV4hiTMl0q/PK3pSMNTMy8VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l73n8rC8rEfAWhK11xC5fJttidW5uf2EZz95NBm8Gk+kuOCmwuFcfC7behM0Q+0qJLeyzm8jeEcIhLDDGbE+Zyz05bU2SO+z7iLgzv7Zaf1Whk6wh5QkMMC6wC6dutHTQ/r040hFkEgpp4Bj4WQxKkdESjBjZSED7egq/FE1j0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7pegb2J; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7pegb2J"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c736261ee8dso2857436a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371689; x=1779976489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asw8+k1HzGDll0cdLC9LdLrDYlLoYsBqK1vXCfm5seM=;
        b=j7pegb2JihntqC2rWQb4+ePgnuLYlBXF7Fi8zPkQNgwok3I+WSjamNqt0u1Q2KYQA8
         OnDerBatZynb/Eh7GoKe+ZvVS9/XDkIe7FGYzr2sTRIGor2wNfKMBhFdk6gapXDDymbg
         nb2lpF7Mum6uxzhepzY2LDY9J24x1EPzsvaQP0zMKKpQvG8VJ9lCV7acc2taP/JUnJo9
         6Yf2ZiUxchz3CfJMp5ugMqMP4tb+opnFGB2kNAtDlA2ik3KcloJ7ZMMW52eOrHeOTmiG
         cpx/ZInTxNqOwJaAEOtmtYHAkr2P6G7hBBmI/6lZIk3rk0+x7HMQAellwkeHuTgAs7j4
         X0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371689; x=1779976489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=asw8+k1HzGDll0cdLC9LdLrDYlLoYsBqK1vXCfm5seM=;
        b=YM+3Bf1x1OAI4k22DC5ga/KYqtzKhFRme3YdS22BlqG4yplJSXufbPOZpu/IiT8SgN
         2osVdM+zhuiH4DpezdR69vKbaGUvuYEVWEL2m9eEeiQqQCaVBVm9wAZMi2myW9A69SKD
         bBb8P9Ho7PiIjSzj4pgydMbxOOOd6h21OJmpRtGEZZ6KkKPwRM7tlD2vxQ6/2BKkl7x3
         Vf20s/fEfX4NqBoWF4xj7EgYJecrUEG3U6BK5hB7ERISQ4eLyrbiPOX0YwS/a9VnwaFp
         UVvUsVKp8utPT85U3Kn6QttxricN7/NCltLSOxri9nl3TI9x3xGxZceyYxwQXvZzcFSP
         BK+w==
X-Gm-Message-State: AOJu0YxCguvi+IShDVVJ9cF06Ot3yDq10Z6SDPonMQUSWpuJQ3+NrVj8
	NtVj5fuh6aCSQ3q+sT/+odWSV8hr8iUvOzl4YzOzYYgmRFhj8BmqoazU
X-Gm-Gg: Acq92OFZehfOMezv+seXrtN7gMdnUsChAlb8W9i5gKao8tNGs6bzKg0e3P/ZgIGOZSz
	J8cSi6oLhWXl8KvMgq3IgA/WxhRfsVsLUG71M3+4f7dTCEhWFCQlw8OF2YTUN3lRyeN5N8H8La5
	dUJENbr2yen4KMJdiSU+7p/5ns6fAk2QRfQZlKN61Qn6MC4WfRZtMd0rWHE9MpYbLilBAY6z4p7
	LQjaMhElc4MDsg2IbeLKrv6qmrwOH/+neVgWmFWLzA/J3BtFZKdoBHNVlc7rsswA5+PHveYqQeB
	FUGdE+Dwq+F1qiQpiZyXlUNglp1REUSqEhyzku4x1HSEreILNF5+uh+H4n5AAKffd1oMdVbTpE6
	/V20rBC+LlxwFoMy6BAg7tqYYlY9j75wgb+t+Jsszy2DJKmL1yx5rrMTNO5N1BIFBRMzKxn0vDL
	FoniWnYQx6UpSKXX3u0dUNpzauWROq6yFwODFNnrYT6a+DXxa9wTd0XGXOKg2/ysP+JA2W4CDPL
	z9Q0y4bzfKTmWBrNy1kSuU=
X-Received: by 2002:a05:6a20:7f86:b0:39f:2dd0:65d5 with SMTP id adf61e73a8af0-3b30879bc49mr3761495637.39.1779371689236;
        Thu, 21 May 2026 06:54:49 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:48 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 3/9] smb: client: sync tcon-level options on remount
Date: Thu, 21 May 2026 13:54:09 +0000
Message-ID: <8c3698becdb6e3e3748bc042ffaed596dce3feb8.1779371115.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Several mount options are stored on each cifs_tcon at mount time but
smb3_reconfigure() only updates cifs_sb->ctx. A remount that changes
any of these options silently has no effect because the runtime code
reads from the tcon fields, not from the superblock context.

The affected options and their tcon fields are:
  retry           -> tcon->retry
  max_cached_dirs -> tcon->max_cached_dirs

Add smb3_sync_tcon_opts() which walks the tlink_tree under
tlink_tree_lock and propagates these values from ctx to every tcon
under tc_lock. Call it from smb3_reconfigure() after the context has
been updated.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0677aad237e8..f92c1cb274a6 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1273,6 +1273,38 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Synchronize tcon options that are derived from ctx across all tcons
+ * associated with this superblock.  These fields are consulted at runtime
+ * (reconnect, I/O, unlink/rmdir) so remount needs to update the live
+ * tcons in addition to cifs_sb->ctx.
+ */
+static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
+				struct smb3_fs_context *ctx)
+{
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct rb_node *node;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+
+		spin_lock(&tcon->tc_lock);
+		tcon->retry = ctx->retry;
+		/*
+		 * Note: this updates the limit for new cached dir opens
+		 * but does not resize or evict existing cached dirents.
+		 */
+		tcon->max_cached_dirs = ctx->max_cached_dirs;
+		spin_unlock(&tcon->tc_lock);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1440,6 +1472,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
 
 	return rc;
 
-- 
2.43.0

