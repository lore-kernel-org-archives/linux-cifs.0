Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC3331327A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 02:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763432876; cv=none; b=Yx8WwJlYackClLLSAbPT10IQjgsaMflZjsm+eZG4/9TE02edUFIQ2pz92PwVcD3CuVhF+DTw52eAEwYzDw7WfP8Mh9GRCQqyNLdrxJJj2pNZwvEjEoKuU9tIQGlOp4hVGU7nRuEJ24mlVivcalORx0snVHcPQzCIq075AU84j+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763432876; c=relaxed/simple;
	bh=Pypc31j7e6WzTBARjBckj9L4hLk7f5FPu0IKuFpsR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nat+++mjZY65ERIMUfLThki1rbva6aY+14nA6b7Ic5RhqHzRoLv2LiODO25oMErzK+Fj5SzGoy5qf+Sd02fhrhc2cBX3EOevwgRX4AvpiZZG163+RfwmGlZXH6+FrPUaFW1qyfIUbg8T2SWVl0ra+h7qM3ufkXTAGLqdHmpFbYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEZ0FG4I; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEZ0FG4I"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29555b384acso51023405ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 18:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763432875; x=1764037675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUeRTgtvZX5xIfYESgNI5CfhH9TmmJjF3mJVIzLoI7M=;
        b=XEZ0FG4I4s+zynMyUVhmidOOzu+lvj2IRjBnjR2Kg6wjxsrMtevPWiPTJL94dDvo98
         vM9EYBLcfpcF1Xa1mmyrlsbzmwEP0nSvmA4kXDnYcnj0aD7ywo7bsOdMMIGR+VKMpsMP
         VoRelZX9kPczIRJLJrAFFQWK1MvN243xbN95FCZg8V9hAC+OISqK9CFjNq7aNmKCEBCk
         p8spcOt6mkn2qZiX070xDPluIcFzDmROTuOtlhGvgLm3Z6UoGqREriiG2SPBaa6SxV37
         iqUk+PqnH9SkRBxSGjtVU9zhcUsfSrtlnXXWz4UxzJAML9YB8N55bYN5TRbPdTC9mynN
         u90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432875; x=1764037675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eUeRTgtvZX5xIfYESgNI5CfhH9TmmJjF3mJVIzLoI7M=;
        b=Sz97VJATeOhJuwEyVQvzGcp60ZV6awI7SLC7/enHwh34Oj+Rg//oF/q/LgnehtDUJZ
         5cprIkuXb29EDesod7Mtnyx7m2ElVGTeIvB8b2aFLxnsafrX0NXm/5effcX2RAbEJt6x
         jDyoQfq1izWKn2lfIlHTGNdpbr6hUaK2Jtfm86VQS6TuINdf9oF8nlLQ6JTD347VXvVg
         WNgUW/buH6G6E4KwYWXrvGPuO24khv03sPuSRSSkETXJOO98krQhg2gTxnX4r7mOFx1C
         r/zpL/J6cN5bpmB5dEDyrk/R16CcpPu0YQKyfOaci9QTKIqr43DUXwfxl1XVOqpEWyAg
         PG3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXW2ZE3WugBiQvE/4FFZ0qxUe3Qgt1PmrVyJLG1tufuBmP32bifg+BHJrJjHWrHdtVdtF6EadA1er3Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo274JpCXl292K+Vd1OoeFMVSbMoFPqfIykWjgxYtmxn64IwGW
	hjXu7krogb1PSHmYGtaxnq1reu582rnV/cmPTtYWSuRCcpIA4UKZBiTY
X-Gm-Gg: ASbGncse7L4U+v1zHBN2Wsa4LQo9JJ7rm5165XvsKAoaN1OGhb5CiEltyWToP45U4Fr
	aWDwzH8cZh3JYWeZu3jdnRyWY9+NK97KyqAMNEFLvqgms/q7KR2hCxFnos6pdSCxr3E6Sphc76M
	NRXD7XUhL82au3lVSHLBdPUg6KJ1bJOp/NDLt3JWI7VAIXk3scxblcehD4PekygCDMeNnYYTZLf
	scc6VKwHx/ulKBh+QHOG6TFgTBghK53Abv0tN2ts6cR3B1G6IvLCc9Tl5XBrH/MBlGmpRfysYxN
	PU0JgDeWlduMXSel+OJ/s2JM4VGjSPH7ZmzN2ZbvuLEtnAKSpjuu4HEEOvSXkSHigoCU1lTiERP
	t3xZr38dVe+cmONbBD7LrPeHfDQim/DW/RUUZpnohJ5DfpX5MzNUDGiW7KgP2TzcPIYTCB2FdAJ
	uCgNXuNCsjuXLNrkZtH1FZSlEY92oZRDVKu4uY0bmn39qCN1VOmQCZZybPfpPPzVZPhiHO+wNGv
	u+wFZg=
X-Google-Smtp-Source: AGHT+IF4kSAjfwknCVM4USZhMERLBGdwXplWAHKQAlRqecUdLezqzo6LAYFe/hkB2X7tS7mhxTfn9w==
X-Received: by 2002:a17:902:cf03:b0:298:46a9:df01 with SMTP id d9443c01a7336-2986a6b8911mr202325475ad.3.1763432874583;
        Mon, 17 Nov 2025 18:27:54 -0800 (PST)
Received: from linuxbackup1-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([4.247.136.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c23849esm153170975ad.5.2025.11.17.18.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:27:54 -0800 (PST)
From: Rajasi Mandal <rajasimandalos@gmail.com>
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH] cifs: client: enforce consistent handling of multichannel and max_channels
Date: Tue, 18 Nov 2025 02:26:55 +0000
Message-ID: <20251118022655.126994-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118022655.126994-1-rajasimandalos@gmail.com>
References: <20251118022655.126994-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Previously, the behavior of the multichannel and max_channels mount
options was inconsistent and order-dependent. For example, specifying
"multichannel,max_channels=1" would result in 2 channels, while
"max_channels=1,multichannel" would result in 1 channel. Additionally,
conflicting combinations such as "nomultichannel,max_channels=3" or
"multichannel,max_channels=1" did not produce errors and could lead to
unexpected channel counts.

This commit introduces two new fields in smb3_fs_context to explicitly
track whether multichannel and max_channels were specified during
mount. The option parsing and validation logic is updated to ensure:
- The outcome is no longer dependent on the order of options.
- Conflicting combinations (e.g., "nomultichannel,max_channels=3" or
  "multichannel,max_channels=1") are detected and result in an error.
- The number of channels created is consistent with the specified
  options.

This improves the reliability and predictability of mount option
handling for SMB3 multichannel support.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifsfs.c     |  1 -
 fs/smb/client/fs_context.c | 65 ++++++++++++++++++++++++++++----------
 fs/smb/client/fs_context.h |  2 ++
 3 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 185ac41bd7e9..4d53ec53d8db 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1016,7 +1016,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	} else {
 		cifs_info("Attempting to mount %s\n", old_ctx->source);
 	}
-
 	cifs_sb = kzalloc(sizeof(*cifs_sb), GFP_KERNEL);
 	if (!cifs_sb)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 46d1eaae62da..1794a31541fe 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -711,6 +711,47 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	return 0;
 }
 
+static int smb3_handle_conflicting_options(struct fs_context *fc)
+{
+	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+
+	if (ctx->multichannel_specified) {
+		if (ctx->multichannel) {
+			if (!ctx->max_channels_specified) {
+				ctx->max_channels = 2;
+			} else if (ctx->max_channels == 1) {
+				cifs_errorf(fc,
+					    "max_channels must be greater than 1 when multichannel is enabled\n");
+				return -EINVAL;
+			}
+		} else {
+			if (!ctx->max_channels_specified) {
+				ctx->max_channels = 1;
+			} else if (ctx->max_channels > 1) {
+				cifs_errorf(fc,
+					    "max_channels must be equal to 1 when multichannel is disabled\n");
+				return -EINVAL;
+			}
+		}
+	} else {
+		if (ctx->max_channels_specified) {
+			if (ctx->max_channels > 1)
+				ctx->multichannel = true;
+			else
+				ctx->multichannel = false;
+		} else {
+			ctx->multichannel = false;
+			ctx->max_channels = 1;
+		}
+	}
+
+	//resetting default values as remount doesn't initialize fs_context again
+	ctx->multichannel_specified = false;
+	ctx->max_channels_specified = false;
+
+	return 0;
+}
+
 static void smb3_fs_context_free(struct fs_context *fc);
 static int smb3_fs_context_parse_param(struct fs_context *fc,
 				       struct fs_parameter *param);
@@ -785,6 +826,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
+	ret = smb3_handle_conflicting_options(fc);
 
 	return ret;
 }
@@ -1296,15 +1338,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->nodelete = 1;
 		break;
 	case Opt_multichannel:
-		if (result.negated) {
+		ctx->multichannel_specified = true;
+		if (result.negated)
 			ctx->multichannel = false;
-			ctx->max_channels = 1;
-		} else {
+		else
 			ctx->multichannel = true;
-			/* if number of channels not specified, default to 2 */
-			if (ctx->max_channels < 2)
-				ctx->max_channels = 2;
-		}
 		break;
 	case Opt_uid:
 		ctx->linux_uid = result.uid;
@@ -1440,15 +1478,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->max_credits = result.uint_32;
 		break;
 	case Opt_max_channels:
+		ctx->max_channels_specified = true;
 		if (result.uint_32 < 1 || result.uint_32 > CIFS_MAX_CHANNELS) {
 			cifs_errorf(fc, "%s: Invalid max_channels value, needs to be 1-%d\n",
 				 __func__, CIFS_MAX_CHANNELS);
 			goto cifs_parse_mount_err;
 		}
 		ctx->max_channels = result.uint_32;
-		/* If more than one channel requested ... they want multichan */
-		if (result.uint_32 > 1)
-			ctx->multichannel = true;
 		break;
 	case Opt_max_cached_dirs:
 		if (result.uint_32 < 1) {
@@ -1866,13 +1902,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		goto cifs_parse_mount_err;
 	}
 
-	/*
-	 * Multichannel is not meaningful if max_channels is 1.
-	 * Force multichannel to false to ensure consistent configuration.
-	 */
-	if (ctx->multichannel && ctx->max_channels == 1)
-		ctx->multichannel = false;
-
 	return 0;
 
  cifs_parse_mount_err:
@@ -1955,6 +1984,8 @@ int smb3_init_fs_context(struct fs_context *fc)
 
 	/* default to no multichannel (single server connection) */
 	ctx->multichannel = false;
+	ctx->multichannel_specified = false;
+	ctx->max_channels_specified = false;
 	ctx->max_channels = 1;
 
 	ctx->backupuid_specified = false; /* no backup intent for a user */
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index b0fec6b9a23b..7af7cbbe4208 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -294,6 +294,8 @@ struct smb3_fs_context {
 	bool domainauto:1;
 	bool rdma:1;
 	bool multichannel:1;
+	bool multichannel_specified:1; /* true if user specified multichannel or nomultichannel */
+	bool max_channels_specified:1; /* true if user specified max_channels */
 	bool use_client_guid:1;
 	/* reuse existing guid for multichannel */
 	u8 client_guid[SMB2_CLIENT_GUID_SIZE];
-- 
2.43.0

