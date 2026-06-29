Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469DA388E40
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782764528; cv=none; b=ileFwmV0LCLkVmtbYCkm8WINXCUHfBVwyMRRCU+O+0ApoytQSWwf369+xX11+x3kS/gP/S/fcnBiSIMlimAfhsSRTCdrEh/eAtRyxLmTumltM51CuGyQ9/Qo37MQ8kRzk3HkSVSXLU6FpI/Sk6kS60JT6Ve7tN8r1bWyLMW7xlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782764528; c=relaxed/simple;
	bh=GB6DpcqCUYLHsrEctstz06bK7arcHcJPpJF0dRz2lxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsb8LQDQ6smiQbLHZbsazHADeGdWwFux1GbPhGm4xclhgwEMvxGFqWdEXLdRsNjg4HqCYrOFet2+WRo2xImg0Gz55CjeLgVPRD+HDIxOjCUBfgGxEmN2QRbYeZ7/rumv4/joDsXH2wEXBl2HxG6Qrumm1yr0EV2lz0cZzBUKY1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y2KGN9Ce; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KdNAAMtJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y2KGN9Ce; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KdNAAMtJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y2KGN9Ce";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KdNAAMtJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y2KGN9Ce";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KdNAAMtJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9519D75E27;
	Mon, 29 Jun 2026 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782764525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSpJRTwmojcb61GdVtlnWTL5BinZSF8GiBjTSPybryI=;
	b=Y2KGN9CecEgyLHsHOL/6/KPJPrb0F8Q95GFJ4w5g59OSzQ/FYC8U1s/MkbqzJleCmMq8go
	jyQB0LIFzb3NpbXtRq0kBhlblW4nlfa+6mLM+MBQ/3E/nsb4YQroaZ8cqjhtjWSaN2tnTe
	qdxSFLVG5d8iF/vkpRpPA/ehw/R2XwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782764525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSpJRTwmojcb61GdVtlnWTL5BinZSF8GiBjTSPybryI=;
	b=KdNAAMtJy5KBuonKJplDeQMsD1A9xkT2KO+PS+yQzgqVtHU+mQj2iDkRKCIFt+jVqvBu4A
	eEH//XvATvVlS2Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782764525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSpJRTwmojcb61GdVtlnWTL5BinZSF8GiBjTSPybryI=;
	b=Y2KGN9CecEgyLHsHOL/6/KPJPrb0F8Q95GFJ4w5g59OSzQ/FYC8U1s/MkbqzJleCmMq8go
	jyQB0LIFzb3NpbXtRq0kBhlblW4nlfa+6mLM+MBQ/3E/nsb4YQroaZ8cqjhtjWSaN2tnTe
	qdxSFLVG5d8iF/vkpRpPA/ehw/R2XwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782764525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSpJRTwmojcb61GdVtlnWTL5BinZSF8GiBjTSPybryI=;
	b=KdNAAMtJy5KBuonKJplDeQMsD1A9xkT2KO+PS+yQzgqVtHU+mQj2iDkRKCIFt+jVqvBu4A
	eEH//XvATvVlS2Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F0F4779A8;
	Mon, 29 Jun 2026 20:22:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4xOYNezTQmpDYwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Jun 2026 20:22:04 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 2/3] cifs.upcall: namespace-aware key authority
Date: Mon, 29 Jun 2026 17:21:44 -0300
Message-ID: <20260629202145.97856-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629202145.97856-1-ematsumiya@suse.de>
References: <20260629202145.97856-1-ematsumiya@suse.de>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

spnego key is allocated before switching namespaces (i.e. as root/host
credentials), but instantiation is done only later.

If we have successfully switched user namespaces, key instantiation
returns EPERM because credentials have changed.

Call keyctl_assume_authority() after switching NS/UID/GID so key is
instantiated with correct creds.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 cifs.upcall.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 8a207544cf48..3f56c69cae28 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1539,6 +1539,7 @@ int main(const int argc, char *const argv[])
 	krb5_ccache ccache = NULL;
 	unsigned expire_time = DNS_RESOLVER_DEFAULT_TIMEOUT;
 	const char *key_descr = NULL;
+	bool same_ns = true;
 
 	hostbuf[0] = '\0';
 
@@ -1688,6 +1689,7 @@ int main(const int argc, char *const argv[])
 	if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
 		syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
 		arg->upcall_target = UPTARGET_APP;
+		same_ns = in_same_user_ns(getpid(), arg->pid);
 		rc = switch_to_process_ns(arg->pid);
 		if (rc == -1) {
 			syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
@@ -1756,6 +1758,27 @@ int main(const int argc, char *const argv[])
 	if (rc)
 		goto out;
 
+	/*
+	 * Keyring keys' credentials are per user NS.  If we switched user namespaces, we need to
+	 * re-acquire authority (with correct UID/GID) over it so we're able to instantiate it
+	 * later (in setup_key()).
+	 */
+	if (!same_ns) {
+		errno = 0;
+		rc = keyctl_assume_authority(key);
+
+		/*
+		 * EINPROGRESS and ENOENT are non-fatal in most cases.
+		 * keyctl_instantiate() (in setup_key()) will fail if something was really
+		 * unexpected.
+		 */
+		if (rc < 0 && errno != EINPROGRESS && errno != ENOENT) {
+			syslog(LOG_ERR, "keyctl_assume_authority: %s", strerror(errno));
+			rc = 1;
+			goto out;
+		}
+	}
+
 	rc = krb5_init_context(&context);
 	if (rc) {
 		syslog(LOG_ERR, "unable to init krb5 context: %ld", rc);
-- 
2.54.0

