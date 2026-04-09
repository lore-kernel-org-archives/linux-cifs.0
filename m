Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A03BAD92
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 09:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728802; cv=none; b=azNgk/PNdqgWAu7oipTouCA1j3zB4IIJ03rHNb9EiZTyV6og4zGwSmc/VLH+dws0EYTsbRBXhO4sA2+4KD/JDMLMmagPAqdKyMUuBPjE2F25WmzT5Yv2q/BZNYaJWRIarVFVr19gVpK5W45gHrL9nKvaRUtqiwLlJyMlkPG4NiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728802; c=relaxed/simple;
	bh=xbioMmi4wWbrPSlpG4HbYgE8Rb3DQIUxwj11/DTkU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MotpLK1ypHJyCgM2e3K2On9X9AQ0lG0tBEQhfwaZzCrgR2k8fH0kX4OLaBniJ2SoUXdYXK2rAXAm6zfADyQYuG1dZpXbyQdRuHPuDhf9DeLccGGhpJYI/a+qS6xlHK3gnTn/uNXuASKDw52LH8tubG516ieAhP4ljhUGyInjgfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hacRuYEE; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hacRuYEE"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82cebbdab08so602225b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728796; x=1776333596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FlkZH1SuQrwakRTOg6E2zmugoAOuiELmZsl+WpaQ39M=;
        b=hacRuYEEBY3eUdxTjB6VYFEqZfmK1fhWRZ7yKcWC4IsEoagaRjiTWuEevNgFuuY3hk
         60ZzZKLgw8yPsTRo82QVxAHtcwwGU3I78P9DJmmWVSULIckzXEtOfU1eiRrm1mFvQLV4
         shFpegoVH2WkeNck7o6gzaZeRSUWAOcnipIcTQZ53raSmjTpir7BeE4Sz+8y4mDc3Q1B
         91lxJwxB0WQyrDKNBdoAF48vwUP2ORo38ZZITgpozNFVC6akipgtQFEQq/uLz8wxJXD/
         12W3/8FQQ/LsorjkeZDkR9w20TujIb0Kz2I7jg+Nhx3TraRWysVhVVJvpB2EXAWMecDR
         Bu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728796; x=1776333596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FlkZH1SuQrwakRTOg6E2zmugoAOuiELmZsl+WpaQ39M=;
        b=VeCSCNA+BSOArGp0mKeprI5MPdbvOsBukfXytmCaAgMQWq7pX8UM+7GY+1CoCtOHg+
         bdippR6iT+dTciWF6suPed6ICDECVvhh3rLDeehlU2RdwfVSM7aOldpDjf+6UGdgySjX
         NoyyatP7R8CEV/MMXQZqb5GgXqiSi6bJClcRYc1xbFQ2+Z1n9qFeIUtdr8ilmFnDSbSG
         t77r++m6hITbleGgIAWYWGqjylDMZukVqwz3dVwGefVnfOHOn0ikqsuoz7Tt2329pU/C
         i0RTo1W2ciERr6XWo3iNMTAl/1zcx7ptq+nnhawUSeZNt/5Glkg8uwf/3uPM7cM05quQ
         OhOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs1yT9MxR5XF4K0XKy+53WD+UiQvxFxhsu8rKEmbFQKhH/yez2FFSD4OiSrQ+QuwFe0cEu2laWqLRL@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4qCTCavT9w/dx1qlgMnZoKzq/Iu/yeQM63LEWAdj/TtOq1tsR
	7DRAhWcWXz5CdFOdVId5DUgbqZrYxlyINcjK/kasJ246fjuSf2GcECD1
X-Gm-Gg: AeBDies7V6k5VWXdTodbCYyfFEq+jjswhH9RrhKHOA8CrsLNRztPAF6vqQGBBNKosac
	Yn8UoDKTWcyObabQPVthb/2qT7AjzZ0p0UWllGpyBHgb1NMk4t7Aj8AzGLR9EvdO098wcaIqye6
	6mfOMvnAA7PgbRcXK9idczeV8Ld0T03VuGfDKz3gg5Ke9ScTtO2LhXJtt2+QTkZMXI0CrMe5aRP
	D70qaF7F/0cJGgbZQ1xAhfjm3UorXjEQ+eKz7z0Yn9Na5VOYpBl2Kd7i9VScbsrhQsDc1HW9An4
	5EvIbCDQS0HHGQHpHGcL9iHOSCuXBOpXQkOhxk2q6j0nx2oqpuuTT2lGGqvfTFERpo9Rp0UcDIH
	xKGKHn98ZSgXaJQ/4Bckteg1f+9SyeUVLOjjEUziHTtkeAw8fgug5K04zBz82e2la2xaa3C+QLb
	tFPoDpOnB6WgzzxO9zXaUJ5dWUbRDF3q9SCHI40wNJyXYF2jAtD2FmqnO94DowhmsiAH9kL4a3k
	wknoB/JE4xXjB+LSD48nUE=
X-Received: by 2002:a05:6a00:c86:b0:82c:d92f:3b64 with SMTP id d2e1a72fcca58-82dd89c526amr3132952b3a.14.1775728796314;
        Thu, 09 Apr 2026 02:59:56 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:59:55 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 3/9] smb: client: sync tcon-level options on remount
Date: Thu,  9 Apr 2026 09:59:20 +0000
Message-ID: <20260409095926.905020-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
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
 fs/smb/client/fs_context.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e1bf7bad5be6..90e83f07c870 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1307,6 +1307,35 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
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
+	struct rb_node *node;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
+		struct tcon_link *tlink;
+		struct cifs_tcon *tcon;
+
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR_OR_NULL(tcon))
+			continue;
+
+		spin_lock(&tcon->tc_lock);
+		tcon->retry = ctx->retry;
+		tcon->max_cached_dirs = ctx->max_cached_dirs;
+		spin_unlock(&tcon->tc_lock);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1444,6 +1473,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
 
 	return rc;
 }
-- 
2.43.0

