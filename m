Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC23F3DB325
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675044; cv=none; b=HiiYu6Or8w82JTBc32GqWk+tvlRm6pJC8ydgGCGZv/AajLtZ5VIPj+0JFyeCgmMwIswtFlCq4SQQcO1A5zQz9BsevH3X22ivHob02pwSj6yeKfWVZiQRekpX9o2wuzHtykA/0nP9JGi1tIKwn5Sh/m/y+jc8NFegCgMhX70D5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675044; c=relaxed/simple;
	bh=XkovWI1OwvuJcOcke/j31AzGNgVWwpXG/By9lgVUUQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSW9qOk/WB0HAQVgQxOs6VXF+l1Y0yV7bLkvbgkxvcocCf3iqf0v+t9NIgmbsu/KxeyukpHP3q1fhm+gm83iGld76MJPeCbwzT0UvmslJ+feWGrLHH4KbyybD7T84TSVTnuTMPF4fTnzwL8M9tDAYwh86HuIgRIKX/eGnG9/ojU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BgfLiJwk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BgfLiJwk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BgfLiJwk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BgfLiJwk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C00C876708;
	Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWoebb0kJa8nFnLslPq5WzU/7fVi2m1UB3nBIRREUBc=;
	b=BgfLiJwkInexTM+ZgQQHShQF3ZRvIGJz6PkVNeQZziNi/b6ATENHIKqEWIM5GaKxVmK3P9
	bh4WFcsobeSUV5O6f/l6iTTtR62lQqiMajrpHyPoT7Qs2P7/1zn1z9S10ifsc2kjm9RxvO
	pCz0nDltE8WwHbZzE9m3/3Njp4UUcoE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWoebb0kJa8nFnLslPq5WzU/7fVi2m1UB3nBIRREUBc=;
	b=BgfLiJwkInexTM+ZgQQHShQF3ZRvIGJz6PkVNeQZziNi/b6ATENHIKqEWIM5GaKxVmK3P9
	bh4WFcsobeSUV5O6f/l6iTTtR62lQqiMajrpHyPoT7Qs2P7/1zn1z9S10ifsc2kjm9RxvO
	pCz0nDltE8WwHbZzE9m3/3Njp4UUcoE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29604779BD;
	Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8JgzB5G4UGqnEQAAD6G6ig
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
Subject: [PATCH 12/18] smb:client: Pass the tcon to notification handlers
Date: Fri, 10 Jul 2026 11:16:31 +0200
Message-ID: <20260710091637.58873-13-scabrero@suse.com>
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
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_RATELIMIT(0.00)[to_ip_from(RLsmepzun9ugcn3tumbc3b9wxd)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Prepare to remove the cached tcon from the registration.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index be275a99e8c4..0a45be8f36d7 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -500,16 +500,17 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(ret);
 }
 
-static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
+static int cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
+					   const char *name, int state)
 {
 	switch (state) {
 	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
@@ -605,7 +606,8 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 	return ret;
 }
 
-static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
+static int cifs_swn_client_move(struct cifs_tcon *tcon,
+				struct sockaddr_storage *addr)
 {
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
@@ -615,7 +617,7 @@ static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_sto
 	else if (addr->ss_family == AF_INET6)
 		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
 
-	return cifs_swn_reconnect(swnreg->tcon, addr);
+	return cifs_swn_reconnect(tcon, addr);
 }
 
 int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
@@ -664,7 +666,8 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 			cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
 			return -EINVAL;
 		}
-		return cifs_swn_resource_state_changed(swnreg, name, state);
+		return cifs_swn_resource_state_changed(swnreg->tcon, name,
+						       state);
 	}
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE: {
 		struct sockaddr_storage addr;
@@ -675,7 +678,7 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 			cifs_dbg(FYI, "%s: missing IP address attribute\n", __func__);
 			return -EINVAL;
 		}
-		return cifs_swn_client_move(swnreg, &addr);
+		return cifs_swn_client_move(swnreg->tcon, &addr);
 	}
 	default:
 		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
-- 
2.54.0

