Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24181C861A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 02:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763432867; cv=none; b=MSWRa0IoOOpnfIl28DQfJWb5umV2NJaihzkJ2NwKN7J9xGRIDzbVQe1sJHEeO7sOpYM+mcUq82GaZ/JpSilvXSlbQiEi6Y479Kf3u555AiCfpOum3MBrMSgo0dwhlYcB3WE7hbbIPLJgqlBb4FU+O3x4G0/1A2uhwUf5QeVwm4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763432867; c=relaxed/simple;
	bh=IuYX8Ybp/bgqXpg4/h9HUgoO1P3LMO1wdokSzXVY8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pHIcDyFbQkrENa97h/6Pupc9kSwD5UjRu5qQMrzKSXJuF6lof3BmSV4H5zKjM5QFRddGZCB7xJgsRyi41EFKIkVk6jhks1qNu4j8iDc5duohnJVHgQVg2IWjGdyp+3ghhIHft5wYrWT6sxvuz3c0A05F19rmDvX/1G34zcQGsLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrPFq5hj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrPFq5hj"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2981f9ce15cso63320485ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 18:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763432865; x=1764037665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Bn9qlwUqhBEonhqbp+iyTs1wo7JGYonc9b4L9aHC3g=;
        b=nrPFq5hjP40XN+UynV+rZ/L6lcgh3yE49MxCpPmguJiFE/nVvyz4WG/1ObupTgnyh/
         Ae9JfACxQ1fEXcZ8Qbi2udXKygW1L4N5f9jxyCkk4NjPzmsqAFL/qhsPklb/Ob8XFmnx
         nB/4+dtSYQuTo3+r+hCxRuLEXy9Ooju0lJObFr4zqBz0Ll4DSa8qbM1J1pNYsA05HBCg
         erlchcqk0GF9HuEP1fi9wxEzw2nwDX0knN7RrFzuAORDPGV4A3MD6s6uoIR+J+C9zo8R
         r4QbK3bsis26z3JVadiwlLDTrozsr37W9MA8mQvQy7agmu1xwhKfxH93xGHkQIg96DJW
         Ghnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432865; x=1764037665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Bn9qlwUqhBEonhqbp+iyTs1wo7JGYonc9b4L9aHC3g=;
        b=VbIbqCkz0aYN65pjB10mzz9ix+sDck4Xr6XYz23W/+MLP+Jrad8imyflzW2mv2WTT9
         m32H2bsf0nR40DyK1c4ukMMDQaTLkwNuB2yR/vBaJ7kGVTLW/7Jrfr63Mckl4bNaMEVh
         H60wmKOW2kzWmOdMRL6VCWGGW6Mr6PtbJFjH2NPcfNR2YDt7YgkgPdSbZh99qf9NAciX
         WKK6ziS07NuLOBQ/WbyL6M2y2wMEicfVknDkJ1aoyi9U7Wz+znWEilAVgE3KHLPzg1z8
         XXJVqfTy117wP9ojbKCgCCKUifWtTLO7tVqh2ssrFMahQMK3g1NL8GkRvZCvzsQwa6kf
         xvHA==
X-Forwarded-Encrypted: i=1; AJvYcCURiWxF4IewYSwoBv1RYa5i61oMVoQ/KsyyZ92wagk3+lFiX1tmnw5jjO83BS2b1A4wpRNV0eW5fSaD@vger.kernel.org
X-Gm-Message-State: AOJu0YwoBcd01ZcmqWIusxxU5EtUQgZsFz4MePRw9r3ceitsluWtrp5f
	ogJI6nzW56aRDnhENsMWvVrDoDLxkfSkQiKDu/YzFaiFyQuB8v4hnJa1
X-Gm-Gg: ASbGncvNPC4SwWhPNh2iznXMFwmbpiscZ8AE+jwgBRZ91Y5frsbSX+QqwVJ6jPQMtqO
	AxdQEYkkEFL8qNkIVggMvNkWzP7N5GqX7UqnjI562uWnLnnXSGYKKGxVbWl66QlOSH9bBNVOpXA
	prhNEFAGx27pEpVWDQ/D6veI+porSCdo8AOhfsWJlokPwP1Nn7aiqDYUGZLpUreflmZQiy2UKVE
	8oQSl+yxdpk0SGNcyEYd3KseEQnWs+UzjWgpzAzdSFir3sR/kY4qj4zbFes8yWkJnoykN1mte5j
	E/LZsEfPZJJHAHISOgIBW30lR+Ly7iywXrRilCcwMoenmmi2mRuxNr8h65WiJgENmjZz8EhoDss
	1pCsLHrqCcyRBiyDXfu7p7+Wwo87kCqFzlPHWFM8/KNId2R+YQIMs0OX0iORUZKDgc6x81JCKGu
	ayxqFfFPo9puAA3gSRInsLmiLHXpp/tlFHBHr/Ke95sJq0skGFtBV3mfxTy+6bkzp1wxZh+VEnL
	OtZ4gAqs6pN/QzTdQ==
X-Google-Smtp-Source: AGHT+IFKECxgl7WkTg/SRwJjv1N7Fi1vzCaBobvQYhBUGpyQwgXtST+Wd/ajvsur73PAvIMJDA7xOw==
X-Received: by 2002:a17:903:3284:b0:298:2237:a2eb with SMTP id d9443c01a7336-2986a6bf9f5mr120474265ad.16.1763432864922;
        Mon, 17 Nov 2025 18:27:44 -0800 (PST)
Received: from linuxbackup1-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([4.247.136.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c23849esm153170975ad.5.2025.11.17.18.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:27:44 -0800 (PST)
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
Subject: [PATCH] cifs: client: allow changing multichannel mount options on remount
Date: Tue, 18 Nov 2025 02:26:54 +0000
Message-ID: <20251118022655.126994-1-rajasimandalos@gmail.com>
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
 fs/smb/client/sess.c       | 32 +++++++++++++++-------
 fs/smb/client/smb2pdu.c    | 55 ++++++++++++++++++++++++++++----------
 5 files changed, 119 insertions(+), 26 deletions(-)

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
index 55cb4b0cbd48..cebe4a5f54f2 100644
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
index 0f894d09157b..751ed6ebd458 100644
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
index 8b4a4573e9c3..d051da46eaab 100644
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
@@ -206,14 +206,41 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
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
+ * Note: Outside of reconfigure, this function is only called from reconnect scenarios
+ * when the server stops advertising multichannel (MC) capability.
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
@@ -355,8 +382,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
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
@@ -438,8 +465,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
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
@@ -451,7 +479,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
 
-			cifs_try_adding_channels(ses);
+			smb3_update_ses_channels(ses, server, from_reconnect,
+						  false /* from_reconfigure */);
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
@@ -1105,8 +1134,7 @@ SMB2_negotiate(const unsigned int xid,
 		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
-	if (ses->chan_max > 1)
-		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
@@ -1312,8 +1340,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	pneg_inbuf->Capabilities =
 			cpu_to_le32(server->vals->req_capabilities);
-	if (tcon->ses->chan_max > 1)
-		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	memcpy(pneg_inbuf->Guid, server->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
-- 
2.43.0

