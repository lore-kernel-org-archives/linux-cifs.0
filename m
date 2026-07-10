Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F85E3A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675051; cv=none; b=BCEQzw7vGsx85QOCqOADjI/bJqBZGDyCcqtENMd9Il8Iyy00P8z9RXtJ+2nuGb73c2P1RFh9mg8e5qlQ4vugUPt57B86oZou824MMguiQQXomCl5g0UdxjXN7FtlYvlKkWQ1/r2COHBY+2NTOLR/VVw2xRmC8pb6BDUh+zjeDuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675051; c=relaxed/simple;
	bh=pXpf20+GV4BqPTGnmpXylXF7DVqdFKMM/x/WrWEbeTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhbQJw0viWP7l4+0I19prBJo6dA5yJpeell6oAKFjA9x5TMMhT8/k32K67qSvKI8DSeFO8W1bCHYCicBDnV2pxxrYuQ1d99J7yMGK30bhkzQxsU2H3bZmCKQMLrLYj9Ov1yUKj9enoKAd2QHnvBMvxKjv9kLuMubAcuk5ky6M/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VO72JDc2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VO72JDc2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VO72JDc2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VO72JDc2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73F3C76709;
	Fri, 10 Jul 2026 09:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zd6lC9P+2XzCannShe4mJ/HGLQBXyxNBVT1TntoGNTY=;
	b=VO72JDc27kmasSdXdGVKvMRsJJYze0SlQ5YBtrLFc/6ZBYXE15uQtEfNSvhv6pDZJKOAsb
	R+zmOgP1Zl9A/I2z5uzzP3IbhGc8dh78KuA7hXA/lVElbGElLU8pUSFmruuPLyzpFqMEFU
	ftvAnKDHFkg2R1hOWI5dYGKfu09FmFQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zd6lC9P+2XzCannShe4mJ/HGLQBXyxNBVT1TntoGNTY=;
	b=VO72JDc27kmasSdXdGVKvMRsJJYze0SlQ5YBtrLFc/6ZBYXE15uQtEfNSvhv6pDZJKOAsb
	R+zmOgP1Zl9A/I2z5uzzP3IbhGc8dh78KuA7hXA/lVElbGElLU8pUSFmruuPLyzpFqMEFU
	ftvAnKDHFkg2R1hOWI5dYGKfu09FmFQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D44AF779BD;
	Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uKXkMJG4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:05 +0000
From: Samuel Cabrero <scabrero@suse.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de,
	Samuel Cabrero <scabrero@suse.com>
Subject: [PATCH 13/18] smb:client: Introduce swn_notification struct
Date: Fri, 10 Jul 2026 11:16:32 +0200
Message-ID: <20260710091637.58873-14-scabrero@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710091637.58873-1-scabrero@suse.com>
References: <20260710091637.58873-1-scabrero@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	R_RATELIMIT(0.00)[to_ip_from(RLsmepzun9ugcn3tumbc3b9wxd)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -6.80

This is a helper struct to contain all necessary data to process a
notification.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 129 ++++++++++++++++++++++++++++++---------
 1 file changed, 99 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 0a45be8f36d7..7e665b657f8d 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -36,6 +36,24 @@ struct cifs_swn_reg {
 	struct delayed_work check;
 };
 
+struct cifs_swn_notification {
+	int type;
+	union {
+		struct {
+			const char *name;
+			int state;
+		} resource_name_changed;
+		struct {
+			struct sockaddr_storage *addr;
+		} client_move;
+		struct {
+			struct sockaddr_storage *addr;
+		} share_move;
+	} data;
+
+	struct cifs_swn_reg *swnreg;
+};
+
 static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
 {
 	int ret;
@@ -620,71 +638,122 @@ static int cifs_swn_client_move(struct cifs_tcon *tcon,
 	return cifs_swn_reconnect(tcon, addr);
 }
 
+static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
+{
+	switch (not->type) {
+	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE:
+		return cifs_swn_resource_state_changed(
+			not->swnreg->tcon, not->data.resource_name_changed.name,
+			not->data.resource_name_changed.state);
+	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE:
+		return cifs_swn_client_move(not->swnreg->tcon,
+					    not->data.client_move.addr);
+	default:
+		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__,
+			 not->type);
+		break;
+	}
+	return 0;
+}
+
 int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cifs_swn_reg *swnreg;
-	char name[256];
-	int type;
+	int swnreg_id;
+	struct cifs_swn_notification not;
+	int ret;
 
+	/* Get the registration ID */
 	if (info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]) {
-		int swnreg_id;
-
-		swnreg_id = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
-		mutex_lock(&cifs_swnreg_idr_mutex);
-		swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		if (swnreg == NULL) {
-			cifs_dbg(FYI, "%s: registration id %d not found\n", __func__, swnreg_id);
-			return -EINVAL;
-		}
+		swnreg_id = nla_get_u32(
+			info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
 	} else {
 		cifs_dbg(FYI, "%s: missing registration id attribute\n", __func__);
 		return -EINVAL;
 	}
 
+	/* Fill the notification struct */
 	if (info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]) {
-		type = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
+		not.type = nla_get_u32(
+			info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
 	} else {
 		cifs_dbg(FYI, "%s: missing notification type attribute\n", __func__);
 		return -EINVAL;
 	}
 
-	switch (type) {
+	switch (not.type) {
 	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE: {
-		int state;
-
 		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]) {
-			nla_strscpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
-					sizeof(name));
+			not.data.resource_name_changed
+				.name = (const char *)nla_data(
+				info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]);
 		} else {
 			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
 			return -EINVAL;
 		}
+
 		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]) {
-			state = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
+			not.data.resource_name_changed.state = nla_get_u32(
+				info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
 		} else {
 			cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
 			return -EINVAL;
 		}
-		return cifs_swn_resource_state_changed(swnreg->tcon, name,
-						       state);
-	}
+	} break;
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE: {
-		struct sockaddr_storage addr;
-
 		if (info->attrs[CIFS_GENL_ATTR_SWN_IP]) {
-			nla_memcpy(&addr, info->attrs[CIFS_GENL_ATTR_SWN_IP], sizeof(addr));
+			not.data.client_move.addr =
+				nla_data(info->attrs[CIFS_GENL_ATTR_SWN_IP]);
 		} else {
 			cifs_dbg(FYI, "%s: missing IP address attribute\n", __func__);
 			return -EINVAL;
 		}
-		return cifs_swn_client_move(swnreg->tcon, &addr);
-	}
+	} break;
 	default:
-		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
-		break;
+		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__,
+			 not.type);
+		return 0;
+	}
+
+	/*
+	 * Get the registration.
+	 */
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	not.swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
+	if (not.swnreg == NULL) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		cifs_dbg(FYI, "%s: registration id %d not found\n", __func__,
+			 swnreg_id);
+		return 0;
+	}
+
+	/*
+	 * Increment the refcount under the lock while processing the notification
+	 * and release the swnreg_idr_mutex because processing will take
+	 * cifs_tcp_ses_lock.
+	 */
+	if (!kref_get_unless_zero(&not.swnreg->ref_count)) {
+		/* The registration is being released, ignore the notificaiton */
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return 0;
+	}
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+
+	ret = cifs_swn_handle_notification(&not);
+	if (ret) {
+		cifs_dbg(FYI,
+			"%s: Failed to process notification for registration id %d: %d\n",
+			__func__, swnreg_id, ret);
 	}
 
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	if (kref_put(&not.swnreg->ref_count, cifs_swn_reg_idr_remove)) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		cancel_delayed_work_sync(&not.swnreg->check);
+		cifs_swn_reg_release(not.swnreg);
+		return 0;
+	}
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+
 	return 0;
 }
 
-- 
2.54.0

