Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0041D4D6
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367644; cv=none; b=gH1TC6Uh2N1J0wx6uiesGErb8KzB8k8yACI6pllUhsMzfsgKSIxHJllbysfA6R09BlZoG+14nWr1HTJKYSVTp7Sirj2d73w23sUrq2qtWpa7//ivM5fd42bluojOYp+4OnnFdaEBGpSvwWgB5XeIRIFksjHaEcDHbfLnrNDXS7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367644; c=relaxed/simple;
	bh=hKCoRgO/pHnTaQRTWMIqSWnU2m3aMbr2eUKcAL9wnkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSjAkPgnRKzyKtlrzY2m5TL0LEFGcIBmYF2BJKV1u+nuhKWtqoSJOefu1v5z7efgQceBfiKCbl5NEwk7vAJSwdLqd5TnVGyBUMQdkA9USzBje0W5brTSN3O7g86edZ3s0G2SADnQe/1wCF9/Vd5u26bCs7rWcY3icxfSHlVzVKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xy9AHkjA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L3zjycYx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zY/4TMea; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OSJ2yR8F; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xy9AHkjA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L3zjycYx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zY/4TMea";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OSJ2yR8F"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C2711F44F;
	Fri, 25 Sep 2026 20:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6h3wGI1C17Ja/8RfOshrZO2gk8g9NUvi/NOqQcXAl8=;
	b=xy9AHkjAqYUVeDS9rWtu/md4Dl54Ut2Gqjm8mzZpTALncXyllLcOV+ke7TGGO4VDbNZ+NR
	m3QDMBSlTObKhjy2Lb6plKtjQIgkZYVs/kIQmKd3MbRps87rr7Zt000amFXuCk6Wk0aFA8
	rHKPjeRaQ3yFo8d4JSEbsw6W+qa7ni0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6h3wGI1C17Ja/8RfOshrZO2gk8g9NUvi/NOqQcXAl8=;
	b=L3zjycYxY8NAoGKNEIjb/kjX8ZQid7OsEJrrKCe+vLWsUKrsiT2HHsdOZWup+aR8pILhD8
	0RwWsDyPo4M6kSBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="zY/4TMea";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OSJ2yR8F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6h3wGI1C17Ja/8RfOshrZO2gk8g9NUvi/NOqQcXAl8=;
	b=zY/4TMearHb/HWtfhH8pgMyxV6Ro6KgjwbiGf4YWeAMn++vPcx3SYrA+zI0JxHGMjYMQvQ
	rEEtlzFEovlxNUuGA3YjFNB4+aHKgGSHigL2qSDpBVxbP+4lXO4jVOWvSBxNveA6/MY8wy
	pLjI29+w6ykSjF4zvnZNQei0sN8rAU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6h3wGI1C17Ja/8RfOshrZO2gk8g9NUvi/NOqQcXAl8=;
	b=OSJ2yR8FOr7jr2djiTpOZvmJ2kJ5XPRjXBNAf7oalOtbCe34GnA+HkR0KEpBcb9gUbxjn8
	guYjevTS4U5PavCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C014213297;
	Fri, 25 Sep 2026 20:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /5FFFI/XtmpnXQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 25 Sep 2026 20:20:31 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 2/2] smb: client: prevent premature discard of requests if reconnecting
Date: Fri, 25 Sep 2026 17:20:03 -0300
Message-ID: <20260925202003.618856-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925202003.618856-1-ematsumiya@suse.de>
References: <20260925202003.618856-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5C2711F44F
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_TRACE(0.00)[suse.de:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Add TCP_Server_Info::reconnecting to track cifs_reconnect() lifetime.
Wait for it to be true in cifs_wait_for_server_reconnect(), and only
then wait for tcpStatus change.

Also, return -EAGAIN (instead of -EHOSTDOWN) if reconnect is still
ongoing at the end, so requests are not discarded unnecessarily.

Changes (refactor cifs_wait_for_server_reconnect()):
- remove unnecessary do/while loop; use wait_event_interruptible()
  for hard mounts
- increase timeout, and base it on echo_interval to match user
  preferences
- remove useless debug log for interrupt errors

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/connect.c  |  4 ++
 fs/smb/client/misc.c     | 83 +++++++++++++++++++++++++---------------
 3 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..c4f8ca844be8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -802,6 +802,7 @@ struct TCP_Server_Info {
 	bool	posix_ext_supported;
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
+	bool reconnecting; /* if cifs_reconnect() is indeed running */
 	unsigned long echo_interval;
 
 	/*
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a19fec8bad64..e57194f1172a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -377,6 +377,8 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 			     server->hostname);
 	shutdown = (server->tcpStatus != CifsNeedReconnect && server->ssocket);
 	server->tcpStatus = CifsNeedReconnect;
+	server->reconnecting = true;
+	wake_up(&server->response_q);
 	spin_unlock(&server->srv_lock);
 
 	/* Don't release it yet! */
@@ -456,6 +458,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
@@ -598,6 +601,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 05168284f205..02c146802008 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1077,44 +1077,67 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 {
-	int timeout = 10;
-	int rc;
+	int timeout, rc = 0;
+
+	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
+	if (retry)
+		return wait_event_interruptible(server->response_q,
+						(server->tcpStatus != CifsNeedReconnect));
 
+	/*
+	 * Soft mounts, wait with timeout.
+	 * Compute timeout based on echo_interval, to match user expectations wrt. time to recover
+	 * from network interruptions.
+	 *
+	 * Minimum is 17 seconds (per reconnect target):
+	 *   7s for cifs socket timeout
+	 *   3s sleep after a failed attempt
+	 *   7s spare, to cover at least a full attempt
+	 *
+	 * Maximum is 60s; might not be enough in some rare cases, but >60s is too much.
+	 */
 	spin_lock(&server->srv_lock);
-	if (server->tcpStatus != CifsNeedReconnect) {
-		spin_unlock(&server->srv_lock);
-		return 0;
+	if (unlikely(server->tcpStatus == CifsNeedReconnect)) {
+		timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
+		timeout = min(timeout, 60);
+		rc = 1; /* dummy */
 	}
-	timeout *= server->nr_targets;
 	spin_unlock(&server->srv_lock);
 
+	if (!rc)
+		return 0;
+
 	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
+	 * First, wait for cifs_reconnect() to start.
+	 * This is needed because tcpStatus == CifsNeedReconnect doesn't imply cifs_reconnect()
+	 * is actually running.
 	 *
-	 * On "soft" mounts we wait once. Hard mounts keep retrying until
-	 * process is killed or server comes back on-line.
+	 * Wait 3*timeout (max 180s) here, which should be more than enough.
 	 */
-	do {
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      timeout * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
+	rc = wait_event_interruptible_timeout(server->response_q, server->reconnecting,
+					      min(3 * timeout, 180) * HZ);
+	if (rc < 0)
+		return rc;
 
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			return 0;
-		}
-		spin_unlock(&server->srv_lock);
-	} while (retry);
+	if (!rc && !server->reconnecting)
+		return -EHOSTDOWN;
+
+	/* cifs_reconnect() started, now wait for status change */
+	rc = wait_event_interruptible_timeout(server->response_q,
+					      (server->tcpStatus != CifsNeedReconnect),
+					      timeout * HZ);
+	if (rc)
+		return rc > 0 ? 0 : rc;
+
+	rc = -EAGAIN;
 
-	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
-	return -EHOSTDOWN;
+	/* are we still trying to reconnect? */
+	spin_lock(&server->srv_lock);
+	if (!server->reconnecting) {
+		cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
+		rc = -EHOSTDOWN;
+	}
+	spin_unlock(&server->srv_lock);
+
+	return rc;
 }
-- 
2.55.0

