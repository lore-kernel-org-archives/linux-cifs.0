Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455653644C4
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161502; cv=none; b=lDDIkOQA1k7xxmX4xRba63akO0+hELrnFkDBY9sV5d/w/P4JVHMc+tsVbE27SzAVbm+Cm6LqPFZvtDOtxFI6i3QyIStYOJ8vyLkt7RWg0cy3A4tmVhZuomXc5KSIT9rbayzxNCYzQOYKXBRVSzwhaGkJsH89YPGkYv4gl+WRUMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161502; c=relaxed/simple;
	bh=m9MaosUPKaB0tBzPKf0abkzvdo8loO0Wht92uCvajp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLojkF/eFDe9af+omJ0htGgTbp/UMn0K/gQiA0CdZIRG/xrwnjQr/qPjx4ugE6l/6e84jaGBGVCtTQAVmYmHtc/DMZ/QjkXor0sngutOIG6i7sg43OfHtQcTkbQvG7IausP2HfH5Y+lmYXaPUS+SqTA2h0DCIgQdVYcTcHWENQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvwN1nuG; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvwN1nuG"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3654ebfd57cso543200a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161500; x=1778766300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvaarcIR8PMZdGAS+35+02AWGF5k6W8rfrTDk8NUCqI=;
        b=cvwN1nuGKKR/995cUJSydF0wfiPn9kff5qlE3QqzbqEa+NV2ZgkBxCfO68TLsOTG3e
         x4s58BTZZpMlGuYngZcs2UvywYfW2optdZCw0cctqPyodQgFKahG9e6saJ5KK6QsPq2g
         pTwE6vdvbPVeWKNS8uK0ts+k/dio5ZlpVFcYDhCF2yYHlw7wynfzESfADQQDpyIVM3g7
         1lKUmhJ1clLFAXWIWKn6vz971zxyas/r6ANoO300/tqHbfGviWOFmp2Q3AisDN70B2sg
         AGCWnOPaayJNcXi5O6ygtEfJKgzn+042tN8QWo6u6lLoioOuIuvlJBquiun3ghY3YDhs
         dxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161500; x=1778766300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hvaarcIR8PMZdGAS+35+02AWGF5k6W8rfrTDk8NUCqI=;
        b=rSQQFpUIKE2aTxSOumIwuXxeVrswYydtMAPdbhVQH5r9M5tsRztk4rJxVR3EWSe9Rp
         feQ0L9nC1MNIeF2sXHjcChoaBjgfKxALH9eKybeQHOUpcqLsZIgDmN9xJZEqVwMM1/ig
         x2ynHF039tNkl3kKCaMo62wvzrLx7KVfmhOI6uzz6MISdrpvGGE4JerbvMNItNce8v+C
         aoZib1jvY9XvZ2Ho8U/kSMDl43c0FqZtLIUpl8pOPaUoYK8I7N5lhdm7//5lXIPUWtCq
         gijIiRAXTf6VPQBtM8q073tTSSK0rspN1FoVqyBBNUwGlAedICMkdu6ioPYluQeBSIoI
         j5mw==
X-Gm-Message-State: AOJu0Yx/rj6B/CqOzeVjFHDh5ouDcWqMa1f2gxKvjOwk7i23G4o4s0da
	9GCDG11mbMaCJ3ruwwe1SOicPph4GIxrQjBX5fxk14MuzWWzGWO9ntREcKMcBQ==
X-Gm-Gg: AeBDievv4Wa7SgEe40Knb1RD9JmdpwP/jneeVrBNQ72VQkI3eRoszHz07AAOFXM6HQN
	HNG+/Ti6H6PqhfqJPhjt8mU5l7entceiidd3LuF5LRH+xWv7m39OQfnw0RKHCHoI4TbXsa1yI0q
	HOERxgNzp3jbeYATIdXGTDLPtIhL+4i01/j3wBVYQ1PRr4Gead4GcVcUjLtcqWOi5a3Z0Ygl8Dp
	OxeSSrvQgmIitTQ/s6ZKZ6oi2scz5+jkTAiaNKE6zbpy+VBNF9O1UQg+cIzA8MjsXyoG/brkt9L
	xAKZPUx5M7Ie0D1gJv+AB5LJIECJVNCLoyyp54JH//aHANdgxDY6n0qXMFM/fDwD5nofrWdbAWn
	lamfCAJB5kCibWPYZx5QSjLTiUHuH3ctTw/Sg/xeTvy5hjwAeAV9roA6baeStP/ZSHzGL3Nlhm1
	8wROnapeZHV6HmMkD6/rvz9zTqbjkr5f9lzJs1IBdE92oyD0vrfiJjhjM9/Ic/ECc9sNTsG/7Fz
	LhTEGr+qiHcVJOMLEzUJALu1wjKpOgwW3O3AxObdKJr
X-Received: by 2002:a17:90b:2f46:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-36635171b3emr524882a91.0.1778161500189;
        Thu, 07 May 2026 06:45:00 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:44:59 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 2/8] smb: client: sync tcon-level options on remount
Date: Thu,  7 May 2026 13:44:42 +0000
Message-ID: <20260507134448.168602-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
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
index d90430e7a648..20c17f7cbbf8 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1264,6 +1264,38 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
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
@@ -1397,6 +1429,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
 
 	return rc;
 }
-- 
2.43.0

