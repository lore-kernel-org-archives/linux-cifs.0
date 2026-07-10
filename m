Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1C3A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675045; cv=none; b=X/VAHOTENP/Y2fcrOVxEMiRcmBfiW9tj0GUg8WFjcUdDEKMeUz4KpcNf8zgk+I2j9lX2nPsSNQ1szasZSLMDeE7EM+SP30NAruaRd2wRW3f5/bac+WqnMXdvU7y3l8i+OUzYji//QA27IHQRvuCF0ajnNpmM0abG+7FjB3+pax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675045; c=relaxed/simple;
	bh=/6zAJ/n5vsnYddJ/c9Qv3I8PH6nlmhnlUZvnaOMNTis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY1d5gEooZgjUqn7p2QYQopOxfYSJNkxghW7FLvFBXVEg87eCeTt1x1HwKTTJAmGO8dTnmDIfVIwba6TgAnVZU/knWXohzuB2Tt0+dBp/npA0KpW1mdJztK0I221Bs1tR9cEcOlob1gdRlnj4pvTtK5xjVCgUv7+1suqaigYz54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC070763F9;
	Fri, 10 Jul 2026 09:17:00 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 478C9779BD;
	Fri, 10 Jul 2026 09:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OFGQDoy4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:00 +0000
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
Subject: [PATCH 05/18] smb:client: Add a specific task to refresh witness registrations
Date: Fri, 10 Jul 2026 11:16:24 +0200
Message-ID: <20260710091637.58873-6-scabrero@suse.com>
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
X-Rspamd-Queue-Id: DC070763F9
X-Rspamd-Action: no action

Instead of overload the echo task, create a delayed work for each
registration.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 116 ++++++++++++++++++++++++++-------------
 fs/smb/client/cifs_swn.h |   3 -
 fs/smb/client/connect.c  |   3 -
 3 files changed, 79 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index fe032ae9c413..36e199eb04c1 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -30,6 +30,9 @@ struct cifs_swn_reg {
 	bool ip_notify;
 
 	struct cifs_tcon *tcon;
+
+	unsigned long check_interval;
+	struct delayed_work check;
 };
 
 static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
@@ -241,6 +244,75 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 	return ret;
 }
 
+static void cifs_swn_reg_release(struct cifs_swn_reg *swnreg)
+{
+	int ret;
+
+	ret = cifs_swn_send_unregister_message(swnreg);
+	if (ret < 0)
+		cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
+
+	kfree(swnreg->net_name);
+	kfree(swnreg->share_name);
+	kfree(swnreg);
+}
+
+static void cifs_swn_reg_idr_remove(struct kref *ref)
+{
+	struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
+
+	idr_remove(&cifs_swnreg_idr, swnreg->id);
+}
+
+/*
+ * Periodic task to enforce registration even when the userspace daemon is
+ * started after mounting the share.
+ */
+static void cifs_swn_reg_check(struct work_struct *work)
+{
+	struct cifs_swn_reg *swnreg =
+		container_of(work, struct cifs_swn_reg, check.work);
+	int ret;
+
+	/*
+	 * First take a reference to avoid other thread releasing the swnreg
+	 * on concurrent cifs_swn_unregister().
+	 *
+	 * Do not resurrect dead registrations, a concurrent cifs_swn_unregister
+	 * can drop refcount to 0 and remove this swnreg from the IDR before
+	 * releasing the mutex, but it will then wait for this callback to end
+	 * before releasing the swnreg.
+	 */
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	if (!kref_get_unless_zero(&swnreg->ref_count)) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return;
+	}
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+
+
+	/*
+	 * It is safe to send the registration message multiple times.
+	 * The userspace client library tracks if registered or not
+	 * using the swnreg->id.
+	 */
+	ret = cifs_swn_send_register_message(swnreg);
+	if (ret < 0)
+		cifs_dbg(FYI, "%s: Failed to send register message: %d\n",
+			 __func__, ret);
+
+	/* Release our reference */
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	if (kref_put(&swnreg->ref_count, cifs_swn_reg_idr_remove)) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		cifs_swn_reg_release(swnreg);
+		return;
+	}
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+
+	queue_delayed_work(cifsiod_wq, &swnreg->check, swnreg->check_interval);
+}
+
 /*
  * Try to find a matching registration for the tcon's server name and share name.
  * Calls to this function must be protected by cifs_swnreg_idr_mutex.
@@ -350,6 +422,11 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	swnreg->ip_notify = false;
 
 	swnreg->tcon = tcon;
+
+	swnreg->check_interval = tcon->ses->server->echo_interval;
+	INIT_DELAYED_WORK(&swnreg->check, cifs_swn_reg_check);
+
+	queue_delayed_work(cifsiod_wq, &swnreg->check, swnreg->check_interval);
 unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
@@ -366,26 +443,6 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(ret);
 }
 
-static void cifs_swn_reg_release(struct cifs_swn_reg *swnreg)
-{
-	int ret;
-
-	ret = cifs_swn_send_unregister_message(swnreg);
-	if (ret < 0)
-		cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
-
-	kfree(swnreg->net_name);
-	kfree(swnreg->share_name);
-	kfree(swnreg);
-}
-
-static void cifs_swn_reg_idr_remove(struct kref *ref)
-{
-	struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
-
-	idr_remove(&cifs_swnreg_idr, swnreg->id);
-}
-
 static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
 {
 	switch (state) {
@@ -593,7 +650,7 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 	ret = cifs_swn_send_register_message(swnreg);
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
-		/* Do not put the swnreg or return error, the echo task will retry */
+		/* Do not put the swnreg or return error, the check task will retry */
 	}
 
 	return 0;
@@ -604,7 +661,6 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 	struct cifs_swn_reg *swnreg;
 
 	mutex_lock(&cifs_swnreg_idr_mutex);
-
 	swnreg = cifs_find_swn_reg(tcon);
 	if (IS_ERR(swnreg)) {
 		mutex_unlock(&cifs_swnreg_idr_mutex);
@@ -612,6 +668,7 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 	}
 	if (kref_put(&swnreg->ref_count, cifs_swn_reg_idr_remove)) {
 		mutex_unlock(&cifs_swnreg_idr_mutex);
+		cancel_delayed_work_sync(&swnreg->check);
 		cifs_swn_reg_release(swnreg);
 		return 0;
 	}
@@ -655,18 +712,3 @@ void cifs_swn_dump(struct seq_file *m)
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	seq_puts(m, "\n");
 }
-
-void cifs_swn_check(void)
-{
-	struct cifs_swn_reg *swnreg;
-	int id;
-	int ret;
-
-	mutex_lock(&cifs_swnreg_idr_mutex);
-	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
-		ret = cifs_swn_send_register_message(swnreg);
-		if (ret < 0)
-			cifs_dbg(FYI, "%s: Failed to send register message: %d\n", __func__, ret);
-	}
-	mutex_unlock(&cifs_swnreg_idr_mutex);
-}
diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
index 955d07b69450..cdc5628a5459 100644
--- a/fs/smb/client/cifs_swn.h
+++ b/fs/smb/client/cifs_swn.h
@@ -22,8 +22,6 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
 
 void cifs_swn_dump(struct seq_file *m);
 
-void cifs_swn_check(void);
-
 static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *server)
 {
 	if (server->use_swn_dstaddr) {
@@ -44,7 +42,6 @@ static inline int cifs_swn_register(struct cifs_tcon *tcon) { return 0; }
 static inline int cifs_swn_unregister(struct cifs_tcon *tcon) { return 0; }
 static inline int cifs_swn_notify(struct sk_buff *s, struct genl_info *i) { return 0; }
 static inline void cifs_swn_dump(struct seq_file *m) {}
-static inline void cifs_swn_check(void) {}
 static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *server) { return false; }
 static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info *server) {}
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..3465566f8cef 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -632,9 +632,6 @@ cifs_echo_request(struct work_struct *work)
 	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
 	cifs_server_dbg(FYI, "send echo request: rc = %d\n", rc);
 
-	/* Check witness registrations */
-	cifs_swn_check();
-
 requeue_echo:
 	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
 }
-- 
2.54.0

