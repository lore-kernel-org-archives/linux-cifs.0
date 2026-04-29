Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685B82FE58C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495983; cv=none; b=RalZ1ykukZx/PmBqdUCbCyjlb5l7nP42I6zWydLBFNttzowtMVfeS+8I1Wolzf4S1G6LtfQgMEnJv/HorAc4efV8FkMiEwHCOReVJRLYh5Te/lrDO4SAyc1gqfJAtYZhlCO7TZ0yXYfeapdITU2EQA0fxMMMKIucwVIJcVi6gu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495983; c=relaxed/simple;
	bh=H95xvPfekRcV6kcCfZnWxct/d3WkScr/5zfu4CeTb74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZC66xSL6BOLhdedeaow0sqpPUL4tm3lGtPTsPXySQjkKqluGxiCE7A7YKXt/WLWREuYziJfyZs6jN8WJpP9yvjh5sFoBRexblfREJeu9O+B0xLpG2J8TWEXEn1o2MaOW0YpbDgkVQVCgNE+PmlR/k8ThG7bq01+XO6XO+eJw0kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fpGBKwYt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fpGBKwYt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b0046078so1717555e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777495980; x=1778100780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tb24MkyjLzb8BmTwEPAd5bKVggSokaYwMRLyJVXZm4g=;
        b=fpGBKwYtS9J65Egz1e+qq1gHrLbrGMlnPZkOfDmPCgTPWC9HF7lDwH+aUERDnnkqJd
         ggKmlIS9eA9r+ZeI8dLDxK9X68rMYIQGBxfC6eNm45UIe8b1EEu6Mc0eh2HwvAHWbinp
         WleOeSL/i0cahlv8tcXluqlVCEKE+8MZrGTGDrE+XXVG//4WM5iTgXNBDIHeimE3Xxtz
         xzXRHbnfUJYO5kQ1a5MQjrCXTKixfYErjXdOLn4Gndb3wlNmZWacnqHftZ33DYwmeyhr
         Bjnt4i03G3LDeiXb8RmYblhqh2/iEXEPPZE/IaQ5WypGp5jRpmsMHhzJDFwYcs63+Hjo
         YCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777495980; x=1778100780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tb24MkyjLzb8BmTwEPAd5bKVggSokaYwMRLyJVXZm4g=;
        b=nsBl7AkuWyD3POMDYFOnzMf01Zr30CK+R89K+12jxyjTDBtkSV5P+9bHo+gdDJFy3/
         0VfjcWFtyzTa/KTKpgIQ7BS04FsP2oqwj63OuVGEgfXiRohtRX0wGOxRC6IjZeOnCkH8
         tXQhnmeuij8AJuILglRXZOe43+9d2CiZelo6vC+xUL2BAQ3vPU+P5LNSHTGfoAiPAvfa
         lRpAnaRslZ3CfRE1EQVFe9D9oX5zMeNiB/92UqabW1zdgrIIuMIq+rafIW0g/zVJqXu1
         5nW3SSp3IANMiKZeMLhYWANV4M1MpZgYfSCDw/WOSHWD4t6S7WIhqeFacDeVWWVv3fNk
         O6zg==
X-Forwarded-Encrypted: i=1; AFNElJ9jq9EheMJJsy72jB52b2aPR5pSBS9XlhonLTdHF3iBlVCjBwEMIZgdeb5Lt5RVmhtTG1imZVyglsju@vger.kernel.org
X-Gm-Message-State: AOJu0YzNHhEG/GjHfBMtDFW/ncJjmPz6+J/KnWHXDDMIm7YpgneumY8e
	k2nBO8v5QeP7z7HXsnWHDwXkS685YIv814cL0LY6oTrObCcIcftVf6MvUNuLLeC/SYo=
X-Gm-Gg: AeBDiesWmvlTUGTg5Pg1fttWydhjJKiukb4Qx0NVpSFy1lahGOOMBnpQbHU3BP9Gvq8
	Bqd0r8JpedoNy2E8aQNYJ32NzjSoH9TN8KBiqI6kiW+vXr/B55UHJ92lx5Kz8RKRUvR2Lgn2cxr
	AUARKaJFNrHwxey8lqWcxxUybWIqiXPrSDPjEU0NzMtuKix+zqrzJDqRAAygaU8K1hN0FmPgM04
	oQc8em8loVmvg217MZ5PHntUGgenxKOv+/jj8zjFpgR22KWAwRW1LWlVIXIGFZgqjhdBOl+oduw
	fkPiJGGU6vgvnMigtJj+Mtq+cCaurFwFTgIrIlNsMPYvZ3sryMs+zL9wfIyRvujMRoTz/XIfQ1/
	fQGEPy/XXPJKL49XYZ5O5scngIxcsciL1gWgF7OPcF4un1JT6jL5Co62cNmU45GXfVISh1BZ1if
	9m9cz3QTXmL2uC1Fv/XhGRvADqbGVS80EVthH7AcMwRsjK
X-Received: by 2002:a05:600c:a409:b0:489:1fa5:997f with SMTP id 5b1f17b1804b1-48a83d6c37cmr2425015e9.9.1777495979623;
        Wed, 29 Apr 2026 13:52:59 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de3269b41sm3925240c88.13.2026.04.29.13.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 13:52:58 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: metze@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/3] smb: client: fix conflicting option validation for new mount API
Date: Wed, 29 Apr 2026 17:52:34 -0300
Message-ID: <20260429205236.456099-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply conflicting option validation consistently across all the new
mount API paths, for both mount and remount.

Some checks were only applied during initial mount validation, while
others were handled during option parsing, causing mount and
remount/reconfigure to behave differently.

Move the conflicting option checks into smb3_handle_conflicting_options()
and call it from the common validation paths, including for
multichannel/max_channels handling.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Fixes: 1ef15fbe6771 ("cifs: client: enforce consistent handling of multichannel and max_channels")
Fixes: 77d8aa79ecfb ("cifs: reinstate original behavior again for forceuid/forcegid")
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/fs_context.c | 87 +++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..41384e1f0f3c 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -724,6 +724,41 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 
+	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
+		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ctx->multiuser && !IS_ENABLED(CONFIG_KEYS)) {
+		cifs_errorf(fc, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
+		cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
+		return -EINVAL;
+	}
+
+	if (ctx->uid_specified && !ctx->forceuid_specified) {
+		ctx->override_uid = 1;
+		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
+	}
+
+	if (ctx->gid_specified && !ctx->forcegid_specified) {
+		ctx->override_gid = 1;
+		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
+	}
+
+	if (ctx->override_uid && !ctx->uid_specified) {
+		ctx->override_uid = 0;
+		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
+	}
+
+	if (ctx->override_gid && !ctx->gid_specified) {
+		ctx->override_gid = 0;
+		pr_notice("ignoring forcegid mount option specified with no gid= option\n");
+	}
+
 	if (ctx->multichannel_specified) {
 		if (ctx->multichannel) {
 			if (!ctx->max_channels_specified) {
@@ -835,28 +870,23 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
-	return ret ?: smb3_handle_conflicting_options(fc);
+	return ret;
 }
 
 /*
- * Validate the preparsed information in the config.
+ * smb3_fs_context_validate - check initial-mount-only constraints: UNC presence, address resolution,
+ * dialect warnings
+ *
+ * @fc: generic mount context
  */
 static int smb3_fs_context_validate(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	int rc;
 
-	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
-		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
-		return -EOPNOTSUPP;
-	}
-
-#ifndef CONFIG_KEYS
-	/* Muliuser mounts require CONFIG_KEYS support */
-	if (ctx->multiuser) {
-		cifs_errorf(fc, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
-		return -1;
-	}
-#endif
+	rc = smb3_handle_conflicting_options(fc);
+	if (rc)
+		return rc;
 
 	if (ctx->got_version == false)
 		pr_warn_once("No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.\n");
@@ -891,26 +921,6 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	/* set the port that we got earlier */
 	cifs_set_port((struct sockaddr *)&ctx->dstaddr, ctx->port);
 
-	if (ctx->uid_specified && !ctx->forceuid_specified) {
-		ctx->override_uid = 1;
-		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
-	}
-
-	if (ctx->gid_specified && !ctx->forcegid_specified) {
-		ctx->override_gid = 1;
-		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
-	}
-
-	if (ctx->override_uid && !ctx->uid_specified) {
-		ctx->override_uid = 0;
-		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
-	}
-
-	if (ctx->override_gid && !ctx->gid_specified) {
-		ctx->override_gid = 0;
-		pr_notice("ignoring forcegid mount option specified with no gid= option\n");
-	}
-
 	return 0;
 }
 
@@ -1097,6 +1107,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (rc)
 		return rc;
 
+	rc = smb3_handle_conflicting_options(fc);
+	if (rc)
+		return rc;
+
 	/*
 	 * We can not change UNC/username/password/domainname/
 	 * workstation_name/nodename/iocharset
@@ -1909,11 +1923,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	}
 	/* case Opt_ignore: - is ignored as expected ... */
 
-	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
-		cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
-		goto cifs_parse_mount_err;
-	}
-
 	return 0;
 
  cifs_parse_mount_err:
-- 
2.53.0

