Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF18140DFD8
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728807; cv=none; b=qy8YtyT+NO78E8jIhXSEhw2106FjnHMGPUr6z16QYq5m+x7Q3tJpuYvqQKbAqx2txHe3ADzvWJ4ySlAv3S3kmqIZBiYz+bRKrNp9mrxV/GWE8JW+8K3Bggu2UScDMzSR+8AlK/5jzv+QRapgqtVTX34xx9tXD4mQC3eEdJ6Mn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728807; c=relaxed/simple;
	bh=FJvQA8MuAcOh6TW2OKa4PlnjZIpQv+MvTWNJtTa0wb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFDR93RvOMIdtzkFUod9OucVm4Skb6Ux+3WqmM4u+ujCIIM1uR603jcXmGuPXzQc5tnoV6kJ8j5ed1a1gv3Zk2nPjegYEHGOV34HeEFlw9Y3QQ+0ycDWn35qcn+0QtOh66tad4oyCclM/ZZkR42GrYtMSVCo5PfWIPN/gXbTQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHxpXfMb; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHxpXfMb"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82cf96ca071so372211b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728800; x=1776333600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDxowHKiU8yEvUkG0ExyLUfpwERX0ltYh/rUSG2zFlo=;
        b=BHxpXfMbgFU1vPFnrRihFA6mXShnKpZ0lloYAp8CYOPBOwTmQw6hG6emZyNEB1cXC5
         hJ4Ar3rtAh0MtEDxs4Nv3E7sXpuP14IXRPJHHfkdz9Y58xDzOU/0rowz7YiXltAFp7WJ
         8G7XPN3rucZ9cX2kxJaA6GrW99AXresKnqlj3jswZM2L3U9ZKDqfiDk/r+z7dPfVHFht
         TXbORxUI3eCHIvxiF5uxEHNO9RWB/FyNVx/wWPAkndB89rATfk49eSI04ZjuxEpcAkro
         a7LMoOlFKcntYnQUOTqQmJvHs+KkgQ//7XWIOSPcb2DGYBmaHCLDV80w4W9vhCa81MZQ
         +gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728800; x=1776333600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mDxowHKiU8yEvUkG0ExyLUfpwERX0ltYh/rUSG2zFlo=;
        b=hgL/+JjRiR55Xm2TRFy2KWuk3oxxEyPrnTeZQvbRCcfePAU5gNMBloGQ71ouTgqMR/
         eLQyZqZKApcnyG2+qQJodPCf9NuXyJ6lvyVnfB0fMLCJ006N+9j0D0PJXXQRhq8212by
         2wdundgC3FxdOHS9HxahpS+ZWWzAK6gpRveqatbsB7Gs8kKEQ4bgrp2x1KqIfJRpYq8a
         XMIViYX2MR+IyatcqZxlOFDwvjBR5h3zmChFzXZD72LrragcDOkLr+kgPTXhoxPKJzWT
         BzuqOLdxJ3QUCAgWMQ8kwAkI2t3+6TGnR6i+TFDpnrzKGk5AdTH+YhtAj02n3k61ti4n
         IECg==
X-Forwarded-Encrypted: i=1; AJvYcCWQTZFvov9JOYqDDbvd6eUGLvKWJiXBTmrXUxsWJj9hB/Dwb3nRp5tF76D8jqkU+CWztw8EE4v8AOLj@vger.kernel.org
X-Gm-Message-State: AOJu0YyQXgug6BDx5xbu4e+XUHWEa6fbB0cr31jQ/gY1ShVvA3sNt0cX
	UZr6xpqQKAApHzSuFZasa6gpWtbj0lUxYc+NSL2fAWC8wuBo2pY6VUXV
X-Gm-Gg: AeBDieuD1LQVDlwNMdb62L9sD3iUvmB1brnn39t55iPFchgRstRhkRYrEIOqFx/nKnm
	uik3qjldMsnszJx4bfZl/In1gVLrnWRyTQIG4M/9s1qFtx0bV8/i1Aeb5AEkLOogoLpBqIfcV/+
	8a40W42TTcOrcHsDxB5meYShyINf0WMkYbvevzyuykePtDMKtWF37l6nqYS0SaWI5Bf42Zn7Bun
	+pYPSSZBANPHuMELXDZEcZBNEQTlUdhYqIUTPeWI2+kc+g75oinDVOqSRg0OxQ635i0oW8jNceE
	pMCL2PDjgqFx7otLtbimABFEyKIC+oBr2mfdaA40jw0RxDFKqRl1JrkPjY0ONABDlBv1QWFBdNc
	8tBTAysP0mpfBwpEjbTyfsDqllImXCS1arfxMawd9Lu4SxndQdCQO4cGn8unLMQ67EnthrN1UIq
	3Po6y7Y6UuXFmTMhQ6B8CMq90pYofoY92/+ujd08NtLapB7dqlmMac62yN0tbpyMdX1sSdghJEL
	ko4viMmSGIRuGCTrqEgVTlkExaLkxyuzg==
X-Received: by 2002:a05:6a00:1acb:b0:82c:d9d0:f482 with SMTP id d2e1a72fcca58-82dd8ad4a09mr2845776b3a.46.1775728800090;
        Thu, 09 Apr 2026 03:00:00 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.02.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:59:59 -0700 (PDT)
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
Subject: [PATCH 4/9] smb: client: sync retrans on remount
Date: Thu,  9 Apr 2026 09:59:21 +0000
Message-ID: <20260409095926.905020-4-rajasimandalos@gmail.com>
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
 fs/smb/client/fs_context.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 90e83f07c870..31b82f8f7ead 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1336,6 +1336,21 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
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
+	if (ctx->retrans)
+		server->retrans = ctx->retrans;
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1475,6 +1490,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 #endif
 	if (!rc)
 		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 }
-- 
2.43.0

