Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A3F25B08B
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367638; cv=none; b=XSUFcJI/N2tTQu20GItpmvtr21GOJ6Eka+5ykoa5+ZeKh/GNVe7quG6n+PIRKs3UGLr+kzNqerE144UbMUELylG7ppwDnl/l0TriQ0bWy0QS8XV5VI+his18BEMMzF19eKoaXDmOatXY44AkPtcdDTNuxpoZw5EbggRV1vVTos0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367638; c=relaxed/simple;
	bh=9URmcIwf+Y4QO78re3yMO8vTuWMQOGu28PARRPVTQec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq4G9LGiM/E7yvQB1P/sI+Bu6r4VxvukC+X5d4mHYdXbPTHX8CJPagZqGGgX8IAm/DuoQUXY3f7nxCkHu7UUuE+lH8UvKxNlyO3d9MqF/vFPyG4gchSszrjCcNrz9IF3KKK9UEpGET+EM/iWh1c777JzbZWF5wAfN/tnKGFDHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZnMWPqcX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=V8GkPmW6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hz8zuxdw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dVNVmEzK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZnMWPqcX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="V8GkPmW6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hz8zuxdw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dVNVmEzK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 070601F388;
	Fri, 25 Sep 2026 20:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lYoUMOSn25WHgRm7ZAHgmXsUjOYhC1lTGuxqWrKFXKs=;
	b=ZnMWPqcX/uqS2k9vnCewE2Cj6nDTs8KcB4NfxjsKeOs2eVmqiFkoyfXl9/u3o8YUwVgjjw
	Q8Xh9l/uzQFJzeqYDPkwTtN9DbAfNYHdE2XClzNONPYR37IFCxQTvA5sZkLqF+B12OUnAK
	oQBFumQkTy4Sb18OBRejeYwymC+M3Bw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lYoUMOSn25WHgRm7ZAHgmXsUjOYhC1lTGuxqWrKFXKs=;
	b=V8GkPmW6BAuFv+M9v/jjcHLZUMu+wHthuwCFVK6b8pluRRG1SSCNEu5th+XqI+/pBTbPjf
	PfcE04jD1cB4WOBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hz8zuxdw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVNVmEzK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lYoUMOSn25WHgRm7ZAHgmXsUjOYhC1lTGuxqWrKFXKs=;
	b=hz8zuxdwxv1whANy2fu1ug01O2or3GuE9jz60nTjnwYR7kfBYmZxZt1XWA3por+ZWXTnP7
	8INJmfn/XS+FEmdk3aPUe2QNOHtpdoIj9rzeI+Xav3z3ySxbA09p/GJzIIZl88juVnQ01H
	4MddwnBdBjvWXu6mfPthvvam+T5aVEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367626;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lYoUMOSn25WHgRm7ZAHgmXsUjOYhC1lTGuxqWrKFXKs=;
	b=dVNVmEzKyWIzl7ruJyB05ZxCWR974JW7+apJPP3zJqI2RISOwu4nw96n2wywfsJAa66tPa
	EvH5YrGA7ELmMMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63D8613274;
	Fri, 25 Sep 2026 20:20:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QTGcOIfXtmpZXQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 25 Sep 2026 20:20:24 +0000
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
Subject: [PATCH 1/2] smb: client: fast fail sends if need to reconnect
Date: Fri, 25 Sep 2026 17:20:02 -0300
Message-ID: <20260925202003.618856-2-ematsumiya@suse.de>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 070601F388
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
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

smb_send_kvec() keeps retrying when server needs to reconnect, which
makes no sense as cifs_reconnect() will never run in parallel (because
both need server mutex).
IOW, retrying will never succeed, but only delay reconnects further.

Bail out early from smb_send_kvec() when need to reconnect.

Also shutdown socket queues when CifsNeedReconnect is first set, so any
sends/receives fails immediately (don't wait for socket to timeout).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/connect.c   | 31 +++++++++++++++++++++++--------
 fs/smb/client/transport.c |  8 ++++++++
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb6182..a19fec8bad64 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -127,13 +127,21 @@ void smb2_query_server_interfaces(struct work_struct *work)
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 }
 
-#define set_need_reco(server) \
-do { \
-	spin_lock(&server->srv_lock); \
-	if (server->tcpStatus != CifsExiting) \
-		server->tcpStatus = CifsNeedReconnect; \
-	spin_unlock(&server->srv_lock); \
-} while (0)
+static inline void set_need_reco(struct TCP_Server_Info *server)
+{
+	bool shutdown = false;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsExiting) {
+		shutdown = (server->tcpStatus != CifsNeedReconnect && server->ssocket);
+		server->tcpStatus = CifsNeedReconnect;
+	}
+	spin_unlock(&server->srv_lock);
+
+	/* Don't release it yet! */
+	if (shutdown)
+		kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
+}
 
 /*
  * Update the tcpStatus for the server.
@@ -353,6 +361,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 
 static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
 {
+	bool shutdown;
+
 	spin_lock(&server->srv_lock);
 	server->nr_targets = num_targets;
 	if (server->tcpStatus == CifsExiting) {
@@ -365,9 +375,14 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
+	shutdown = (server->tcpStatus != CifsNeedReconnect && server->ssocket);
 	server->tcpStatus = CifsNeedReconnect;
-
 	spin_unlock(&server->srv_lock);
+
+	/* Don't release it yet! */
+	if (shutdown)
+		kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
+
 	return true;
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 6e21b5f8754a..c6e0ee6d0ef4 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -180,6 +180,10 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
 		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+			/* Don't retry if need to reconnect */
+			if (unlikely(server->tcpStatus == CifsNeedReconnect))
+				return -ECONNRESET;
+
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {
@@ -191,6 +195,10 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 			continue;
 		}
 
+		/* Blame the need to reconnect for any non-interrupt error */
+		if (unlikely(server->tcpStatus == CifsNeedReconnect && !is_interrupt_error(rc)))
+			rc = -ECONNRESET;
+
 		if (rc < 0)
 			return rc;
 
-- 
2.55.0

