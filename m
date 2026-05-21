Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529103EF0D7
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371694; cv=none; b=m4c/EX6oFK2VERv85HQ8+jjsbvw0IdJe9XpLF1x94d/up/NsmE7/D/E91rOL3txU/lP4CxmV+pHiv1c78Ngg59q1vWaoKdfhHSq01lyDdkiBVsZGHBYmK6ZzGNGK4DIAGZCpTkMEdvZCWhiXMeIKC5Gx4GS+FRDGPnBJhYtEifI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371694; c=relaxed/simple;
	bh=1FqrHpDAtvMFciyscnGdOj53H/dJ7yRt3uoRsX/mHfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehE9bMB3CcgEGykQJPANCayi/QLyhNfyfjT5qjvJTmFFgMv+xv8lx58Pm6kuJHhpVeVbCv76u6MHZrY3AGWTubPNHYwsDAOYk+ki1JkKp46tWnQxIbliJmBAFXHt5zr3Uwrmd6C/e/ntwNz6bSDDfyddhjs5vQqcB66ENLV83jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhOITMp9; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhOITMp9"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c80291e6237so4534605a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371693; x=1779976493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEBcGirH2p8qZvg9q6NAt3qPrbqwcSbM2/Hf655L6Fc=;
        b=mhOITMp9S6fKsWAVQex691uLQ3xaI+YuD5laTwUkJ6OkXnRIRIK6pB5raQb4QfxJ+R
         MXFQJg9HBZ9vPeOkPfGRImCDo5aexypsmfZMSTjIXHF0PJLsvtvEEeBK1u1P1ka4aika
         TsJAvcyu2Zu1zp9nnoh7hFugIiy+q1v4Da9akoE4ehZLqk/aChKgr7VPYH8DSaUy8PpA
         6kdbQqXmZ2fjyh1PTtC/NdY4tbH3B2ECGRDMD/0W3DLFSk04Q9attN9x10Nh0MQy938Q
         lF0PqwzsknhB/jro4fQizCrmZDqVwXAdrGJ+k0A5TEGT8p2UQC1r2Zk9wmi5WMd9aY9w
         hdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371693; x=1779976493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NEBcGirH2p8qZvg9q6NAt3qPrbqwcSbM2/Hf655L6Fc=;
        b=q3i8rPAtfWHTtxPDcFO3XtnVcykw5P91WDJ1lXD3yh7liQo6UbohD6ipKRFcaHIFCF
         mazUkFm/lliwNX9bM6kQDDuWZFsvtoll5NcbhlrnEea/Ku2ShtSslbROJSNJMqRn6/6i
         exQ3a6rcM2YGC1BMSPLw8TaPs5G0mfNje5iBcGOUOeNEHZWmqQxZRopKdlvie/GKP27E
         Jj81Yke86wyIcNyWwezlw9ciZ3xniNnLwQimRpZCHBprzmre5j8LgMBIXB/Pco3WC1Hw
         B+Bd9vEngkfdof2fLtv4NsBbBos8YQsdJ+7FItNFufC6lHJeGRBmJQQeL9VK1rhkpTya
         gUhA==
X-Gm-Message-State: AOJu0YxHTnXK9enobE7+0DIZVpYrWsVJYmRIW1FIzKiAf3Jljze4ylBJ
	DG5UFeLwZbJ3BC87casAvB2wbIThERM+O+xoN+ZIAHZ+Mhmmi4v+FVuh
X-Gm-Gg: Acq92OG49nEoRMeu9QbNie2d/owrdIo0SGIMRhFtdIc/bw9rvW+Elunrd49r8B2NXlO
	8bTZ9CgSZS9FG9xNp2SyrPWbS8oK+vL3aa921SdcG42CGcycrQGLBZfOsbUGnBCNwReH0DDtmAe
	0UIJezeDV5X47Mu1S+4wCO5xEBBHUkbwlZULM09cWoH/CPXglXthNrFSALpSOWQ8IBMeDHTaXgS
	qwdZQo8cRG554j/UPinf212kLJn9npZDYsGQB+xTb1QIYsStJSGbrWPC9dZHTxFuy4sUYHKfMU2
	Im2lI6JGPaIV6kJxa15ckzYN4/ZX2OxQE+yYde3lEAQ4KMQJWFK+u3xy1BJNTUQWBc58jkQq9PM
	Wrv8Zw54+hK0P+aEo8ipAAokwwseQQPaSoXDnAjTUdUG/A0Fx/4PsUGCKhDYVsLW0qI2fbV0w80
	IqXAIC1XEP2heowVE8Wrl4ZxV7zdJV0sQiCzize6sdBLpGqLXKY5D0wTtdubXe+8JVfS6IQBQTA
	eBA6sqzd2hjrccjvazkS8YrA3SzAhwVBg==
X-Received: by 2002:a05:6a21:338c:b0:3a2:dabf:fef9 with SMTP id adf61e73a8af0-3b30878ecf2mr3789760637.27.1779371692780;
        Thu, 21 May 2026 06:54:52 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:52 -0700 (PDT)
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
Subject: [PATCH v3 4/9] smb: client: sync retrans on remount
Date: Thu, 21 May 2026 13:54:10 +0000
Message-ID: <1611febb63ba5ac318fcb8b3faa1aa68fcefa873.1779371115.git.rajasimandal@microsoft.com>
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
index f92c1cb274a6..903b4060d5d0 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1305,6 +1305,23 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
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
@@ -1474,6 +1491,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 #endif
 	if (!rc)
 		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 
-- 
2.43.0

