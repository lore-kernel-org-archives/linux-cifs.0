Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495CC39CD0F
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790701464; cv=none; b=GtDllMcjqW1KF62tl7GThzRp5SIWcl6Mm/4jSbyuJtju83kN/9nFMHTnqSyYLeTkfzvvGXSZfXa3Z5KPwfs0XyA2GNo9porxA4vE1r15cz13XbCGrnNZ0reyV5nh/lAiCNLCQGakCIJjsqM6q2+3GlMg81JdsKJ3zo2UExwIUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790701464; c=relaxed/simple;
	bh=9ZAIDxmF52/QJFskq9LArcN4k1mro7eMy7yU9XqV3vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dx8E3uDf2Wz5NQl9tkwkvYgOR6peeAxZywc/n1hmuuqB+uJsiwAxMP7muJipk820g16T0240KnDTFYHSZKiKkOGmHVot//qAT+3u6KeJJsKpzWbDkfKDWilEUfENnZDSMwTaaSd4ccOmT/y68ph2ojGZtBrKjzSLlZ6TkPk+f1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ejn38D0f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w92cNglG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QU8IwR5b; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yCEBB3q1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ejn38D0f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w92cNglG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QU8IwR5b";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yCEBB3q1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C888B21D57;
	Tue, 29 Sep 2026 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790701456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1lekT6HQvaKPMxogk7uH5chLlIHHy/aR6KGIDhic1o=;
	b=ejn38D0faTwsvSm1XZA13L0BumPaUfd3WnAA0GptAyITdtfFTAu1pCwBYrAQHhadEQX2GK
	3vqZ/qRILbWMJ8z9cXuQ2m5Bam+GC5TKlK2M/XuDXYY3N2FXYgBz4h/M1zh7DWzkZqyFV9
	qJJobDsTLw9hDJdLy9DJyVm0/PFkH04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790701456;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1lekT6HQvaKPMxogk7uH5chLlIHHy/aR6KGIDhic1o=;
	b=w92cNglGZ5QkVIsOscjlGUul8WSPUBaqvupjSwPqiRq9AjGu90D8D2Lpywtu7h5nUSkafF
	Ghod6UT+u6QRcTCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QU8IwR5b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yCEBB3q1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790701451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1lekT6HQvaKPMxogk7uH5chLlIHHy/aR6KGIDhic1o=;
	b=QU8IwR5bHVpE42i0L6EUS9jjnstUXOso8aj6nNQFGxFX/QPIc80/TTAASXoihhl7EEuLt/
	Gn6qwMd98l689nSWV2h8SZgwVThuTSP1LfCbEcpx1tJ658MFxuTqaEYC4xzbZ/1Lj6Uox9
	EWVjU73VXbJJw0vQgShfH0MsAe2ACRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790701451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1lekT6HQvaKPMxogk7uH5chLlIHHy/aR6KGIDhic1o=;
	b=yCEBB3q1P+LHjbrM8xH/+vEEp5tL7ZTZsMO58aP6Mty9PKY6Dsapd6zAihSupxCEkF0nYa
	7Uq4J40CdlAELtBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA804136D1;
	Tue, 29 Sep 2026 17:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h6GxGorvu2pZCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 29 Sep 2026 17:04:10 +0000
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
Subject: [PATCH v3 2/2] smb: client: prevent premature discard of requests if reconnecting
Date: Tue, 29 Sep 2026 14:03:58 -0300
Message-ID: <20260929170358.270612-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929170358.270612-1-ematsumiya@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C888B21D57
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Add TCP_Server_Info::reconnecting to track cifs_reconnect() lifetime.
Wait for it to be true in cifs_wait_for_server_reconnect(), and only
then wait for tcpStatus change.

Also, return -ECONNRESET (instead of -EHOSTDOWN) if reconnect is still
ongoing at the end, so requests are not discarded unnecessarily;
-ECONNRESET is not immediately retried by intermediate layers, e.g. VFS
or netfs, but still serves as an indication to userspace that retrying
the operation might be successful.

Changes (refactor cifs_wait_for_server_reconnect()):
- remove unnecessary do/while loop; use wait_event_interruptible()
  for hard mounts
- increase timeout, and base it on echo_interval to match user
  preferences
- remove useless debug log for interrupt errors

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2 -> v3:
- handle CifsExiting status on hard mounts (from sashiko report)

v1 -> v2 (fix issues detected by sashiko):
- handle condition changes post-wait_event timeouts
- return -ECONNRESET instead of -EAGAIN when leaving still reconnecting

(not from sashiko):
- add missing wake_up() after setting server->reconnecting to true in
  cifs_tcp_ses_needs_reconnect()
- handle tcpStatus == CifsExiting in cifs_wait_for_server_reconnect()
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/connect.c  |  4 ++
 fs/smb/client/misc.c     | 94 ++++++++++++++++++++++++++++------------
 3 files changed, 72 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index e49140d5c4a4..61191a167b89 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -803,6 +803,7 @@ struct TCP_Server_Info {
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
 	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
+	bool reconnecting; /* if cifs_reconnect() is indeed running */
 	unsigned long echo_interval;
 
 	/*
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 733d50b042fd..8ea60965ae06 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -374,6 +374,8 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
 	server->need_sock_shutdown = false;
 	server->tcpStatus = CifsNeedReconnect;
+	server->reconnecting = true;
+	wake_up(&server->response_q);
 	spin_unlock(&server->srv_lock);
 
 	if (shutdown) {
@@ -457,6 +459,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
@@ -599,6 +602,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	server->reconnecting = false;
 	spin_unlock(&server->srv_lock);
 
 	wake_up(&server->response_q);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 05168284f205..3fa4e36aac32 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1077,44 +1077,84 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 {
-	int timeout = 10;
-	int rc;
+	int timeout, rc = 0;
 
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus != CifsNeedReconnect) {
+		if (unlikely(server->tcpStatus == CifsExiting))
+			rc = -ESHUTDOWN;
 		spin_unlock(&server->srv_lock);
-		return 0;
+
+		return rc;
+	}
+
+	/* Hard mounts keep waiting until process is killed or server comes back on-line. */
+	if (retry) {
+		spin_unlock(&server->srv_lock);
+
+		return wait_event_interruptible(server->response_q,
+						(server->tcpStatus != CifsNeedReconnect));
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
 
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			return 0;
+	/* cifs_reconnect() never started, don't wait any longer */
+	spin_lock(&server->srv_lock);
+	if (!rc && !server->reconnecting && server->tcpStatus == CifsNeedReconnect)
+		rc = -EHOSTDOWN;
+	spin_unlock(&server->srv_lock);
+
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

