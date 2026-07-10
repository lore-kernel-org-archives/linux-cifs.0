Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7E43A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675070; cv=none; b=BfiP2Hgyqhl6HlpeGd6X8sS1g7cn0Ga480zvfgjQ2KkFuWZucfrzsbdyzBfs4U88mA57Ia6qwG1EoVuSY+ROzPydUJH4/lRHfu89A1Y+ZROpXWsHWLnSOGPyPIyk77WLbdtRUf4PYDwl/x8J7hCCTm3gy9QhuY1Ubyj/VQ/FPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675070; c=relaxed/simple;
	bh=QyPIPs0Uhb5g1GvUizcXxB9bMi/evbop00WCWt2yO0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UA7ys59G6l4ADJ51yhM/XR7fConhLMCL0BXuTMCSX9fIsLReLtd4HeXuzYjoLsNLAzMK4Z4X8lue29siF8R8Y/KS8TG3J+6SxlaZ7fT2itufF530UgysHSiy1i9MWfPFS2CLtIf6NjHKuof+G6+Z09y24b62Aeu1LSCczZqtwu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vHFrbUqW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vHFrbUqW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vHFrbUqW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vHFrbUqW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15A8476403;
	Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzlQUxaJLPKaGG749X/WXRnJHovKESzVsxUQ28wo16w=;
	b=vHFrbUqWeVn9VY4Xa5UqHpyh65k+lrmcGOqTcyPSH6osRGtV8TqmeZp2KqUppUE1wb3dLa
	WDFxPI+MoUOSQfdkJ2k24nUPCGu/Wg+e9H2XQu3Jq7/nVF356mE5arzfgueqKYzPEDmyG4
	rm8VYncfclETZtKhUgwmGQgKjT5b05E=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzlQUxaJLPKaGG749X/WXRnJHovKESzVsxUQ28wo16w=;
	b=vHFrbUqWeVn9VY4Xa5UqHpyh65k+lrmcGOqTcyPSH6osRGtV8TqmeZp2KqUppUE1wb3dLa
	WDFxPI+MoUOSQfdkJ2k24nUPCGu/Wg+e9H2XQu3Jq7/nVF356mE5arzfgueqKYzPEDmyG4
	rm8VYncfclETZtKhUgwmGQgKjT5b05E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7346F779BD;
	Fri, 10 Jul 2026 09:17:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mMs3GZC4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:04 +0000
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
Subject: [PATCH 11/18] smb:client: Pass the tcon to cifs_swn_send_register_message
Date: Fri, 10 Jul 2026 11:16:30 +0200
Message-ID: <20260710091637.58873-12-scabrero@suse.com>
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
 fs/smb/client/cifs_swn.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 5728647a1e5d..be275a99e8c4 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -170,7 +170,8 @@ static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
  * The authentication information to connect to the witness service is bundled
  * into the message.
  */
-static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
+static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg,
+					  struct cifs_tcon *tcon)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
@@ -222,10 +223,10 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 			goto nlmsg_fail;
 	}
 
-	authtype = cifs_select_sectype(swnreg->tcon->ses->server, swnreg->tcon->ses->sectype);
+	authtype = cifs_select_sectype(tcon->ses->server, tcon->ses->sectype);
 	switch (authtype) {
 	case Kerberos:
-		ret = cifs_swn_auth_info_krb(swnreg->tcon, skb);
+		ret = cifs_swn_auth_info_krb(tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get kerberos auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
@@ -233,7 +234,7 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 		break;
 	case NTLMv2:
 	case RawNTLMSSP:
-		ret = cifs_swn_auth_info_ntlm(swnreg->tcon, skb);
+		ret = cifs_swn_auth_info_ntlm(tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
@@ -378,7 +379,7 @@ static void cifs_swn_reg_check(struct work_struct *work)
 	 * The userspace client library tracks if registered or not
 	 * using the swnreg->id.
 	 */
-	ret = cifs_swn_send_register_message(swnreg);
+	ret = cifs_swn_send_register_message(swnreg, swnreg->tcon);
 	if (ret < 0)
 		cifs_dbg(FYI, "%s: Failed to send register message: %d\n",
 			 __func__, ret);
@@ -693,7 +694,7 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 	if (IS_ERR(swnreg))
 		return PTR_ERR(swnreg);
 
-	ret = cifs_swn_send_register_message(swnreg);
+	ret = cifs_swn_send_register_message(swnreg, tcon);
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
 		/* Do not put the swnreg or return error, the check task will retry */
-- 
2.54.0

