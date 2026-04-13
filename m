Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533CA3B6BE8
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107483; cv=none; b=pazH79GaMGW77WmsLrCKfQvflVE+1u3fNVJou1cRalfP4H83b+XNyFTYObUfJckPd4reG6zUxqUTPduLEbpfA6Y8FpJ4QcotL2BGg2MDeu6GPlIrpwnxbQ3Hoyl8dRYqD/T4ztr3Q8AUV7DXoz0GGwxvrQ4vpDdABcUn0+hyEXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107483; c=relaxed/simple;
	bh=E2hjxYStm3aD6IMH0x56H1eA9O7MIAYApbvv/cTbWNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bTNHMnUIvS1XuYT8dSC3joY1i4sLBCfsukO3Qb7AgNYp0R+qnI332Dpgp6y3J8VVH2Pxq8j6bKaGq4S8fR5phrRGZRheWaxjlfVEhN35Y4jOJDbKIfCkjicHMlhZO8NL5cTxpF/nxKljy/mjWUD3a76W/x4Y69yq/GfCMaiVxqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OUXumIF8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OUXumIF8"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488afb0427eso59687455e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 12:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776107481; x=1776712281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fXWGSvkFU16FgOFRkCaaPZi61w++nh88NCvP7Zfs+t0=;
        b=OUXumIF8AX3lCnvtPOWN1pLHMorUFBkYKEcjLV69DTQNZDtECiiWfMJ6MRk3VLpqYE
         0ojH3vi4S6K7VUX4R3B8rwKUQQs4HMuHUvp9Em6QRI4SO0zth1JEmdTUhsU60XZgVW7f
         ZVRD5HNHreH+NKT9pfq2kKnIrUylru0MCIi3tZfOuyhL3GFK3glTZfxh2Qtl3GLv/wfK
         7qfTX6Fh7/6vXCDAf/0Xaz1G1KDmAjnhN6AMsTDJWe43PXOo/C5NDU5XG//sgV5NxCwj
         EV1jiOPWDAywFgskNDhDJDmarPU9N3Eef0Mfe1YME4LMPRMa0yNurpow/Hv4B7PgEF9H
         A8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776107481; x=1776712281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXWGSvkFU16FgOFRkCaaPZi61w++nh88NCvP7Zfs+t0=;
        b=Ltu6vlavJRmCfymR47CuvKf60Y9b0dLxUf7oa6jOrDzPTmqTpbeVR1ljgy2nhZNpZF
         tFkDf3DsEEHd1akIIHCykyXOWGGTiHM0JSimZ785WL2moXzikPYiTQsB5LeKWPlIxaSw
         5rSOmoGgv3mOBe+2/q5aQMbUV1C2d9KDvpDczRU5p9spAvx4zbO8SXRW/qShX1WuWWjN
         /xAqhC0pEld90tlEOrVuZCe5n/zmBlrA5rktbPQB6u1MEujtngY7wSzokavli4Gkmr56
         3b4u7EJN9opcM5wIWu4vm4HNAnzd7hCs+M8oqcLcNVJXiNmrUZd6SxRqZFiWKzrNDyAj
         QPnw==
X-Forwarded-Encrypted: i=1; AFNElJ98pryrZgGO+JDPjTvcQy7wKxGh6H01AtBo5hpDKfbCqpqvIS27gR9+7JRC9fp3ZnZ5xWJjhIytKf9I@vger.kernel.org
X-Gm-Message-State: AOJu0YyokaggVbZQ+NiTb0x+LI72nCx0VMHHkAXUjHj4pgE0SczBFM4S
	rAgcYnhuh37B/74FQjrrrRID1UDYiVxVIk7FGeDTHKayvzEbTSzBRALoDCucIiLmPk70A4hvVNP
	h35MwzkY=
X-Gm-Gg: AeBDiev574L/EFm3Vxy047IbgTpuDOL4ltCcNPbUVW31Qy3/Gdy3q6GWjrSYqUlbpAk
	sOEwyJJDecMkVxWlOURk1fd/M+jlPAo8X5GyVYYxjgBwe5chqrhknZZIZug4rOKTtsIlRqhi7LQ
	V1YjYNW9iY3ZLiLytg9TREuIpmJOXt98o4gb3P3Bt61OAzXXgAxIWbWwiSmwTGo+zwGD2kKiTFR
	c40xGu7SAHn6+pwiNOC5OEcU4/gqpy5T2icEBA6IL/AOkK9d7IrFzo65SLGi96RqROUXHDK/JZv
	z8qGLoVMTcjlrrekTZh27eber/7reXHe9+xsAAKphzZyGQoFkuFLd/pStcW9HEZQFkQNDC6n+8n
	sq1+vPFPVmqXG9o4vF5dC17KNsaGJsxpoN6NzT2f5DZs7VHMtLoI9MaojIEVkdj/KxUtR/4B+NR
	vy7fNTCNouWFb74iM0GyDqg1+y7bdL3eg=
X-Received: by 2002:a05:600c:3f0d:b0:485:40fd:8390 with SMTP id 5b1f17b1804b1-488d68769f9mr181491475e9.26.1776107480576;
        Mon, 13 Apr 2026 12:11:20 -0700 (PDT)
Received: from precision ([2804:7f0:6401:5290:433e:afae:f475:c9f7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55f5c6afdsm17508032eec.4.2026.04.13.12.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:11:19 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] smb: client: serialize channel scaling path
Date: Mon, 13 Apr 2026 16:11:09 -0300
Message-ID: <20260413191110.1508848-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Channel scaling serialization was coded at several call sites with plain
flag values in ses->flags, which duplicated the same bookkeeping in
reconnect and remount paths, and was missing in the mount path.

Move the CIFS_SES_FLAG_SCALE_CHANNELS acquisition and release inside
smb3_update_ses_channels(), and convert the session flags to bit indices
and their operations to bitops.

Make smb3_update_ses_channels return -EBUSY if there is already an
ongoing channel scaling operation.

Fixes: 556bb341f9f2e ("smb: client: introduce multichannel async work during mount")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsglob.h   |  6 +++---
 fs/smb/client/fs_context.c | 15 ---------------
 fs/smb/client/smb2pdu.c    | 24 ++++++++----------------
 3 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 709e96e07791..7b1323927711 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1049,8 +1049,8 @@ struct cifs_chan {
 	__u8 signkey[SMB3_SIGN_KEY_SIZE];
 };
 
-#define CIFS_SES_FLAG_SCALE_CHANNELS (0x1)
-#define CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES (0x2)
+#define CIFS_SES_FLAG_SCALE_CHANNELS 0
+#define CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES 1
 
 /*
  * Session structure.  One of these for each uid session with a particular host
@@ -1089,7 +1089,7 @@ struct cifs_ses {
 	bool domainAuto:1;
 	bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
 	int unicode;
-	unsigned int flags;
+	unsigned long flags;
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
 	__u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a46764c24710..e0e13c22e159 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1166,27 +1166,12 @@ static int smb3_reconfigure(struct fs_context *fc)
 
 		/* Synchronize ses->chan_max with the new mount context */
 		smb3_sync_ses_chan_max(ses, ctx->max_channels);
-		/* Now update the session's channels to match the new configuration */
-		/* Prevent concurrent scaling operations */
-		spin_lock(&ses->ses_lock);
-		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
-			spin_unlock(&ses->ses_lock);
-			mutex_unlock(&ses->session_mutex);
-			return -EINVAL;
-		}
-		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
-		spin_unlock(&ses->ses_lock);
 
 		mutex_unlock(&ses->session_mutex);
 
 		rc = smb3_update_ses_channels(ses, ses->server,
 					       false /* from_reconnect */,
 					       false /* disable_mchan */);
-
-		/* Clear scaling flag after operation */
-		spin_lock(&ses->ses_lock);
-		ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
-		spin_unlock(&ses->ses_lock);
 	} else {
 		mutex_unlock(&ses->session_mutex);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5188218c25be..2eb13b2665a4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -228,6 +228,10 @@ int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *serve
 			bool from_reconnect, bool disable_mchan)
 {
 	int rc = 0;
+
+	if (test_and_set_bit(CIFS_SES_FLAG_SCALE_CHANNELS, &ses->flags))
+		return -EBUSY;
+
 	/*
 	 * Manage session channels based on current count vs max:
 	 * - If disable requested, skip or disable the channel
@@ -243,6 +247,7 @@ int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *serve
 			rc = cifs_chan_skip_or_disable(ses, server, from_reconnect, disable_mchan);
 	}
 
+	clear_bit(CIFS_SES_FLAG_SCALE_CHANNELS, &ses->flags);
 	return rc;
 }
 
@@ -432,15 +437,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	spin_lock(&ses->ses_lock);
-	if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
-		spin_unlock(&ses->ses_lock);
-		mutex_unlock(&ses->session_mutex);
-		goto skip_add_channels;
-	}
-	ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
-	spin_unlock(&ses->ses_lock);
-
 	if (!rc &&
 	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
 	    server->ops->query_server_interfaces) {
@@ -450,11 +446,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		 * is in progress. This will be used to avoid calling
 		 * smb2_reconnect recursively.
 		 */
-		ses->flags |= CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
+		set_bit(CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES, &ses->flags);
 		xid = get_xid();
 		rc = server->ops->query_server_interfaces(xid, tcon, false);
 		free_xid(xid);
-		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
+		clear_bit(CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES, &ses->flags);
 
 		if (!tcon->ipc && !tcon->dummy)
 			queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
@@ -492,10 +488,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 
 skip_add_channels:
-	spin_lock(&ses->ses_lock);
-	ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
-	spin_unlock(&ses->ses_lock);
-
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		cifs_queue_server_reconn(server);
 
@@ -609,7 +601,7 @@ static int smb2_ioctl_req_init(u32 opcode, struct cifs_tcon *tcon,
 	 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO ||
 	    (opcode == FSCTL_QUERY_NETWORK_INTERFACE_INFO &&
-	     (tcon->ses->flags & CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES)))
+	     test_bit(CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES, &tcon->ses->flags)))
 		return __smb2_plain_req_init(SMB2_IOCTL, tcon, server,
 					     request_buf, total_len);
 
-- 
2.53.0

