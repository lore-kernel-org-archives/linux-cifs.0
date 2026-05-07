Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778993876C3
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161505; cv=none; b=l1lmEBxACqhXTaPmFLBJCkUr1VCt2jFh4wSM+YsMIINRMFVjbzkttCJvVLGlRmad9dkN2KypY+b66kCjZfxdg9Q5en7+2WYmq1z/9wrafWZjKiQ3zRuZeZlpuHfnZauDFuVQ4px/uxqTArVxmvSWVgQpmDfzUKPOHKuKsCLsivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161505; c=relaxed/simple;
	bh=mBrIPsQn2200blVCRje5Sn1az2PJGyMV6oZGfbfx9rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJe7Ihayw1semz8oVMuAc6lLp5I58K9xjW2vMg8lUFTdidzTqt2bgn/tOu9EPNZ0oTFxoJyNUIu1MOJRGijHoPGBFzf63uJmuN8nTLf/h3gFm2NPhy3vt8W6U2bNKvksd22BPJmTteLhlMj7wDsoi7DgtSaDO32MfUCoVI0vUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r5khwji3; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r5khwji3"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-364c5317d67so869986a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161503; x=1778766303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4prNkElwy3XcOJK7RHKYQB456SeJfycmRsfTY5hl4I=;
        b=r5khwji36jPLlt8ZWiU5uLmSfCiwq6SHlxagLZVMbU+Tpnv6PZXyoyHLViwzsVj1Lq
         5z5aApfq/ZAq6STkVb/Wy6UqBYVBPJrm9VRHgkArH4fIfjk36txqTcqEO4LYeYn6q7VJ
         O3S8a4xuAceAUTt/Yv3r47sHTanO3jRpRaXyaM/Js4pwRxqf5NxSPdsbwFdKEf8gr1nu
         WnERWrMQVpKUb+ub+hIuh9qNjdKfeKfC5sMcCkoyPZpnQeRxfW8QoPICT/ezvIk5yQ9B
         4o4EDKBS5aYwItlSvMW6q4HFOYVv4iwB43vYLsu+6HTrL6VllpNLAKXJ3Y0gKCVRhyEz
         MTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161503; x=1778766303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G4prNkElwy3XcOJK7RHKYQB456SeJfycmRsfTY5hl4I=;
        b=DIsBgVUZsc2Jo8H6lxlCLN+aECbm0mF/4EpcUsu7JZFpRNCe6U+cojhxL0znnOpxwJ
         Qg8iyVR1K6KgkcZWdYIlEDCJriVgcyuk3Y72pKr+e14KPj2+ZzBuN2CMSeEMs/NZh7Jc
         m83jOv3VU+b9yqttsZ2dsUOO8u6FbT1M1KMvs0QuIJYOxFqAzoOrBnI7nyPd4Ksh6COi
         vwKO5mFN0gN+reJ1GlVJbIfyKCR42ScbqDyZT+2iYHEyU+2Z0BXXzV4kPXlsklF0QnmR
         x2U02ZNBYaxCyIANqtue7HJku/N6bl48BGhtSpsalbpXIFC6gy5XXRexIGOnZajiCNSV
         CJ+g==
X-Gm-Message-State: AOJu0Yxm2r0KqSb6syXEqY0K5lWacUQYCZmwEGUVdz4Ckfd2RqVbbVCL
	KBnZQQxo1JKxhfSUjY0hiR2j34/GdLIgYCozhwbAP6jpgj/wKkTW+GVNaHhXRw==
X-Gm-Gg: AeBDietr4PbUeY8MHVexZ0OJtVl3w5d4LC20p0vZ5nGisdPj7pFpvVb1vL26XSwgNPB
	9PTwlGGPt0/PB6yfcRhxBsX3CvTbxcDZrgd5ffFBouWgGuy3q+Rfrk2DwtSRTCB34qUd9N4ysFH
	6i16DobXWpHg3znQshVqyF+yfOjp8X6pG5etv+MwoNcYY8Aw3JbHq2hwo92UiVs+QI2NNg9K/VT
	NVxvfsTDZ1VaSszDUj1UD7zopuaxHvzL67vXBvd1HoviBgpZN956+DsJ9w3TmSvoQ4n6OBQD6EO
	vhIIi7RZnQFSEm9Nhy+OXelr01XMMa8iCnmCphfnn8lch060s1jVVw+5HiDAhWlQ36X8Urx2vjZ
	jsKYlSx/11gpEvbqqXbR8wfyn08FvwP5p0UdQTR4j16hVii91q8p/prJNA520AJtUHkPq9BLZ5F
	uA+Kf+nRThQOYLcmgxogV7dBAPTUOpKv8KKHMFid0a5Y5j6Sfbbu1p2ABo21ZUiw7YVyEku1owr
	pttfwsnCGSrKwz4tAsGekvnI1/586BtPg==
X-Received: by 2002:a17:90b:3c42:b0:35c:30a8:330 with SMTP id 98e67ed59e1d1-365aa73d260mr8680130a91.0.1778161503150;
        Thu, 07 May 2026 06:45:03 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:02 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 3/8] smb: client: sync retrans on remount
Date: Thu,  7 May 2026 13:44:43 +0000
Message-ID: <20260507134448.168602-4-rajasimandalos@gmail.com>
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

The retrans mount option controls how many times the client retries
sending a request before giving up.  Although remount already stored
the new value in cifs_sb->ctx, it was never propagated to
server->retrans, so the running connection kept using the old count.

Introduce smb3_sync_server_opts() to push ctx options that live on
TCP_Server_Info into the live server struct after a successful
remount.  For now it handles retrans; subsequent patches will extend
it to other server-level knobs.

The assignment is guarded (if ctx->retrans) so that a bare
'mount -o remount' (which re-parses /proc/mounts and gets
retrans=0 because cifs_show_options does not print it) does not
accidentally reset the value to zero.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 20c17f7cbbf8..de682a5d2b68 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1296,6 +1296,23 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 }
 
+/*
+ * Synchronize server-level options that are stored on TCP_Server_Info
+ * at mount time.  These fields are consulted at runtime (retry logic)
+ * so remount needs to update the live server struct in addition to
+ * cifs_sb->ctx.
+ */
+static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
+{
+	struct TCP_Server_Info *server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	spin_lock(&server->srv_lock);
+	if (ctx->retrans)
+		server->retrans = ctx->retrans;
+	spin_unlock(&server->srv_lock);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1431,6 +1448,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 #endif
 	if (!rc)
 		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 }
-- 
2.43.0

