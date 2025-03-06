Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C4C16130C
	for <linux-cifs@vger.kernel.org>; Thu,  6 Mar 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741283247; cv=none; b=QknWNr4wC7tXD6Ak2rVU05hSPULpA+ldbByfYz7o0rrcSS49pt+Za+DW0GgxQXHv/wQUAYHugaUWr6uL2fq27RI95Vqnnfh0NzPifNLuxnxW7XDwZbgM82Cu93lia8+HwtoC/NGmLK7AzPCBXmzeyuYVuroSZYNs7d5pdlv1/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741283247; c=relaxed/simple;
	bh=jDg90pWUVw0GUJPS3HqfWIQb+dw6LvPIIPhlJGgGe1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5/7EHCmTMekMBhSysU2tInACtzKWEN2ouxAk+Fzsjax6z4MKR26/HOZW9pVbCQao1GBN3Gjm4t0tfOP4M+dh5hmXRhXzHG4ft/uxd24JIvF9IQlXq920DT37OMKqkuytfJwYTzFmDM/TMiEybmXoZQLWFSDWazX9MfUUknTZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d/oB79OJ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/oB79OJ"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d191bfeafbso3847035ab.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Mar 2025 09:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741283245; x=1741888045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2c7f9o/6BwE2R1yaOgXadrnpj/yop8CTRDrinV7zMU=;
        b=d/oB79OJg/dhPFUuRw1gquJJi1XsS0LWdh7dH3mllN0lIpWH8tIX+deAIG87AcD5e+
         3zB/C9E7maA87tbv3ASEphKTC/qygez2TYqEFdnajWMq4wHW1cFn+xAxNZA3UtU9vUM5
         2qpws0lKNUUzHwVG+YbCPtp5VT1j5gV1fWGb5fJIlSaE5LSNFK78wkgLAY/BTyGkQyqo
         uMFPkTNHHb5AZ5t7mkP9t+2/Pu75NeKRAZLgyh7BVXkPWiIZQFXcOGgd7XK66IFUtQP4
         uc10SX1MDIyrjtGaQbWSkmEnHgaujxUlS+WKThgZpC7VdNQZsfi/xRXar/NjJ/kQGmbt
         JzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741283245; x=1741888045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2c7f9o/6BwE2R1yaOgXadrnpj/yop8CTRDrinV7zMU=;
        b=gZg3/gre5KIEuR/A9MERd/L6EuJrNwqPUyliGj0jq5T3OXp6sOUWT4ZzBiTbuY0EnB
         wAuB8+OL0ICqtREj1JgoRhXYrOnbXgB6iNtRmytXAJUIpEuQmbVO52hxS69Yw/gyF41p
         duwGyrFFnRRhI8+mRWkS4j8I+0DlHgZv9DZgOd76pQJ6DDHQa3GX7Msb0CuvEwyzvP4e
         iNkPOpSzr6NSbONY+P4ffk5CkeTqCBHN8GudUQzvbCFFVSkLv9c+rieFTeRoY1xnxprq
         AXnwZ+no8Sd8pul/YTawBzJ2fgOq4Gcud1Fh7LQx/0gfFBGz/m6eHJMu6zVivLatuPD0
         v3yA==
X-Gm-Message-State: AOJu0YywfF27sJLsP4bxnZbrpLE9XYTJzsGXaJfxpLq2l/T7depfn3S+
	Z3SYbMsQiPSRt5RM+f+ZYEdE2NTBzra2vXVnIrlKFKBF9tOgnYx/2UHVKZs8
X-Gm-Gg: ASbGncsOjJ/XbNsYBXnunZZhV/twMpUZp3ME+mpFBsmZh5XuSXNur+feZRjrPqFPNnK
	x3PyBmNSQnU/2zwPSV8oFJkpWpwi1qRswYQ9IeIG1sLBzFH3+chHeX07l25PLS8mDrJtRP5KDvH
	lPHCxe65rpv7rcGakZeWzLAbwWkuRQSDzV6ncuw4gmp+cXPG7R59OiRm66+RQ0UK1DMNXVVpzx/
	fl9RzKd7g47e3ee4cwiHI5Bx0b2K76Sd0GcnCVf/ZA7R8o1s/M35vnH7FcWPc6cZTAxXKQTv++R
	1/vVL9rCqmtydDHZqLsmgltI4Ccw1zMk94dU2Irij9S3A1EgdpvqAC2jR6BwF194H5cWVaTBClM
	6l8yazvCq3CEi8N48iemRmTd/d4F76Wg=
X-Google-Smtp-Source: AGHT+IFLRctgWlCBABHu7i3a5O0XHrcpojv7gx4H7sC4EFF/qqoyit2mSiPMk7a/wkNvR8AkGZdU0A==
X-Received: by 2002:a05:6e02:174b:b0:3a7:820c:180a with SMTP id e9e14a558f8ab-3d441a12ce3mr5764735ab.19.1741283245205;
        Thu, 06 Mar 2025 09:47:25 -0800 (PST)
Received: from linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net ([74.249.180.8])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4f209e15757sm459632173.48.2025.03.06.09.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 09:47:24 -0800 (PST)
From: aman1cifs@gmail.com
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	ronniesahlberg@gmail.com,
	bharathsm@microsoft.com,
	psachdeva@microsoft.com
Cc: Aman <aman1@microsoft.com>
Subject: [PATCH 1/2] CIFS: Propagate min offload along with other parameters from primary to secondary channels.
Date: Thu,  6 Mar 2025 17:46:43 +0000
Message-ID: <20250306174642.584848-2-aman1cifs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250214124306.498808-1-aman1cifs@gmail.com>
References: <20250214124306.498808-1-aman1cifs@gmail.com>
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
 fs/smb/client/connect.c | 1 +
 fs/smb/client/sess.c    | 7 +++++++
 2 files changed, 8 insertions(+)

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
index 91d4d409c..b4d76a37a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -522,6 +522,13 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx->echo_interval = ses->server->echo_interval / HZ;
 	ctx->max_credits = ses->server->max_credits;
+	ctx->min_offload = ses->server->min_offload;
+	ctx->compress = ses->server->compression.requested;
+	ctx->dfs_conn = ses->server->dfs_conn;
+	ctx->ignore_signature = ses->server->ignore_signature;
+	ctx->leaf_fullpath = ses->server->leaf_fullpath;
+	ctx->rootfs = ses->server->noblockcnt;
+	ctx->retrans = ses->server->retrans;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
-- 
2.43.0

