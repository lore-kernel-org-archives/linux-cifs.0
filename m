Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A30927CCF0
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 06:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570368; cv=none; b=DlYg1We2QFTTPSYWzIWy4PPVKBRzTu2JcAjxgKj/N/qCwP8cUHMyUAN0cnQ+5j0R/iFIpu78/LWkR090HhlKQOoEFjwIXnwOKJsMFHopVFBtSx/bNooJG/ycmLVQmlliuW1t/+OfDkhahfNuuXm/cUKnjcclaNJGLVYS9VPxYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570368; c=relaxed/simple;
	bh=43Zuz2mv9XOAh+rsxsA+EflhJVJnlr9M00TrduJ/jt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=trJp2hjUUXOAO71/hzV4zfCHfB5sa5JXhf2SjZ0+yUIf4Idp1081Rp07KYscARQ4SU6znqf6t6WBdnvbJxwkgih42eTAd7lHheA2AYa4rZOZB0jHWMuwi0CkamEKYso89PTuYusaJsJCRmwBLTs2UliXMgenML1+uFhTM8BIhUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAyyLBgJ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAyyLBgJ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2923169b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 30 Nov 2025 22:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764570365; x=1765175165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Um0gRzEgMcM2RxAxHpNhCQLlAn5tOkq/AJSzGvXpcnM=;
        b=QAyyLBgJGHG4ds0NNX13kKbu918kXZIgPhYy9mEyLjeh0WnK+qL+YKdReaYGFl13rt
         el01MKHGObIcsDWdqpgDZpJW40OAYyeDFy7Kxkod1N2K4H9JZkc6smjFQIOaY3T6FKJn
         QEk2A7aJKUgjQgDBTk1zL/gFkpwXRjGHLbG4iTLkCEkbR3kBmmQCaohgbOv1EsSbPD1T
         d16LZaKO+vfXtalpgENIlvgbdbEpMtT8XnDqgAscSVsRvfjbq8kf46bzcMlj5LrjE1wy
         Lt/M7D2x9UI+cmASrrHrmT6tv/mlBLDM/xnXv2+4VLamdy4KE6eiLMWnJDHvcaTbPICp
         wfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764570365; x=1765175165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Um0gRzEgMcM2RxAxHpNhCQLlAn5tOkq/AJSzGvXpcnM=;
        b=jSwB0mv7aWyqRAb8h0DWXaVHy6I3Q7VYdroL1Eplyto/SuF8N3rNNRPWbA6pvsPB9e
         VkryoqCRyTO+ApCqWLpS/xyM7anniNJt3sR6nb+YNIHX1CE7HIn/DrVXsKhpEy5LujqD
         g+bSgiYE873wCRqKcKUz9W01YSUrJOw7PMiKRLYaYKPQWUHWIh9hpzgs6PvJD5sTIZLB
         9XyAmAdp97OTxEQyrbNQpWAZICWwhph2cbuPCl082+88aa/u9TYsjIT9GLO2jftVavRY
         7/fSNjxgoju76wB4dyg+s3mYO52ucI48HmYbsuRYRpUND6auRbCb1RJwQMaXsyJG7/Qz
         l1Kg==
X-Gm-Message-State: AOJu0YwUiR9vcWcdAMJobrUCpFJojAMsybOK1NCAcqLF68tb8Hk7QJ56
	p0mut0ak8PAO07Tk+FpQ6as+c6SpRfr61uRrzli+3nK0X7l4Jo5nEqff+cHDwQ==
X-Gm-Gg: ASbGnctuyr6JrNIZCYeXHdMPBJUa566UmvAM8aFnlPpYHmi+g27k+2aDhnCdCq0fgIW
	ANfOun0C4NwHXsp8VRovbDtZ1NlmGzwDmwqcjJ5Y6Usfe/RvL9WHRABczmrpIVYwUA2kbwFcutU
	Ut3wBIUyXq0Lqt/iNUzKFfHNGq32kqFP7i79oQOmvjLQT88JXWkJ5HGmWEF1RhZByMemgLAKp3z
	9LMxk/72ituCHBDqJMPrOuygYOc8bRd1nb7Ge3owmnbN2K1dZlAVLr4nXgj5tdaEDngydv29RIG
	90TLKA2g6s58fqjDSDubcUzgfkRWnk57Z9OV03CYj8Z6jvojdWdwBpXBh9uqvcC/P7OCb3YKQr4
	5FwMfRFOSVoAQJxC62u+/fekmFG+u3sLa3vxdxTqcgWApXOU74jzR1BS7bnfOHMNHfWUOVTDv8p
	MyKe9IZjzBI51TrTRMAHGYmn7GpQRBAi3s4cwqt+pqxj88aesxbLVRSDEYkTb9ZMDj/gBK65Dq/
	JMK0OcjdA8=
X-Google-Smtp-Source: AGHT+IFu4wHlwtOyq7//ueZRE10jXbrh0iLyHfxjCNOdD6gCoxpXtS4CVKtYu5CyxyHoAEWKSjmd5Q==
X-Received: by 2002:a05:6a20:a126:b0:350:55e0:5522 with SMTP id adf61e73a8af0-36150ef925dmr42778122637.37.1764570365190;
        Sun, 30 Nov 2025 22:26:05 -0800 (PST)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be4fb434e8esm10898565a12.4.2025.11.30.22.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 22:26:04 -0800 (PST)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH] cifs: client: allow changing multichannel mount options on remount
Date: Mon,  1 Dec 2025 06:25:17 +0000
Message-ID: <20251201062517.1513683-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Previously, the client did not update a session's channel state when
multichannel or max_channels mount options were changed via remount.
This led to inconsistent behavior and prevented enabling or disabling
multichannel support without a full unmount/remount cycle.

Enable dynamic reconfiguration of multichannel and max_channels during
remount by:
- Introducing smb3_sync_ses_chan_max(), a centralized function for
  channel updates which synchronizes the session's channels with the
  updated configuration.
- Replacing cifs_disable_secondary_channels() with
  cifs_decrease_secondary_channels(), which accepts a from_reconfigure
  flag to support targeted cleanup during reconfiguration.
- Updating remount logic to detect changes in multichannel or
  max_channels and trigger appropriate session/channel updates.

Current limitation:
- The query_interfaces worker runs even when max_channels=1 so that
  multichannel can be enabled later via remount without requiring an
  unmount. This is a temporary approach and may be refined in the
  future.

Users can safely modify multichannel and max_channels on an existing
mount. The client will correctly adjust the session's channel state to
match the new configuration, preserving durability where possible and
avoiding unnecessary disconnects.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifsproto.h  |  4 ++-
 fs/smb/client/connect.c    |  4 ++-
 fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++++++++-
 fs/smb/client/sess.c       | 32 ++++++++++++++++------
 fs/smb/client/smb2pdu.c    | 56 ++++++++++++++++++++++++++++----------
 5 files changed, 120 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3528c365a452..a1fc9e1918bc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
 
 int cifs_try_adding_channels(struct cifs_ses *ses);
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+					bool from_reconnect, bool from_reconfigure);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
@@ -674,7 +676,7 @@ bool
 cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses);
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure);
 void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2f94d93b95e9..6557b3546398 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	ctx->prepath = NULL;
 
 out:
-	cifs_try_adding_channels(mnt_ctx.ses);
+	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
+				  false /* from_reconnect */,
+				  false /* from_reconfigure */);
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2a0d8b87bd8e..46428181699e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 					    void *data);
 static int smb3_get_tree(struct fs_context *fc);
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
 static int smb3_reconfigure(struct fs_context *fc);
 
 static const struct fs_context_operations smb3_fs_context_ops = {
@@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
 	return 0;
 }
 
+/*
+ * smb3_sync_ses_chan_max - Synchronize the session's maximum channel count
+ * @ses: pointer to the old CIFS session structure
+ * @max_channels: new maximum number of channels to allow
+ *
+ * Updates the session's chan_max field to the new value, protecting the update
+ * with the session's channel lock. This should be called whenever the maximum
+ * allowed channels for a session changes (e.g., after a remount or reconfigure).
+ */
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+{
+	spin_lock(&ses->chan_lock);
+	ses->chan_max = max_channels;
+	spin_unlock(&ses->chan_lock);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_context *fc)
 		ses->password2 = new_password2;
 	}
 
-	mutex_unlock(&ses->session_mutex);
+	/*
+	 * If multichannel or max_channels has changed, update the session's channels accordingly.
+	 * This may add or remove channels to match the new configuration.
+	 */
+	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
+	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
+
+		/* Synchronize ses->chan_max with the new mount context */
+		smb3_sync_ses_chan_max(ses, ctx->max_channels);
+		/* Now update the session's channels to match the new configuration */
+		/* Prevent concurrent scaling operations */
+		spin_lock(&ses->ses_lock);
+		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+			spin_unlock(&ses->ses_lock);
+			return -EINVAL;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+
+		mutex_unlock(&ses->session_mutex);
+
+		rc = smb3_update_ses_channels(ses, ses->server,
+					       false /* from_reconnect */,
+					       true /* from_reconfigure */);
+
+		/* Clear scaling flag after operation */
+		spin_lock(&ses->ses_lock);
+		ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+	} else {
+		mutex_unlock(&ses->session_mutex);
+	}
 
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index ef3b498b0a02..cfd83986a84a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 }
 
 /*
- * called when multichannel is disabled by the server.
- * this always gets called from smb2_reconnect
- * and cannot get called in parallel threads.
+ * cifs_decrease_secondary_channels - Reduce the number of active secondary channels
+ * @ses: pointer to the CIFS session structure
+ * @from_reconfigure: if true, only reduce to chan_max; if false, reduce to a single channel
+ *
+ * This function disables and cleans up extra secondary channels for a CIFS session.
+ * If called during reconfiguration, it reduces the channel count to the new maximum (chan_max).
+ * Otherwise, it disables all but the primary channel.
  */
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses)
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure)
 {
 	int i, chan_count;
 	struct TCP_Server_Info *server;
@@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 	if (chan_count == 1)
 		goto done;
 
-	ses->chan_count = 1;
-
-	/* for all secondary channels reset the need reconnect bit */
-	ses->chans_need_reconnect &= 1;
+	/* Update the chan_count to the new maximum */
+	if (from_reconfigure)
+		ses->chan_count = ses->chan_max;
+	else
+		ses->chan_count = 1;
 
-	for (i = 1; i < chan_count; i++) {
+	for (i = ses->chan_max ; i < chan_count; i++) {
 		iface = ses->chans[i].iface;
 		server = ses->chans[i].server;
 
@@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 		spin_lock(&ses->chan_lock);
 	}
 
+	/* For extra secondary channels, reset the need reconnect bit */
+	if (ses->chan_count == 1) {
+		cifs_dbg(VFS, "server does not support multichannel anymore. Disable all other channels\n");
+		ses->chans_need_reconnect &= 1;
+	} else {
+		cifs_dbg(VFS, "Disable extra secondary channels\n");
+		ses->chans_need_reconnect &= ((1UL << ses->chan_max) - 1);
+	}
+
 done:
 	spin_unlock(&ses->chan_lock);
 }
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8b4a4573e9c3..37a3216b37e4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 static int
 cifs_chan_skip_or_disable(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
-			  bool from_reconnect)
+			  bool from_reconnect, bool from_reconfigure)
 {
 	struct TCP_Server_Info *pserver;
 	unsigned int chan_index;
@@ -206,14 +206,42 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		return -EHOSTDOWN;
 	}
 
-	cifs_server_dbg(VFS,
-		"server does not support multichannel anymore. Disable all other channels\n");
-	cifs_disable_secondary_channels(ses);
-
+	cifs_decrease_secondary_channels(ses, from_reconfigure);
 
 	return 0;
 }
 
+/*
+ * smb3_update_ses_channels - Synchronize session channels with new configuration
+ * @ses: pointer to the CIFS session structure
+ * @server: pointer to the TCP server info structure
+ * @from_reconnect: indicates if called from reconnect context
+ * @from_reconfigure: indicates if called from reconfigure context
+ *
+ * Returns 0 on success or error code on failure.
+ *
+ * Outside of reconfigure, this function is called from cifs_mount() during mount
+ * and from reconnect scenarios to adjust channel count when the
+ * server's multichannel support changes.
+ */
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+			bool from_reconnect, bool from_reconfigure)
+{
+	int rc = 0;
+	/*
+	 * If the current channel count is less than the new chan_max,
+	 * try to add channels to reach the new maximum.
+	 * Otherwise, disable or skip extra channels to match the new configuration.
+	 */
+	if (ses->chan_count < ses->chan_max)
+		rc = cifs_try_adding_channels(ses);
+	else
+		rc = cifs_chan_skip_or_disable(ses, server, from_reconnect,
+						from_reconfigure);
+
+	return rc;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
@@ -355,8 +383,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 */
 	if (ses->chan_count > 1 &&
 	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-		rc = cifs_chan_skip_or_disable(ses, server,
-					       from_reconnect);
+		rc = smb3_update_ses_channels(ses, server,
+					       from_reconnect, false /* from_reconfigure */);
 		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			goto out;
@@ -438,8 +466,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			 * treat this as server not supporting multichannel
 			 */
 
-			rc = cifs_chan_skip_or_disable(ses, server,
-						       from_reconnect);
+			rc = smb3_update_ses_channels(ses, server,
+						       from_reconnect,
+						       false /* from_reconfigure */);
 			goto skip_add_channels;
 		} else if (rc)
 			cifs_tcon_dbg(FYI, "%s: failed to query server interfaces: %d\n",
@@ -451,7 +480,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
 
-			cifs_try_adding_channels(ses);
+			smb3_update_ses_channels(ses, server, from_reconnect,
+						  false /* from_reconfigure */);
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
@@ -1105,8 +1135,7 @@ SMB2_negotiate(const unsigned int xid,
 		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
-	if (ses->chan_max > 1)
-		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
@@ -1312,8 +1341,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	pneg_inbuf->Capabilities =
 			cpu_to_le32(server->vals->req_capabilities);
-	if (tcon->ses->chan_max > 1)
-		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	memcpy(pneg_inbuf->Guid, server->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
-- 
2.43.0

