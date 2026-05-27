Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FCB3FF1AD
	for <linux-cifs@vger.kernel.org>; Wed, 27 May 2026 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779884830; cv=none; b=F+3TExFKsTJeWdkmj+VULMCTGYFyCdeiCWtIfm2XJYf7KLh2jmxBi5IWk9E8OUaT7NTKZVo0ASqibm9fWsUXm7+SRreZ+y/usR7gMu5EB9Yjdku6u3sxzYThCZEHJFR1RpJw12g0nY5fQbcV8etTWqU80xgGQxRhdb+FgOdazCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779884830; c=relaxed/simple;
	bh=Dh2F4+v/SQxEmzZKhGkze4MZj3ZexI4jC2bUmihqS68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=px/picQy/EZHvw4/Qbg/5jS6B75s5fkLvFZ0ZzrcvOjUR9XA8EVM0O/gssT2cJJ/TGqtrl+v/QiBPXi9MFWxw0OWwlEBNh1oMCwAJDabgDepWW0CuIGvl8Y+hmNor3ukbu43onesHlah/0WlwjJw3NnAi9LcM/feysTaQ0FSaOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IFSj3q98; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IFSj3q98"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so8260132f8f.0
        for <linux-cifs@vger.kernel.org>; Wed, 27 May 2026 05:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779884826; x=1780489626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/G0+2g+6rzZHpmNkSPIR2neEzlFHWm4xbECmEQ37CUg=;
        b=IFSj3q987+Ek5tW1S1R2MuXAKhQdac7nlCYP2zOyGTnduk3RpuHUQE53iNlGoOKJ/m
         twcIydpmqCNRgZmKPmdMoH2Fi3aHhFAgqSVBinnRCLQHysQRGf+aYNdHV3q6za5SPav0
         bGN+HG9NBVkrDVdviTU6YxgXN7JkXc7+VALpVNDYmdPeehD3XBit9I9hKUR6QvSmosmC
         uxBw2C1KvHQM00kQynPyUvLs68tPIp7fEllNh276VX+cC8Vao4oWg8Izyl0lMNcq11Xo
         nw/Ts8pMHp+eCQ84gJGBlpe08uUkGtOPF8iSRzUWZC1mM5E/fXTzAxNnnaeEFfPz3tQt
         3KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779884826; x=1780489626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/G0+2g+6rzZHpmNkSPIR2neEzlFHWm4xbECmEQ37CUg=;
        b=hWOVwTz9QjkGen2fU5nxCprtJ4wA43z4WSCmQ93ERRUEFkft3Xk5l/0hVz40v3JnkC
         b8vAkqFfE3UJ5J0DCdLdNZwv3612NUC+Mhdj3u6Ef/b9BP1+Y9UANDJNUpOx8t6ZPcPI
         DJgAXicggq4BA638pzpcb199NGkEUK27N3wBcD4CLpv+VRgY33+AulPRXMDsP4jwSkzx
         KoCiTuv90IRyIu0Wxui8g0wB7tQjuDVxP3QtHAvOd9eZBI5MWzvmKISLOlSxjAoJTw7r
         YETNckVmfQ0Dse1RrR88wnzImqcWiBFpi5Wzkjz9Jzy0NzEKU9bb/F+tdVbZXKY9iSrS
         Nx3g==
X-Forwarded-Encrypted: i=1; AFNElJ9dyPE3fegWV6HiJajdB7hF02urMf/GrhiS322YfkIOsnNH5pF/8V+ZuUhoc6iZ9AkhcVLczEKMqjVp@vger.kernel.org
X-Gm-Message-State: AOJu0YxoWokSJ5phUaJG9Zm0cDK2sOQ+1Tcemfzbo18pi5QExTa862rD
	XPsspFyhvsVA1+V+09anon2lEFvvAAPehMc1xl6WqvR7+7F4Me1DXH8STVt4TEEwiM3aeYTS/1b
	PsdwGuKk=
X-Gm-Gg: Acq92OFZ4m6gzIwfnMuWm/v+Jz8FUkwSsyceDgL1ZZzpcCP9665Sh4amUM/7oKDQT6I
	QxO4MsiBlARd5PD42NGWSjkiOfW/fJVBBZSBv3WKf98NoFBx48xjUFJuHaARnLqb6Ddq2HgXUGK
	H4j/Wg0o75EVLvdFeCx6LtK9gJcneezYvsbM4/sgktJKS3CljqRXNft13cf/ZHmYzYtU02GvJTC
	HtXiL6n3UT+8BOJoKOGVS7JGrSK6MnrMGhoR5pJ0KC2Q37qjzEKoKZLu9ymT6GhHraVIPISnbCz
	V78ipijl/ICAiBS1D7pYqsmh9MsGqoT/qOlrWa97GiI+zqbNPyxO4j4ZuSWZRX3Zl1s28KW+1Ju
	6L/bh67XBrPR9JFNy/ZszuBPubbNtDMQEw0oBtvcbzwg9U61AzAGerYMkoYP9gxau6/9ayd/EVG
	30hGJJVH83ndU+t6kP5/1LMjGXNtpUgWuvqjB2cIw7
X-Received: by 2002:a05:600c:c04f:b0:48e:8eb0:4957 with SMTP id 5b1f17b1804b1-49035f2527amr309753285e9.2.1779884826386;
        Wed, 27 May 2026 05:27:06 -0700 (PDT)
Received: from precision ([2804:7f0:6400:9a19:361f:d1db:dabe:267])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-586f25d708bsm21141385e0c.1.2026.05.27.05.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:27:05 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: fix conflicting option validation for new mount API
Date: Wed, 27 May 2026 09:26:42 -0300
Message-ID: <20260527122642.1153269-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
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

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
v1 -> v2: rebase, remove patches 2/3 and 3/3 (will be sent later), add
Fixes tag for the oldest commit only.

 fs/smb/client/fs_context.c | 102 +++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2f86158f85d7..fd4b13cd654d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -693,6 +693,41 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
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
@@ -711,19 +746,14 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
 				return -EINVAL;
 			}
 		}
-	} else {
-		if (ctx->max_channels_specified) {
-			if (ctx->max_channels > 1)
-				ctx->multichannel = true;
-			else
-				ctx->multichannel = false;
-		} else {
+	} else if (ctx->max_channels_specified) {
+		if (ctx->max_channels > 1)
+			ctx->multichannel = true;
+		else
 			ctx->multichannel = false;
-			ctx->max_channels = 1;
-		}
 	}
 
-	//resetting default values as remount doesn't initialize fs_context again
+	/* clear parse-time latches so they don't persist across remounts */
 	ctx->multichannel_specified = false;
 	ctx->max_channels_specified = false;
 
@@ -804,28 +834,23 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
-	return ret ?: smb3_handle_conflicting_options(fc);
+	return ret;
 }
 
 /*
- * Validate the preparsed information in the config.
+ * smb3_fs_context_validate - check initial-mount-only constraints:
+ * UNC presence, address resolution, dialect warnings
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
@@ -860,26 +885,6 @@ static int smb3_fs_context_validate(struct fs_context *fc)
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
 
@@ -1078,6 +1083,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (rc)
 		return rc;
 
+	rc = smb3_handle_conflicting_options(fc);
+	if (rc)
+		return rc;
+
 	old_ctx = kzalloc_obj(*old_ctx);
 	if (!old_ctx)
 		return -ENOMEM;
@@ -1933,11 +1942,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
2.54.0

