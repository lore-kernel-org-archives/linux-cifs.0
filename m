Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689FF263F25
	for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739537011; cv=none; b=Mq8th6xGiA4cHJOrT7t9iveLZUFM1l+e5kbw1oDlSpC1Jral1FWZ6dI/VYJ5I2dJCl8Nj61qb5+wnZOIc9QWTckqEfw/H6QEc82TBdpPShMkGWI9lv+35OCvB7WDgf4fi+vBUXoUhwHcswlzZAMBn0JlNPZvv+UHPI/mXJ0TGcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739537011; c=relaxed/simple;
	bh=MZ+VdqlRD6k15vCaswscsbYcvyxtTvj5vR/ZpiGv3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ez/r0YduJtPqIt/czhNsJXkETjVJbq86nGJeAM//7NHa4LOnydU9E49Ndv2vjrqjiI7QS2h6uSevZs6alhF5Duy/Ahj9q4rVTtwaxGrp285ve2bo8WOrRmL2vsWm+BhsadTiIdIa4enMf35qFReWLZWdfMsyEum7A+pJv2eZTrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFPojC+P; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFPojC+P"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d19d214f0aso5385125ab.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 04:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739537009; x=1740141809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yEv0BAIFY+ZXCq6s+ViTi0GSgjctCzh7oVYkrs6HivQ=;
        b=eFPojC+Pm4aVDp+kY1rJuBQUlLjnp9zI3utxi5wv7O38LKtI0BOWT33V9lEfs4Fmvj
         5Lh7FusKDnragwykkbC8/Gb7MN6CoxhyKxSBbbn5Ytxl3bMgHLtwPILohgJhh/Cinu6F
         qwI9S3WJRtb3YxW/X2xwpZ4Qi25o5MDAlWWHYCAlzAfy0OaSOYCuCT3fcD7qlNYjiShj
         6WMZG273IvCUYIm9pCG5mn3ggUdLYgTRQm4PLbil0Ea2gJ6c5CoVDfGt9qQfvEwF4USK
         yGDP288TeLoDNFKRgWdHceTkgq1fHPuW0gTqWJuZvbFX5ES1jYqziNUiNrC9EnemN05X
         9w+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739537009; x=1740141809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yEv0BAIFY+ZXCq6s+ViTi0GSgjctCzh7oVYkrs6HivQ=;
        b=MBY37orbsZkHgpsTMk+WakmGB76FxhIJxaxdZBOlDFXun1QWV/ZEBqiUdfQvPe5y0i
         /8GsV7bab3ZwImdk054s6UiLo5IcNdbUTxsTMd+m/8Q5j/gHsJsYKBG5FUHtN3wcLZMX
         XKgEMJ0ZR9AMAsMq2BZrctTKba4m5dQfWr0lCeJXsHbDqnvHH8gYhQPmG2+ms6JrhKJF
         hycry491kRgu2vYJoeIOewS5in0MxI9N1++V/8oXzYasgYryTdSqb12A9CQsXav+Y5Qt
         MyD5uHCPGR/yLjuFT7ifLjk7Gs5PtbZ6YRtQA99QQ5a+QcSllAin2pIWWQJ6RnTnZLdi
         s7pw==
X-Gm-Message-State: AOJu0YyllThmz4Wnz7itPdwYEbbrm1NDujzAwfDz+yAvj9mCIAC60oWz
	HdgnCQtz3Yz5EdCdsMeUZFjm0EIy2k8gy0jgwd3luwgJzdmTLVnmrmV6F37A
X-Gm-Gg: ASbGncvgglxgZ5fiQ0Hz5xlLp7C7rm6/9s8saoSC9E432kQb979pAryCYbThVbp45oa
	PQhgDfJzZJNUDD8TUO2nT4tP7SE21XMzVVXkzChIRYZQ1JvgaYT1FsUltV7MUq6dN2hClzyA4ck
	oAV07c3VfGeIb6lFo9YuEMXnwZ4TtkrC6jKhtwDHgmpIwCzzvhR0EuKZ20sQ3oKZad4pjYf96Bv
	+TxljCE/COERHfzIplCl+3pg7Jl+yQfjslfptSAKCZJmrNpL+RwEWW4GwSu98j+ZCsIP1pfeJ8V
	Kmn3aRIP3/3Ni23eL97Sc/ZNQkGh4fbek8G+lto/WJDjJhNcH8M1VgLTnWtx/TlHJLv+93TGehH
	6aQ==
X-Google-Smtp-Source: AGHT+IEWoU0PXeglFWcNK60ktFp3o3vr18N3sFiTM6OYSCot4cZkAfufNtJFMVFXBu2g2BSO6io1FQ==
X-Received: by 2002:a05:6e02:1fc9:b0:3d0:fe8:607e with SMTP id e9e14a558f8ab-3d17bfddde8mr83510835ab.14.1739537009331;
        Fri, 14 Feb 2025 04:43:29 -0800 (PST)
Received: from linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net ([74.249.180.8])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4ed281487c5sm795162173.13.2025.02.14.04.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 04:43:29 -0800 (PST)
From: aman1cifs@gmail.com
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	ronniesahlberg@gmail.com,
	bharathsm@microsoft.com
Cc: Aman <aman1@microsoft.com>
Subject: [PATCH 1/2] CIFS: Propagate min offload along with other parameters from primary to secondary channels.
Date: Fri, 14 Feb 2025 12:43:05 +0000
Message-ID: <20250214124306.498808-1-aman1cifs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aman <aman1@microsoft.com>

In a multichannel setup, it was observed that a few fields were not being
copied over to the secondary channels, which impacted performance in cases
where these options were relevant but not properly synchronized. To address
this, this patch introduces copying the following parameters from the
primary channel to the secondary channels:

- min_offload
- compression.requested
- dfs_conn
- ignore_signature
- leaf_fullpath
- noblockcnt
- retrans
- sign

By copying these parameters, we ensure consistency across channels and
prevent performance degradation due to missing or outdated settings.

Signed-off-by: Aman <aman1@microsoft.com>
---
 fs/smb/client/connect.c |  1 +
 fs/smb/client/sess.c    | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index eaa6be445..eb82458eb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1721,6 +1721,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	/* Grab netns reference for this server. */
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
 
+	tcp_ses->sign = ctx->sign;
 	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
 	tcp_ses->noblockcnt = ctx->rootfs;
 	tcp_ses->noblocksnd = ctx->noblocksnd || ctx->rootfs;
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 91d4d409c..fdbd32a13 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -522,6 +522,16 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx->echo_interval = ses->server->echo_interval / HZ;
 	ctx->max_credits = ses->server->max_credits;
+	ctx->min_offload = ses->server->min_offload;
+	ctx->compress = ses->server->compression.requested;
+	ctx->dfs_conn = ses->server->dfs_conn;
+	ctx->ignore_signature = ses->server->ignore_signature;
+
+	if (ses->server->leaf_fullpath)
+		ctx->leaf_fullpath = kstrdup(ses->server->leaf_fullpath, GFP_KERNEL);
+
+	ctx->rootfs = ses->server->noblockcnt;
+	ctx->retrans = ses->server->retrans;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
-- 
2.43.0

