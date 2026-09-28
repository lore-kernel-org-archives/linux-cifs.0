Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81B495AD5
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607869; cv=none; b=hFNcwtvWcg8ZxVlbKHyfotvSu2TgUAlDBA+6Y2zgZ4rxePzU91Hr7irwMX1Z/ia5rqPz8ZdXef6h5MAtXbUACkFLpIR5dFOHZ3JuGzLWCVVG1GOoMFri9dHXyF29cZa85PgDgmet05A+OCd1t/qmoMojAuucvYKJnu2iPO5dwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607869; c=relaxed/simple;
	bh=gGtIWKR4a2R9EiCkQk0R1XT1i7MooGCwo3oFaNkNUj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHRiyLamvDr7e6Q7bjcvzOxAljwS0gngbnVO57qQBMXAOtsuy8+FFNt1neUZWN5sF0yPhiMtmCSh5s0BVPbCztjAzFG3gy9Oen8qEt3sRdNrbNtD+iSaWS3ftQyDQxiIDR6WBmpufhCZXfIixdyZ1wiRQAOXeS7aFC3AjRQqKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=akWOIViQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZvK46Lnx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nO3Agz72; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AldmV6/S; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="akWOIViQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZvK46Lnx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nO3Agz72";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AldmV6/S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B411221D9C;
	Mon, 28 Sep 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjgOurjoSdTWYnP1YIe0lMLymcWhOnitXN9cMOeE+4=;
	b=akWOIViQsz4RU2SvdxWDC/1ZvtqJIp5I5CXlh0gYHswkDvyX5TgHpvAUNcnTioFmr+JIUt
	n9xc9+gTGQEzHjxuiOHD4MH40SNXdRqGtx1V4y0IgynCDef1waxNOrWMvcsdPfNjI2fRO/
	DmmHJEsWPxBUZy2R3KCDs3LJ4IDpheM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjgOurjoSdTWYnP1YIe0lMLymcWhOnitXN9cMOeE+4=;
	b=ZvK46LnxHNyBNTQsj32BcDls8QN8YrWt2ATQHex3qdHGGi9HtUMVhCS/AIirl/YRpKCrLP
	cnV+sKvzQ76PG1Cg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nO3Agz72;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="AldmV6/S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjgOurjoSdTWYnP1YIe0lMLymcWhOnitXN9cMOeE+4=;
	b=nO3Agz726LXxOV5/A9ZeKiPrAiD51BJMbawqGM1fQZjyzJ6FE1o1nUXfhfgbqck98VDWzJ
	uBUsI2Pq+AJnAS732WNWQVQMbFfK3rE3Px2LOMnV1NTR7DsAMZoJ6rUbqDOxnWuChc0OCG
	7cwoiCCalz+WSndEJlB1dDMdhx0LrmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607857;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZjgOurjoSdTWYnP1YIe0lMLymcWhOnitXN9cMOeE+4=;
	b=AldmV6/SjSXKKuZOvsvfZBQaZTsgZ4vDGNSxnP1Lii633hr5fFHxN8tyrtAQT74t8V5qwW
	shFy1s/QuQ72vQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 256861340F;
	Mon, 28 Sep 2026 15:04:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /2wNKvCBumpdIwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 28 Sep 2026 15:04:16 +0000
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
Subject: [PATCH v2 2/2] smb: client: prevent premature discard of requests if reconnecting
Date: Mon, 28 Sep 2026 12:03:55 -0300
Message-ID: <20260928150355.850472-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928150355.850472-1-ematsumiya@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: B411221D9C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Add TCP_Server_Info::reconnecting to track cifs_reconnect() lifetime.
Wait for it to be true in cifs_wait_for_server_reconnect(), and only
then wait for tcpStatus change.

Also, return -ECONNRESET (instead of -EHOSTDOWN) if reconnect is still
ongoing at the end, so requests are not discarded unnecessarily.
-ECONNRESET is not immediately retried by intermediate layers, e.g. VFS,
but still serves as an indication to userspace that retrying the
operation might be successful.

Changes (refactor cifs_wait_for_server_reconnect()):
- remove unnecessary do/while loop; use wait_event_interruptible()
  for hard mounts
- increase timeout, and base it on echo_interval to match user
  preferences
- remove useless debug log for interrupt errors

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v1 -> v2 (fix issues detected by sashiko):
- handle condition changes post-wait_event timeouts
- return -ECONNRESET instead of -EAGAIN when leaving still reconnecting

(not from sashiko):
- add missing wake_up() after setting server->reconnecting to true in
  cifs_tcp_ses_needs_reconnect()
- handle tcpStatus == CifsExiting in cifs_wait_for_server_reconnect()


 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/connect.c  |  4 ++
 fs/smb/client/misc.c     | 91 ++++++++++++++++++++++++++++------------
 3 files changed, 69 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d279b5c92a08..9623ee19312c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -803,6 +803,7 @@ struct TCP_Server_Info {
 	bool	posix_ext_supported;
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
+	bool reconnecting; /* if cifs_reconnect() is indeed running */
 	unsigned long echo_interval;
 
 	/*
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 4cc433308c96..58efc5392fc4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -398,6 +398,8 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
+	server->reconnecting = true;
+	wake_up(&server->response_q);
 	spin_unlock(&server->srv_lock);
 
 	set_need_reco(server);
@@ -475,6 +477,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
@@ -617,6 +620,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 05168284f205..24aa0333553a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1077,44 +1077,81 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 
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
 
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus != CifsNeedReconnect) {
+		if (unlikely(server->tcpStatus == CifsExiting))
+			rc = -ESHUTDOWN;
 		spin_unlock(&server->srv_lock);
-		return 0;
+
+		return rc;
 	}
-	timeout *= server->nr_targets;
+
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
+	timeout = max(server->echo_interval / HZ, 17) * server->nr_targets;
+	timeout = min(timeout, 60);
 	spin_unlock(&server->srv_lock);
 
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
+	rc = wait_event_interruptible_timeout(server->response_q,
+					      (server->reconnecting ||
+					       server->tcpStatus != CifsNeedReconnect),
+					      min(3 * timeout, 180) * HZ);
+
+	/* cifs_reconnect() never started, don't wait any longer */
+	spin_lock(&server->srv_lock);
+	if (!rc && !server->reconnecting && server->tcpStatus == CifsNeedReconnect)
+		rc = -EHOSTDOWN;
+	spin_unlock(&server->srv_lock);
 
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			return 0;
+	if (rc < 0)
+		return rc;
+
+	/* cifs_reconnect() started (maybe already succeeded), wait for status change */
+	rc = wait_event_interruptible_timeout(server->response_q,
+					      (server->tcpStatus != CifsNeedReconnect),
+					      timeout * HZ);
+	if (rc < 0)
+		return rc;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsNeedReconnect) {
+		rc = 0;
+		if (server->tcpStatus == CifsExiting)
+			rc = -ESHUTDOWN;
+	} else {
+		rc = -ECONNRESET;
+
+		/* Are we still even trying to reconnect? */
+		if (!server->reconnecting) {
+			cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
+			rc = -EHOSTDOWN;
 		}
-		spin_unlock(&server->srv_lock);
-	} while (retry);
+	}
+	spin_unlock(&server->srv_lock);
 
-	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
-	return -EHOSTDOWN;
+	return rc;
 }
-- 
2.55.0

