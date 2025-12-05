Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A903B8D4D
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764965573; cv=none; b=pSf107B6qfdWn2MOkG1LY++3T1Y7/vF2Xxzl1xDtXNwliKy0MtMd0vl+QWIEbzZ6cLW7JEQBR817H/CayU74d7mw38Fb4qG/1HBug8b0W7xfKuQlaSpB4Z0Nq845w/Dfu8+/cY8WH6x1qA/o7LtVypSE1U0uYR6kRmEf/+hmGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764965573; c=relaxed/simple;
	bh=/MCKpZbAevfhOFgRRG2rqIMScDSmckP0wuBxTbyJEaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Npebh5LJ5Vsm831uvKwsKjESG/0Mwmf2ucnk20uDVGcGw3RmVlfo3ehhCwfQyKwbZSoURj1AOz4vOhZhWIqfPGoDbBYRwkANLoji16OAEcUqKa7Ks8ba5Yc4yKn8k+3iOYF8Sj93n/Oxxtmek4fHDQijLNHD7ETLCIBW90VuIrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FAfRlvNO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FAfRlvNO"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29845b06dd2so34349115ad.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 Dec 2025 12:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764965571; x=1765570371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiWr35Xcp+w6beL0h3C2ovcgRNxpZOtKTrjHbefymQ0=;
        b=FAfRlvNOxHlYnRAKvaUiiNXBQyIZVNKL9r0M7Rkfio1sK43EUl2kmPvXXTGbxZW+NB
         2kyi4XqQCAYvEqQTn3dE6mt0QCRZpeOV7cgHHSVrTS5Au0qbHNYdbSXr5GKhhz5lQJK2
         5Eys7VHO8T5oINO3glC1AAdWWM31U0Nh/pxHPPG0Z0UZ/8cdslHwhALmi4Vjs6uZjWRP
         ZaMhXfQafJrJDVM55+9Zs9JSlbUfhqd36XuA61ifgewNHjdnaivNC0cgCgfPrrLkMgGk
         VmBavkHNSOdpjCh/PSsd8FCslJR3xEynhVckPePOOGhttieTiakl5bjfFLd84rx111yt
         p8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764965571; x=1765570371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hiWr35Xcp+w6beL0h3C2ovcgRNxpZOtKTrjHbefymQ0=;
        b=X7PFi9udN/uyRfmmuZ6oS5Y38IP8wd7NXqbfL0mgEGW5UYIpgZzdC32PYF7nm11pa5
         XnsWf1zqcSD74wU4F4xEqiBoGm1TTXtxjxGa3JvJo7NMSrljwCjckf4/UbsaGeBt0Dtw
         gVC9Kh0Fc9L3rWxp8battxu00jld/1wjNlgF3AblMC1XuU+wn5G7Mqo/pZiXUVC5lVIh
         qgLNehco2p1bG7M1aWddWFFbVNLcDBEl1xVtH01nf33Qayc7MsBCnI6eXYxNdQGz33vC
         yEURFXyOxQtP6JXn4ClG5yeRZfwB3sYv6gnDjOfrxxJO7kYVM3G4n3DLe4TVt3f6PgDw
         sw8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVJfFQ18y7zzBP8WFGFAyCTSonWlRQwyrxoN65rwN4PvTzYynCw50aVYhdjbQ39CJwLarQLZz60kFfa@vger.kernel.org
X-Gm-Message-State: AOJu0YxW25TwXBOdWy1ovAOPmCBIG0hnuxFMqWamwi03gVuKw5e+PpxL
	SVp5I4ye6icVOSmkrw88IOyqlWJ1B4f9cjX/Lm/S5XR133U5/P8Ah8c2
X-Gm-Gg: ASbGncvASphIFJSNQhJoIQTf/0Sgb0/4vQKKBvnzNmNynNctKpgZdTKedId4UEl78e6
	VX61kQJHZ9Na69npPN/UtDKPs4TM7P6XD06gP5OSOO26qu1YSqGfMnqPWNKvKU+LDBwuIY1DCOA
	RkISByp3qBZ14+avlhKRzbXS0Hld5iakbok263DOmGZQ/l/EgvY13j47cPMtEgTOet9Fvpl7F0V
	TPrCc/VHbvg2qi0QmmIbR+o9jNbln8B0tOzpuuzZBetw8MF3mKicekEvneDq/5tp1YtG55witbE
	lEce5X+6z1x+eFp2akn2k1K//Mo/HsvYi9R2gXFY4HSN3mrrMyaQrReTUmoXJdjw9bOAnDk5cO5
	vbIenXSaje9UUr20vmQ1wTAITfA+ASE+4ad9Hb39Wr9ZpNlkktcFn4AvTkdE+Aw1k1etvTv3xfn
	lWVOBaHDdbfFtf1BjCtwbeEaAFjUsntU4SqVUxiyjmFM2sNvBJD5QRQbxxC6rx0g3Toc44dIfDO
	oGLogTXZFX1DUOE5SHoNA==
X-Google-Smtp-Source: AGHT+IF+llJyXEGPfHEOB0iSgSoi3uXJwB91tgeEeIMbk0WTq3rgxibEttcTAvsiZ8dChpM+C60UPg==
X-Received: by 2002:a17:90b:4a02:b0:343:e2ba:e8be with SMTP id 98e67ed59e1d1-349a250ef5amr248603a91.10.1764965571082;
        Fri, 05 Dec 2025 12:12:51 -0800 (PST)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494f5a6e25sm5348670a91.13.2025.12.05.12.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 12:12:50 -0800 (PST)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v2] cifs: client: allow changing multichannel mount options on remount
Date: Fri,  5 Dec 2025 20:11:51 +0000
Message-ID: <20251205201151.22192-1-rajasimandalos@gmail.com>
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
  cifs_decrease_secondary_channels(), which accepts a disable_mchan
  flag to support multichannel disable when the server stops supporting
  multichannel.
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
 fs/smb/client/fs_context.c | 51 +++++++++++++++++++++++++++++++-
 fs/smb/client/sess.c       | 35 ++++++++++++++++------
 fs/smb/client/smb2pdu.c    | 60 +++++++++++++++++++++++++++++---------
 5 files changed, 128 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3528c365a452..f2733d18c162 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
 
 int cifs_try_adding_channels(struct cifs_ses *ses);
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+					bool from_reconnect, bool disable_mchan);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
@@ -674,7 +676,7 @@ bool
 cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses);
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool disable_mchan);
 void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2f94d93b95e9..962f1bfdffdd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	ctx->prepath = NULL;
 
 out:
-	cifs_try_adding_channels(mnt_ctx.ses);
+	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
+				  false /* from_reconnect */,
+				  false /* disable_mchan */);
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2a0d8b87bd8e..214babb012f2 100644
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
@@ -1095,7 +1112,39 @@ static int smb3_reconfigure(struct fs_context *fc)
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
+			mutex_unlock(&ses->session_mutex);
+			return -EINVAL;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+
+		mutex_unlock(&ses->session_mutex);
+
+		rc = smb3_update_ses_channels(ses, ses->server,
+					       false /* from_reconnect */,
+					       false /* disable_mchan */);
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
index ef3b498b0a02..239cd5c8208d 100644
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
+ * @disable_mchan: if true, reduce to a single channel; if false, reduce to chan_max
+ *
+ * This function disables and cleans up extra secondary channels for a CIFS session.
+ * If called during reconfiguration, it reduces the channel count to the new maximum (chan_max).
+ * Otherwise, it disables all but the primary channel.
  */
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses)
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool disable_mchan)
 {
 	int i, chan_count;
 	struct TCP_Server_Info *server;
@@ -281,12 +285,16 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 	if (chan_count == 1)
 		goto done;
 
-	ses->chan_count = 1;
-
-	/* for all secondary channels reset the need reconnect bit */
-	ses->chans_need_reconnect &= 1;
+	/* Update the chan_count to the new maximum */
+	if (disable_mchan) {
+		cifs_dbg(FYI, "server does not support multichannel anymore.\n");
+		ses->chan_count = 1;
+	} else {
+		ses->chan_count = ses->chan_max;
+	}
 
-	for (i = 1; i < chan_count; i++) {
+	/* Disable all secondary channels beyond the new chan_count */
+	for (i = ses->chan_count ; i < chan_count; i++) {
 		iface = ses->chans[i].iface;
 		server = ses->chans[i].server;
 
@@ -318,6 +326,15 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 		spin_lock(&ses->chan_lock);
 	}
 
+	/* For extra secondary channels, reset the need reconnect bit */
+	if (ses->chan_count == 1) {
+		cifs_dbg(VFS, "Disable all secondary channels\n");
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
index 8b4a4573e9c3..23b7792f983f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 static int
 cifs_chan_skip_or_disable(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
-			  bool from_reconnect)
+			  bool from_reconnect, bool disable_mchan)
 {
 	struct TCP_Server_Info *pserver;
 	unsigned int chan_index;
@@ -206,14 +206,46 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		return -EHOSTDOWN;
 	}
 
-	cifs_server_dbg(VFS,
-		"server does not support multichannel anymore. Disable all other channels\n");
-	cifs_disable_secondary_channels(ses);
-
+	cifs_decrease_secondary_channels(ses, disable_mchan);
 
 	return 0;
 }
 
+/*
+ * smb3_update_ses_channels - Synchronize session channels with new configuration
+ * @ses: pointer to the CIFS session structure
+ * @server: pointer to the TCP server info structure
+ * @from_reconnect: indicates if called from reconnect context
+ * @disable_mchan: indicates if called from reconnect to disable multichannel
+ *
+ * Returns 0 on success or error code on failure.
+ *
+ * Outside of reconfigure, this function is called from cifs_mount() during mount
+ * and from reconnect scenarios to adjust channel count when the
+ * server's multichannel support changes.
+ */
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+			bool from_reconnect, bool disable_mchan)
+{
+	int rc = 0;
+	/*
+	 * Manage session channels based on current count vs max:
+	 * - If disable requested, skip or disable the channel
+	 * - If below max channels, attempt to add more
+	 * - If above max channels, skip or disable excess channels
+	 */
+	if (disable_mchan)
+		rc = cifs_chan_skip_or_disable(ses, server, from_reconnect, disable_mchan);
+	else {
+		if (ses->chan_count < ses->chan_max)
+			rc = cifs_try_adding_channels(ses);
+		else if (ses->chan_count > ses->chan_max)
+			rc = cifs_chan_skip_or_disable(ses, server, from_reconnect, disable_mchan);
+	}
+
+	return rc;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
@@ -355,8 +387,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 */
 	if (ses->chan_count > 1 &&
 	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-		rc = cifs_chan_skip_or_disable(ses, server,
-					       from_reconnect);
+		rc = smb3_update_ses_channels(ses, server,
+					       from_reconnect, true /* disable_mchan */);
 		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			goto out;
@@ -438,8 +470,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			 * treat this as server not supporting multichannel
 			 */
 
-			rc = cifs_chan_skip_or_disable(ses, server,
-						       from_reconnect);
+			rc = smb3_update_ses_channels(ses, server,
+						       from_reconnect,
+						       true /* disable_mchan */);
 			goto skip_add_channels;
 		} else if (rc)
 			cifs_tcon_dbg(FYI, "%s: failed to query server interfaces: %d\n",
@@ -451,7 +484,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
 
-			cifs_try_adding_channels(ses);
+			smb3_update_ses_channels(ses, server, from_reconnect,
+						  false /* disable_mchan */);
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
@@ -1105,8 +1139,7 @@ SMB2_negotiate(const unsigned int xid,
 		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
-	if (ses->chan_max > 1)
-		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
@@ -1312,8 +1345,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	pneg_inbuf->Capabilities =
 			cpu_to_le32(server->vals->req_capabilities);
-	if (tcon->ses->chan_max > 1)
-		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	memcpy(pneg_inbuf->Guid, server->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
-- 
2.43.0

