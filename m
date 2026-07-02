Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4746B3F23CF
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992158; cv=none; b=kbCheSDW/wSBsju/bPnJRS7aNjizs2ivZY0p1Q+V+bQ+vmMRc8Vhs+SmDi/pSdeIMkZll1DEgU2MdFeC7qzqoQTxov+Q+8QgQ5k31VJYMIjdjn3cScP37Zf53SljqmdT33SZvixk4++J+FBnSfeBQrUJyqm0ZEpi4TDugcLb7C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992158; c=relaxed/simple;
	bh=nhK5erLPMld59NqJFTXEr32ELobTHwtHREBLVNCVBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQij1RkFAVgGta1Pw1o8cCOTMQnSmWLee3zeWv3zieFoFCDM7bxlh3kkFRyjRghEotDGlJS9Vt8UmznEfABf908xfgx7E3/I0BUeKp2hcYeRifH7MYOe/HjDaCPrFJM5HBWRg/YuVxNt7QQeLbP2iSkMkw9kvUkT/UxySUS02DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkJ+QW93; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkJ+QW93"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38060005f1cso398272a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992150; x=1783596950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2WHE69XCvPsuob7aME3t/R6BnMk/X5IWMhOHC9uOQw=;
        b=YkJ+QW93JVZ+rHR6UWlT/x7xyGz4d23Q51EGUL23G716nF5WysrnG+z9kt1/m51AEi
         Fp4zCTNVqsCYLc6exKaYyV5NsVlyjF/Wl9WwnLsS1ajFAZPmcv6F3mNyPAIMdp8XeQdV
         PgK67BX3MSZX9LsSwUxBQyhItLDNIxzSVhxLWYoIzHgIwQ1zHjBDUqHLMfa5YSBkvfRX
         5W58XarpQHO/kXeAkctmsIYdxBwuTJ+tD12lrorbvgHdx/TTbhK48qRFDOEGZsqqI4MI
         RNombBG89VY8m6o7OaV+Y9xFg6sQgw+LY5FS10MBguv6R10IyIrrp7ud4cKg7htuN93A
         fOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992150; x=1783596950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a2WHE69XCvPsuob7aME3t/R6BnMk/X5IWMhOHC9uOQw=;
        b=o1c5i2BL3/t/fzGBdCPQKMx0fsXEMjuYg1lQCxCbtgN/p4OMVCuK7rVAgbzCzjvexl
         2L7KdN86OaKcdENYj9io7WsOLPknIs3dEa+EgpSy5CL5Pqfdq6d/wUcprMjBsxzo33ol
         ReEuOUW6q87ip9rqzb0CDCfuqaffX7y/1cvCHgNltlIL/tQ4itE4Ke+nhVJ+zQRHWxSL
         WGqaUIgxUpQV3hc1YWVyizJJknQK24Vj8RCjonyhIRbslop8/f9nGDKF4cF3mNAQ6T4L
         0pt/QLim0zCy/WqXU1HeV1cw8c/fAljVcJOFu8Hcto3AeohBJ2bA7S9Gefi0cPTPpUP/
         Lgow==
X-Gm-Message-State: AOJu0YwCfjauXjb8AENvh5ru862hYfDMThI/BSjJvQSd24cS6F2vVniR
	k1R5dtNvwsD4LZ5j31Cfcfw7NlFkZpszknW3j1cYk+mcGqFTtZMkCMjyB9ClCw==
X-Gm-Gg: AfdE7clkMO6k23AvnYAwGd8kD55wDAnojGadNdiA9abLSG/NpmCw4dx4iojYxHJI246
	m3w+7gzb/4APkc9JW3pp71j1lcHb68YYuT76yCXwq+GDU36LmZv9R6Lm68tdJZQpQHE2OgzPtkO
	vMOFSLwmoQqI56Oqz5J4Lvt9mGolqvT/AO9ksKkvUkchebNLq0ScFZoAWtvW2k4ZBfqGPh2wE5G
	JQLv9k0ID19la3yQq03g+lUYPbHbxqAbNuQWo8TfrVOrkj6KGoJtZ1ifbXjhZRuzrrYT8bXtz1G
	enF7e7PCG0ubsPo/XqQMNKKGVPnjj8JxYpN2Ppswu7jPhb7JjvpcYprhLhHT4IIwIYkPYh7AieP
	GKj7OEtDgAJ9/tPrUOf/84IvHkV7ozaIft0rwZ690dzGWDRY9KrBsbrfQ4RJjzS5uxrA5uWqEKG
	lGecjZUv5W4wDtU0NLVfmynSlolSafx2AFe8JfD6rCW9LaKSEvUfl/ZAHk86Pzw1yIDsVzYU97+
	IFCuQGJDJha
X-Received: by 2002:a17:90b:17d1:b0:36b:4d63:4a93 with SMTP id 98e67ed59e1d1-38069c54d60mr9019401a91.13.1782992150091;
        Thu, 02 Jul 2026 04:35:50 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:49 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 3/9] smb: client: sync retrans on remount
Date: Thu,  2 Jul 2026 11:35:29 +0000
Message-ID: <20260702113535.4044308-4-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
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

The previous patch in this series ("smb: client: sync runtime state
into ctx on reconfigure") duplicates the existing context on remount,
so a bare 'mount -o remount' carries the old retrans value forward and
the parser only overwrites it when the user explicitly passes
retrans=N.  No special-casing for the bare-remount /proc/mounts replay
is therefore needed; in particular, an explicit retrans=0 from the
user now correctly resets the value to the compile-time default.

Writes to server->retrans are unsynchronized to match the existing
convention: every other reader of the field (smb2ops.c retry path,
cifs_show_options(), the original cifs_get_tcp_session() writer) does
not take server->srv_lock, and match_server() only reads it under
srv_lock as part of the larger match function.

Note that retrans lives on TCP_Server_Info and is therefore shared
across all mounts to the same server; reconfiguring one mount updates
the value seen by every other mount sharing the connection.  This is
consistent with the existing semantics: cifs_show_options() already
reads server->retrans for /proc/mounts on every mount, and the
runtime retry path always uses the server's value rather than any
per-mount copy.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d5a7d4dd402b..bfbea0648f6a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1278,6 +1278,24 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Synchronize server-level options that are stored on TCP_Server_Info
+ * at mount time.  These fields are consulted at runtime (retry logic)
+ * so remount needs to update the live server struct in addition to
+ * cifs_sb->ctx.  Note these live on TCP_Server_Info and are therefore
+ * shared across all mounts to the same server; reconfiguring one mount
+ * updates the value seen by every other mount sharing the connection,
+ * matching how cifs_show_options() and the runtime retry path already
+ * read them unsynchronized from the server struct.
+ */
+static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
+{
+	struct TCP_Server_Info *server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	server->retrans = ctx->retrans;
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1447,6 +1465,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 
-- 
2.43.0

