Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCED3D5252
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675033; cv=none; b=m77phHkEmVpq7pMThC620cQ2AMjHNuENi2nbCtQJ9eFGrL60IHhOiZ8Vqal34g4Bzxn6/u+gRIC47gYO1wkFEM6n2fRyiTCjS3RdeCInEj4wXNsjmsOBP6EvSbRH0Q+ywzmtElScUzZ/AbHKqWJYAAmu+whthIA53JN9P1DB73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675033; c=relaxed/simple;
	bh=0qdi2iTV/bBNrhv/6bmI10oJg1f14nY6Y10OzOR/U/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8B3n757aKfgDBSwCibOM7prbxoU0IEpon4/tZbWmr0PDuf8tLyIqhwA2QhHNrH+65d9VOdj09/vDg87CMzA69goUQq1FaKHuMCugLJxqMoqRZb7R0s71KkkwlTYouA2OZHowqJzABXFHLZRIEtU/mn4Ro/hwK573zUX1jtCxNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F97A763F3;
	Fri, 10 Jul 2026 09:16:59 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1782779BE;
	Fri, 10 Jul 2026 09:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKgsNIq4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:16:58 +0000
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
Subject: [PATCH 03/18] smb:client: Rename variable to match the rest of the code
Date: Fri, 10 Jul 2026 11:16:22 +0200
Message-ID: <20260710091637.58873-4-scabrero@suse.com>
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
X-Rspamd-Queue-Id: 7F97A763F3
X-Rspamd-Action: no action

struct cifs_swn_reg pointer is always named swnreg.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 50 ++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 2f8af8a281e8..0afb69b2eed2 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -301,66 +301,66 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
  */
 static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 {
-	struct cifs_swn_reg *reg = NULL;
+	struct cifs_swn_reg *swnreg = NULL;
 	int ret;
 
 	mutex_lock(&cifs_swnreg_idr_mutex);
 
 	/* Check if we are already registered for this network and share names */
-	reg = cifs_find_swn_reg(tcon);
-	if (!IS_ERR(reg)) {
-		kref_get(&reg->ref_count);
+	swnreg = cifs_find_swn_reg(tcon);
+	if (!IS_ERR(swnreg)) {
+		kref_get(&swnreg->ref_count);
 		goto unlock;
-	} else if (PTR_ERR(reg) != -EEXIST) {
+	} else if (PTR_ERR(swnreg) != -EEXIST) {
 		goto unlock;
 	}
 
-	reg = kmalloc_obj(struct cifs_swn_reg, GFP_ATOMIC);
-	if (reg == NULL) {
+	swnreg = kmalloc_obj(struct cifs_swn_reg, GFP_ATOMIC);
+	if (swnreg == NULL) {
 		ret = -ENOMEM;
 		goto fail_unlock;
 	}
 
-	kref_init(&reg->ref_count);
+	kref_init(&swnreg->ref_count);
 
-	reg->id = idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_ATOMIC);
-	if (reg->id < 0) {
+	swnreg->id = idr_alloc(&cifs_swnreg_idr, swnreg, 1, 0, GFP_ATOMIC);
+	if (swnreg->id < 0) {
 		cifs_dbg(FYI, "%s: failed to allocate registration id\n", __func__);
-		ret = reg->id;
+		ret = swnreg->id;
 		goto fail;
 	}
 
-	reg->net_name = extract_hostname(tcon->tree_name);
-	if (IS_ERR(reg->net_name)) {
-		ret = PTR_ERR(reg->net_name);
+	swnreg->net_name = extract_hostname(tcon->tree_name);
+	if (IS_ERR(swnreg->net_name)) {
+		ret = PTR_ERR(swnreg->net_name);
 		cifs_dbg(VFS, "%s: failed to extract host name from target: %d\n", __func__, ret);
 		goto fail_idr;
 	}
 
-	reg->share_name = extract_sharename(tcon->tree_name);
-	if (IS_ERR(reg->share_name)) {
-		ret = PTR_ERR(reg->share_name);
+	swnreg->share_name = extract_sharename(tcon->tree_name);
+	if (IS_ERR(swnreg->share_name)) {
+		ret = PTR_ERR(swnreg->share_name);
 		cifs_dbg(VFS, "%s: failed to extract share name from target: %d\n", __func__, ret);
 		goto fail_net_name;
 	}
 
-	reg->net_name_notify = true;
-	reg->share_name_notify =
+	swnreg->net_name_notify = true;
+	swnreg->share_name_notify =
 		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
-	reg->ip_notify = false;
+	swnreg->ip_notify = false;
 
-	reg->tcon = tcon;
+	swnreg->tcon = tcon;
 unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
-	return reg;
+	return swnreg;
 
 fail_net_name:
-	kfree(reg->net_name);
+	kfree(swnreg->net_name);
 fail_idr:
-	idr_remove(&cifs_swnreg_idr, reg->id);
+	idr_remove(&cifs_swnreg_idr, swnreg->id);
 fail:
-	kfree(reg);
+	kfree(swnreg);
 fail_unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	return ERR_PTR(ret);
-- 
2.54.0

