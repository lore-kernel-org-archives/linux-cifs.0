Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E92FFFB5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577029; cv=none; b=tHfGubkkE4w9Ow/AnV+k37zbvsSrlcjmGhRR5cG7CU1niv9RJ6HIiiaSxO8fU02aJpFqDR0aXy/sX239O7XG2mAjZDbOaKyextmI+H6kswANS551+2rJHmcY1USJ7c5Xd/JLmrNJev1vQXLE6NdDNj66PpA1Ae0Kh1KeGgxi8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577029; c=relaxed/simple;
	bh=atq6FPT3/ol+m38/4LHDT0oEUZbpA9Ou8XaAHVCjqGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/HW2X5jX9pNVnUntzBHzVKMgakluq6rWqcCSkUYZd70DTcXmodgFjX/vPesAdX/qnUj1oC8g1m+sfRBuq08XHm/FlMPEO/nOfNHOE5ySWZ20mUwkiHj7zhCTjwS30Zy9fkjWdahjJ3U5xNTASYquSc/6lIYwpm6Zb3Gnc+HWWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WEkhHQ9W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wyLoo3CI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WEkhHQ9W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wyLoo3CI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WEkhHQ9W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wyLoo3CI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WEkhHQ9W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wyLoo3CI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45E2D7A138;
	Mon, 20 Jul 2026 19:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784577020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVBC7EblBa4pYUAFCRBXs3SBiFORL+wfYgdIBe2g/Os=;
	b=WEkhHQ9WYEmlT5EU7vTMDdprw0W/B8ZkFRSDZtxpC2xNUsLo4FXqo8GDIeB4HEcyvzeC8e
	N1pGLQjGsUVyK3c8p6i47Cx9Khrk99iBkMEhTHe1L9MlCpT6H0rgrOf3pxwwhkswmeMk4x
	8P97ldO0DKKLHVE/mplSpPsJqBM4Rp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784577020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVBC7EblBa4pYUAFCRBXs3SBiFORL+wfYgdIBe2g/Os=;
	b=wyLoo3CIcEvs/oUY/elQkBYasduYyxqh+w9Y6T0X0W6zV/WsEBJAlllukeVU9cGbLOvAer
	leTkROVapfH1pADg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784577020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVBC7EblBa4pYUAFCRBXs3SBiFORL+wfYgdIBe2g/Os=;
	b=WEkhHQ9WYEmlT5EU7vTMDdprw0W/B8ZkFRSDZtxpC2xNUsLo4FXqo8GDIeB4HEcyvzeC8e
	N1pGLQjGsUVyK3c8p6i47Cx9Khrk99iBkMEhTHe1L9MlCpT6H0rgrOf3pxwwhkswmeMk4x
	8P97ldO0DKKLHVE/mplSpPsJqBM4Rp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784577020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVBC7EblBa4pYUAFCRBXs3SBiFORL+wfYgdIBe2g/Os=;
	b=wyLoo3CIcEvs/oUY/elQkBYasduYyxqh+w9Y6T0X0W6zV/WsEBJAlllukeVU9cGbLOvAer
	leTkROVapfH1pADg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C595E779AA;
	Mon, 20 Jul 2026 19:50:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WHDnIvt7XmrYCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:19 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2 14/14] smb: client: mark compression as supported on 64-bit LE only
Date: Mon, 20 Jul 2026 16:49:25 -0300
Message-ID: <20260720194925.2108840-14-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720194925.2108840-1-ematsumiya@suse.de>
References: <20260720194925.2108840-1-ematsumiya@suse.de>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Other architectures require more tuning + tests, even more so to
maintain the same performance.

So for now, mark SMB2 compression as supported only on 64-bit little
endian architectures.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/fs_context.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index abc29500a664..05aceb5652a9 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1248,6 +1248,22 @@ static int smb3_reconfigure(struct fs_context *fc)
 	return rc;
 }
 
+/*
+ * Current SMB2 compression code works best, or at all, only in 64-bit little endian architectures.
+ *
+ * (this is more of a "TODO" than a final statement for other archs)
+ */
+static inline bool smb_compress_arch_supported(void)
+{
+#if BITS_PER_LONG == 64 && (defined(__LITTLE_ENDIAN) || \
+	(defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
+	 __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__))
+	return true;
+#else
+	return false;
+#endif
+}
+
 static int smb3_fs_context_parse_param(struct fs_context *fc,
 				      struct fs_parameter *param)
 {
@@ -1289,8 +1305,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "CONFIG_CIFS_COMPRESSION kernel config option is unset\n");
 			goto cifs_parse_mount_err;
 		}
-		ctx->compress = true;
-		cifs_dbg(VFS, "SMB3 compression support is experimental\n");
+
+		if (smb_compress_arch_supported()) {
+			ctx->compress = true;
+			cifs_dbg(VFS, "SMB3 compression support is experimental\n");
+		} else {
+			cifs_dbg(VFS, "SMB3 compression is currently only supported on 64-bit little endian architectures, not enabling\n");
+		}
 		break;
 	case Opt_nodfs:
 		ctx->nodfs = 1;
-- 
2.54.0

