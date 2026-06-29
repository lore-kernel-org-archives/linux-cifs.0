Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A2A1862
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782764527; cv=none; b=mGCudc7BA1hMsUGnyXpCShbqr4EFY1HFjFCqMbc7kzYURYYjKKuwM8LszMGOO3ZboniP1FslQ41ml5wAJBajbPRLlnsWq19X79uUhfgYIkOJGa472aQBAcAmSjUJrjcZTbEd49k0IbsRK9FavnlXwW2JogZlqg8PDpYn5BBWbfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782764527; c=relaxed/simple;
	bh=a+8/mPC4C46AWRBuF7Fy0ktrzpn8Up3Kw7X9ECzz3CM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D4dgF6TyTWxQdlc/BrViBf7hvWuqQUHDt3IOA6Th6H3YbLC40l49Pq8e06Oqa7EmjyJpNQwtpvRSskdTHfBwZCrh6SRES8HurUiwT/GptkUp9Mq7+dxIiDyQ1lEyxNoB1uF7MJ+S8dsTEkmL8f9anu8loK+y7YA2EtkuToYvDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sz/iMntU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fTnsX5de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y3BllhH/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7E5qsBID; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sz/iMntU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fTnsX5de";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y3BllhH/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7E5qsBID"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E09D70FE2;
	Mon, 29 Jun 2026 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782764523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WFD5Orz/fd3L8JyRmmduPrOJpfzajzIvMG7z6fhDsEo=;
	b=sz/iMntU4/l4+Mv4ENug7L5Mbq62FGFTL8OMnotf3fFC4rop0iu+8io7FuVRD5BgBmATjP
	1iQR8C6KyosIiNbBtW2lxhiqj+/RO6DEG0ssLPwnWlKj7Hki1zhgWIOMJQ6HptiIz0hshV
	4CNRq+c1kopssHiecazV9NGlAGtKUC4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782764523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WFD5Orz/fd3L8JyRmmduPrOJpfzajzIvMG7z6fhDsEo=;
	b=fTnsX5deGLkQoWSDPl8YIdGcSb8x/GS9stVPmDh6NanNVFFZiFkD0/MTLji3i13HeIQvED
	HypHILd8iNKz1fDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782764522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WFD5Orz/fd3L8JyRmmduPrOJpfzajzIvMG7z6fhDsEo=;
	b=Y3BllhH/+37iuFyVEdEo5GmDIF88a8Q8IJocLnqPAtM9HceTVxkZrdUTsAArW1ciAxZ6A2
	ZkRtdL2vcdVWcvnYckHWpGLKaGtApumsLJsMmahjsBhEPAaai9jvxt7qoaQyJbnaxAyi/i
	WV6KR0vTuVi67hblJmv/t+OlXFyluAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782764522;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WFD5Orz/fd3L8JyRmmduPrOJpfzajzIvMG7z6fhDsEo=;
	b=7E5qsBIDUcat80LAZRMITZNBsTy3X+hRLEDLQEiI9vUmepbabdIQd28/EdBiNSgdNBZWxm
	oNXQOgXzlsufzeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF1CC779A8;
	Mon, 29 Jun 2026 20:22:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6WgtKenTQmo7YwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Jun 2026 20:22:01 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 1/3] cifs.upcall: fix regression with krb5 + creduid
Date: Mon, 29 Jun 2026 17:21:43 -0300
Message-ID: <20260629202145.97856-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de,manguebit.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,manguebit.org:email];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

With 'mount.cifs -o sec=krb5,cruid=XXX' (where XXX > 0), get_uidgid()
maps XXX to 0, as mount.cifs is running as root.

This makes kerberos lookup for credentials for UID 0, which, if not
existent, will fail with -ENOKEY.

To fix this, simply ignore UID/GID mapping (get_uidgid() call) when
arg->uid == 0, as cifs.upcall is already running as root anyway, and
then kerberos will use 'uid' (which might be 0 or cruid) for lookup.

Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
Reported-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 cifs.upcall.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 11dbc6186a74..8a207544cf48 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1708,15 +1708,27 @@ int main(const int argc, char *const argv[])
 	if (uid == 0)
 		env_probe = false;
 
-	/*
-	 * FIXME: this only works if we haven't switched PID namespaces.
-	 * If we did, /proc/arg->pid/ might not exist, or worse, point to something else.
-	 */
-	rc = get_uidgid(arg->pid, &uid, &gid);
-	if (rc) {
-		syslog(LOG_ERR, "get_uidgid (NS): %s", strerror(errno));
-		rc = 1;
-		goto out;
+	gid = INVALID_UIDGID;
+	if (arg->uid == 0) {
+		/*
+		 * By now, 'uid' is either 0 or 'arg->creduid'.
+		 * In either case, we just need to set GID=0 to make setgid() happy, as kerberos
+		 * credential cache lookup relies only on UID anyway (in case arg->creduid != 0).
+		 */
+		gid = 0;
+	} else {
+		/*
+		 * For any other case, we need to get UID/GID from procfs.
+		 *
+		 * FIXME: this only works if we haven't switched PID namespaces.
+		 * If we did, /proc/arg->pid/ might not exist, or worse, point to something else.
+		 */
+		rc = get_uidgid(arg->pid, &uid, &gid);
+		if (rc) {
+			syslog(LOG_ERR, "get_uidgid (NS): %s", strerror(errno));
+			rc = 1;
+			goto out;
+		}
 	}
 
 	rc = setgid(gid);
-- 
2.54.0

