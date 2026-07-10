Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C353D5252
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675026; cv=none; b=qLUi40Jw3k7p8ID4ICN+GItazqw79i5YT4FGCMbmT1xabCcvSAFOOGM6HyaB1qHb5TaakUhygpQGpKAe9Fd27s9fXG+cnchVLgBlWZvAQBZZNg0hZYTVPwj+dcJhauyv82gL3aMV/5rqrispFdtwMTbNd54vtIIiAzSLy2u8sEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675026; c=relaxed/simple;
	bh=1EN3Ntm4J+NSp89SvWtrEE82llTwOSNp0JmBFzgdNQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDJ2fsla1wYecO+vm5yWADseRLlFwYDc7OnE5pYD/HSnk0fFe1wMgn2ncEunLfA1NKLl2xsOPEl9Iq3iPskfK0pIDRGOvUycsurrVB3zrByXUwuDul6S5BBNGNxeCwxqxU5qo9AQIUdj6pCd69UDfO7XArYoNz7WlQn0YTvSgKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fcB5Q9By; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fcB5Q9By; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fcB5Q9By";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fcB5Q9By"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CDC06766ED;
	Fri, 10 Jul 2026 09:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiOh0qpeWJb3WgdaUhoFMAbsnxHuL3E3bDKk+ggkTv4=;
	b=fcB5Q9By1TbOnkBF+7TWyQkjpHc4v+asdyKS4ZZx77vUSUpfvf+gH93vDm4EYu6IzXKVey
	SUwUnIGW1vc0MohbPiaD6CkYK/mVQeF45P7hOzyqlw3RuSay0yWDXk/LR6vqHkYq1RoeaZ
	z+MJrRpENZjRu6W0ldSMaJXLgExnc18=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiOh0qpeWJb3WgdaUhoFMAbsnxHuL3E3bDKk+ggkTv4=;
	b=fcB5Q9By1TbOnkBF+7TWyQkjpHc4v+asdyKS4ZZx77vUSUpfvf+gH93vDm4EYu6IzXKVey
	SUwUnIGW1vc0MohbPiaD6CkYK/mVQeF45P7hOzyqlw3RuSay0yWDXk/LR6vqHkYq1RoeaZ
	z+MJrRpENZjRu6W0ldSMaJXLgExnc18=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AC6C779BD;
	Fri, 10 Jul 2026 09:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aChpC4q4UGqnEQAAD6G6ig
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
Subject: [PATCH 02/18] smb:client: Adjust witness notification request
Date: Fri, 10 Jul 2026 11:16:21 +0200
Message-ID: <20260710091637.58873-3-scabrero@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
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
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Request share notifications only if asymmetric capability is set.

Never request IP change notifications, handling is not implemented.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 9753a432d099..2f8af8a281e8 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -345,8 +345,9 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	}
 
 	reg->net_name_notify = true;
-	reg->share_name_notify = true;
-	reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
+	reg->share_name_notify =
+		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
+	reg->ip_notify = false;
 
 	reg->tcon = tcon;
 unlock:
-- 
2.54.0

