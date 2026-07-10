Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189E73DB651
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675082; cv=none; b=ZvtRKK85sK7aF86RWlxH5lM5Euout6WmZBKhFcjRSjZS9yL7APyNQZ8FXVvG+iYgXCBFBSvz4Ub/NC5SgsbRzjRH8V57SIOcLpxNU7vLGY50BZeMmoznD01QJNY3JOzGjlauMr0pf8NRFzHNsX+CE4zKkIYXa97KpDRPeItCcyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675082; c=relaxed/simple;
	bh=2WDMC84fDHtM+W88BEn30k2VZ3S3RmXFiafcob5FjSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h095jrGPa2jbWpGsTBWxx8/oDZqIIrxVVuh3srm09RBkZ9ABJAX4SMjtFgFMmk5uXFvKgnlY43rjfzadwdVMnoTGBmV2uq6QquZRRvZOLcBgO7fCO7F1usz1v4vVZIAZhOkPqT6orGXuYYgO3+tk0wOjAaX61xJsRX0qY+0cL7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D64876402;
	Fri, 10 Jul 2026 09:17:08 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECD6B779BE;
	Fri, 10 Jul 2026 09:17:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MPXuNpO4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:07 +0000
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
Subject: [PATCH 16/18] smb:client: Simplify registration creation
Date: Fri, 10 Jul 2026 11:16:35 +0200
Message-ID: <20260710091637.58873-17-scabrero@suse.com>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 8D64876402
X-Rspamd-Action: no action

And switch to GFP_KERNEL since the code path can sleep.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 209 ++++++++++++++++++++-------------------
 1 file changed, 106 insertions(+), 103 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 97e415e441e4..3375a65ec32e 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -323,7 +323,8 @@ cifs_swn_reg_get_tcon(const struct cifs_swn_reg *swnreg)
 /*
  * Sends a register message to the userspace daemon based on the registration.
  * The authentication information to connect to the witness service is bundled
- * into the message.
+ * into the message. This function can sleep while allocating the genlmsg so
+ * it must be called after taking a swnreg reference and release the lock.
  */
 static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 {
@@ -414,7 +415,9 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 }
 
 /*
- * Sends an uregister message to the userspace daemon based on the registration
+ * Sends an unregister message to the userspace daemon based on the registration.
+ * This function can sleep while allocating the genlmsg so it must be called after
+ * taking a swnreg reference and release the lock.
  */
 static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 {
@@ -481,6 +484,11 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 	return ret;
 }
 
+/*
+ * Release a registration. Must be called with the last reference dropped (the
+ * refcount has reached zero) and with the registration already removed from the
+ * IDR under cifs_swnreg_idr_mutex, so it is no longer discoverable.
+ */
 static void cifs_swn_reg_release(struct cifs_swn_reg *swnreg)
 {
 	int ret;
@@ -614,99 +622,6 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(-ENOENT);
 }
 
-/*
- * Get a registration for the tcon's server and share name, allocating a new one if it does not
- * exists
- */
-static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
-{
-	struct cifs_swn_reg *swnreg = NULL;
-	int ret;
-
-	mutex_lock(&cifs_swnreg_idr_mutex);
-
-	/* Check if we are already registered for this network and share names */
-	swnreg = cifs_find_swn_reg(tcon);
-	if (!IS_ERR(swnreg)) {
-		kref_get(&swnreg->ref_count);
-		goto unlock;
-	} else if (PTR_ERR(swnreg) != -ENOENT) {
-		goto unlock;
-	}
-
-	swnreg = kmalloc_obj(struct cifs_swn_reg, GFP_ATOMIC);
-	if (swnreg == NULL) {
-		ret = -ENOMEM;
-		goto fail_unlock;
-	}
-
-	kref_init(&swnreg->ref_count);
-
-	swnreg->id = idr_alloc(&cifs_swnreg_idr, swnreg, 1, 0, GFP_ATOMIC);
-	if (swnreg->id < 0) {
-		cifs_dbg(FYI, "%s: failed to allocate registration id\n", __func__);
-		ret = swnreg->id;
-		goto fail;
-	}
-
-	swnreg->net_name = extract_hostname(tcon->tree_name);
-	if (IS_ERR(swnreg->net_name)) {
-		ret = PTR_ERR(swnreg->net_name);
-		cifs_dbg(VFS, "%s: failed to extract host name from target: %d\n", __func__, ret);
-		goto fail_idr;
-	}
-
-	swnreg->share_name = extract_sharename(tcon->tree_name);
-	if (IS_ERR(swnreg->share_name)) {
-		ret = PTR_ERR(swnreg->share_name);
-		cifs_dbg(VFS, "%s: failed to extract share name from target: %d\n", __func__, ret);
-		goto fail_net_name;
-	}
-
-	ret = cifs_swn_reg_set_auth(swnreg, tcon);
-	if (ret != 0) {
-		cifs_dbg(VFS, "%s: failed to set auth info: %d\n", __func__,
-			 ret);
-		goto fail_share_name;
-	}
-
-	/*
-	 * If there is an address stored use it instead of the server address, because we are
-	 * in the process of reconnecting to it after a share has been moved or we have been
-	 * told to switch to it (client move message). In these cases we unregister from the
-	 * server address and register to the new address when we receive the notification.
-	 */
-	if (tcon->ses->server->use_swn_dstaddr)
-		swnreg->addr = tcon->ses->server->swn_dstaddr;
-	else
-		swnreg->addr = tcon->ses->server->dstaddr;
-
-	swnreg->net_name_notify = true;
-	swnreg->share_name_notify =
-		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
-	swnreg->ip_notify = false;
-
-	swnreg->check_interval = tcon->ses->server->echo_interval;
-	INIT_DELAYED_WORK(&swnreg->check, cifs_swn_reg_check);
-
-	queue_delayed_work(cifsiod_wq, &swnreg->check, swnreg->check_interval);
-unlock:
-	mutex_unlock(&cifs_swnreg_idr_mutex);
-
-	return swnreg;
-fail_share_name:
-	kfree(swnreg->share_name);
-fail_net_name:
-	kfree(swnreg->net_name);
-fail_idr:
-	idr_remove(&cifs_swnreg_idr, swnreg->id);
-fail:
-	kfree(swnreg);
-fail_unlock:
-	mutex_unlock(&cifs_swnreg_idr_mutex);
-	return ERR_PTR(ret);
-}
-
 static void cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
 					    const char *name, int state)
 {
@@ -816,8 +731,8 @@ cifs_swn_handle_notification_tcon(const struct cifs_swn_notification *not,
 
 /*
  * This function process a notification received for a registration. It
- * searches all matching tcons to deliver it and then unregisters/registers
- * as necessary if the address has changed.
+ * unregisters/registers as necessary and applies the notification to all
+ * matching tcons.
  */
 static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
 {
@@ -986,16 +901,104 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 	struct cifs_swn_reg *swnreg;
 	int ret;
 
-	swnreg = cifs_get_swn_reg(tcon);
-	if (IS_ERR(swnreg))
+	mutex_lock(&cifs_swnreg_idr_mutex);
+
+	swnreg = cifs_find_swn_reg(tcon);
+	if (!IS_ERR(swnreg)) {
+		/*
+		 * There is a registration matching this tcon, could be a second mount of
+		 * the same share, increment the refcount.
+		 */
+		if (kref_get_unless_zero(&swnreg->ref_count)) {
+			mutex_unlock(&cifs_swnreg_idr_mutex);
+			return 0;
+		}
+		/* Else it is being released, allocate new one */
+	} else if (PTR_ERR(swnreg) != -ENOENT) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
 		return PTR_ERR(swnreg);
+	}
 
-	ret = cifs_swn_send_register_message(swnreg);
-	if (ret < 0) {
-		cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
-		/* Do not put the swnreg or return error, the check task will retry */
+	/* Allocate new registration */
+	swnreg = kzalloc_obj(struct cifs_swn_reg, GFP_KERNEL);
+	if (swnreg == NULL) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return -ENOMEM;
 	}
 
+	kref_init(&swnreg->ref_count);
+
+	swnreg->id = idr_alloc(&cifs_swnreg_idr, swnreg, 1, 0, GFP_KERNEL);
+	if (swnreg->id < 0) {
+		ret = swnreg->id;
+		cifs_dbg(FYI, "%s: failed to allocate registration id\n",
+			 __func__);
+		kfree(swnreg);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return ret;
+	}
+
+	swnreg->net_name = extract_hostname(tcon->tree_name);
+	if (IS_ERR(swnreg->net_name)) {
+		ret = PTR_ERR(swnreg->net_name);
+		cifs_dbg(VFS,
+			 "%s: failed to extract host name from target: %d\n",
+			 __func__, ret);
+		idr_remove(&cifs_swnreg_idr, swnreg->id);
+		kfree(swnreg);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return ret;
+	}
+
+	swnreg->share_name = extract_sharename(tcon->tree_name);
+	if (IS_ERR(swnreg->share_name)) {
+		ret = PTR_ERR(swnreg->share_name);
+		cifs_dbg(VFS,
+			 "%s: failed to extract share name from target: %d\n",
+			 __func__, ret);
+		kfree(swnreg->net_name);
+		idr_remove(&cifs_swnreg_idr, swnreg->id);
+		kfree(swnreg);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return ret;
+	}
+
+	ret = cifs_swn_reg_set_auth(swnreg, tcon);
+	if (ret != 0) {
+		cifs_dbg(VFS, "%s: failed to set auth info: %d\n", __func__,
+			 ret);
+		kfree(swnreg->net_name);
+		kfree(swnreg->share_name);
+		idr_remove(&cifs_swnreg_idr, swnreg->id);
+		kfree(swnreg);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return ret;
+	}
+
+	/*
+	 * If there is an address stored use it instead of the server address, because we are
+	 * in the process of reconnecting to it after a share has been moved or we have been
+	 * told to switch to it (client move message). In these cases we unregister from the
+	 * server address and register to the new address when we receive the notification.
+	 */
+	if (tcon->ses->server->use_swn_dstaddr)
+		swnreg->addr = tcon->ses->server->swn_dstaddr;
+	else
+		swnreg->addr = tcon->ses->server->dstaddr;
+
+	swnreg->net_name_notify = true;
+	swnreg->share_name_notify =
+		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
+	swnreg->ip_notify = false;
+
+	swnreg->check_interval = tcon->ses->server->echo_interval;
+	INIT_DELAYED_WORK(&swnreg->check, cifs_swn_reg_check);
+
+	/* Queue a immediate run to send the netlink message */
+	queue_delayed_work(cifsiod_wq, &swnreg->check, 0);
+
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+
 	return 0;
 }
 
-- 
2.54.0

